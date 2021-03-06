#' Make rasters from values and spatial indices
#'
#' Function that returns a raster based on given spatial indices (plot numbers)
#' and corresponding values that should be assigned to each pixel.
#' @param spatial.ID vector containing spatial indices
#' @param value vector containing values to fill the pixels
#' @param res side length of one spatial subunit
#' @param minx minimum X-coordinate
#' @param miny minimum Y-coordinate
#' @param maxx maximum X-coordinate
#' @param maxy maximum Y-coordinate
#' @return raster object
#' @keywords spatial index plot number raster map value cast
#' @export
#' @examples in progress
#' @author Nikolai Knapp, nikolai.knapp@ufz.de

make.map.from.spatial.index <- function(spatial.ID, value, res=1, minx=NA, miny=NA, maxx=NA, maxy=NA){
  require(data.table)
  require(raster)
  # Count number of cells in X- and Y-direction
  # %/%: integer division operator
  nx <- (maxx - minx) %/% res
  ny <- (maxy - miny) %/% res
  # Make a data.table with all possible spatial IDs inside the map extent
  id.dt <- data.table(SpatID=1:(nx*ny))
  # Make a data.table with all spatial IDs and their values given as input
  val.dt <- data.table(SpatID=spatial.ID, Value=value)
  # Merge the Values to the id.dt and fill all IDs with missing value with NA
  id.dt <- merge(id.dt, val.dt, by="SpatID", all.x=T, sort=T)
  # Build a matrix from the values
  value.mx <- matrix(data=id.dt$Value, nrow=ny, ncol=nx, byrow=T)
  # Convert matrix to raster
  ras <- rowmx2ras(value.mx)
  # Adjust the raster extent
  ras <- setExtent(ras, ext=c(minx, maxx, miny, maxy))
  return(ras)
}
