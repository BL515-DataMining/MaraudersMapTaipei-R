library(modules)

GenGrid <- module({
  # import library
  import("sp")
  import("raster")
  import("ggmap")
  import("rgdal")
  
  # read in taipei district polygons
  taipei_districts <- readOGR(dsn = "data/shapefiles/taipei_district_wgs84", encoding = "UTF-8")
  taipei_districts <- spTransform(taipei_districts, CRS("+init=epsg:4326"))
  taipei_bbox <- bbox(taipei_districts)
  
  resolution <- 0.0045
  long_len <- floor(abs(taipei_bbox[1,2] - taipei_bbox[1,1]) / resolution) + 10
  lat_len <- floor(abs(taipei_bbox[2,2] - taipei_bbox[2,1]) / resolution) + 10
  
  coords <- function() {
    # grid
    r <- raster(xmn=taipei_bbox[1,1], ymn=taipei_bbox[2,1], xmx=taipei_bbox[1,2], ymx=taipei_bbox[2,2], res=resolution)
    r[] <- 0
    # project raster
    t <- projectRaster(from = r, crs = CRS("+init=epsg:4326"))
    t[is.na(t)] <- 0
    t.pt <- rasterToPoints(t)
    colnames(t.pt) <- c("long", "lat", "val")
    return(data.frame(t.pt[,c("long", "lat")]))
  }
  
  from_raster <- function(r) {
    r[is.na(r)] <- 0
    r.pt <- rasterToPoints(r)
    colnames(r.pt) <- c("long", "lat", "val")
    return(data.frame(r.pt))
  }
  
  calc_center <- function(grid_coords) {
    long_coords <- grid_coords[,"long"]
    lat_coords <- grid_coords[,"lat"]
    long_coords <- matrix(long_coords, nrow = lat_len, ncol = long_len, byrow = T)
    lat_coords <- matrix(lat_coords, nrow = lat_len, ncol = long_len, byrow = T)
  }
})