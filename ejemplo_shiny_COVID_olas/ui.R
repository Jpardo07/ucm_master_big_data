#
# Ejemplo de app shiny para master UCM Big Data
# Módulo visualización avanzada
#
# Ejemplo de representación series temporales COVID (olas) por grupo edad y sexo

library(shiny)
library(ggplot2)
library(tidyverse)
library(tsibble)
library(feasts)

# Cargamos los datos desde el repositorio Inst. Salud Carlos III (ISCIII) 


shinyUI(
  navbarPage("Shiny Visualización Avanzada",
                   tabPanel("Descripción del trabajo",
                            mainPanel(
                              h1("Ejemplo Visualización Avanzada", align = "center"),
                              h1("Máster UCM online 2021", align = "center"),
                              h2("Propuesto por Pedro Concejero", align = "center"),
                              h3("Ejemplo de series temporales COVID-19 por grupos de edad", 
                                 align = "center"),
                              h3("A partir de los datos publicados por el Inst. Salud Carlos III", 
                                 align = "center"),
                              h3("Diarios salvo agregados fines de semana", 
                                 align = "center"),
                              
                              p(""),
                              h2("IMPORTANTE", align = "center"),
                              h2("Recomendable resolución superior a 1024x768 para visualizar gráficos", 
                                 align = "center"))),
             tabPanel("Olas COVID -series temporales",
                      sidebarPanel(
                        selectInput(inputId = 'y2', 
                                    'Elige variable para eje Y', 
                                    choices = c("total_contagiados",
                                                "total_hospitalizados",
                                                "total_uci",
                                                "total_fallecidos"), 
                                    selected = "total_contagiados"),
                        selectInput(inputId = 'edad', 
                                    'Elige grupo de edad', 
                                    edades,
                                    edades[[3]])
                      ),
                      mainPanel(
                        plotOutput(outputId = 'plot2',
                                   height = 900,
                                   width = 1200
                        )
                        
                      )
             )
             
  
))



