#' Separate modules for downloads
#'
#' @description A shiny Module.
#'
#' @noRd
#' @importFrom jsonlite fromJSON write_json
#' @importFrom shiny moduleServer downloadHandler showModal modalDialog modalButton
#' @importFrom utils zip
dlmodule <- function(id){
  shiny::moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$example_data <- shiny::downloadHandler(
      filename = function() {
        paste0("donnes_fictives_IDEA.json")
      },
      
      content = function(file) {
        f <- jsonlite::fromJSON(system.file("example_data/idea_example_1.json", package = "IDEATools"))
        jsonlite::write_json(f, file)
      }
    )
    
    
    # PDF ---------------------------------------------------------------------
    output$dl_pdf <- shiny::downloadHandler(
      # For PDF output, change this to "report.pdf"
      
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Rapport_individuel_", file_name_short, ".pdf")
      },
      
      content = function(file) {
        
        shiny::showModal(shiny::modalDialog(
          title = "Production du rapport PDF en cours",
          "Merci de patienter quelques secondes...",
          footer = shiny::modalButton("OK")
        ))
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        # Defining a knitting dir in tempdir in case the user doesn't have all permissions in working dir
        knitting_dir <- file.path(tempdir(), "IDEATools_reports")
        if (!dir.exists(knitting_dir)) (dir.create(knitting_dir))
        
        diag_idea(input$files$datapath,
                  output_directory = knitting_dir, prefix = file_name_short,
                  export_type = "report", type = "single", quiet = TRUE, report_format = "pdf"
        )
        
        file.copy(file.path(knitting_dir, Sys.Date(), file_name_short, paste0("Rapport_individuel_", file_name_short, ".pdf")), file)
        
      }
    )
    
    # ZIP --------------------------------------------------------------
    output$dl_zip <- shiny::downloadHandler(
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Figures_", file_name_short, ".zip")
      },
      
      content = function(file) {
        shiny::showModal(shiny::modalDialog(
          title = "Production de l'archive en cours",
          "Merci de patienter quelques secondes...",
          footer = shiny::modalButton("OK")
        ))
        
        outdir <- file.path(tempdir(), "Figures")
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        diag_idea(input$files$datapath, output_directory = outdir, type = "single", export_type = "local", quiet = TRUE, prefix = file_name_short)
        
        ## Définition du chemin des fichiers à archiver
        current_dir <- getwd()
        setwd(file.path(outdir, Sys.Date()))
        
        fs <- list.files(file_name_short, recursive = TRUE, full.names = TRUE)
        
        # Export du zip
        utils::zip(zipfile = file, files = fs)
        setwd(current_dir)
      }
    )
    
    # EXCEL --------------------------------------------------------------
    output$dl_xlsx <- shiny::downloadHandler(
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Rapport_individuel_", file_name_short, ".xlsx")
      },
      
      content = function(file) {
        shiny::showModal(shiny::modalDialog(
          title = "Production du fichier en cours",
          "Merci de patienter quelques secondes..."
        ))
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        # Defining a knitting dir in tempdir in case the user doesn't have all permissions in working dir
        knitting_dir <- file.path(tempdir(), "IDEATools_reports")
        if (!dir.exists(knitting_dir)) (dir.create(knitting_dir))
        
        diag_idea(input$files$datapath,
                  output_directory = knitting_dir, prefix = file_name_short,
                  export_type = "report", type = "single", quiet = TRUE, report_format = "xlsx"
        )
        
        
        file.copy(file.path(knitting_dir, Sys.Date(), file_name_short, paste0("Rapport_individuel_", file_name_short, ".xlsx")), file)
        
      }
    )
  })
}
