library(raster)
library(XML)
library(rgdal)

#Change the following line to set the working directory
setwd("/Users/xuantongwang/Documents/2017S/R/Files/ProjectFinal/Econ")

#Download, unzip and load the polygon shapefile with the countries' borders
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip",destfile="TM_WORLD_BORDERS_SIMPL-0.3.zip")
unzip("TM_WORLD_BORDERS_SIMPL-0.3.zip",exdir=getwd())
polygons <- shapefile("TM_WORLD_BORDERS_SIMPL-0.3.shp")


#Read Economic data tables from the World Bank website
CO2_emissions_Tons.per.Capita_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EN.ATM.CO2E.PC")
Population_urban.more.1.mln_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EN.URB.MCTY")
Population_Density_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EN.POP.DNST")
Population_Largest_Cities_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EN.URB.LCTY")
GDP_capita_HTML <- readHTMLTable("http://data.worldbank.org/indicator/NY.GDP.PCAP.CD")
GDP_HTML <- readHTMLTable("http://data.worldbank.org/indicator/NY.GDP.MKTP.CD")
Adj_Income_capita_HTML <- readHTMLTable("http://data.worldbank.org/indicator/NY.ADJ.NNTY.PC.CD")
Adj_Income_HTML <- readHTMLTable("http://data.worldbank.org/indicator/NY.ADJ.NNTY.CD")
Elect_Consumption_capita_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EG.USE.ELEC.KH.PC")
Elect_Consumption_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EG.USE.ELEC.KH")
Elect_Production_HTML <- readHTMLTable("http://data.worldbank.org/indicator/EG.ELC.PROD.KH")


#First Approach - Find the most recent data
#Maximum Year
CO2.year <- max(as.numeric(names(CO2_emissions_Tons.per.Capita_HTML)),na.rm=T)
PoplUrb.year <- max(as.numeric(names(Population_urban.more.1.mln_HTML)),na.rm=T)
PoplDens.year <- max(as.numeric(names(Population_Density_HTML)),na.rm=T)
PoplLarg.year <- max(as.numeric(names(Population_Largest_Cities_HTML)),na.rm=T)
GDPcap.year <- max(as.numeric(names(GDP_capita_HTML)),na.rm=T)
GDP.year <- max(as.numeric(names(GDP_HTML)),na.rm=T)
AdjInc.cap.year <- max(as.numeric(names(Adj_Income_capita_HTML)),na.rm=T)
AdjInc.year <- max(as.numeric(names(Adj_Income_HTML)),na.rm=T)
EleCon.cap.year <- max(as.numeric(names(Elect_Consumption_capita_HTML)),na.rm=T)
EleCon.year <- max(as.numeric(names(Elect_Consumption_HTML)),na.rm=T)
ElecProd.year <- max(as.numeric(names(Elect_Production_HTML)),na.rm=T)


#Column Maximum Year
CO2.col <- grep(x=names(CO2_emissions_Tons.per.Capita_HTML),pattern=paste(CO2.year))
PoplUrb.col <- grep(x=names(Population_urban.more.1.mln_HTML),pattern=paste(PoplUrb.year))
PoplDens.col <- grep(x=names(Population_Density_HTML),pattern=paste(PoplDens.year))
PoplLarg.col <- grep(x=names(Population_Largest_Cities_HTML),pattern=paste(PoplLarg.year))
GDPcap.col <- grep(x=names(GDP_capita_HTML),pattern=paste(GDPcap.year))
GDP.col <- grep(x=names(GDP_HTML),pattern=paste(GDP.year))
AdjInc.cap.col <- grep(x=names(Adj_Income_capita_HTML),pattern=paste(AdjInc.cap.year))
AdjInc.col <- grep(x=names(Adj_Income_HTML),pattern=paste(AdjInc.year))
EleCon.cap.col <- grep(x=names(Elect_Consumption_capita_HTML),pattern=paste(EleCon.cap.year))
EleCon.col <- grep(x=names(Elect_Consumption_HTML),pattern=paste(EleCon.year))
ElecProd.col <- grep(x=names(Elect_Production_HTML),pattern=paste(ElecProd.year))



#Second Approach - Find data for specific Years
YEAR = 2010

#Year
CO2.year <- YEAR
PoplUrb.year <- YEAR
PoplDens.year <- YEAR
PoplLarg.year <- YEAR
GDPcap.year <- YEAR
GDP.year <- YEAR
AdjInc.cap.year <- YEAR
AdjInc.year <- YEAR
EleCon.cap.year <- YEAR
EleCon.year <- YEAR
ElecProd.year <- YEAR


