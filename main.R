source("convert_coord_to_district.R")
source("convert_coord_to_raster.R")
source("gen_grid.R")
source("analyze_grid.R")
source("map_drawer.R")
library(corrplot)
library(plyr)

# read in taipei test event data
# coord_district <- read.csv("data/test/test_coord_district.csv", header = TRUE, sep = ",", encoding = "UTF-8")
# coord_district <- Coord2District$convert(coord_district)

# grid coords
grid_coords <- GenGrid$coords()
grid_districts <- Coord2District$convert(grid_coords)

# populations
pop_density <- read.csv("data/population/taipei_population_density.csv", header = TRUE, sep = ",", encoding = "UTF-8")
pop_data <- pop_density[,c("鄉鎮市區名稱", "村里名稱", "人口密度")]
colnames(pop_data) <- c("tname", "vname", "density")
pop_d <- data.frame(cbind(paste(pop_data$tname, pop_data$vname, sep = ""), pop_data[,"density"]))
colnames(pop_d) <- c("tvname", "density")
# write.csv(pop_d, "data/population/taipei_density.csv", row.names=FALSE)
districts_pop_density <- read.csv("data/population/taipei_density.csv", header = TRUE, sep = ",", encoding = "UTF-8")

# crime locations
buglary_home <- read.csv("data/burglary/home.csv", header = TRUE, sep = ",", encoding = "UTF-8")
buglary_car <- read.csv("data/burglary/car.csv", header = TRUE, sep = ",", encoding = "UTF-8")
buglary_bike <- read.csv("data/burglary/bicycle.csv", header = TRUE, sep = ",", encoding = "UTF-8")
# police stations
police_stations <- read.csv("data/police_station/taipei_police_station.csv", header = TRUE, sep = ",", encoding = "UTF-8")

# crime districts
buglary_home.coords <- buglary_home[,c("long", "lat")]
buglary_car.coords <- buglary_car[,c("long", "lat")]
buglary_bike.coords <- buglary_bike[,c("long", "lat")]
buglary_home.districts <- Coord2District$convert(buglary_home.coords)
buglary_car.districts <- Coord2District$convert(buglary_car.coords)
buglary_bike.districts <- Coord2District$convert(buglary_bike.coords)
buglary_home.locations <- cbind(buglary_home[,c("long", "lat")], district=buglary_home.districts$district)
buglary_car.locations <- cbind(buglary_car[,c("long", "lat")], district=buglary_car.districts$district)
buglary_bike.locations <- cbind(buglary_bike[,c("long", "lat")], district=buglary_bike.districts$district)
buglary_home.count <- data.frame(buglary_home.locations %>% group_by(district) %>% summarise(freq=length(district)))
buglary_car.count <- data.frame(buglary_car.locations %>% group_by(district) %>% summarise(freq=length(district)))
buglary_bike.count <- data.frame(buglary_bike.locations %>% group_by(district) %>% summarise(freq=length(district)))
names(buglary_home.count) <- c("x", "freq")
names(buglary_car.count) <- c("x", "freq")
names(buglary_bike.count) <- c("x", "freq")

# police station districts
police_stations.coords <- police_stations[,c("long", "lat")]
police_stations.districts <- Coord2District$convert(police_stations.coords)
police_stations.locations <- cbind(police_stations[,c("long", "lat")], district=police_stations.districts$district)
police_stations.count <- data.frame(police_stations.locations %>% group_by(district) %>% summarise(freq=length(district)))
names(police_stations.count) <- c("x", "freq")

# population districts
pop_density.count <- districts_pop_density
names(pop_density.count) <- c("x", "freq")

# corrplot
# count.relation <- join(pop_density.count, buglary_home.count, by = "x", type = "left")
# count.relation <- join(count.relation, buglary_car.count, by = "x", type = "left")
# count.relation <- join(count.relation, buglary_bike.count, by = "x", type = "left")
# count.relation[is.na(count.relation)] <- 0
# names(count.relation) <- c("x", "population.density", "buglary.home", "buglary.car", "buglary.bike")
# relation <- count.relation[c(2, 3, 4, 5)]
# corrplot(cor(relation), order = "FPC")

