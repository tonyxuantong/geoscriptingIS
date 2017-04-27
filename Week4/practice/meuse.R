## Example using built-in dataset from the sp package
library(sp)
## Load required datastes
data(meuse)
# The meuse dataset is not by default a spatial object
# but its x, y coordinates are part of the data.frame
class(meuse)
## [1] "data.frame"
coordinates(meuse) <- c("x", "y")
class(meuse)
## [1] "SpatialPointsDataFrame"
## attr(,"package")
## [1] "sp"
bubble(meuse, "zinc", maxsize = 2.5,
       main = "zinc concentrations (ppm)", key.entries = 2^(-1:4))

