library(raster)
## Function to subtract 2 rasterLayers
minusRaster <- function(x, y, plot=FALSE) { 
  z <- x - y
  if (plot) {
    plot(z)
  }
  return(z)
}

# Let's generate 2 rasters 
# that first one is the R logo raster
# converted to the raster package file format.
r <- raster(system.file("external/rlogo.grd", package="raster")) 
# The second RasterLayer is derived from the initial RasterLayer in order
# to avoid issues of non matching extent or resolution, etc
r2 <- r
## Filling the rasterLayer with new values
# The /10 simply makes the result more spectacular
r2[] <- (1:ncell(r2)) / 10
## Simply performs the calculation
r3 <- minusRaster(r, r2) 
## Now performs the calculation and plots the resulting RasterLayer
r4 <- minusRaster(r, r2, plot=TRUE) 