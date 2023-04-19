#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#'     
#' @noRd
#' @importFrom bs4Dash dashboardPage dashboardHeader dashboardBrand dashboardSidebar sidebarUserPanel sidebarMenu menuItem sidebarHeader dashboardFooter dashboardBody tabItems tabItem
#' @importFrom shiny tagList icon a includeHTML includeMarkdown
#' @importFrom shinyjs useShinyjs
app_ui <- function(request) {
  shiny::tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyjs::useShinyjs(),
    # Your application UI logic 
    bs4Dash::dashboardPage(
      title = "ShinyIDEA",
      preloader <- list(html = shiny::tagList(spin_1(), "Loading ..."), color = "#343a40"),
      header = bs4Dash::dashboardHeader(
        title <- bs4Dash::dashboardBrand(
          title = "ShinyIDEA",
          color = "white",
          image = "https://methode-idea.org/fileadmin/_processed_/b/a/csm_IDEA_233d11c519.png"
        )),
      sidebar = bs4Dash::dashboardSidebar(
        skin="light",
        status = "success",
        minified = FALSE,
      bs4Dash::sidebarUserPanel(
      image = "https://cdn-icons-png.flaticon.com/512/652/652076.png",
      name = "Utilisateur IDEA4"
    ),
        bs4Dash::sidebarMenu(
          id = "sidebarmenu",
          bs4Dash::menuItem(
            "Accueil",
            selected = TRUE,
            tabName = "home",
            icon = shiny::icon("list-alt")
          ),
          bs4Dash::sidebarHeader("Analyse de calculateurs"),
          bs4Dash::menuItem(
            "Analyse individuelle",
            tabName = "indiv",
            icon = shiny::icon("user", verify_fa = FALSE)
          ),
          bs4Dash::menuItem(
            "Analyse de groupe",
            tabName = "grp",
            icon = shiny::icon("users")
          ),
          bs4Dash::sidebarHeader("Analyses de la base IDEA_V4"),
          bs4Dash::menuItem(
            "Données repère",
            tabName = "data_repere",
            icon = shiny::icon("database")
          ),
          bs4Dash::menuItem(
            "Statistiques et usages",
            tabName = "stat_base",
            icon = shiny::icon("dashboard")
          ),

          # sidebarHeader("Outils complémentaires"),
          # menuItem(
          #   "Conversion JSON",
          #   tabName = "jsonify",
          #   icon = icon("file-code", verify_fa = FALSE)
          # ),
          bs4Dash::sidebarHeader("A propos"),
          bs4Dash::menuItem(
            "Mentions légales",
            tabName = "cgu",
            icon = shiny::icon("book")
          )
        )
      ),
      
      controlbar = NULL,
      footer = bs4Dash::dashboardFooter(
        left = shiny::a(
          href = "https://methode-idea.org/",
          target = "_blank", "methode-idea.org"
        ),
        right = shiny::includeHTML(app_sys("app", "docs", "footer.html"))
      ),
      body = bs4Dash::dashboardBody(
        bs4Dash::tabItems(
          bs4Dash::tabItem(
            tabName = "home",
            mod_welcome_ui("welcome_ui_1")
          ),
          bs4Dash::tabItem(
            tabName = "cgu",
            shiny::includeMarkdown(app_sys("app", "docs", "cgu.md"))
          ),
          bs4Dash::tabItem(
            tabName = "indiv",
            mod_indiv_analysis_ui("indiv_analysis_ui_1")
          ),
          bs4Dash::tabItem(
            tabName = "grp",
            mod_group_analysis_ui("group_analysis_ui_1")
          ),
          bs4Dash::tabItem(
            tabName = "jsonify",
            mod_jsonify_ui("jsonify_ui_1")
          ),
          bs4Dash::tabItem(
            tabName = "stat_base",
            mod_database_stat_ui("database_stat_1")
          ),
          bs4Dash::tabItem(
            tabName = "data_repere",
            mod_repere_ui("repere_1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#'
#' @noRd
#' @importFrom shiny tags
golem_add_external_resources <- function(){
  
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  shiny::tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'ShinyIDEA'
    ),
    # Add here other external resources
    # for example, you can add useShinyalert() 
  )
}

