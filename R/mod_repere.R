#' repere UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @import shinyWidgets
#' @importFrom bs4Dash bs4Card column infoBoxOutput
#' @importFrom shiny NS tagList br fluidRow selectInput sliderInput icon uiOutput
mod_repere_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(
    bs4Dash::bs4Card(id = ns("filter_card"),title = "A propos de ce module", width = 12, collapsed = FALSE,
            "Bienvenue sur le module d’édition de données repère. Vous pouvez ici des filtres à appliquer pour obtenir des statistiques descriptives sur la base.",
            shiny::br(),
    shiny::br(),
    shiny::fluidRow(
      bs4Dash::column(width = 3,
               shiny::selectInput("lyc_agr", "Quelles exploitations ?", choices = c("Toutes les exploitations agricoles", "Uniquement les lycées agricoles", "Toutes les exploitations sauf les lycées agricoles"), selected = c("Toutes les exploitations agricoles", "Uniquement les lycées agricoles", "Toutes les exploitations sauf les lycées agricoles"), width = "100%"),
               
               shiny::selectInput("vers", label = "Version utilisée", choices = c("4.1.5", "4.1.6"), multiple = TRUE, selected = c("4.1.5", "4.1.6")),
               shiny::selectInput("age", label = "Tranche d'âge d'exploitation",choices = c("Moins de 26 ans",
                                                                                     "26 à 36 ans"), selected = c("Moins de 26 ans",
                                                                                                                  "26 à 36 ans"), multiple = TRUE),
               shiny::selectInput("otex", label = "Type d'exploitation (OTEX)",choices = c("(1500) Céréales et oléoprotéagineux",
                                                                                    "(3500) Viticulture"), selected = c("(1500) Céréales et oléoprotéagineux",
                                                                                                                        "(3500) Viticulture"), multiple = TRUE),
             
      ),
      
      bs4Dash::column(width = 3,
               shiny::selectInput("dpt", label = "Zone Géographique", choices = as.character(1:95), multiple = TRUE, selected = NULL),
               shiny::selectInput("atelier", label = "Atelier hors sol", choices = c("oui", "non"), multiple = TRUE, selected = c("oui","non")),
               shiny::selectInput("annee", label = "Année d'enquête", choices = as.character(2015:2025), multiple = TRUE, selected = as.character(2015:2025)),
               shiny::selectInput("elevage", label = "Type d'élevage",choices = c("Pas d'élevage",
                                                                           "Herbivore", "Monogastrique"), selected = c("Pas d'élevage",
                                                                                                                       "Herbivore", "Monogastrique")),
               shiny::selectInput("phyto", label = "Usage des produits phytos", choices = c("oui", "non"), multiple = TRUE, selected = c("oui","non")),
             
      ),
      bs4Dash::column(width = 3,
               shiny::sliderInput("sau", label = "SAU", min = 0, max = 500, value = c(40, 60)),
               shiny::sliderInput("uth", label = "UTH", min = 0, max = 10, value = c(4, 6)),
               shiny::sliderInput("uth-f", label = "UTH-F", min = 0, max = 10, value = c(4, 6)),
               shiny::sliderInput("surf_herbe", label = "Surface en herbe en % de la SAU", min = 0, max = 100, value = c(40, 60)),
             
      ),
      
      bs4Dash::column(width = 3,
               shiny::sliderInput("cap_exp", label = "Capital d'exploitation", min = -10000, max = 10000, value = c(400, 600)),
               shiny::sliderInput("ebe", label = "EBE",  min = -10000, max = 10000, value = c(400, 600)),
               shiny::sliderInput("res_cour", label = "Résultat courant", min = -10000, max = 10000, value = c(400, 600)),
               shiny::sliderInput("pp_sau", label = "Part des PP dans la SAU", min = 0, max = 100, value = c(40, 60)),
      )
    )
    ),
    shiny::br(),
    shinyWidgets::actionBttn(ns("filter"), "Appliquer les filtres", icon = shiny::icon("play"), block = TRUE, style = "simple", color = "success"),
    shiny::br(),
    bs4Dash::infoBoxOutput(ns("nb_exploit")),
    shiny::uiOutput(ns('download_box_repere')),
    shiny::br(),
    bs4Dash::infoBoxOutput(ns("nb_exploit2"))

  )
}
    
#' repere Server Functions
#'
#' @noRd 
#' @importFrom bs4Dash updatebs4Card renderInfoBox infoBox
#' @importFrom shiny moduleServer observeEvent icon renderUI
mod_repere_server <- function(id){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns

    shiny::observeEvent(input$filter,{

      bs4Dash::updatebs4Card("filter_card", action = "toggle")

      output$nb_exploit <- bs4Dash::renderInfoBox({
        bs4Dash::infoBox(value=10, title = "Nombre d'exploitations", icon = shiny::icon("house"), color = "success", width = 1, fill = TRUE)
      })

      output$nb_exploit2 <- bs4Dash::renderInfoBox({
        bs4Dash::infoBox(value=2, title = "Nombre d'exploitations", icon = shiny::icon("house"), color = "danger", width = 1, fill = TRUE)
      })

      output$download_box_repere <- shiny::renderUI({

          CustomDownloadButton(
                    ns("xlsx_repere"),
                    label = "Document Excel",
                    icon = shiny::icon("file-excel"),
                    size = 'lg',
                    color = "success"
                  )

      })

    })
 
  })
}
    
## To be copied in the UI
# mod_repere_ui("repere_1")
    
## To be copied in the server
# mod_repere_server("repere_1")
