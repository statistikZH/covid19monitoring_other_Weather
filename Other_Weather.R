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
# Download data
climvars<-read.table("climate_vars.csv", sep=",", fileEncoding = "UTF-8", header=T)
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
smaweather$date=as.POSIXct(paste(smaweather$date, "00:00:00", sep=" "))
smaweather$topic="andere" 
smaweather$location="SMA Zürich Fluntern"
smaweather$origin="meteoschweiz"
smaweather$update="daily"
smaweather$public="ja"

################################

# export result
write.table(smaweather, "./Other_Weather.csv", sep=",", fileEncoding="UTF-8", row.names = F)
