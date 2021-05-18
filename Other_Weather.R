#  Other_Weather.R
# Import libraries
library(reshape2)
################################
#get keyfile with units and variables
climvars<-read.table("climate_vars_recodings.csv", sep=",", fileEncoding = "UTF-8", header=T)

# Download data current year
urlfilecur="https://data.geo.admin.ch/ch.meteoschweiz.klima/nbcn-tageswerte/nbcn-daily_SMA_current.csv"

# Download data previous years
urlfileprev="https://data.geo.admin.ch/ch.meteoschweiz.klima/nbcn-tageswerte/nbcn-daily_SMA_previous.csv"


################################
# Format data according to data structure specification
smaweathercur<-data.frame(read.table(url(urlfilecur), sep=";", header=T))

################################
# Format data according to data structure specification
smaweatherprev<-data.frame(read.table(url(urlfileprev), sep=";", header=T))

smaweather<-rbind(smaweatherprev, smaweathercur)



smaweather$date<-as.Date(as.character(smaweather$date), format="%Y%m%d")
smaweather$rre150d0<-as.numeric(smaweather$rre150d0)
smaweather$rre150d0<-ifelse(is.na(smaweather$rre150d0), 0, smaweather$rre150d0)
# Variablen in denen Missings mit "-" gekennszeichnet wurden, sind vorderhand weggelassen (Schnehöhe etc)
smaweather<-melt(smaweather, 
                 id.vars = "date", 
                 measure.vars =c("gre000d0", "prestad0","rre150d0",
                                 "sre000d0", "tre200d0", "tre200dn", "tre200dx", "ure200d0",  "hto000d0"))    


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
#Cut off deep past
weatherzh<-subset(weatherzh, date>"2017-12-31")

weatherzh$value<-as.numeric(weatherzh$value)

write.table(weatherzh, "Other_Weather.csv", sep=",", fileEncoding="UTF-8", row.names = F)

range(weatherzh$date)
