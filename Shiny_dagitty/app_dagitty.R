
library(shiny)
library(dagitty)
# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("A simple web app using R libraries shiny and dagitty."),
    # headerPanel("A simple Shiny App using dagitty library"),
    sidebarLayout(
        sidebarPanel = NULL
        # Show a plot of the generated distribution
        , mainPanel(
            p(
                "This is a simple web app made by Min-Hyung Kim, using R libraries shiny and dagitty."
                # , br()
                , "The code for this web app is available in the following github page:"
                , br()
                , a("https://github.com/mkim0710/Shiny")
            )
            , p(
                "You may use the same dag {} code syntax for the R library dagitty, which could also be used in in the following web app:"
                , br()
                , a("http://www.dagitty.net/development/dags.html")
            )
            , p(
                "The dagitty library was published as follows:"
                , br()
                , "Johannes Textor, Benito van der Zander, Mark K. Gilthorpe, Maciej Liskiewicz, George T.H. Ellison."
                , br()
                , a("http://dx.doi.org/10.1093/ije/dyw341", "Robust causal inference using directed acyclic graphs: the R package 'dagitty'.")
                , br()
                , em("International Journal of Epidemiology")
                , "45(6):1887-1894, 2016."
            )
            , textAreaInput(
                inputId = "textAreaInput_dagitty_code"
                , label = "dagitty code"
                , value = 'dag {
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
                , width = '400px', height = '400px'
            )
            , plotOutput(outputId = "plotOutput1")
            , radioButtons(inputId = "DownloadOption", label = "Select Download Option", choices = list("pdf","png","jpeg"))
            , downloadButton(outputId = "downloadButton_plot", label = "Download The Plot")
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
            paste0("plot ", gsub(":", "_", Sys.time()), ".", input$DownloadOption)
        }
        , content = function(file){
            # open the format of file which needs to be downloaded ex: pdf, png etc. 
            if (input$DownloadOption== "png"){
                png(file)
            } else if (input$DownloadOption== "pdf"){
                pdf(file)
            } else {
                jpeg(file) 
            }
            plot(dagitty(input$textAreaInput_dagitty_code))
            
            dev.off()
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)

