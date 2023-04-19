#' database_stat UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList icon tableOutput
#' @importFrom shinyWidgets actionBttn
mod_database_stat_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(
              shinyWidgets::actionBttn(
   inputId = ns("modal"),
   label = "Me connecter pour accéder à ces fonctionnalités", 
   style = "simple",
   color = "success",
  icon = shiny::icon("user-plus"),
  size = "md"
),
    shiny::tableOutput(ns("toto"))
        )
}
    
#' database_stat Server Functions
#'
#' @noRd 
#' @importFrom bs4Dash updateSidebar sidebarUserPanel
#' @importFrom DBI dbConnect dbReadTable dbDisconnect
#' @importFrom RSQLite SQLite
#' @importFrom shiny moduleServer observeEvent showModal modalDialog textInput passwordInput actionButton modalButton removeModal renderTable
#' @importFrom shinyjs hide
mod_database_stat_server <- function(id){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns


    shiny::observeEvent(input$modal, {

          shiny::showModal(shiny::modalDialog(
          title = "Me connecter",
          shiny::textInput(ns("mail"),"Adresse mail"),
          shiny::passwordInput(ns("password"),"Mot de passe"),
          shiny::actionButton(ns("login"),"Me connecter"),
          footer = shiny::modalButton("Fermer")
        ))


    })


    shiny::observeEvent(input$login, {

      shiny::removeModal()
      output$toto <- shiny::renderTable({
      mydb <- DBI::dbConnect(RSQLite::SQLite(), "my-db.sqlite")
      table <- DBI::dbReadTable(mydb, "dataset")
      DBI::dbDisconnect(mydb)
      table
        
        })

      shinyjs::hide("modal")
      shinyjs::hide("login")
      shinyjs::hide("mail")
      shinyjs::hide("password")

      bs4Dash::updateSidebar(
        bs4Dash::sidebarUserPanel(
      image = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg",
      name = "David"
    )
      ) 

    })

    
 
  })
}
    
## To be copied in the UI
# mod_database_stat_ui("database_stat_1")
    
## To be copied in the server
# mod_database_stat_server("database_stat_1")
