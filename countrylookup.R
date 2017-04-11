#install.packages("ggmap")
#install.packages("DeducerSpatial")
require(maps)
require(ggmap)

country <- function(x){
  map("world", x)
}

capital <- function(x){
  map.cities(country = x, capitals = 2)
}

