library(shiny)
library(ggplot2)

data(mtcars)
model <- lm(mpg~wt+qsec+am, data=mtcars)

shinyServer(function(input, output) {
  observeEvent(input$go, {
    

    x <- data.frame(wt=as.numeric(input$wt), 
                    qsec=as.numeric(input$qsec), 
                    am=as.numeric(input$am))
    predValue <- predict(model, newdata=x)
    output$wt <- renderText({paste(as.numeric(input$wt)*1000, 'lbs')})
    output$qsec <- renderText({paste(as.numeric(input$qsec), 'seconds')})
    output$am <- renderText({ifelse(input$am==0, 'Automatic Transmission', 'Manual Transmission')})
    output$mpg <- renderText({predValue})
    myHist <- ggplot(data=mtcars, aes(x=mpg))+geom_histogram(binwidth=3)+geom_vline(xintercept=predValue, color='red')
    output$plot <- renderPlot(myHist)
  })
  
})
