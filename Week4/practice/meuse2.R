## Load meuse.riv dataset
data(meuse.riv)
## Create an object of class SpatialPolygons from meuse.riv
meuse.sr <- SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
## Load the meuse.grid dataset
data(meuse.grid)
## Assign coordinates to the dataset and make it a grid
coordinates(meuse.grid) = c("x", "y")
gridded(meuse.grid) = TRUE
## Plot all variables of the meuse.grid dataset in a multiple window spplot
spplot(meuse.grid, col.regions=bpy.colors(), main = "meuse.grid",
       sp.layout=list(
         list("sp.polygons", meuse.sr),
         list("sp.points", meuse, pch="+", col="black")
       )
)
