#' Separate modules for downloads
#'
#' @description A shiny Module.
#'
#' @noRd
#'
#' @importFrom tools file_path_sans_ext
dlmodule_json <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$dl_json <- downloadHandler(
      filename = function() {
        file_name_short <- basename(tools::file_path_sans_ext(input$jsonfile$name))
        paste0(file_name_short, ".json")
      },
      
      content = function(file) {
        f <- IDEATools:::jsonify(input$jsonfile$datapath)
        write(f, file)
      }
    )
  })
}
