# load sp package
library(sp)
library(rgdal)

# coordinates of two points identiefied in Google Earth, for example
pnt1_xy <- cbind(5.679651, 51.978879)   # enter your own coordinates
pnt2_xy <- cbind(5.66089, 51.987697)   # enter your own coordinates

# combine coordinates in single matrix
coords <- rbind(pnt1_xy, pnt2_xy)

# make spatial points object
prj_string_WGS <- CRS("+proj=longlat +datum=WGS84")
mypoints <- SpatialPoints(coords, proj4string=prj_string_WGS)

# inspect object
class(mypoints)
str(mypoints)

# create and display some attribute data and store in a data frame
mydata <- data.frame(cbind(id = c(1,2), 
                           Name = c("my first point", 
                                    "my second point")))

# make spatial points data frame
mypointsdf <- SpatialPointsDataFrame(
  coords, data = mydata, 
  proj4string=prj_string_WGS)

# inspect and plot object
class(mypointsdf)
names(mypointsdf)
str(mypointsdf)
spplot(mypointsdf, zcol="Name", col.regions = c("red", "blue"), 
       xlim = bbox(mypointsdf)[1, ]+c(-0.01,0.01), 
       ylim = bbox(mypointsdf)[2, ]+c(-0.01,0.01),
       scales= list(draw = TRUE))