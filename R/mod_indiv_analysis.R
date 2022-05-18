#' module_indiv_analysis UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @importFrom bs4Dash bs4Card
#' @importFrom shiny NS tagList fluidRow includeMarkdown fileInput downloadButton br uiOutput
mod_indiv_analysis_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        bs4Card(
          inputId = ns("doc_card"),
          title = "A propos de ce module",
          width = 12,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          includeMarkdown(app_sys("app", "docs", "explore.md")),
          fileInput(ns("files"), "Charger votre calculateur :", accept = c(".xls", ".xlsx", ".json",".zip"), width = "100%", multiple = FALSE, buttonLabel = "Charger...", placeholder = "Aucun fichier chargé"),
          downloadButton(outputId = ns("example_data"), label = "Télécharger un exemple de données d'entrée")
        )
      )
    ),
    br(),
    uiOutput(ns("result_boxes")),
    br(),
    col_12(uiOutput(ns("download_box"), width = 12))
  )
}

#' module_indiv_analysis Server Functions
#'
#' @noRd 
#' @importFrom grDevices pdf
#' @importFrom zip zip
#' @importFrom bs4Dash renderInfoBox infoBox renderbs4InfoBox bs4InfoBox bs4Card infoBoxOutput bs4InfoBoxOutput
#' @importFrom dplyr arrange slice inner_join pull filter
#' @importFrom IDEATools diag_idea
#' @importFrom shiny moduleServer eventReactive observeEvent req icon renderText HTML renderUI div fluidRow htmlOutput
#' @importFrom tidyr gather
#' @importFrom stringr str_to_title
mod_indiv_analysis_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Permet d'éviter une erreur liée au fichier "Rplots.pdf"
    pdf(NULL)
    
    # Définition du dossier de travail temporaire où créer puis piocher les fichiers
    outdir <- tempdir()
    
    IDEAdata <- eventReactive(input$files, {
      diag_idea(input$files$datapath, plot_choices = "", export_type = NULL, type = "single", quiet = TRUE)
    })
    
    observeEvent(input$files, {
      
      
      output$note_ae <- renderInfoBox({
        req(IDEAdata())
        value <- unique(subset(IDEAdata()$data$dataset, dimension_code == "A")$dimension_value)
        infoBox(value=paste0(value, "/100"), title = "Durabilité Agroécologique", icon = icon("leaf"), color = "success", width = 12, fill = TRUE)
      })
      output$note_st <- renderbs4InfoBox({
        req(IDEAdata())
        value <- unique(subset(IDEAdata()$data$dataset, dimension_code == "B")$dimension_value)
        bs4InfoBox(value=paste0(value, "/100"), title = "Durabilité Socio-\nTerritoriale", icon = icon("handshake"), color = "primary", width = 12, fill = TRUE)
      })
      output$note_ec <- renderbs4InfoBox({
        req(IDEAdata())
        value <- unique(subset(IDEAdata()$data$dataset, dimension_code == "C")$dimension_value)
        bs4InfoBox(value=paste0(value, "/100"), title = "Durabilité Economique", icon = icon("euro-sign"), color = "warning", width = 12, fill = TRUE)
      })
      output$IDEAtext <- renderText({
        req(IDEAdata())
        value <- min(IDEAdata()$data$dataset$dimension_value)
        newdim <- IDEAdata()$data$dataset %>%
          arrange(dimension_value) %>%
          slice(1) %>%
          inner_join(IDEATools:::reference_list$indic_dim, by = "dimension_code") %>%
          pull(dimension) %>%
          unique()
        
        
        
        HTML(paste0("La méthode IDEA retient la note la plus faible des 3 dimensions en tant que valeur finale, puisque les dimensions ne peuvent se compenser entre elles (principe de la durabilité forte).<br> Ainsi, votre exploitation obtient la note de <b>", value, "/100 </b> avec la méthode IDEA, correspondant à la dimension <b>", newdim, "</b>."))
      })
      output$proptext <- renderText({
        req(IDEAdata())
        
        to_increase <- IDEAdata()$data$nodes$Global %>%
          gather(key = node_code, value = valeur) %>%
          inner_join(IDEATools:::reference_list$properties_nodes, by = "node_code") %>%
          filter(level == "propriete") %>%
          filter(valeur %in% c("défavorable", "très défavorable")) %>%
          pull(node_name) %>%
          paste(collapse = " / ")
        
        
        if (nchar(to_increase) == 0) {
          to_increase <- "Aucune en particulier"
        }
        
        
        HTML(paste0("La méthode IDEA évalue également les exploitations agricoles, depuis sa version 4, selon les propriétés de la durabilité.<br>
                  Selon cette approche, votre exploitation devrait axer ses efforts sur la ou les propriété(s) : <b>", to_increase, "</b>"))
      })
      output$prop1 <- renderbs4InfoBox({
        req(IDEAdata())
        val <- IDEAdata()$data$nodes$Robustesse$R10
        
        color <- replace_col(val)
        
        val <- str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4InfoBox(
          value = paste(val),
          title = "Robustesse",
          icon = icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })
      output$prop2 <- renderbs4InfoBox({
        req(IDEAdata())
        val <- IDEAdata()$data$nodes$Ancrage$AN5
        
        color <- replace_col(val)
        
        val <- str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4InfoBox(
          value = paste(val),
          title = "Ancrage territorial",
          icon = icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })
      output$prop3 <- renderbs4InfoBox({
        req(IDEAdata())
        val <- IDEAdata()$data$nodes$Autonomie$AU6
        
        color <- replace_col(val)
        
        val <- str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4InfoBox(
          value = paste(val),
          title = "Autonomie",
          icon = icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })
      output$prop4 <- renderbs4InfoBox({
        req(IDEAdata())
        val <- IDEAdata()$data$nodes$Responsabilite$RG15
        
        color <- replace_col(val)
        
        val <- str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4InfoBox(
          value = paste(val),
          title = "Responsabilité globale",
          icon = icon(ico),
          color =color, href = "#", fill = TRUE
        )
      })
      output$prop5 <- renderbs4InfoBox({
        req(IDEAdata())
        val <- IDEAdata()$data$nodes$Capacite$CP10
        
        color <- replace_col(val)
        
        val <- str_to_title(val)
        
        ico <- ifelse(val %in% c("Favorable", "Très Favorable"), yes = "smile", no = "frown")
        
        bs4InfoBox(
          value = paste(val),
          title = "Capacité productive et reproductive de biens et de services",
          icon = icon(ico),
          color =color, href = "#", width = 12, fill = TRUE
        )
      })
      
      output$download_box <- renderUI({
        bs4Card(
          inputID = "download_card", title = "Télécharger le diagnostic complet", width = 12,
          solidHeader = TRUE, color ="info", closable = FALSE,
          div(
            style = "display:inline-block;width:100%;text-align: center;",
            CustomDownloadButton(
              ns("dl_pdf"),
              label = "Format PDF",
              icon = icon("file-pdf")
            ),
            CustomDownloadButton(
              ns("dl_xlsx"),
              label = "Format XLSX",
              icon = icon("file-excel")
            ),
            CustomDownloadButton(
              ns("dl_pptx"),
              label = "Format PPTX",
              icon = icon("file-powerpoint")
            ),
            CustomDownloadButton(
              ns("dl_docx"),
              label = "Format DOCX",
              icon = icon("file-word")
            ),
            CustomDownloadButton(
              ns("dl_zip"),
              label = "Format ZIP",
              icon = icon("file-archive")
            )
          )
        )
      })
      output$result_boxes <- renderUI({
        div(
          fluidRow(
            bs4Card(
              inputId = ns("doc_dim"),
              title = "Vos résultats par les dimensions de la durabilité",
              color ="info",
              footer = htmlOutput(ns("IDEAtext")),
              width = 6,
              collapsible = TRUE,
              collapsed = FALSE,
              closable = FALSE,
              solidHeader = TRUE,
              fluidRow(
                infoBoxOutput(ns("note_ae"), width = 4),
                bs4InfoBoxOutput(ns("note_st"), width = 4),
                bs4InfoBoxOutput(ns("note_ec"), width = 4)
              )
            ),
            
            
            bs4Card(
              inputId = ns("doc_prop"),
              title = "Vos résultats par les propriétés de la durabilité",
              color ="info",
              footer = htmlOutput(ns("proptext")),
              solidHeader = TRUE,
              width = 6,
              collapsible = TRUE,
              collapsed = FALSE,
              closable = FALSE,
              
              fluidRow(
                bs4InfoBoxOutput(ns("prop1")),
                bs4InfoBoxOutput(ns("prop2")),
                bs4InfoBoxOutput(ns("prop3")),
                bs4InfoBoxOutput(ns("prop4")),
                bs4InfoBoxOutput(ns("prop5"), width = 8),
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
