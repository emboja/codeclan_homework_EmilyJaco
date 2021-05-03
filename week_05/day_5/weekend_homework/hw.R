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
