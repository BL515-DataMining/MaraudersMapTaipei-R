source("convert_coord_to_district.R")
source("convert_coord_to_raster.R")
source("gen_grid.R")
source("map_drawer.R")

# read in taipei test event data
# coord_district <- read.csv("data/test/test_coord_district.csv", header = TRUE, sep = ",", encoding = "UTF-8")
# coord_district <- Coord2District$convert(coord_district)

# grid coords
grid_coords <- GenGrid$coords()
grid_districts <- Coord2District$convert(grid_coords)

# populations
# pop_density <- read.csv("data/population/taipei_population_density.csv", header = TRUE, sep = ",", encoding = "UTF-8")
# pop_data <- pop_density[,c("鄉鎮市區名稱", "村里名稱", "人口密度")]
# colnames(pop_data) <- c("tname", "vname", "density")
# pop_d <- data.frame(cbind(paste(pop_data$tname, pop_data$vname, sep = ""), pop_data[,"density"]))
# colnames(pop_d) <- c("tvname", "density")
# write.csv(pop_d, "data/population/taipei_density.csv", row.names=FALSE)
districts_pop_density <- read.csv("data/population/taipei_density.csv", header = TRUE, sep = ",", encoding = "UTF-8")

# crime locations
buglary_home <- read.csv("data/burglary/home.csv", header = TRUE, sep = ",", encoding = "UTF-8")
buglary_car <- read.csv("data/burglary/car.csv", header = TRUE, sep = ",", encoding = "UTF-8")
buglary_bike <- read.csv("data/burglary/bicycle.csv", header = TRUE, sep = ",", encoding = "UTF-8")
# police stations
police_stations <- read.csv("data/police_station/taipei_police_station.csv", header = TRUE, sep = ",", encoding = "UTF-8")

# grid count
buglary_home.r = Coord2Raster$convert(buglary_home)
buglary_car.r = Coord2Raster$convert(buglary_car)
buglary_bike.r = Coord2Raster$convert(buglary_bike)
police_stations.r = Coord2Raster$convert(police_stations)

# grid data
pop_density.grid <- cbind(grid_coords, density=districts_pop_density$density[match(grid_districts$district, districts_pop_density$tvname)])
buglary_home.grid <- GenGrid$from_raster(buglary_home.r)
buglary_car.grid <- GenGrid$from_raster(buglary_car.r)
buglary_bike.grid <- GenGrid$from_raster(buglary_bike.r)
police_stations.grid <- GenGrid$from_raster(police_stations.r)

# write grid data
# write.csv(pop_density.grid, "data/grids/population_density.csv", row.names=FALSE)
# write.csv(buglary_home.grid, "data/grids/buglary_home.csv", row.names=FALSE)
# write.csv(buglary_car.grid, "data/grids/buglary_car.csv", row.names=FALSE)
# write.csv(buglary_bike.grid, "data/grids/buglary_bike.csv", row.names=FALSE)
# write.csv(police_stations.grid, "data/grids/police_stations.csv", row.names=FALSE)

# make 0 NA
buglary_home.grid$val[buglary_home.grid$val == 0] <- NA
buglary_car.grid$val[buglary_car.grid$val == 0] <- NA
buglary_bike.grid$val[buglary_bike.grid$val == 0] <- NA
police_stations.grid$val[police_stations.grid$val == 0] <- NA

# draw map
# MapDrawer$drawTaipei() + MapDrawer$drawRaster(police_stations.r) + MapDrawer$drawPoints(police_stations, "yellow")
# MapDrawer$drawTaipei() + MapDrawer$drawPoints(grid_coords) + MapDrawer$drawRaster(buglary_home.r)
# MapDrawer$drawTaipei() + geom_point(data = pop_density.grid, aes(x = long, y = lat, color = density), size = 2, alpha = 0.8)
MapDrawer$drawTaipei() + geom_point(data = police_stations.grid, aes(x = long, y = lat, color = val), size = 2, alpha = 0.8)
