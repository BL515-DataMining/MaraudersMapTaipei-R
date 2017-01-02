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
})