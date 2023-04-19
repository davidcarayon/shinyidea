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
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      col_12(
        bs4Dash::bs4Callout(width = 12,
                   title = "Bienvenue sur ShinyIDEA",
                   headerBorder = FALSE,
                   closable = FALSE,
                   collapsible = FALSE,
                   status = "success",
                   shiny::includeMarkdown(app_sys("app", "docs", "welcome.md")),
                   bs4Dash::bs4Callout(
                    width = 12,
                   title = "Note",
                   headerBorder = FALSE,
                   closable = FALSE,
                   collapsible = FALSE,
                   status = "warning",
                  shiny::includeMarkdown(app_sys("app", "docs", "welcome_callout.md")),
                   ),
                    "L'application ShinyIDEA est un programme libre. Celui-est diffusé dans l’espoir qu’il sera utile, mais sans aucune garantie de qualité marchande ou d’adéquation à un but particulier."
        )
      )
    ),
  
    shiny::fluidRow(
      bs4Dash::box(width = 12,title = "Contributeurs",
          shiny::includeMarkdown(app_sys("app", "docs", "bandeau.md")))
      
    )
  )
}

#' module_welcome Server Functions
#'
#' @noRd 
#' @importFrom shiny moduleServer
mod_welcome_server <- function(id){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}

## To be copied in the UI
# mod_welcome_ui("welcome_ui_1")

## To be copied in the server
# mod_welcome_server("welcome_ui_1")
