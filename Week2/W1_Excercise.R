library(raster)
raster::getData("ISO3")
datdir <- 'data'
dir.create(datdir, showWarnings = FALSE)
adm <- raster::getData("GADM", country = "CHN",
                       level = 2, path = datdir)
plot(adm[adm$NAME_1 == "Beijing",])
mar <- adm[adm$NAME_1 == "Beijing",]
plot(mar, bg = "dodgerblue", axes=T)
plot(mar, lwd = 10, border = "skyblue", add=T)
plot(mar, col = "green4", add = T)
grid()
box()
invisible(text(getSpPPolygonsLabptSlots(mar),
               labels = as.character(mar$NAME_2), cex = 1.1, col = "white", font = 2))
mtext(side = 3, line = 1, "City Map of Beijing", cex = 2)
mtext(side = 1, "Longitude", line = 2.5, cex=1.1)
mtext(side = 2, "Latitude", line = 2.5, cex=1.1)
text(122.08, 13.22, "Projection: Geographic\n
Coordinate System: WGS 1984\n
Data Source: GADM.org", adj = c(0, 0), cex = 0.7, col = "grey20")

