library(modules)

MapDrawer <- module({
  # import library
  import("sp")
  import("maps")
  import("raster")
  import("maptools")
  if (!require("gpclib")) install.packages("gpclib", type="source")
  gpclibPermit()
  import("rgdal")
  import("ggmap")
  import("ggplot2")
  import("dplyr")
  
  # Read in taipei district polygons
  taipei_districts <- readOGR(dsn = "data/shapefiles/taipei_district_wgs84", encoding = "UTF-8")
  taipei_districts <- spTransform(taipei_districts, CRS("+init=epsg:4326"))
  
  # Read from Taiwan districts and Write Taipei districts shapefile
  #taiwan_districts <- readOGR(dsn = "data/shapefiles/taiwan_district", encoding = "Utf-8")
  #taiwan_districts_t <- spTransform(taiwan_districts, CRS("+init=epsg:4326"))
  #taipei_districts_indices <- which(taiwan_districts_t$COUNTYNAME == "臺北市")
  #taipei_districts_t <- taiwan_districts_t[taipei_districts_indices,]
  #Sys.getlocale("LC_CTYPE")
  #getCPLConfigOption("SHAPE_ENCODING")
  #setCPLConfigOption("SHAPE_ENCODING", "UTF-8")
  #writeOGR(obj=taipei_districts_t, dsn="data/shapefiles/taipei_district_wgs84", layer="taipei_district", driver="ESRI Shapefile", layer_options= c(encoding= "UTF-8"))
  
  # create region data
  taipei_districts$TVNAME <- paste(taipei_districts$TOWNNAME, taipei_districts$VILLNAME, sep="")
  taipei_fortify = fortify(taipei_districts, region = "TVNAME")
  taipei_neighborhoods = merge(taipei_fortify, taipei_districts@data, by.x = "id", by.y = "TVNAME")
  regions = taipei_neighborhoods %>% select(id) %>% distinct()
  # region_values = data.frame(id = c(regions), value = c(runif(regions %>% count() %>% unlist(),5.0, 25.0)))
  #taipei_districts = merge(taipei_neighborhoods, region_values, by.x='id')
  
  # create map
  taipei_bbox <- bbox(taipei_districts)
  cen_long <- mean(taipei_bbox[1,])
  cen_lat <- mean(taipei_bbox[2,])
  taipei_map = get_map(location = c(lon=cen_long, lat=cen_lat), zoom = 11)
  # functions
  drawTaipei <- function(fillData="None") {
    if(class(fillData) != "character") {
      region_values <- data.frame(id = c(regions), value = rep.int(0, length(regions)))
      region_values <- merge(region_values, fillData, by.x="id", by.y="x", all.x=TRUE)
      region_values <- region_values[,c("id", "freq")]
      region_values[is.na(region_values)] <- 0
      names(region_values) <- c("id", "value")
      taipei_districts <- merge(taipei_neighborhoods, region_values, by.x='id')
    }
    # return(ggmap(taipei_map) + geom_polygon(aes(fill = value, x = long, y = lat, group = group), data = taipei_districts, alpha = 0.9, color = "blue", size = 0.1) + scale_fill_gradient(low="green", high="red"))
    return(ggmap(taipei_map) + geom_polygon(aes(x = long, y = lat, group = group), data = taipei_districts, alpha = 0.9, fill="gray", color = "blue", size = 0.1))
  }
  
  drawPoints <- function(coords, color="red") {
    return(geom_point(data = data.frame(coords), aes(x =long, y= lat), alpha = 0.5, color = color))
  }
  
  drawRaster <- function(r) {
    return(inset_raster(as.raster(r), xmin=r@extent[1], xmax=r@extent[2], ymin=r@extent[3], ymax=r@extent[4]))
  }
  
  drawTile <- function() {
    return(geom_tile())
  }
})