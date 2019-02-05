
library(shiny)
library(dagitty)
# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("A simple web app using R libraries shiny and dagitty."),
    # headerPanel("A simple Shiny App using dagitty library"),
    sidebarLayout(

        sidebarPanel = sidebarPanel(
            width = 5
            , p(
                "You may use the same dag {} code syntax for the R library dagitty, which could also be used in in the following web app:"
                , br()
                , a(href = "http://www.dagitty.net/development/dags.html", "http://www.dagitty.net/development/dags.html")
                , br()
                , strong("Briefly, the code syntax is as follows:")
                , br()
                , code('dag {')
                , br()
                , code('NodeName1 [pos = "x-axis,y-axis(flipped)"]')
                , br()
                , code('NodeName2 [pos = "x-axis,y-axis(flipped)"]')
                , br()
                , code('From(NodeName1) -> To(NodeName2)')
                , br()
                , code('}')
                , br()
                , strong("You may edit the default code within the text box, and the plot will be updated automatically.", style = "color:blue")
            )
            , textAreaInput(
                inputId = "textAreaInput_dagitty_code"
                , label = "dagitty code"
                , value = '
dag {
RiskyBehaviors [pos="-8,-4"]
HIV [pos="-2,-2"]
ART [exposure, pos="0,0"]
MedAdverseEffect [pos="2,2"]
Death [outcome, pos="10,0"]

RiskyBehaviors -> HIV
RiskyBehaviors -> ART
RiskyBehaviors -> Death
HIV -> ART
ART -> Death
HIV -> Death
ART -> MedAdverseEffect
MedAdverseEffect -> Death
}'
                , width = '300px', height = '400px'
            )
        )
        # Show a plot of the generated distribution
        , mainPanel = mainPanel(
            width = 5
            , p(
                "This is a simple web app made by Min-Hyung Kim, using R libraries shiny and dagitty."
                # , br()
                , "The code for this web app is available in the following github page:"
                , br()
                , a(href = "https://github.com/mkim0710/Shiny", "https://github.com/mkim0710/Shiny")
            )
            , plotOutput(outputId = "plotOutput1")
            # , selectInput(inputId = "DownloadOption", label = "Select Download Option", choices = list("pdf","png","jpeg"))
            , downloadButton(outputId = "downloadButton_plot", label = "Download the code & plot in PDF")
            , br()
            , h3("REFERENCES")
            , p(
                "Hernán, M.A., and Robins, J. M., 2019."
                # , br()
                , a(href = "https://www.hsph.harvard.edu/miguel-hernan/causal-inference-book/", "Causal Inference.")
                # , br()
                , em("Boca Raton: Chapman & Hall/CRC, ")
                , "forthcoming."
            )
            , p(
                "Textor, J., van der Zander, B., Gilthorpe, M.S., Liśkiewicz, M. and Ellison, G.T., 2016."
                # , br()
                , a(href = "http://dx.doi.org/10.1093/ije/dyw341", "Robust causal inference using directed acyclic graphs: the R package 'dagitty'.")
                # , br()
                , em("International Journal of Epidemiology, 45")
                , "(6), pp.1887-1894."
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$plotOutput1 <- renderPlot({
        plot(dagitty(input$textAreaInput_dagitty_code))
    })
    
    output$downloadButton_plot <- downloadHandler(
        #Specify The File Name
        filename = function() {
            # paste0("plot ", gsub(":", "_", Sys.time()), ".", input$DownloadOption)
            paste0("plot ", gsub(":", "_", Sys.time()), ".", "pdf")
        }
        , content = function(file){
            # # open the format of file which needs to be downloaded ex: pdf, png etc.
            # if (input$DownloadOption== "png"){
            #     png(file)
            # } else if (input$DownloadOption== "jpeg"){
            #     jpeg(file)
            # } else {
            #     pdf(file)
            # }
            pdf(file)
            plot(NA, xlim=c(0,10), ylim=c(0,10), bty='n', xaxt='n', yaxt='n', xlab='', ylab='')
            text(0, 5, input$textAreaInput_dagitty_code, cex = 0.8, pos = 4)
            plot(dagitty(input$textAreaInput_dagitty_code))

            dev.off()
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)