# scatter plot

# bin plot
# pop_density.count.sorted <- pop_density.count[with(pop_density.count, order(-freq)), ]
# buglary_home.count.sorted <- buglary_home.count[with(buglary_home.count, order(-freq)), ]
# buglary_car.count.sorted <- buglary_car.count[with(buglary_car.count, order(-freq)), ]
# buglary_bike.count.sorted <- buglary_bike.count[with(buglary_bike.count, order(-freq)), ]
#
# pop_density.count.top50 <- pop_density.count.sorted[1:50,]
# buglary_home.count.top50 <- buglary_home.count.sorted[1:50,]
# buglary_car.count.top50 <- buglary_car.count.sorted[1:50,]
# buglary_bike.count.top50 <- buglary_bike.count.sorted[1:50,]

# write.csv(buglary_home.locations, "data/burglary/home_district.csv", row.names=FALSE)
# write.csv(buglary_car.locations, "data/burglary/car_district.csv", row.names=FALSE)
# write.csv(buglary_bike.locations, "data/burglary/bike_district.csv", row.names=FALSE)

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

# grid corrplot
tpe_pop_density.grid <- pop_density.grid[which(!is.na(pop_density.grid$density)),]
tpe_grid.coords <- tpe_pop_density.grid[c(1, 2)]
tpe_police_grid.dist <- distm(tpe_grid.coords, police_stations.coords, fun = distHaversine)
tpe_police_grid.dist.min <- apply(tpe_police_grid.dist, 1, min)
grid.relation <- merge(tpe_pop_density.grid, buglary_home.grid, by=c("lat", "long"))
grid.relation <- merge(grid.relation, buglary_car.grid, by=c("lat", "long"))
grid.relation <- merge(grid.relation, buglary_bike.grid, by=c("lat", "long"))
grid.relation$min_police_dist <- tpe_police_grid.dist.min
names(grid.relation) <- c("lat", "long", "population.density", "buglary.home", "buglary.car", "buglary.bike", "police.min.dist")
relation.grid <- grid.relation[c(3, 4, 5, 6, 7)]
grid.corr <- cor(relation.grid)
corrplot(grid.corr, order = "FPC")

# prepare predict data
# relation.home.grid <- relation.grid[c(1, 5, 2)]
# relation.car.grid <- relation.grid[c(1, 5, 3)]
# relation.bike.grid <- relation.grid[c(1, 5, 4)]
# relation.home.nominal.grid <- relation.home.grid
# relation.home.nominal.grid$buglary.home[relation.home.nominal.grid$buglary.home > 0] <- "bug"
# relation.home.nominal.grid$buglary.home[relation.home.nominal.grid$buglary.home == 0] <- "good"
# write.csv(relation.home.nominal.grid, "data/predict/predict.home.csv", row.names=FALSE)
# write.csv(relation.car.grid, "data/predict/predict.car.csv", row.names=FALSE)
# write.csv(relation.bike.grid, "data/predict/predict.bike.csv", row.names=FALSE)

# handle density factor
buglary_home.density.r <- AnlGrid$grid_divide_raster(buglary_home.r, pop_density.grid$density)
buglary_car.density.r <- AnlGrid$grid_divide_raster(buglary_car.r, pop_density.grid$density)
buglary_bike.density.r <- AnlGrid$grid_divide_raster(buglary_bike.r, pop_density.grid$density)

buglary_home.density.grid <- GenGrid$from_raster(buglary_home.density.r)
buglary_car.density.grid <- GenGrid$from_raster(buglary_car.density.r)
buglary_bike.density.grid <- GenGrid$from_raster(buglary_bike.density.r)

