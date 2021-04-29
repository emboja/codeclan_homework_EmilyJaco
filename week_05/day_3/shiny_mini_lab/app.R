library(shiny)
library(dplyr)
library(ggplot2)
library(CodeClanData)
library(shinythemes)
olympic_medals <- olympics_overall_medals

ui <- fluidPage(
    theme = shinytheme("flatly"),
    
    titlePanel(tags$b("Five Country Medal Comparison")),
    
    tabsetPanel(
        tabPanel("Olympic Medal Info",
                 (tags$a("Olympic Medal Info", href = "https://www.olympic.org/olympic-medals"))
        )
    ),
    
    tabsetPanel(
    tabPanel("This year's Olympics",
             (tags$a("This year's Olympics", href = "https://www.olympic.org/all-information-about-the-olympic-games-tokyo-2020-and-covid-19"))
    )
              ),
    
        
        mainPanel(
            plotOutput("medal_plot")
        ),

sidebarPanel(
    radioButtons("season_button",
                 tags$i("Summer or Winter Olympics?"),
                 choices = c("Summer", "Winter")
    ),
    radioButtons("medal_button",
                 tags$i("Compare Which Medals?"),
                 choices = c("Gold", "Silver", "Bronze")
        )
    )
)


server <- function(input, output) {
    output$medal_plot <- renderPlot({
        medal_colour <- case_when(
            input$medal_button == "Gold" ~ "#F5B041",
            input$medal_button == "Silver" ~ "#808B96",
            input$medal_button == "Bronze" ~ "chocolate"
        )
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal_button) %>%
            filter(season == input$season_button) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal) +
            geom_col(fill = medal_colour) 
    })
}
shinyApp(ui = ui, server = server)