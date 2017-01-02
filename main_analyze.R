# population threshold 10
features.pop10.grid <- read.csv("data/feature/features_pop10.csv", header = TRUE, sep = ",", encoding = "UTF-8")
features_valid.pop10.grid <- features.pop10.grid[which(features.pop10.grid$pop_valid), -which(names(features.pop10.grid) %in% c("pop_valid"))]
features_has_station.pop10.grid <- features_valid.pop10.grid[which(features_valid.pop10.grid$has_station), -which(names(features_valid.pop10.grid) %in% c("has_station", "has_station_n3"))]
features_no_station.pop10.grid <- features_valid.pop10.grid[which(!features_valid.pop10.grid$has_station), -which(names(features_valid.pop10.grid) %in% c("has_station", "has_station_n3"))]
mean_has_station.pop10 <- data.frame(colMeans(features_has_station.pop10.grid))
mean_no_station.pop10 <- data.frame(colMeans(features_no_station.pop10.grid))

# population threshold 50
features.pop50.grid <- read.csv("data/feature/features_pop50.csv", header = TRUE, sep = ",", encoding = "UTF-8")
features_valid.pop50.grid <- features.pop50.grid[which(features.pop50.grid$pop_valid), -which(names(features.pop50.grid) %in% c("pop_valid"))]
features_has_station.pop50.grid <- features_valid.pop50.grid[which(features_valid.pop50.grid$has_station), -which(names(features_valid.pop50.grid) %in% c("has_station", "has_station_n3"))]
features_no_station.pop50.grid <- features_valid.pop50.grid[which(!features_valid.pop50.grid$has_station), -which(names(features_valid.pop50.grid) %in% c("has_station", "has_station_n3"))]
mean_has_station.pop50 <- data.frame(colMeans(features_has_station.pop50.grid))
mean_no_station.pop50 <- data.frame(colMeans(features_no_station.pop50.grid))

# population threshold 100
features.pop100.grid <- read.csv("data/feature/features_pop100.csv", header = TRUE, sep = ",", encoding = "UTF-8")
features_valid.pop100.grid <- features.pop100.grid[which(features.pop100.grid$pop_valid), -which(names(features.pop100.grid) %in% c("pop_valid"))]
features_has_station.pop100.grid <- features_valid.pop100.grid[which(features_valid.pop100.grid$has_station), -which(names(features_valid.pop100.grid) %in% c("has_station", "has_station_n3"))]
features_no_station.pop100.grid <- features_valid.pop100.grid[which(!features_valid.pop100.grid$has_station), -which(names(features_valid.pop100.grid) %in% c("has_station", "has_station_n3"))]
mean_has_station.pop100 <- data.frame(colMeans(features_has_station.pop100.grid))
mean_no_station.pop100 <- data.frame(colMeans(features_no_station.pop100.grid))

# police station n3
# population threshold 10
features.n3.pop10.grid <- read.csv("data/feature/features_pop10.csv", header = TRUE, sep = ",", encoding = "UTF-8")
features_valid.n3.pop10.grid <- features.n3.pop10.grid[which(features.n3.pop10.grid$pop_valid), -which(names(features.n3.pop10.grid) %in% c("pop_valid"))]
features_has_station.n3.pop10.grid <- features_valid.n3.pop10.grid[which(features_valid.n3.pop10.grid$has_station_n3), -which(names(features_valid.n3.pop10.grid) %in% c("has_station", "has_station_n3"))]
features_no_station.n3.pop10.grid <- features_valid.n3.pop10.grid[which(!features_valid.n3.pop10.grid$has_station_n3), -which(names(features_valid.n3.pop10.grid) %in% c("has_station", "has_station_n3"))]
mean_has_station.n3.pop10 <- data.frame(colMeans(features_has_station.n3.pop10.grid))
mean_no_station.n3.pop10 <- data.frame(colMeans(features_no_station.n3.pop10.grid))

# population threshold 50
features.n3.pop50.grid <- read.csv("data/feature/features_pop50.csv", header = TRUE, sep = ",", encoding = "UTF-8")
features_valid.n3.pop50.grid <- features.n3.pop50.grid[which(features.n3.pop50.grid$pop_valid), -which(names(features.n3.pop50.grid) %in% c("pop_valid"))]
features_has_station.n3.pop50.grid <- features_valid.n3.pop50.grid[which(features_valid.n3.pop50.grid$has_station_n3), -which(names(features_valid.n3.pop50.grid) %in% c("has_station", "has_station_n3"))]
features_no_station.n3.pop50.grid <- features_valid.n3.pop50.grid[which(!features_valid.n3.pop50.grid$has_station_n3), -which(names(features_valid.n3.pop50.grid) %in% c("has_station", "has_station_n3"))]
mean_has_station.n3.pop50 <- data.frame(colMeans(features_has_station.n3.pop50.grid))
mean_no_station.n3.pop50 <- data.frame(colMeans(features_no_station.n3.pop50.grid))

# population threshold 100
features.n3.pop100.grid <- read.csv("data/feature/features_pop100.csv", header = TRUE, sep = ",", encoding = "UTF-8")
features_valid.n3.pop100.grid <- features.n3.pop100.grid[which(features.n3.pop100.grid$pop_valid), -which(names(features.n3.pop100.grid) %in% c("pop_valid"))]
features_has_station.n3.pop100.grid <- features_valid.n3.pop100.grid[which(features_valid.n3.pop100.grid$has_station_n3), -which(names(features_valid.n3.pop100.grid) %in% c("has_station", "has_station_n3"))]
features_no_station.n3.pop100.grid <- features_valid.n3.pop100.grid[which(!features_valid.n3.pop100.grid$has_station_n3), -which(names(features_valid.n3.pop100.grid) %in% c("has_station", "has_station_n3"))]
mean_has_station.n3.pop100 <- data.frame(colMeans(features_has_station.n3.pop100.grid))
mean_no_station.n3.pop100 <- data.frame(colMeans(features_no_station.n3.pop100.grid))