# write grid data
# write.csv(pop_density.grid, "data/grids/population_density.csv", row.names=FALSE)
# write.csv(buglary_home.grid, "data/grids/buglary_home.csv", row.names=FALSE)
# write.csv(buglary_car.grid, "data/grids/buglary_car.csv", row.names=FALSE)
# write.csv(buglary_bike.grid, "data/grids/buglary_bike.csv", row.names=FALSE)
# write.csv(police_stations.grid, "data/grids/police_stations.csv", row.names=FALSE)

# population
pop_density_thres = 100
pop_density.grid$density[is.na(pop_density.grid$density)] <- 0
pop_density.grid$valid <- pop_density.grid$density >= pop_density_thres

# police station
police_stations.grid$has_station <- police_stations.grid$val > 0
police_stations.indices <- which(police_stations.grid$has_station)
police_stations.xy <- AnlGrid$xy_by_indices(police_stations.indices, GenGrid$long_len)
police_stations.neighbor3.xy <- AnlGrid$neighbor_xy(police_stations.xy, 3, GenGrid$long_len, GenGrid$lat_len)
police_stations.neighbor3.indices <- AnlGrid$indinces_by_xy(police_stations.neighbor3.xy, GenGrid$long_len)
police_stations.neighbor3.grid <- data.frame(police_stations.grid)
police_stations.neighbor3.grid$has_station[police_stations.neighbor3.indices] <- TRUE
# police_stations.neighbor3.grid$val[police_stations.neighbor3.indices] <- 1

# calc mean
# # neighbor mean 3x3
# buglary_home.rmean3 <- AnlGrid$mean(buglary_home.r, AnlGrid$wmean(3))
# buglary_car.rmean3 <- AnlGrid$mean(buglary_car.r, AnlGrid$wmean(3))
# buglary_bike.rmean3 <- AnlGrid$mean(buglary_bike.r, AnlGrid$wmean(3))
# buglary_home.gridmean3 <- GenGrid$from_raster(buglary_home.rmean3)
# buglary_car.gridmean3 <- GenGrid$from_raster(buglary_car.rmean3)
# buglary_bike.gridmean3 <- GenGrid$from_raster(buglary_bike.rmean3)
# 
# # neighbor mean 5x5
# buglary_home.rmean5 <- AnlGrid$mean(buglary_home.r, AnlGrid$wmean(5))
# buglary_car.rmean5 <- AnlGrid$mean(buglary_car.r, AnlGrid$wmean(5))
# buglary_bike.rmean5 <- AnlGrid$mean(buglary_bike.r, AnlGrid$wmean(5))
# buglary_home.gridmean5 <- GenGrid$from_raster(buglary_home.rmean5)
# buglary_car.gridmean5 <- GenGrid$from_raster(buglary_car.rmean5)
# buglary_bike.gridmean5 <- GenGrid$from_raster(buglary_bike.rmean5)
# 
# # neighbor mean 7x7
# buglary_home.rmean7 <- AnlGrid$mean(buglary_home.r, AnlGrid$wmean(7))
# buglary_car.rmean7 <- AnlGrid$mean(buglary_car.r, AnlGrid$wmean(7))
# buglary_bike.rmean7 <- AnlGrid$mean(buglary_bike.r, AnlGrid$wmean(7))
# buglary_home.gridmean7 <- GenGrid$from_raster(buglary_home.rmean7)
# buglary_car.gridmean7 <- GenGrid$from_raster(buglary_car.rmean7)
# buglary_bike.gridmean7 <- GenGrid$from_raster(buglary_bike.rmean7)
# 
# # neighbor mean 9x9
# buglary_home.rmean9 <- AnlGrid$mean(buglary_home.r, AnlGrid$wmean(9))
# buglary_car.rmean9 <- AnlGrid$mean(buglary_car.r, AnlGrid$wmean(9))
# buglary_bike.rmean9 <- AnlGrid$mean(buglary_bike.r, AnlGrid$wmean(9))
# buglary_home.gridmean9 <- GenGrid$from_raster(buglary_home.rmean9)
# buglary_car.gridmean9 <- GenGrid$from_raster(buglary_car.rmean9)
# buglary_bike.gridmean9 <- GenGrid$from_raster(buglary_bike.rmean9)

