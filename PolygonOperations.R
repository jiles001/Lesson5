library(rgeos)
## Expand the given geometry to include the area within the specified width with specific styling options.
# buffer around the first point, width determines what the size is
#quadseg determines the number of line segments to use to approximate a quarter circle
# if you increase quadseg, the circle becomes rounder
buffpoint <- gBuffer(mypointsRD[1,], width=mylinesdf$length[1], quadsegs=2)

# gDifference calculates the difference between 2 geometries
mydiff <- gDifference(circlesdf[1,], buffpoint)

plot(circlesdf[1,], col = "red")
plot(buffpoint, add = TRUE, lty = 3, lwd = 2, col = "blue")

#area of the difference
gArea(mydiff)
plot(mydiff, col = "red")

# plot the intersection
myintersection <- gIntersection(circlesdf[1,], buffpoint)
plot(myintersection, col="blue")
gArea(myintersection)

print(paste("The difference in area =", round(100 * gArea(mydiff) / gArea(myintersection),2), "%"))
