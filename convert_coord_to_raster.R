library(modules)

Coord2Raster <- module({
  # import library
  import("sp")
  import("raster")
  import("ggmap")
  import("rgdal")
  
  # read in taipei district polygons
  taipei_districts <- readOGR(dsn = "data/shapefiles/taipei_district_wgs84", encoding = "UTF-8")
  taipei_districts <- spTransform(taipei_districts, CRS("+init=epsg:4326"))
  taipei_bbox = bbox(taipei_districts)
  
  convert <- function (coords) {
    coords <- coords[,c("long", "lat")]
    coordinates(coords) <- c("long", "lat")
    # grid
    r <- raster(xmn=taipei_bbox[1,1], ymn=taipei_bbox[2,1], xmx=taipei_bbox[1,2], ymx=taipei_bbox[2,2], res=0.0045)
    r <- rasterize(coords, r, fun='count')
    # project raster
    t <- projectRaster(from = r, crs = CRS("+init=epsg:4326"))
    return(t)
  }
})