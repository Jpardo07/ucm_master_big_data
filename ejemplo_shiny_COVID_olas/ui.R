# Pedro Concejero febrero 2022
# Ejemplo de app shiny para master UCM Big Data
# Módulo visualización avanzada
#
# Ejemplo de representación series temporales COVID-19 (olas) por grupo edad y sexo
# Y de la importancia (gravedad) por grupo de edad y sexo

library(shiny)
library(ggplot2)
library(tidyverse)
library(tsibble)
library(feasts)

# Cargamos los datos desde el repositorio Inst. Salud Carlos III (ISCIII) 

# Cargamos los datos 

isciii <- read_csv("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv")

# Para el barplot:

#names(isciii)[4] <- "fecha"

fech_max <- max(isciii$fecha)

#cond <- {isciii$fecha == fech_max & 
 #   isciii$grupo_edad != "NC"} # excluimos datos de sexo NC

cond <- {isciii$grupo_edad != "NC" &
  isciii$sexo != "NC"} # excluimos datos de sexo NC

#cond <- {isciii$grupo_edad != "NC"} # excluimos datos de sexo NC


data_para_plot <- isciii[cond, ]

# Seguimos:

edades <- unique(isciii$grupo_edad)


# distinguimos variables "a nivel de intervalo" ("continuas" para barplot (ggplot))

nums <- sapply(data_para_plot, is.numeric)
continuas <- names(isciii)[nums]

# y variables "categóricas" ("discretas" para barplot(ggplot))
cats <- sapply(data_para_plot, is.character)
categoricas <- names(data_para_plot)[cats]


shinyUI(
  navbarPage("Shiny Visualización Avanzada",
                   tabPanel("Descripción del trabajo",
                            mainPanel(
                              h1("Ejemplo Visualización Avanzada", align = "center"),
                              h1("Máster UCM 2022", align = "center"),
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
                                    edades[[3]]),
                        dateRangeInput('dateRange',
                                       label = 'Pon tu rango de datos en formato: yyyy-mm-dd',
                                       start = "2020-02-01", 
                                       end = fech_max,
                                       min = "2020-01-01",
                                       max = fech_max
                        )
                      ),
                      mainPanel(
                        plotOutput(outputId = 'plot2',
                                   height = 800,
                                   width = 1000
                        ))
                        
                      ),
                      
             tabPanel("Barplot",
                      sidebarPanel(
                        
                        selectInput(inputId = 'y', 
                                    'Elige lo que se representará en barplot', 
                                    choices = c("total_contagiados",
                                                "total_hospitalizados",
                                                "total_uci",
                                                "total_fallecidos"), 
                                    selected = "total_contagiados")),
                     
                     mainPanel(
                       plotOutput(outputId = 'plot',
                                  height = 800,
                                  width = 800)
             ))
             
  
))



