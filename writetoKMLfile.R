library(rgdal)

# write to kml ; below we assume a subdirectory data within the current 
# working directory.

dir.create("data", showWarnings = FALSE) 
writeOGR(mypointsdf, file.path("data","mypointsGE.kml"), 
         "mypointsGE", driver="KML", overwrite_layer=TRUE)
writeOGR(mylinesdf, file.path("data","mylinesGE.kml"), 
         "mylinesGE", driver="KML", overwrite_layer=TRUE)

#read route from google earth (dsn=data source name)
#readOGR reads an OGR data source and layer into a spatial vector object
dsn = file.path("data","route.kml")
ogrListLayers(dsn) ## to find out what the layers are
myroute <- readOGR(dsn, layer = ogrListLayers(dsn))

# put both in single data frame
prj_string_WGS <- CRS("+proj=longlat +datum=WGS84")
proj4string(myroute) <- prj_string_WGS
myroute$Description <- NULL # delete Description
mylinesdf <- rbind(mylinesdf, myroute)

# define CRS object (defines coordinate system) for RD projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
mylinesRD <- spTransform(mylinesdf, prj_string_RD)
plot(mylinesRD, col = c("red", "blue"))
box()

# use rgeos for computing the length of lines 
library(rgeos)
(mylinesdf$length <- gLength(mylinesRD, byid=T))
