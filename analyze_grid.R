library(modules)

AnlGrid <- module({
  # import library
  import("raster")
  
  wgauss <- function(sigma, n=5) {
    m <- matrix(ncol=n, nrow=n) 
    col <- rep(1:n, n) 
    row <- rep(1:n, each=n) 
    x <- col - ceiling(n/2) 
    y <- row - ceiling(n/2) 
    m[cbind(row, col)] <- 1/(2*pi*sigma^2) * exp(-(x^2+y^2)/(2*sigma^2)) 
    return(m / sum(m))
  }
  
  wmean <- function(n=5) {
    return(matrix(1/(n*n), ncol=n, nrow=n))
  }
  
  mean_raster <- function(grid_raster, wmat=matrix(1/9, ncol=3, nrow=3)) {
    grid_raster[is.na(grid_raster)] <- 0
    grid_raster.mean <- focal(grid_raster, w=wmat, fun=sum)
    return(grid_raster.mean)
  }

  xy_by_indices <- function(indices, ncol) {
    x_indices <- indices %% ncol
    y_indices <- indices %/% ncol
    y_indices[x_indices != 0] = y_indices[x_indices != 0] + 1
    x_indices[x_indices == 0] <- ncol
    return(cbind(x = x_indices, y = y_indices))
  }

  indinces_by_xy <- function(xy, ncol) {
    return(ncol * (xy[,c("y")] - 1) + xy[,c("x")])
  }

  neighbor_xy <- function(xy, n, ncol, nrow) {
    shift_num <- n %/% 2
    n_xy <- data.frame(xy)
    for(sx in c(-shift_num:shift_num)) {
      for(sy in c(-shift_num:shift_num)) {
        if(sx != 0 || sy != 0) {
          s_xy <- data.frame(xy)
          s_xy$x <- s_xy$x + sx
          s_xy$y <- s_xy$y + sy
          s_xy.f <- s_xy[s_xy$x >= 1 && s_xy$x <= ncol && s_xy$y >= 1 && s_xy$y <= nrow,]
          n_xy <- rbind(n_xy, s_xy.f)
          n_xy <- n_xy[!duplicated(n_xy), ]
        }
      }
    }
    return(n_xy)
  }
})
