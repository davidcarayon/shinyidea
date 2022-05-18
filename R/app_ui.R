#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#'     
#' @noRd
#' @importFrom bs4Dash dashboardPage dashboardHeader dashboardBrand dashboardSidebar sidebarMenu menuItem sidebarHeader dashboardControlbar dashboardFooter dashboardBody tabItems tabItem
#' @importFrom shiny tagList icon a includeMarkdown
#' @importFrom waiter spin_1
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    dashboardPage(
      title = "ShinyIDEA",
      preloader <- list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
      header = dashboardHeader(
        title <- dashboardBrand(
          title = "ShinyIDEA",
          color = "white",
          image = "https://methode-idea.org/fileadmin/_processed_/b/a/csm_IDEA_233d11c519.png"
        )),
      sidebar = dashboardSidebar(
        skin="light",
        status = "info",
        minified = FALSE,
        sidebarMenu(
          id = "sidebarmenu",
          menuItem(
            "Accueil",
            selected = TRUE,
            tabName = "home",
            icon = icon("list-alt")
          ),
          sidebarHeader("Outils d'analyse"),
          menuItem(
            "Analyse individuelle",
            tabName = "indiv",
            icon = icon("user", verify_fa = FALSE)
          ),
          menuItem(
            "Analyse de groupe",
            tabName = "grp",
            icon = icon("users")
          ),
          sidebarHeader("Outils complémentaires"),
          menuItem(
            "Conversion JSON",
            tabName = "jsonify",
            icon = icon("file-code", verify_fa = FALSE)
          ),
          sidebarHeader("A propos"),
          menuItem(
            "Mentions légales",
            tabName = "cgu",
            icon = icon("book")
          )
        )
      ),
      controlbar = dashboardControlbar(),
      footer = dashboardFooter(
        left = a(
          href = "https://sk8.inrae.fr/",
          target = "_blank", "Propulsé par SK8"
        ),
        right = "\u00A9 David Carayon - 2022"
      ),
      body = dashboardBody(
        tabItems(
          tabItem(
            tabName = "home",
            mod_welcome_ui("welcome_ui_1")
          ),
          tabItem(
            tabName = "cgu",
            includeMarkdown(app_sys("app", "docs", "cgu.md"))
          ),
          tabItem(
            tabName = "indiv",
            mod_indiv_analysis_ui("indiv_analysis_ui_1")
          ),
          tabItem(
            tabName = "grp",
            mod_group_analysis_ui("group_analysis_ui_1")
          ),
          tabItem(
            tabName = "jsonify",
            mod_jsonify_ui("jsonify_ui_1")
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
#' 
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @importFrom bs4Dash box
#' @importFrom shiny tags HTML
golem_add_external_resources <- function(){
  
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'ShinyIDEA'
    ),
    ### Replacing status colors
    tags$style(
      type = 'text/css',
      '.info-box.bg-success {background-color: #0D8A00!important; color: #FFFFFF }'),
    tags$style(
      type = 'text/css',
      '.info-box.bg-warning {background-color: #FE942E!important; color: #FFFFFF }'),
    tags$style(
      type = 'text/css',
      '.info-box.bg-danger {background-color: #FF0000!important; color: #FFFFFF }'),
    tags$style(
      type = 'text/css',
      '.info-box.bg-info {background-color: #6db866!important; color: #FFFFFF }'),
    tags$style(
      type = 'text/css',
      '.info-box.bg-maroon {background-color: #FF6348!important; color: #000000; }'),
    tags$style(
      type = 'text/css',
      '.info-box-icon.elevation-3 {color: #FFFFFF; }'),
    tags$style(
      HTML(".shiny-notification {
              height: 50px;
              width: 600px;
              position:fixed;
              top: calc(100% - 55px);;
              left: calc(50% - 300px);;
            }
           "
      )
    )
    # Add here other external resources
    # for example, you can add useShinyalert() 
  )
}

