#install.packages("ggmap")
#install.packages("DeducerSpatial")
require(maps)
require(ggmap)

country <- function(x){
  map("world", x)
}

add("china")
