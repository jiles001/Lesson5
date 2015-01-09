library(sp)

# perform the coordinate transformation from WGS84 (i.e. not a projection) to RD (projected)"
# this step is necessary to be able to measure objectives in 2D (e.g. meters)
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
pnt1_xy <- cbind(5.679651, 51.978879)
pnt2_xy <- cbind(5.66089, 51.987697)
coords <- rbind(pnt1_xy, pnt2_xy)
mydata <- data.frame(cbind(id = c(1,2), 
                           Name = c("my first point", 
                                    "my second point")))
prj_string_WGS <- CRS("+proj=longlat +datum=WGS84")
mypointsdf <- SpatialPointsDataFrame(
  coords, data = mydata, 
  proj4string=prj_string_WGS)
mypointsRD <- spTransform(mypointsdf, prj_string_RD)
pnt1_rd <- coordinates(mypointsRD)[1,]
pnt2_rd <- coordinates(mypointsRD)[2,]

# make circles around points, with radius equal to distance between points
# define a series of angles going from 0 to 2pi
ang <- pi*0:200/100
circle1x <- pnt1_rd[1] + cos(ang) * mylinesdf$length[1]
circle1y <- pnt1_rd[2] + sin(ang) * mylinesdf$length[1]
circle2x <- pnt2_rd[1] + cos(ang) * mylinesdf$length[1]
circle2y <- pnt2_rd[2] + sin(ang) * mylinesdf$length[1] 
c1 <- cbind(circle1x, circle1y)
c2 <- cbind(circle2x, circle2y)

#cex and pch define thinkness of the line of the circle
plot(c2, pch = 19, cex = 0.2, col = "red", ylim = range(circle1y, circle2y))
points(c1, pch = 19, cex = 0.2, col = "blue")
points(mypointsRD, pch = 3, col= "darkgreen")

# Iterate through some steps to create SpatialPolygonsDataFrame object
# first you make polygosn of both circles and you add an ID
# secondly you put both together in as SpatialPolygons (they get a coordinate system)
# thirdly, you make a data frame and put the Spatial Polygons in it.

circle1 <- Polygons(list(Polygon(cbind(circle1x, circle1y))),"1")
circle2 <- Polygons(list(Polygon(cbind(circle2x, circle2y))),"2")
spcircles <- SpatialPolygons(list(circle1, circle2), proj4string=prj_string_RD)
circledat <- data.frame(mypointsRD@data, row.names=c("1", "2"))
circlesdf <- SpatialPolygonsDataFrame(spcircles, circledat)

# Plotting the results, door add=TRUE worden ze samen in 1 plot geplot
plot(circlesdf, col = c("gray60", "gray40"))
plot(mypointsRD, add = TRUE,col="red", pch=19, cex=1.5)
plot(mylinesRD, add = TRUE, col = c("green", "yellow"), lwd=1.5)
box()


# plotting it with spplot
spplot(circlesdf, zcol="Name", col.regions=c("gray60", "gray40"), 
       sp.layout=list(list("sp.points", mypointsRD, col="red", pch=19, cex=1.5), 
                      list("sp.lines", mylinesRD, lwd=1.5)))

# breaking ssplot up into little steps:
spplot(circlesdf, zcol="Name", col.regions=c("gray60", "gray40"))
spplot(mypointsRD, zcol="Name", col.regions=c("red", "red"))
spplot(mylinesRD, zcol="Name", col.regions=c("red", "blue", lwd=1.8))


