library(shiny)
library(ggplot2)

# Cargamos los datos desde el repositorio github del módulo 

url <- "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/nacional_covid19_rango_edad.csv"

dataset <- read_csv(url)

names(dataset)[1] <- "fecha"

fecha <- max(dataset$fecha)

cond <- {dataset$fecha == fecha & 
         dataset$rango_edad != "Total" &
         dataset$sexo != "ambos" }

data_para_plot <- dataset[cond, ]

shinyServer(function(input, output) {
  
  output$plot <- renderPlot({

    # dodged bar charts
    

    p <- ggplot(data_para_plot)
    
    if (input$y == 'fallecidos')
      p <- p + aes(rango_edad, fallecidos,
                   fill = as.factor(sexo))

    if (input$y == 'casos_confirmados')
      p <- p + aes(rango_edad, casos_confirmados,
                   fill = as.factor(sexo))

    if (input$y == 'hospitalizados')
      p <- p + aes(rango_edad, hospitalizados,
                   fill = as.factor(sexo))

    if (input$y == 'ingresos_uci')
      p <- p + aes(rango_edad, ingresos_uci,
                   fill = as.factor(sexo))
    
      p <- p + geom_bar(position = "dodge",
                      stat = "identity") + coord_flip()
 
    title <- paste(input$y, 
                   "por COVID-19 en España",
                   "\n",
                   "entre",
                   min(dataset$fecha),
                   "y",
                   max(dataset$fecha))
    
    p <- p + ggtitle(paste(title, "\n", "por género"))
    
    print(p)
    
  })

  
})