# neighbor mean 3x3
buglary_home.rmean3 <- AnlGrid$mean(buglary_home.density.r, AnlGrid$wmean(3))
buglary_car.rmean3 <- AnlGrid$mean(buglary_car.density.r, AnlGrid$wmean(3))
buglary_bike.rmean3 <- AnlGrid$mean(buglary_bike.density.r, AnlGrid$wmean(3))
buglary_home.gridmean3 <- GenGrid$from_raster(buglary_home.rmean3)
buglary_car.gridmean3 <- GenGrid$from_raster(buglary_car.rmean3)
buglary_bike.gridmean3 <- GenGrid$from_raster(buglary_bike.rmean3)

# neighbor mean 5x5
buglary_home.rmean5 <- AnlGrid$mean(buglary_home.density.r, AnlGrid$wmean(5))
buglary_car.rmean5 <- AnlGrid$mean(buglary_car.density.r, AnlGrid$wmean(5))
buglary_bike.rmean5 <- AnlGrid$mean(buglary_bike.density.r, AnlGrid$wmean(5))
buglary_home.gridmean5 <- GenGrid$from_raster(buglary_home.rmean5)
buglary_car.gridmean5 <- GenGrid$from_raster(buglary_car.rmean5)
buglary_bike.gridmean5 <- GenGrid$from_raster(buglary_bike.rmean5)

# neighbor mean 7x7
buglary_home.rmean7 <- AnlGrid$mean(buglary_home.density.r, AnlGrid$wmean(7))
buglary_car.rmean7 <- AnlGrid$mean(buglary_car.density.r, AnlGrid$wmean(7))
buglary_bike.rmean7 <- AnlGrid$mean(buglary_bike.density.r, AnlGrid$wmean(7))
buglary_home.gridmean7 <- GenGrid$from_raster(buglary_home.rmean7)
buglary_car.gridmean7 <- GenGrid$from_raster(buglary_car.rmean7)
buglary_bike.gridmean7 <- GenGrid$from_raster(buglary_bike.rmean7)

# neighbor mean 9x9
buglary_home.rmean9 <- AnlGrid$mean(buglary_home.density.r, AnlGrid$wmean(9))
buglary_car.rmean9 <- AnlGrid$mean(buglary_car.density.r, AnlGrid$wmean(9))
buglary_bike.rmean9 <- AnlGrid$mean(buglary_bike.density.r, AnlGrid$wmean(9))
buglary_home.gridmean9 <- GenGrid$from_raster(buglary_home.rmean9)
buglary_car.gridmean9 <- GenGrid$from_raster(buglary_car.rmean9)
buglary_bike.gridmean9 <- GenGrid$from_raster(buglary_bike.rmean9)

# merge grid data
features.grid <- cbind(grid_coords, pop_valid=pop_density.grid$valid, has_station=police_stations.grid$has_station, has_station_n3=police_stations.neighbor3.grid$has_station,
                       buglary_home=buglary_home.grid$val, buglary_home_density=buglary_home.density.grid$val, buglary_home_mean3=buglary_home.gridmean3$val, buglary_home_mean5=buglary_home.gridmean5$val, buglary_home_mean7=buglary_home.gridmean7$val, buglary_home_mean9=buglary_home.gridmean9$val,
                       buglary_car=buglary_car.grid$val, buglary_car_density=buglary_car.density.grid$val, buglary_car_mean3=buglary_car.gridmean3$val, buglary_car_mean5=buglary_car.gridmean5$val, buglary_car_mean7=buglary_car.gridmean7$val, buglary_car_mean9=buglary_car.gridmean9$val,
                       buglary_bike=buglary_bike.grid$val, buglary_bike_density=buglary_bike.density.grid$val, buglary_bike_mean3=buglary_bike.gridmean3$val, buglary_bike_mean5=buglary_bike.gridmean5$val, buglary_bike_mean7=buglary_bike.gridmean7$val, buglary_bike_mean9=buglary_bike.gridmean9$val)
