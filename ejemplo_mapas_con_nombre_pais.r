
install.packages(c("mapdata"))
library(maps)
library(mapdata)


map('worldHires',
    c('Spain', 'Portugal'))

map('worldHires',
    c('UK', 'Ireland', 'Isle of Man','Isle of Wight', 'Wales:Anglesey'))

map('worldHires',
    c('UK', 'Ireland', 'Isle of Man','Isle of Wight'),
    xlim=c(-11,3), ylim=c(49,60.9))	