#Column Maximum Year
CO2.col <- grep(x=names(CO2_emissions_Tons.per.Capita_HTML),pattern=paste(YEAR))
PoplUrb.col <- grep(x=names(Population_urban.more.1.mln_HTML),pattern=paste(YEAR))
PoplDens.col <- grep(x=names(Population_Density_HTML),pattern=paste(YEAR))
PoplLarg.col <- grep(x=names(Population_Largest_Cities_HTML),pattern=paste(YEAR))
GDPcap.col <- grep(x=names(GDP_capita_HTML),pattern=paste(YEAR))
GDP.col <- grep(x=names(GDP_HTML),pattern=paste(YEAR))
AdjInc.cap.col <- grep(x=names(Adj_Income_capita_HTML),pattern=paste(YEAR))
AdjInc.col <- grep(x=names(Adj_Income_HTML),pattern=paste(YEAR))
EleCon.cap.col <- grep(x=names(Elect_Consumption_capita_HTML),pattern=paste(YEAR))
EleCon.col <- grep(x=names(Elect_Consumption_HTML),pattern=paste(YEAR))
ElecProd.col <- grep(x=names(Elect_Production_HTML),pattern=paste(YEAR))




#Some Country names need to be changed for inconsistencies between datasets
polygons[polygons$NAME=="Libyan Arab Jamahiriya","NAME"] <- "Libya"
polygons[polygons$NAME=="Democratic Republic of the Congo","NAME"] <- "Congo, Dem. Rep."
polygons[polygons$NAME=="Congo","NAME"] <- "Congo, Rep."
polygons[polygons$NAME=="Kyrgyzstan","NAME"] <- "Kyrgyz Republic"
polygons[polygons$NAME=="United Republic of Tanzania","NAME"] <- "Tanzania"
polygons[polygons$NAME=="Iran (Islamic Republic of)","NAME"] <- "Iran, Islamic Rep."

#The States of "Western Sahara", "French Guyana" do not exist in the World Bank Database


#Now we can start the loop to add the economic data to the polygon shapefile
polygons$CO2 <- c()
polygons$PoplUrb <- c()
polygons$PoplDens <- c()
polygons$PoplLargCit <- c()
polygons$GDP.capita <- c()
polygons$GDP <- c()
polygons$AdjInc.capita <- c()
polygons$AdjInc <- c()
polygons$ElectConsumpt.capita <- c()
polygons$ElectConsumpt <- c()
polygons$ElectProduct <- c()


