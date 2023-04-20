#' module_indiv_analysis UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @import data.table
#' @importFrom bs4Dash bs4Card
#' @importFrom shiny NS tagList fluidRow includeMarkdown fileInput downloadButton br uiOutput
mod_indiv_analysis_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      col_12(
        bs4Dash::bs4Card(
          inputId = ns("doc_card"),
          title = "A propos de ce module",
          width = 12,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          shiny::includeMarkdown(app_sys("app", "docs", "explore.md")),
          shiny::fileInput(ns("files"), "Charger votre calculateur :", accept = c(".xls", ".xlsx", ".json",".zip"), width = "100%", multiple = FALSE, buttonLabel = "Charger...", placeholder = "Aucun fichier chargé"),
          shiny::downloadButton(outputId = ns("example_data"), label = "Télécharger un exemple de données d'entrée")
        )
      )
    ),
    shiny::br(),
    shiny::uiOutput(ns("result_boxes")),
    shiny::br(),
    col_12(shiny::uiOutput(ns("download_box"), width = 12))
  )
}

#' module_indiv_analysis Server Functions
#'
#' @noRd 
#' @import data.table
#' @importFrom bs4Dash renderInfoBox infoBox renderbs4InfoBox bs4InfoBox bs4Card bs4InfoBoxOutput
#' @importFrom DBI dbConnect dbWriteTable dbDisconnect
#' @importFrom grDevices pdf
#' @importFrom RSQLite SQLite
#' @importFrom shiny moduleServer eventReactive observeEvent renderPlot icon renderText HTML req renderUI div fluidRow htmlOutput plotOutput
#' @importFrom stringr str_to_title
mod_indiv_analysis_server <- function(id){
  shiny::moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Permet d'éviter une erreur liée au fichier "Rplots.pdf"
    grDevices::pdf(NULL)
    
    # Définition du dossier de travail temporaire où créer puis piocher les fichiers
    outdir <- tempdir()
    
    IDEAdata <- shiny::eventReactive(input$files, {

      idea_diag <- diag_idea(input$files$datapath, plot_choices = "dimensions", export_type = NULL, type = "single", quiet = TRUE)

      idea_diag$data$dataset <- data.table::as.data.table(idea_diag$data$dataset)

      idea_diag$data$dataset$dimension_value <- unlist(idea_diag$data$dataset$dimension_value)
      idea_diag$data$dataset$score_category <- unlist(idea_diag$data$dataset$score_category)

      mydb <- DBI::dbConnect(RSQLite::SQLite(), "my-db.sqlite")
      DBI::dbWriteTable(mydb, "dataset", idea_diag$data$dataset, append = TRUE)
      DBI::dbDisconnect(mydb)

      idea_diag

    })

    shiny::observeEvent(input$files, {

      dataset <- IDEAdata()$data$dataset

      ## Extraction score dimensions
      vec_dim <- unique(dataset[,.(dimension_code,dimension_value)])

      notes_dimensions = vec_dim$dimension_value
      names(notes_dimensions) = vec_dim$dimension_code

      output$plot_dim <- shiny::renderPlot({
        IDEAdata()$dimensions$plot_dimensions
      })


      output$note_ae <- bs4Dash::renderInfoBox({
        bs4Dash::infoBox(value=paste0(notes_dimensions["A"], "/100"), title = "Durabilité Agroécologique", icon = shiny::icon("leaf"), color = "success", width = 12, fill = TRUE)
      })

      output$note_st <- bs4Dash::renderbs4InfoBox({
        bs4Dash::bs4InfoBox(value=paste0(notes_dimensions["B"], "/100"), title = "Durabilité Socio-\nTerritoriale", icon = shiny::icon("handshake"), color = "primary", width = 12, fill = TRUE)
      })

      output$note_ec <- bs4Dash::renderbs4InfoBox({
        bs4Dash::bs4InfoBox(value=paste0(notes_dimensions["C"], "/100"), title = "Durabilité Economique", icon = shiny::icon("euro-sign"), color = "warning", width = 12, fill = TRUE)
      })

      output$IDEAtext <- shiny::renderText({

        dataset <- IDEAdata()$data$dataset

         ## Extraction score dimensions
        vec_dim <- unique(dataset[,.(dimension_code,dimension_value)])
        min_dim <- unlist(vec_dim[order(dataset$dimension_value),][1,.(dimension_code)])
        text_dim <- return_dimension(min_dim)
        value = min(dataset$dimension_value)

        shiny::HTML(paste0("La méthode IDEA retient la note la plus faible des 3 dimensions en tant que valeur finale, puisque les dimensions ne peuvent se compenser entre elles (principe de la durabilité forte).<br> Ainsi, votre exploitation obtient la note de <b>", value, "/100 </b> avec la méthode IDEA, correspondant à la dimension <b>", text_dim, "</b>."))
      })

      output$prop1 <- bs4Dash::renderbs4InfoBox({
        shiny::req(IDEAdata())
        val <- IDEAdata()$data$nodes$Robustesse$R10
        
        color <- replace_col(val)
        
        val <- stringr::str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4Dash::bs4InfoBox(
          value = paste(val),
          title = "Robustesse",
          icon = shiny::icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })

      output$prop2 <- bs4Dash::renderbs4InfoBox({
        shiny::req(IDEAdata())
        val <- IDEAdata()$data$nodes$Ancrage$AN5
        
        color <- replace_col(val)
        
        val <- stringr::str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4Dash::bs4InfoBox(
          value = paste(val),
          title = "Ancrage territorial",
          icon = shiny::icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })

      output$prop3 <- bs4Dash::renderbs4InfoBox({
        shiny::req(IDEAdata())
        val <- IDEAdata()$data$nodes$Autonomie$AU6
        
        color <- replace_col(val)
        
        val <- stringr::str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4Dash::bs4InfoBox(
          value = paste(val),
          title = "Autonomie",
          icon = shiny::icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })

      output$prop4 <- bs4Dash::renderbs4InfoBox({
        shiny::req(IDEAdata())
        val <- IDEAdata()$data$nodes$Responsabilite$RG15
        
        color <- replace_col(val)
        
        val <- stringr::str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4Dash::bs4InfoBox(
          value = paste(val),
          title = "Responsabilité globale",
          icon = shiny::icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })

      output$prop5 <- bs4Dash::renderbs4InfoBox({
        shiny::req(IDEAdata())
        val <- IDEAdata()$data$nodes$Capacite$CP10
        
        color <- replace_col(val)
        
        val <- stringr::str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4Dash::bs4InfoBox(
          value = paste(val),
          title = "Capacité productive et reproductive de biens et de services",
          icon = shiny::icon(ico),
          color =color, href = "#", width = 12, fill = TRUE
        )
      })
      
      output$download_box <- shiny::renderUI({
        bs4Dash::bs4Card(
          inputID = "download_card", title = "Télécharger le diagnostic complet", width = 12,
          solidHeader = TRUE, color ="info", closable = FALSE,
          shiny::div(
            style = "display:inline-block;width:100%;text-align: center;",
            CustomDownloadButton(
              ns("dl_pdf"),
              label = "Rapport PDF",
              icon = shiny::icon("file-pdf"),
              size = "lg"
            ),
            CustomDownloadButton(
              ns("dl_xlsx"),
              label = "Document Excel (XLSX)",
              icon = shiny::icon("file-excel"),
              size = "lg"
            ),
            CustomDownloadButton(
              ns("dl_zip"),
              label = "Figures brutes (ZIP)",
              icon = shiny::icon("file-archive"),
              size = "lg"
            )
          )
        )
      })

      output$result_boxes <- shiny::renderUI({
        shiny::div(
          shiny::fluidRow(
            bs4Dash::bs4Card(
              inputId = ns("doc_dim"),
              title = "Vos résultats par les dimensions de la durabilité",
              color ="info",
              footer = shiny::htmlOutput(ns("IDEAtext")),
              width = 6,
              collapsible = TRUE,
              collapsed = FALSE,
              closable = FALSE,
              solidHeader = TRUE,
              shiny::fluidRow(
                # infoBoxOutput(ns("note_ae"), width = 4),
                # bs4InfoBoxOutput(ns("note_st"), width = 4),
                # bs4InfoBoxOutput(ns("note_ec"), width = 4)
                shiny::plotOutput(ns("plot_dim"))
              )
            ),
            
            
            bs4Dash::bs4Card(
              inputId = ns("doc_prop"),
              title = "Vos résultats par les propriétés de la durabilité",
              color ="info",
              solidHeader = TRUE,
              width = 6,
              collapsible = TRUE,
              collapsed = FALSE,
              closable = FALSE,
              
              shiny::fluidRow(
                bs4Dash::bs4InfoBoxOutput(ns("prop1"), width = 12),
                bs4Dash::bs4InfoBoxOutput(ns("prop2"), width = 12),
                bs4Dash::bs4InfoBoxOutput(ns("prop3"), width = 12),
                bs4Dash::bs4InfoBoxOutput(ns("prop4"), width = 12),
                bs4Dash::bs4InfoBoxOutput(ns("prop5"), width = 12),
              )
            )
          ),
        )
      })
    })
  })
}

## To be copied in the UI
# mod_indiv_analysis_ui("indiv_analysis_ui_1")

## To be copied in the server
# mod_indiv_analysis_server("indiv_analysis_ui_1")
