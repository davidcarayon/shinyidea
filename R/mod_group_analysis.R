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
  ns <- NS(id)
  tagList(
    
    fluidRow(
      col_12(
        bs4Card(
          inputId = ns("doc_card_group"),
          title = "A propos de ce module",
          width = 12,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          includeMarkdown(app_sys("app", "docs", "explore_group.md")),
          fileInput(ns("dir"), "Charger plusieurs calculateurs", accept = c(".xls",".xlsx",".json"), width = "100%", multiple = TRUE, buttonLabel = "Charger...",placeholder = "Maintenir la touche CTRL pour une sélection multiple")
        )
      )
    ),
    uiOutput(ns("result_boxes")),
    uiOutput(ns("download_box"))
  )
}
    
#' module_group_analysis Server Functions
#'
#' @noRd 
#' @importFrom bs4Dash bs4Card
#' @importFrom dplyr inner_join distinct mutate group_by summarise filter select
#' @importFrom DT renderDataTable datatable dataTableOutput
#' @importFrom ggrepel geom_label_repel
#' @importFrom grDevices pdf
#' @importFrom IDEATools diag_idea
#' @importFrom shiny moduleServer eventReactive observeEvent renderPlot renderUI fluidRow plotOutput div icon
#' @importFrom shinycssloaders withSpinner
#' @importFrom tidyr gather spread
#' @importFrom DT renderDataTable datatable formatStyle styleEqual dataTableOutput
#' @importFrom ggplot2 ggplot aes stat_boxplot geom_boxplot geom_point scale_fill_manual theme element_blank labs scale_y_continuous
#' @importFrom tidyr gather spread
mod_group_analysis_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
    # Permet d'éviter une erreur liée au fichier "Rplots.pdf"
    pdf(NULL)
    
    # Définition du dossier de travail temporaire où créer puis piocher les fichiers
    outdir <- tempdir()
    
    IDEAcollectivedata <- eventReactive(input$dir,{
      diag_idea(dirname(input$dir$datapath[[1]]),export_type = NULL, type = "group", quiet = TRUE)
    })

    observeEvent(input$dir, {

      output$group_boxplot <- renderPlot({

        df_dim <- IDEAcollectivedata()$data$dataset %>%
          inner_join(IDEATools:::reference_list$indic_dim, by = "dimension_code") %>%
          distinct(farm_id,dimension,dimension_value) %>%
          mutate(dimension = factor(dimension, levels = c("Agroécologique","Socio-Territoriale","Economique")))

        moys <- df_dim %>% group_by(dimension) %>% summarise(Moyenne = mean(dimension_value))

        p <- ggplot(df_dim, aes(x = dimension, y = dimension_value)) +
          stat_boxplot(geom = "errorbar", width = 0.3) +
          geom_boxplot(color = "black", aes(fill = dimension), width = 0.8) +
          geom_point(data = moys, aes(x = dimension, y = Moyenne), size = 4, color = "darkred",shape = 18) +
          geom_label_repel(data = moys, aes(x = dimension, y = Moyenne, label = paste0("Moyenne = ",round(Moyenne,1))), nudge_x = 0.5, nudge_y = 5) +
          theme_tq_cust() +
          scale_fill_manual(values = c("Agroécologique" = "#2e9c15", "Socio-Territoriale" = "#5077FE", "Economique" = "#FE962B")) +
          theme(axis.title.x = element_blank()) +
          labs(y = "Valeur de la dimension",fill = "Dimension") +
          scale_y_continuous(breaks = seq(0,100,10), limits = c(0,100))

        p

      })
      output$table_prop <- renderDataTable({

        df <- IDEAcollectivedata()$data$nodes$Global %>%
          gather(key = indic, value = resultat, -farm_id) %>%
          inner_join(IDEATools:::reference_list$properties_nodes, by = c("indic" = "node_code")) %>%
          mutate(resultat = factor(resultat, levels = c("très favorable", "favorable", "intermédiaire", "défavorable", "très défavorable", "NC"))) %>%
          mutate(indic_name = ifelse(node_name == "Capacité productive et reproductive de biens et de services", yes = "Capacité productive et \n reproductive de biens et de \n services", no = node_name)) %>%
          filter(level == "propriete") %>%
          select(farm_id,node_name,resultat) %>%
          spread(key = node_name, value = resultat)

        rown <- df$farm_id
        df <- df %>% select(-farm_id)


        datatable(df, rownames = rown, options = list(pageLength = 4)) %>%
          formatStyle('Robustesse', backgroundColor = styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          formatStyle('Autonomie', backgroundColor = styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          formatStyle('Ancrage territorial', backgroundColor = styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          formatStyle('Capacité productive et reproductive de biens et de services', backgroundColor = styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          formatStyle('Responsabilité globale', backgroundColor = styleEqual(c("favorable", "défavorable", "intermédiaire","très défavorable", "très favorable"), c('#1CDA53', '#FF6348',"#FFA300","#FF0000","#0D8A00"))) %>%
          formatStyle(c("Robustesse","Autonomie", "Ancrage territorial", "Capacité productive et reproductive de biens et de services", "Responsabilité globale"), border = '1px solid #ddd')

      })
      output$result_boxes <- renderUI({

        fluidRow(

          bs4Card(inputId = ns("boxplotCard"),
                  title = "Résultats par les dimensions",
                  width = 5,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  closable = FALSE,
                  solidHeader = TRUE,
                  plotOutput(ns("group_boxplot")) %>% withSpinner(color="#0dc5c1")),

          bs4Card(inputId = ns("DTCard"),
                  title = "Résultats par les propriétés",
                  width = 7,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  closable = FALSE,
                  solidHeader = TRUE,
                  dataTableOutput(ns("table_prop")) %>% withSpinner(color="#0dc5c1")
          )





        )



      })


      output$download_box <- renderUI({


        bs4Card(inputID = "download_card_group",title = "Télécharger le diagnostic de groupe complet",width = 12,
                solidHeader = TRUE,closable = FALSE,
                div(
                  style="display:inline-block;width:100%;text-align: center;",
                  CustomDownloadButton(
                    ns("dl_group_pdf"),
                    label = "Format PDF",
                    icon = icon("file-pdf")
                  ),
                  CustomDownloadButton(
                    ns("dl_group_xlsx"),
                    label = "Format XLSX",
                    icon = icon("file-excel")
                  ),
                  CustomDownloadButton(
                    ns("dl_group_pptx"),
                    label = "Format PPTX",
                    icon = icon("file-powerpoint")
                  ),
                  CustomDownloadButton(
                    ns("dl_group_docx"),
                    label = "Format DOCX",
                    icon = icon("file-word")
                  ),
                  CustomDownloadButton(
                    ns("dl_group_zip"),
                    label = "Format ZIP",
                    icon = icon("file-archive")
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
