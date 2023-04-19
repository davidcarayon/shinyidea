#' Separate modules for downloads
#'
#' @description A shiny Module.
#'
#' @noRd
#'
#' @importFrom shiny moduleServer downloadHandler
#' @importFrom tools file_path_sans_ext
dlmodule_json <- function(id){
  shiny::moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$dl_json <- shiny::downloadHandler(
      filename = function() {
        file_name_short <- basename(tools::file_path_sans_ext(input$jsonfile$name))
        paste0(file_name_short, ".json")
      },
      
      content = function(file) {
        outdir <- tempdir()
        IDEATools:::jsonify2(input$jsonfile$datapath, outdir)
        file.path(outdir,filename())
      }
    )
  })
}
