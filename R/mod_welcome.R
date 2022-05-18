#' module_welcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom bs4Dash bs4Callout box
#' @importFrom shiny NS tagList fluidRow includeMarkdown
mod_welcome_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        bs4Callout(width = 12,
                   title = "Bienvenue sur ShinyIDEA",
                   headerBorder = FALSE,
                   closable = FALSE,
                   collapsible = FALSE,
                   status = "info",
                   includeMarkdown(app_sys("app", "docs", "welcome.md")),
        )
      )
    ),
    
    # Acknowledgments
    fluidRow(
      col_12(
        bs4Callout(
          title = "A propos de cette application",
          width = 12,
          status = "info",
          "L'application ShinyIDEA est un programme libre. Celui-est diffusé dans l’espoir qu’il sera utile, mais sans aucune garantie de qualité marchande ou d’adéquation à un but particulier."
        )
      )
    ),
    fluidRow(
      box(width = 12,title = "Contributeurs",
          includeMarkdown(app_sys("app", "docs", "bandeau.md")))
      
    )
  )
}

#' module_welcome Server Functions
#'
#' @noRd 
#' @importFrom shiny moduleServer
mod_welcome_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}

## To be copied in the UI
# mod_welcome_ui("welcome_ui_1")

## To be copied in the server
# mod_welcome_server("welcome_ui_1")
