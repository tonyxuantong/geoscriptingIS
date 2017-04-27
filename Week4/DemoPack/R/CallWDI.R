library(WDI)
library(ggplot2)
library(googleVis)
library(plyr)

# World population total
population = WDI(indicator='SP.POP.TOTL', country="all",start=1960, end=2016)
# GDP in US $
gdp= WDI(indicator='NY.GDP.MKTP.CD', country="all",start=1960, end=2016)
# Life expectancy at birth (Years)
lifeExpectancy= WDI(indicator='SP.DYN.LE00.IN', country="all",start=1960, end=2016)
# GDP Per capita
income = WDI(indicator='NY.GDP.PCAP.PP.CD', country="all",start=1960, end=2016)
# Fertility rate (births per woman)
fertility = WDI(indicator='SP.DYN.TFRT.IN', country="all",start=1960, end=2016)
# Poverty head count
poverty= WDI(indicator='SI.POV.2DAY', country="all",start=1960, end=2016)
# Poverty head count
ENBird= WDI(indicator='EN.BIR.THRD.NO', country="all",start=2016, end=2016)

names(population)[3]="Total population"
names(lifeExpectancy)[3]="Life Expectancy (Years)"
names(gdp)[3]="GDP (US$)"
names(income)[3]="GDP per capita income"
names(fertility)[3]="Fertility (Births per woman)"
names(poverty)[3]="Poverty headcount ratio"


j1 <- join(population, gdp)
j2 <- join(j1,lifeExpectancy)
j3 <- join(j2,income)
j4 <- join(j3,poverty)
wbData <- join(j4,fertility)

#This returns  list of 2 matrixes
wdi_data =WDI_data
# The 1st matrix is the list is the set of all World Bank Indicators
indicators=wdi_data[[1]]
# The 2nd  matrix gives the set of countries and regions
countries=wdi_data[[2]]
df = as.data.frame(countries)
aa <- df$region != "Aggregates"
# Remove the aggregates
countries_df <- df[aa,]
# Subset from the development data only those corresponding to the countries
bb = subset(wbData, country %in% countries_df$country)
cc = join(bb,countries_df)
dd = complete.cases(cc)
developmentDF = cc[dd,]

gg<- gvisMotionChart(cc,
                     idvar = "country",
                     timevar = "year",
                     xvar = "GDP (US$)",
                     yvar = "Life Expectancy (Years)",
                     sizevar ="Total population",
                     colorvar = "region")
plot(gg)
cat(gg$html$chart, file="chart11.html")

cat(gg$html$chart, file="chart1.html")

##basic map
Geo=gvisGeoChart(cc, locationvar="country", colorvar="region", options=list(projection="kavrayskiy-vii"))
##plot(Geo)



G <- gvisGeoChart(cc, locationvar="country", colorvar="region",
                  options=list(width=300, height=300))

T <- gvisTable(cc,
               options=list(width=220, height=300))

GT <- gvisMerge(G,T, horizontal=TRUE)
plot(GT)

