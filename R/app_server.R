#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  mod_welcome_server("welcome_ui_1")
  mod_indiv_analysis_server("indiv_analysis_ui_1")
  mod_group_analysis_server("group_analysis_ui_1")
  dlmodule("indiv_analysis_ui_1")
  dlmodule_group("group_analysis_ui_1")
  dlmodule_json("jsonify_ui_1")
  mod_jsonify_server("jsonify_ui_1")
}
