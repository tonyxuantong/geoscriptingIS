##Reproducible examples
library(raster)

## Loading required package: sp
r <- s <- raster(ncol=50, nrow=50)
## Fill the raster with values
r[] <- 1:ncell(r)
s[] <- 2 * (1:ncell(s))
s[200:400] <- 150
s[50:150] <- 151
## Perform the replacement
r[s %in% c(150, 151)] <- NA
## Visualise the result
plot(r)