# write feature data
# write.csv(features.grid, "data/feature/features_pop10_density_100m.csv", row.names=FALSE)

# make 0 NA
pop_density.grid$density[pop_density.grid$density == 0] <- NA
buglary_home.grid$val[buglary_home.grid$val == 0] <- NA
buglary_car.grid$val[buglary_car.grid$val == 0] <- NA
buglary_bike.grid$val[buglary_bike.grid$val == 0] <- NA

buglary_home.density.grid$val[buglary_home.density.grid$val == 0] <- NA
buglary_car.density.grid$val[buglary_car.density.grid$val == 0] <- NA
buglary_bike.density.grid$val[buglary_bike.density.grid$val == 0] <- NA

police_stations.grid$val[police_stations.grid$val == 0] <- NA
police_stations.neighbor3.grid$val[police_stations.neighbor3.grid$val == 0] <- NA

buglary_home.gridmean3$val[buglary_home.gridmean3$val == 0] <- NA
buglary_car.gridmean3$val[buglary_car.gridmean3$val == 0] <- NA
buglary_bike.gridmean3$val[buglary_bike.gridmean3$val == 0] <- NA

buglary_home.gridmean5$val[buglary_home.gridmean5$val == 0] <- NA
buglary_car.gridmean5$val[buglary_car.gridmean5$val == 0] <- NA
buglary_bike.gridmean5$val[buglary_bike.gridmean5$val == 0] <- NA

buglary_home.gridmean7$val[buglary_home.gridmean7$val == 0] <- NA
buglary_car.gridmean7$val[buglary_car.gridmean7$val == 0] <- NA
buglary_bike.gridmean7$val[buglary_bike.gridmean7$val == 0] <- NA

buglary_home.gridmean9$val[buglary_home.gridmean9$val == 0] <- NA
buglary_car.gridmean9$val[buglary_car.gridmean9$val == 0] <- NA
buglary_bike.gridmean9$val[buglary_bike.gridmean9$val == 0] <- NA

# filt_pop_density.grid <- pop_density.grid[which(pop_density.grid$valid),]
# filt_buglary_home.grid <- buglary_home.grid[which(pop_density.grid$valid),]
# filt_buglary_home.gridmean5 <- buglary_home.gridmean5[which(pop_density.grid$valid),]
# filt_police_stations.neighbor3 <- police_stations.neighbor3.grid[which(pop_density.grid$valid),]

# draw map
# MapDrawer$drawTaipei(fillData=pop_density.count)
# MapDrawer$drawTaipei() + MapDrawer$drawRaster(police_stations.r) + MapDrawer$drawPoints(police_stations, "yellow")
# MapDrawer$drawTaipei() + MapDrawer$drawPoints(grid_coords) + MapDrawer$drawRaster(buglary_home.r)
# MapDrawer$drawTaipei() + geom_point(data = filt_police_stations.neighbor3, aes(x = long, y = lat, color = val), size = 0.1, alpha = 0.6) + scale_colour_gradient(low="green", high="red")
# MapDrawer$drawTaipei() + geom_point(data = buglary_home.density.grid, aes(x = long, y = lat, color = val), size = 0.1, alpha = 0.8)
# MapDrawer$drawTaipei() + geom_point(data = buglary_home.coords, aes(x = long, y = lat), color="red", size = 0.4, alpha = 0.9) + geom_point(data = police_stations.coords, aes(x = long, y = lat), color="yellow", size = 0.6, alpha = 0.9)

