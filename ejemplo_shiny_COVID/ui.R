#
# Ejemplo de app shiny para master UNED Big Data
# Módulo visualización avanzada
#
# Ejemplo de ejercicio con datos COVID por edad

library(shiny)
library(ggplot2)
library(tidyverse)

# Cargamos los datos desde el repositorio github datadista 

url <- "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/old_series/nacional_covid19_rango_edad.csv"

dataset <- read_csv(url)

  names(dataset)[1] <- "fecha"

fecha <- max(dataset$fecha)

cond <- {dataset$fecha == fecha & 
    dataset$rango_edad != "Total"}

data_para_plot <- dataset[cond, ]

# distinguimos variables "a nivel de intervalo" ("continuas" para ggplot)
nums <- sapply(data_para_plot, is.numeric)
continuas <- names(data_para_plot)[nums]

# y variables "categóricas" ("discretas" para ggplot)
cats <- sapply(data_para_plot, is.character)
categoricas <- names(data_para_plot)[cats]


shinyUI(
  navbarPage("Shiny Visualización Avanzada",
                   tabPanel("Descripción del trabajo",
                            mainPanel(
                              h1("Ejercicio Visualización Avanzada", align = "center"),
                              h2("Propuesto por Pedro Concejero", align = "center"),
                              p("Ejemplo de gráfico COVID-19 por grupos de edad"),
                              p("En función de si consideramos hospitalizados, UCI y fallecidos")
                              )),
                   tabPanel("Barplot",
                            sidebarPanel(
                              
                              selectInput(inputId = 'y', 
                                          'Elige variable para eje Y', 
                                          continuas, 
                                          continuas[[4]]),
                            ),
                            
                            mainPanel(
                              plotOutput(outputId = 'plot',
                                         height = 900,
                                         width = 600
                                         )
                              
                            )
                   )
  
))



