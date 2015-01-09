# load sp package
library(sp)
library(rgdal)

# coordinates of two points identiefied in Google Earth, for example
pnt1_xy <- cbind(5.679651, 51.978879)   # enter your own coordinates
pnt2_xy <- cbind(5.66089, 51.987697)   # enter your own coordinates

# combine coordinates in single matrix
coords <- rbind(pnt1_xy, pnt2_xy)

# create a line between the coordinates
(simple_line <- Line(coords))

# creates a lines object of the simple_line and 1
(lines_obj <- Lines(list(simple_line), "1"))

# creates objects of class SpatialLines from lists of Lines
prj_string_WGS <- CRS("+proj=longlat +datum=WGS84")
(spatlines <- SpatialLines(list(lines_obj), proj4string=prj_string_WGS))

# create a dataframe and put spatlines in it
(line_data <- data.frame(Name = "straight line", row.names="1"))
(mylinesdf <- SpatialLinesDataFrame(spatlines, line_data))

# create a plot of the lines
spplot(mylinesdf, col.regions = "blue", 
       xlim = bbox(mypointsdf)[1, ]+c(-0.01,0.01), 
       ylim = bbox(mypointsdf)[2, ]+c(-0.01,0.01),
       scales= list(draw = TRUE))
