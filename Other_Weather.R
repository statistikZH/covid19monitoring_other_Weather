#  Other_Weather.R
# Import libraries
library(reshape2)
################################
# Preliminary Code subject to review, Results to be viewed with caution!! 

#get keyfile with units and variables
climvars<-read.table("climate_vars_recodings.csv", sep=",", fileEncoding = "UTF-8", header=T)

# Download data
urlfile="https://data.geo.admin.ch/ch.meteoschweiz.klima/nbcn-tageswerte/nbcn-daily_SMA_current.csv"
################################
# Format data according to data structure specification
smaweather<-data.frame(read.table(url(urlfile), sep=";", header=T))
smaweather$date<-as.Date(as.character(smaweather$date), format="%Y%m%d")
smaweather$rre150d0<-as.numeric(smaweather$rre150d0)
smaweather$rre150d0<-ifelse(is.na(smaweather$rre150d0), 0, smaweather$rre150d0)
# Variablen in denen Missings mit "-" gekennszeichnet wurden, sind vorderhand weggelassen (Schnehöhe etc)
smaweather<-melt(smaweather, 
                 id.vars = "date", 
                 measure.vars =c("gre000d0", "prestad0","rre150d0",
                                 "sre000d0", "tre200d0", "tre200dn", "tre200dx", "ure200d0"))    


smaweather<-merge(smaweather, climvars, all.x=T)
weatherzh<-droplevels(data.frame(date=smaweather$date,
                       value=smaweather$value,
                       topic="Sonstiges",
                       variable_short=smaweather$variable_short,
                       variable_long=smaweather$variable_long,
                       location="SMA Zürich Fluntern",
                       unit=smaweather$unit,
                       source="meteoschweiz",
                       update="täglich",
                       public="ja",
                       description="https://github.com/statistikZH/covid19monitoring_other_Weather"))


# export result

write.table(weatherzh, "Other_Weather.csv", sep=",", fileEncoding="UTF-8", row.names = F)

range(weatherzh$date)
