#' jsonify UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom bs4Dash bs4Card
#' @importFrom shiny NS tagList fluidRow includeMarkdown fileInput br uiOutput
mod_jsonify_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        bs4Card(
          inputId = ns("json_card"),
          title = "A propos de ce module",
          width = 12,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          includeMarkdown(app_sys("app", "docs", "json_pres.md")),
          fileInput(ns("jsonfile"), "Charger votre calculateur :", accept = c(".xls", ".xlsx"), width = "100%", multiple = FALSE, buttonLabel = "Charger...", placeholder = "Aucun fichier chargé")
        )
      )
    ),
    br(),
    col_12(uiOutput(ns("download_json_box"), width = 12))
  )
}

#' jsonify Server Functions
#'
#' @noRd 
#' @importFrom bs4Dash bs4Card
#' @importFrom shiny moduleServer observeEvent renderUI div icon
mod_jsonify_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    observeEvent(input$jsonfile, {
      
      output$download_json_box <- renderUI({
        bs4Card(
          inputID = "download_card_json", title = "Télécharger votre fichier JSON", width = 12,
          solidHeader = TRUE, color ="info", closable = FALSE,
          div(
            style = "display:inline-block;width:100%;text-align: center;",
            CustomDownloadButton(
              ns("dl_json"),
              label = "Télécharger les données issues de votre calculateur au format JSON",
              icon = icon("file-code")
            )
          )
        )
      })
    })
  })
}

## To be copied in the UI
# mod_jsonify_ui("jsonify_ui_1")

## To be copied in the server
# mod_jsonify_server("jsonify_ui_1")
