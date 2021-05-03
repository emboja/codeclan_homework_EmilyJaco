library(tidyverse)
library(shiny)
library(CodeClanData)
library(shinythemes)

game_sales <- game_sales

ui <- fluidPage(
  theme = shinytheme("readable"),
  titlePanel("Game Sales"),
  
  sidebarLayout(
    sidebarPanel(
      
  radioButtons("genre",
               "Game Genre",
                choices = c("Action", "Adventure", "Fighting", "Misc", "Platform", "Puzzle", "Racing", "Role-Playing", "Shooter", "Simulation", "Sports", "Strategy"))
  
    ),

  mainPanel(
    plotOutput("sales_plot")
     )
  )
)

server <- function(input, output) {
output$sales_plot <- renderPlot({
  
  game_sales %>% 
    filter(genre == input$genre) %>% 
    ggplot() +
    aes(x = sales, y = publisher, fill = rating) +
    geom_col() 
})
}

shinyApp(ui = ui, server = server)

# This interactive visualisation shows the games sales separated by the publisher of the game and coloured in by the rating. The user can change the chart based on the genre of the game.
# I picked viewing the data this way as I think it clearly shows the market leaders in each genre of game and it could be updated with annual sales data to show the fluctuation of different companies each year.
# I think the fill of the rating shows insight into the popularity of each rating in each genre and could be a good indication for a publisher for which rating they should aim for their game to have.
