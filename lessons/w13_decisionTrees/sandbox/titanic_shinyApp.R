# Load necessary libraries
library(shiny)
library(rpart)
library(rpart.plot)
library(titanic)  # To get the Titanic dataset

# Define the UI
ui <- fluidPage(
  titlePanel("Titanic Decision Tree Model"),
  
  sidebarLayout(
    sidebarPanel(
      # Input for selecting number of rows
      sliderInput("numRows", 
                  "Number of Rows for Training:",
                  min = 50, 
                  max = nrow(titanic::titanic_train), 
                  value = 200),
      
      # Input for selecting variables to use in the model
      checkboxGroupInput("vars", 
                         "Select Variables for Model:",
                         choices = colnames(titanic::titanic_train)[-1], # Excluding the 'Survived' column
                         selected = c("Pclass", "Sex", "Age", "Fare")),
      
      # Button to generate the decision tree
      actionButton("generate", "Generate Decision Tree")
    ),
    
    mainPanel(
      plotOutput("treePlot"),
      verbatimTextOutput("modelSummary"),
      tableOutput("dataTable")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Reactive expression to prepare the Titanic dataset and create decision tree model
  dataInput <- eventReactive(input$generate, {
    # Select the number of rows based on input
    data <- titanic::titanic_train[1:input$numRows, ]
    
    # Select the variables based on the user's selection
    formula <- as.formula(paste("Survived ~", paste(input$vars, collapse = "+")))
    
    # Create the decision tree model
    model <- rpart(formula, data = data, method = "class")
    
    # Return the model and the data for plotting and summarizing
    list(model = model, data = data)
  })
  
  # Render the decision tree plot
  output$treePlot <- renderPlot({
    modelData <- dataInput()
    model <- modelData$model
    rpart.plot(model, main = "Decision Tree for Titanic Survival")
  })
  
  # Render the model summary (important details of the tree)
  output$modelSummary <- renderPrint({
    modelData <- dataInput()
    model <- modelData$model
    summary(model)
  })
  
  # Render the dataset used in the model
  output$dataTable <- renderTable({
    modelData <- dataInput()
    modelData$data
  })
}

# Run the application
shinyApp(ui = ui, server = server)
