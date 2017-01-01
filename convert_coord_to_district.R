library(modules)

Coord2District <- module({
  # import library
  import("rgdal")
  import("sp")
  
  # read in taipei district polygons
  taipei_districts <- readOGR(dsn = "data/shapefiles/taipei_district_wgs84", encoding = "UTF-8")
  taipei_districts <- spTransform(taipei_districts, CRS("+init=epsg:4326"))
  
  convert <- function (coords) {
    coordinates(coords) <- c("long", "lat")
    # project coords
    proj4string(coords) <- CRS("+init=epsg:4326")
    over_districts <- over(coords, taipei_districts)
    coords$district <- paste(over_districts$TOWNNAME, over_districts$VILLNAME, sep="")
    coords$district[coords$district == "NANA"] <- NA
    return(coords)
  }
})