for(row in 1:length(polygons)){
  if(any(grep(x=paste(CO2_emissions_Tons.per.Capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)))&length(grep(x=paste(CO2_emissions_Tons.per.Capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)))==1){
    polygons[row,"CO2"] <- as.numeric(paste(CO2_emissions_Tons.per.Capita_HTML[grep(x=paste(CO2_emissions_Tons.per.Capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)),CO2.col]))
    polygons[row,"PoplUrb"] <- as.numeric(gsub(",","",paste(Population_urban.more.1.mln_HTML[grep(x=paste(Population_urban.more.1.mln_HTML[,1]),pattern=paste(polygons[row,]$NAME)),PoplUrb.col])))
    polygons[row,"PoplDens"] <- as.numeric(paste(Population_Density_HTML[grep(x=paste(Population_Density_HTML[,1]),pattern=paste(polygons[row,]$NAME)),PoplDens.col]))
    polygons[row,"PoplLargCit"] <- as.numeric(gsub(",","",paste(Population_Largest_Cities_HTML[grep(x=paste(Population_Largest_Cities_HTML[,1]),pattern=paste(polygons[row,]$NAME)),PoplLarg.col])))
    polygons[row,"GDP.capita"] <- as.numeric(gsub(",","",paste(GDP_capita_HTML[grep(x=paste(GDP_capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)),GDPcap.col])))
    polygons[row,"GDP"] <- as.numeric(gsub(",","",paste(GDP_HTML[grep(x=paste(GDP_HTML[,1]),pattern=paste(polygons[row,]$NAME)),GDP.col])))
    polygons[row,"AdjInc.capita"] <- as.numeric(gsub(",","",paste(Adj_Income_capita_HTML[grep(x=paste(Adj_Income_capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)),AdjInc.cap.col])))
    polygons[row,"AdjInc"] <- as.numeric(gsub(",","",paste(Adj_Income_HTML[grep(x=paste(Adj_Income_HTML[,1]),pattern=paste(polygons[row,]$NAME)),AdjInc.col])))
    polygons[row,"ElectConsumpt.capita"] <- as.numeric(gsub(",","",paste(Elect_Consumption_capita_HTML[grep(x=paste(Elect_Consumption_capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)),EleCon.cap.col])))
    polygons[row,"ElectConsumpt"] <- as.numeric(gsub(",","",paste(Elect_Consumption_HTML[grep(x=paste(Elect_Consumption_HTML[,1]),pattern=paste(polygons[row,]$NAME)),EleCon.col])))
    polygons[row,"ElectProduct"] <- as.numeric(gsub(",","",paste(Elect_Production_HTML[grep(x=paste(Elect_Production_HTML[,1]),pattern=paste(polygons[row,]$NAME)),ElecProd.col])))
  }

  if(any(grep(x=paste(CO2_emissions_Tons.per.Capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)))&length(grep(x=paste(CO2_emissions_Tons.per.Capita_HTML[,1]),pattern=paste(polygons[row,]$NAME)))>1){
    polygons[row,"CO2"] <- as.numeric(paste(CO2_emissions_Tons.per.Capita_HTML[paste(CO2_emissions_Tons.per.Capita_HTML[,1])==paste(polygons[row,]$NAME),CO2.col]))
    polygons[row,"PoplUrb"] <- as.numeric(gsub(",","",paste(Population_urban.more.1.mln_HTML[paste(Population_urban.more.1.mln_HTML[,1])==paste(polygons[row,]$NAME),PoplUrb.col])))
    polygons[row,"PoplDens"] <- as.numeric(paste(Population_Density_HTML[paste(Population_Density_HTML[,1])==paste(polygons[row,]$NAME),PoplDens.col]))
    polygons[row,"PoplLargCit"] <- as.numeric(gsub(",","",paste(Population_Largest_Cities_HTML[paste(Population_Largest_Cities_HTML[,1])==paste(polygons[row,]$NAME),PoplLarg.col])))
    polygons[row,"GDP.capita"] <- as.numeric(gsub(",","",paste(GDP_capita_HTML[paste(GDP_capita_HTML[,1])==paste(polygons[row,]$NAME),GDPcap.col])))
    polygons[row,"GDP"] <- as.numeric(gsub(",","",paste(GDP_HTML[paste(GDP_HTML[,1])==paste(polygons[row,]$NAME),GDP.col])))
    polygons[row,"AdjInc.capita"] <- as.numeric(gsub(",","",paste(Adj_Income_capita_HTML[paste(Adj_Income_capita_HTML[,1])==paste(polygons[row,]$NAME),AdjInc.cap.col])))
    polygons[row,"AdjInc"] <- as.numeric(gsub(",","",paste(Adj_Income_HTML[paste(Adj_Income_HTML[,1])==paste(polygons[row,]$NAME),AdjInc.col])))
    polygons[row,"ElectConsumpt.capita"] <- as.numeric(gsub(",","",paste(Elect_Consumption_capita_HTML[paste(Elect_Consumption_capita_HTML[,1])==paste(polygons[row,]$NAME),EleCon.cap.col])))
    polygons[row,"ElectConsumpt"] <- as.numeric(gsub(",","",paste(Elect_Consumption_HTML[paste(Elect_Consumption_HTML[,1])==paste(polygons[row,]$NAME),EleCon.col])))
    polygons[row,"ElectProduct"] <- as.numeric(gsub(",","",paste(Elect_Production_HTML[paste(Elect_Production_HTML[,1])==paste(polygons[row,]$NAME),ElecProd.col])))
  }

}



#Spatial Plots
spplot(polygons,"CO2",main=paste("CO2 Emissions - Year:",CO2.year),sub="Metric Tons per capita")
spplot(polygons,"PoplUrb",main=paste("Population - Year:",PoplUrb.year),sub="In urban agglomerations of more than 1 million")
spplot(polygons,"PoplDens",main=paste("Population Density - Year:",PoplDens.year),sub="People per sq. km of land area")
spplot(polygons,"PoplLargCit",main=paste("Population in largest city - Year:",PoplLarg.year))
spplot(polygons,"GDP.capita",main=paste("GDP per capita - Year:",GDPcap.year),sub="Currency: USD")
spplot(polygons,"GDP",main=paste("GDP - Year:",GDP.year),sub="Currency: USD")
spplot(polygons,"AdjInc.capita",main=paste("Adjusted net national income per capita - Year:",AdjInc.cap.year),sub="Currency: USD")
spplot(polygons,"AdjInc",main=paste("Adjusted net national income - Year:",AdjInc.year),sub="Currency: USD")
spplot(polygons,"ElectConsumpt.capita",main=paste("Electric power consumption per capita - Year:",EleCon.cap.year),sub="kWh per capita")
spplot(polygons,"ElectConsumpt",main=paste("Electric power consumption - Year:",EleCon.year),sub="kWh")
spplot(polygons,"ElectProduct",main=paste("Electricity production - Year:",ElecProd.year),sub="kWh")
