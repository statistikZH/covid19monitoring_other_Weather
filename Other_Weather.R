#  Other_Weather.R

# Import libraries
require(tidyquant)
require(xts)
require(anytime)
library (readr)
library (lattice)
library(chron)
library(reshape)

################################
# Preliminary Code subject to review, Results to be viewed with caution!! 

#get keyfile with units and variables
climvars<-read.table("climate_vars_recodings.csv", sep=",", fileEncoding = "UTF-8", header=T)

# Download data
urlfile="https://data.geo.admin.ch/ch.meteoschweiz.klima/nbcn-tageswerte/VQEA34.csv"

################################

# Format data according to data structure specification
weather<-data.frame(read_delim(url(urlfile), delim=";", skip = 2))
weather$date<-anydate(weather$time)
smaweather<-subset(weather, stn=="SMA")

# Variablen in denen Missings mit "-" gekennszeichnet wurden, sind vorderhand weggelassen (Schnehöhe etc)
smaweather<-melt(smaweather, 
                 id.vars = "date", 
                 measure.vars =c("gre000d0", "prestad0",
                                 "sre000d0", "tre200d0", "tre200dn", "tre200dx", "ure200d0"))    


smaweather<-merge(smaweather, climvars, all.x=T)


weatherzh<-data.frame(date=as.POSIXct(paste(smaweather$date, "00:00:00", sep=" ")),
                       value=smaweather$value,
                       topic="Sonstiges",
                       variable_short=smaweather$variable_short,
                       variable_long=smaweather$variable_long,
                       location="SMA Zürich Fluntern",
                       unit=smaweather$unit,
                       source="meteoschweiz",
                       update="täglich",
                       public="ja",
                       description="https://github.com/statistikZH/covid19monitoring_other_Weather")



# export result
<<<<<<< HEAD
write.table(weatherzh, "Other_Weather.csv", sep=",", fileEncoding="UTF-8", row.names = F)
=======
write.table(smaweather, "./Other_Weather.csv", sep=",", fileEncoding="UTF-8", row.names = F)

>>>>>>> a15fb11ea0da386df39311d3b65b89886356e080
