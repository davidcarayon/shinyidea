# Definition de la partie UI 
ui <- fluidPage(

    # Titre de l application
    titlePanel("Ma Super Application R-Shiny"),

    # affiche une image
    mainPanel(
        imageOutput("SK8Image")
    )
)

