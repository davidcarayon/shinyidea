#' Separate modules for downloads
#'
#' @description A shiny Module.
#'
#' @noRd
#'
#' @importFrom IDEATools diag_idea
#' @importFrom jsonlite fromJSON write_json
#' @importFrom shiny moduleServer downloadHandler
#' @importFrom shinyWidgets sendSweetAlert closeSweetAlert
#' @importFrom tools file_path_sans_ext
#' @importFrom zip zip
dlmodule <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$example_data <- downloadHandler(
      filename = function() {
        paste0("donnes_fictives_IDEA.json")
      },
      
      content = function(file) {
        f <- fromJSON(system.file("idea_example.json", package = "IDEATools"))
        write_json(f, file)
      }
    )
    
    
    # PDF ---------------------------------------------------------------------
    output$dl_pdf <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Rapport_individuel_", file_name_short, ".pdf")
      },
      
      content = function(file) {
        
        sendSweetAlert(
          session = session,
          type = "info",
          title = "Production du fichier en cours. Merci de patienter quelques secondes..."
        )
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        # Defining a knitting dir in tempdir in case the user doesn't have all permissions in working dir
        knitting_dir <- file.path(tempdir(), "IDEATools_reports")
        if (!dir.exists(knitting_dir)) (dir.create(knitting_dir))
        
        diag_idea(input$files$datapath,
                  output_directory = knitting_dir, prefix = file_name_short,
                  export_type = "report", type = "single", quiet = TRUE, report_format = "pdf"
        )
        
        file.copy(file.path(knitting_dir, Sys.Date(), file_name_short, paste0("Rapport_individuel_", file_name_short, ".pdf")), file)
        
        closeSweetAlert(session = session)
        sendSweetAlert(
          session = session,
          title = " Fichier téléchargé !",
          type = "success"
        )
        
      }
    )
    
    
    # Powerpoint --------------------------------------------------------------
    output$dl_pptx <- downloadHandler(
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Rapport_individuel_", file_name_short, ".pptx")
      },
      
      content = function(file) {
        sendSweetAlert(
          session = session,
          type = "info",
          title = "Production du fichier en cours. Merci de patienter quelques secondes..."
        )
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        # Defining a knitting dir in tempdir in case the user doesn't have all permissions in working dir
        knitting_dir <- file.path(tempdir(), "IDEATools_reports")
        if (!dir.exists(knitting_dir)) (dir.create(knitting_dir))
        
        diag_idea(input$files$datapath,
                  output_directory = knitting_dir, prefix = file_name_short,
                  export_type = "report", type = "single", quiet = TRUE, report_format = "pptx"
        )
        
        file.copy(file.path(knitting_dir, Sys.Date(), file_name_short, paste0("Rapport_individuel_", file_name_short, ".pptx")), file)
        
        closeSweetAlert(session = session)
        sendSweetAlert(
          session = session,
          title = " Fichier téléchargé !",
          type = "success"
        )
      }
    )
    
    # Word --------------------------------------------------------------
    output$dl_docx <- downloadHandler(
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Rapport_individuel_", file_name_short, ".docx")
      },
      
      content = function(file) {
        sendSweetAlert(
          session = session,
          type = "info",
          title = "Production du fichier en cours. Merci de patienter quelques secondes..."
        )
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        # Defining a knitting dir in tempdir in case the user doesn't have all permissions in working dir
        knitting_dir <- file.path(tempdir(), "IDEATools_reports")
        if (!dir.exists(knitting_dir)) (dir.create(knitting_dir))
        
        diag_idea(input$files$datapath,
                  output_directory = knitting_dir, prefix = file_name_short,
                  export_type = "report", type = "single", quiet = TRUE, report_format = "docx"
        )
        
        
        file.copy(file.path(knitting_dir, Sys.Date(), file_name_short, paste0("Rapport_individuel_", file_name_short, ".docx")), file)
        
        closeSweetAlert(session = session)
        sendSweetAlert(
          session = session,
          title = " Fichier téléchargé !",
          type = "success"
        )
      }
    )
    
    # ZIP --------------------------------------------------------------
    output$dl_zip <- downloadHandler(
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Figures_", file_name_short, ".zip")
      },
      
      content = function(file) {
        sendSweetAlert(
          session = session,
          type = "info",
          title = "Production du fichier en cours. Merci de patienter quelques secondes..."
        )
        
        outdir <- file.path(tempdir(), "Figures")
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        diag_idea(input$files$datapath, output_directory = outdir, type = "single", export_type = "local", quiet = TRUE, prefix = file_name_short)
        
        ## Définition du chemin des fichiers à archiver
        current_dir <- getwd()
        setwd(file.path(outdir, Sys.Date()))
        
        fs <- list.files(file_name_short, recursive = TRUE, full.names = TRUE)
        
        # Export du zip
        zip(zipfile = file, files = fs)
        setwd(current_dir)
        
        closeSweetAlert(session = session)
        sendSweetAlert(
          session = session,
          title = " Fichier téléchargé !",
          type = "success"
        )
      }
    )
    
    # EXCEL --------------------------------------------------------------
    output$dl_xlsx <- downloadHandler(
      filename = function() {
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        paste0("Rapport_individuel_", file_name_short, ".xlsx")
      },
      
      content = function(file) {
        sendSweetAlert(
          session = session,
          type = "info",
          title = "Production du fichier en cours. Merci de patienter quelques secondes..."
        )
        
        file_name_short <- substr(basename(file_path_sans_ext(input$files$name)), start = 1, stop = 10)
        
        # Defining a knitting dir in tempdir in case the user doesn't have all permissions in working dir
        knitting_dir <- file.path(tempdir(), "IDEATools_reports")
        if (!dir.exists(knitting_dir)) (dir.create(knitting_dir))
        
        diag_idea(input$files$datapath,
                  output_directory = knitting_dir, prefix = file_name_short,
                  export_type = "report", type = "single", quiet = TRUE, report_format = "xlsx"
        )
        
        
        file.copy(file.path(knitting_dir, Sys.Date(), file_name_short, paste0("Rapport_individuel_", file_name_short, ".xlsx")), file)
        
        closeSweetAlert(session = session)
        sendSweetAlert(
          session = session,
          title = " Fichier téléchargé !",
          type = "success"
        )
      }
    )
  })
}
