# Decision Trees with Small, medium and Large animals

# Load necessary libraries
library(shiny)
library(rpart)
library(rpart.plot)

# Define the UI
ui <- fluidPage(
  titlePanel("Decision Tree for Animal Classification"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("numAnimals",
                  "Number of Animals:",
                  min = 5,
                  max = 50,
                  value = 30),
      textInput("seedValue", 
                "Seed Value (leave blank for random):", 
                value = ""),
      actionButton("generate", "Generate Data")
    ),
    
    mainPanel(
      plotOutput("treePlot"),
      verbatimTextOutput("modelSummary"),
      tableOutput("dataTable")  # Display the generated dataset
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Reactive expression to generate random animal data
  animalData <- eventReactive(input$generate, {
    # Set seed based on user input or randomize if left blank
    if (input$seedValue != "") {
      set.seed(as.numeric(input$seedValue))
    } else {
      set.seed(Sys.time())  # Use current time for randomness
    }
    
    sizes <- c("small", "medium", "large")
    colors <- c("brown", "black", "white", "gray", "gold", "orange")
    animals <- c("cat", "dog", "rabbit", "bird")
    
    data.frame(
      size = sample(sizes, input$numAnimals, replace = TRUE),
      color = sample(colors, input$numAnimals, replace = TRUE),
      type = sample(animals, input$numAnimals, replace = TRUE)
    )
  })
  
  # Create the decision tree model and plot it
  output$treePlot <- renderPlot({
    data <- animalData()
    model <- rpart(type ~ size + color, data = data)
    rpart.plot(model, main = "Decision Tree for Animal Classification")
  })
  
  # Display the model summary
  output$modelSummary <- renderPrint({
    data <- animalData()
    model <- rpart(type ~ size + color, data = data)
    summary(model)
  })
  
  # Display the generated dataset
  output$dataTable <- renderTable({
    animalData()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
