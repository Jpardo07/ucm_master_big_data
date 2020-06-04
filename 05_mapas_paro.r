
# Ejemplo super básico

install.packages("maps")
library(maps)

map('italy')

# Usando gadm
# A "R SpatialPolygonsDataFrame" (.rds) file can be used in R. 
# To use it, first load the sp package using library(sp) and then use readRDS("filename.rds") 
# (obviously replacing "filename.rds" with the actual filename). 

install.packages("sp")
library(sp)
library(lattice)
library(ggplot2)


# Forma básica de España
espania <- readRDS(file = "ESP_adm0.rds")
plot(espania)

# España con comunidades (nivel 1 administrativo)
espania <- readRDS(file = "ESP_adm1.rds")
plot(espania)

# España con provincias (nivel 2 administrativo)
espania <- readRDS(file = "ESP_adm2.rds")
plot(espania)

# Queremos comunidad autónoma Andalucía
andalucia <- espania[espania$NAME_1=="Andalucía",]
plot(andalucia)

# Dibujar un mapa básico con escalas de color
# A partir de los mapas de José Luis Cañadas:
# http://rpubs.com/joscani/mapa_paro_andalucia

# Con cambios en escalas de color a partir de taller de color de grupo R madrid:
# https://github.com/pedroconcejero/taller-color/blob/master/taller_color_def_grupo_madrid.rmd


# Pon tu directorio de trabajo
setwd("/home/pedro/Escritorio/UCM_master/ucm_master_big_data")

githubURL1 <- "https://github.com/pedroconcejero/taller-color/blob/master/tasas_paro_andalucia.rda?raw=true"

load(url(githubURL1))

str(tasa.paro.and.provincial)
tasa.paro.and.provincial$gedad <- as.character(tasa.paro.and.provincial$gedad)
table(tasa.paro.and.provincial$gedad)

tasa.paro.and.provincial$gedad[tasa.paro.and.provincial$gedad == "De 16 a 34 a\xf1os"] <- "De 16 a 34 años"
tasa.paro.and.provincial$gedad[tasa.paro.and.provincial$gedad == "De 35 a 54 a\xf1os"] <- "De 35 a 54 años"
tasa.paro.and.provincial$gedad[tasa.paro.and.provincial$gedad == "Mayor de 55 a\xf1os"] <- "Mayor de 55 años"
table(tasa.paro.and.provincial$gedad)

# la función fortify -de ggplot2- permite pasar el objeto andalucia
# propio de la librería sp
# a data.frame que ya puede utilizar ggplot2
and.data.frame <- fortify(andalucia)

# Problema es que los datos los tenemos como dos primeros dígitos código postal
# y en mapa tenemos un código de 1 a 8

and.data.frame$id[and.data.frame$id == 1] <- "04"
and.data.frame$id[and.data.frame$id == 2] <- "11"
and.data.frame$id[and.data.frame$id == 3] <- "14"
and.data.frame$id[and.data.frame$id == 4] <- "18"
and.data.frame$id[and.data.frame$id == 5] <- "21"
and.data.frame$id[and.data.frame$id == 6] <- "23"
and.data.frame$id[and.data.frame$id == 7] <- "29"
and.data.frame$id[and.data.frame$id == 8] <- "41"

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat)



#######################################
# añadimos facetas -separamos por grupo de edad y nivel de formación

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)

#######################################
# cambiamos la escala de color para que más intenso sea más paro

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)  + 
  scale_fill_gradient(low = "#FDECDD", 
                      high = "#D94701")

#######################################
# Quitamos las coordenadas de x e y (longitud y latitud)

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)  + 
  scale_fill_gradient(low = "#FDECDD", 
                      high = "#D94701") + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) 

#######################################
# añadimos título, etiquetas de ejes y leyenda

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)  + 
  scale_fill_gradient(low = "#FDECDD", 
                      high = "#D94701") + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) + 
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(face = "bold", 
                                  size = rel(1.4)), 
        legend.text = element_text(size = rel(1.1)), 
        strip.text = element_text(face = "bold", size = rel(1))) + 
  labs(list(x = "", y = "", fill = "")) + 
  ggtitle("Tasa de paro\npor edad y estudios")


# Mejoramos el mapa con etiquetas para los niveles
# para dar significado a los colores
# ver la capa "scale_fill_manual"


ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = intervalos), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3) + 
  scale_fill_manual(values = c("#FDEBDD", 
                               "#F9C9AD",
                               "#E1885F", 
                               "#D34400"), 
                    labels = c("Menos del 20%", 
                               "[20% - 40%)", 
                               "[40% - 60%)", 
                               "[60% - 80%]")) + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) + 
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(face = "bold", 
                                  size = rel(1.4)), 
        legend.text = element_text(size = rel(1.1)), 
        strip.text = element_text(face = "bold", 
                                  size = rel(1.1))) + 
  labs(list(x = "", y = "", fill = "")) + 
  ggtitle("Tasa de paro\npor edad y estudios")



