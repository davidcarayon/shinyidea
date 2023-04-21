#' module_group_analysis UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @importFrom bs4Dash bs4Card
#' @importFrom shiny NS tagList fluidRow includeMarkdown fileInput uiOutput
mod_group_analysis_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(
    
    shiny::fluidRow(
      col_12(
        bs4Dash::bs4Card(
          inputId = ns("doc_card_group"),
          title = "A propos de ce module",
          width = 12,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          shiny::includeMarkdown(app_sys("app", "docs", "explore_group.md")),
          shiny::fileInput(ns("dir"), "Charger plusieurs calculateurs", accept = c(".xls",".xlsx",".json"), width = "100%", multiple = TRUE, buttonLabel = "Charger...",placeholder = "Maintenir la touche CTRL pour une sélection multiple")
        )
      )
    ),
    shiny::uiOutput(ns("result_boxes")),
    shiny::uiOutput(ns("download_box"))
  )
}
    
#' module_group_analysis Server Functions
#'
#' @noRd 
#' @import data.table
#' @importFrom bs4Dash bs4Card
#' @importFrom dplyr inner_join mutate filter select
#' @importFrom DT renderDataTable datatable formatStyle styleEqual dataTableOutput
#' @importFrom ggplot2 guides element_text
#' @importFrom grDevices pdf
#' @importFrom plotly renderPlotly ggplotly plotlyOutput
#' @importFrom shiny moduleServer eventReactive observeEvent p renderUI fluidRow div icon
#' @importFrom tidyr gather spread
#' @importFrom shinycssloaders withSpinner
mod_group_analysis_server <- function(id){
  shiny::moduleServer(id, function(input, output, session){
    ns <- session$ns
 
    # Permet d'éviter une erreur liée au fichier "Rplots.pdf"
    grDevices::pdf(NULL)
    
    # Définition du dossier de travail temporaire où créer puis piocher les fichiers
    outdir <- tempdir()
    
    IDEAcollectivedata <- shiny::eventReactive(input$dir,{
      
      idea_group_diag <- diag_idea(dirname(input$dir$datapath[[1]]),export_type = NULL, type = "group", quiet = TRUE)

      idea_group_diag$data$dataset <- data.table::as.data.table(idea_group_diag$data$dataset)

      idea_group_diag$data$dataset$dimension_value <- unlist(idea_group_diag$data$dataset$dimension_value)
      idea_group_diag$data$dataset$score_category <- unlist(idea_group_diag$data$dataset$score_category)

      idea_group_diag

    })

    shiny::observeEvent(input$dir, {

      output$group_boxplot <- plotly::renderPlotly({

        df_dim <- unique(IDEAcollectivedata()$data$dataset[,.(farm_id,dimension_code,dimension_value)])
        df_dim$dimension = sapply(df_dim$dimension_code,return_dimension)
        df_dim$dimension = factor(df_dim$dimension, levels = c("Agroécologique","Socio-Territoriale","Economique"))

        moys <- df_dim[,.(Moyenne = mean(dimension_value)),by = dimension]

        p <- ggplot(df_dim, aes(x = dimension, y = dimension_value)) +
          stat_boxplot(geom = "errorbar", width = 0.3) +
          geom_boxplot(color = "black", aes(fill = dimension), width = 0.8) +
          geom_point(data = moys, aes(x = dimension, y = Moyenne), size = 4, color = "darkred",shape = 18) +
          IDEATools:::theme_idea() +
          scale_fill_manual(values = c("Agroécologique" = "#2e9c15", "Socio-Territoriale" = "#5077FE", "Economique" = "#FE962B")) +
          theme(axis.title.x = element_blank()) +
          ggplot2::guides(fill = "none") +
          labs(y = "Valeur de la dimension",fill = "Dimension") +
          scale_y_continuous(breaks = seq(0,100,10), limits = c(0,100)) +
          theme(axis.text.x = ggplot2::element_text(angle = 45))

        plotly::ggplotly(shiny::p)

      })
      output$table_prop <- DT::renderDataTable({

        df <- IDEAcollectivedata()$data$nodes$Global %>%
          tidyr::gather(key = indic, value = resultat, -farm_id) %>%
          dplyr::inner_join(IDEATools:::reference_list$properties_nodes, by = c("indic" = "node_code")) %>%
          dplyr::mutate(resultat = factor(resultat, levels = c("très favorable", "favorable", "intermédiaire", "défavorable", "très défavorable", "NC"))) %>%
          dplyr::mutate(indic_name = ifelse(node_name == "Capacité productive et reproductive de biens et de services", yes = "Capacité productive et \n reproductive de biens et de \n services", no = node_name)) %>%
          dplyr::filter(level == "propriete") %>%
          dplyr::select(farm_id,node_name,resultat) %>%
          tidyr::spread(key = node_name, value = resultat)

        rown <- df$farm_id
        df <- df %>% dplyr::select(-farm_id)


        DT::datatable(df, rownames = rown, options = list(pageLength = 4)) %>%
          DT::formatStyle('Robustesse', backgroundColor = DT::styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          DT::formatStyle('Autonomie', backgroundColor = DT::styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          DT::formatStyle('Ancrage territorial', backgroundColor = DT::styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          DT::formatStyle('Capacité productive et reproductive de biens et de services', backgroundColor = DT::styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          DT::formatStyle('Responsabilité globale', backgroundColor = DT::styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          DT::formatStyle(c("Robustesse","Autonomie", "Ancrage territorial", "Capacité productive et reproductive de biens et de services", "Responsabilité globale"), border = '1px solid #ddd')

      })
      output$result_boxes <- shiny::renderUI({

        shiny::fluidRow(

          bs4Dash::bs4Card(inputId = ns("boxplotCard"),
                  title = "Résultats par les dimensions",
                  width = 5,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  closable = FALSE,
                  solidHeader = TRUE,
                  plotly::plotlyOutput(ns("group_boxplot")) %>% shinycssloaders::withSpinner(color="#0dc5c1")),

          bs4Dash::bs4Card(inputId = ns("DTCard"),
                  title = "Résultats par les propriétés",
                  width = 7,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  closable = FALSE,
                  solidHeader = TRUE,
                  DT::dataTableOutput(ns("table_prop")) %>% shinycssloaders::withSpinner(color="#0dc5c1")
          )





        )



      })


      output$download_box <- shiny::renderUI({


        bs4Dash::bs4Card(inputID = "download_card_group",title = "Télécharger le diagnostic de groupe complet",width = 12,
                solidHeader = TRUE,closable = FALSE,
                shiny::div(
                  style="display:inline-block;width:100%;text-align: center;",
                  CustomDownloadButton(
                    ns("dl_group_pdf"),
                    label = "Rapport PDF",
                    icon = shiny::icon("file-pdf"),
                    size = 'lg'
                  ),
                  CustomDownloadButton(
                    ns("dl_group_xlsx"),
                    label = "Document Excel (XLSX)",
                    icon = shiny::icon("file-excel"),
                    size = 'lg'
                  ),
                  CustomDownloadButton(
                    ns("dl_group_zip"),
                    label = "Figures brutes (ZIP)",
                    icon = shiny::icon("file-archive"),
                    size = 'lg'
                  )
                ))

      })




    })
    
  })
}
    
## To be copied in the UI
# mod_group_analysis_ui("group_analysis_ui_1")
    
## To be copied in the server
# mod_group_analysis_server("group_analysis_ui_1")
