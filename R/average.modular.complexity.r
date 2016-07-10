#' Compute a measure of average modular complexity of technologies
#'
#' This function computes a measure of average modular complexity of technologies (average complexity of patent documents in a given technological class) from technological classes - patents (incidence) matrices 
#' @param mat A bipartite adjacency matrix (can be a sparse matrix)
#' @param sparse Logical; is the input matrix a sparse matrix? Defaults to FALSE, but can be set to TRUE if the input matrix is a sparse matrix
#' @param list Logical; is the input a list? Defaults to FALSE (input = adjacency matrix), but can be set to TRUE if the input is an edge list
#' @keywords modular complexity interdependencies
#' @export
#' @examples
#' ## generate a region - industry matrix 
#' set.seed(31)
#' mat <- matrix(sample(0:1,30,replace=T), ncol = 5)
#' rownames(mat) <- c ("T1", "T2", "T3", "T4", "T5", "T6")
#' colnames(mat) <- c ("US1", "US2", "US3", "US4", "US5")
#' 
#' ## run the function
#' average.modular.complexity (mat)
#' 
#' ## generate a region - industry sparse matrix 
#' library (Matrix)
#'
#' ## run the function
#' smat <- Matrix(mat,sparse=TRUE)
#'
#' average.modular.complexity (smat, sparse = TRUE)
#' ## generate a regular data frame (list)
#' list <- get.list (mat)
#' 
#' ## run the function
#' average.modular.complexity (list, list = TRUE)
#' @author Pierre-Alexandre Balland \email{p.balland@uu.nl}
#' @references Fleming, L. and Sorenson, O. (2001) Technology as a complex adaptive system: evidence from patent data, \emph{Research Policy} \strong{30}: 1019-1039
#' @seealso \code{\link{ease.recombination}}, \code{\link{TCI}}, \code{\link{MORt}}

average.modular.complexity <- function(mat, sparse = FALSE, list = FALSE) {

  library (Matrix)

  if (!list) {

  if (!sparse) {

  mat <- Matrix(mat,sparse=TRUE)
  cooc =   mat %*% Matrix::t(mat)
  diag(cooc) <- 0
  cooc[cooc > 1] <- 1

  Ease <- Matrix::rowSums(cooc, na.rm =T)/Matrix::rowSums(mat, na.rm =T)

  IntPat <- Matrix::colSums (mat, na.rm =T) / (Matrix::t(mat) %*% Ease)
  IntPat[is.infinite(IntPat)] <- 0 

avgIntPat <- (mat %*% IntPat) / Matrix::rowSums(mat, na.rm =T)

  avgIntPat <- data.frame (tech = rownames (mat), 
                          avg.mod.comp = as.numeric (avgIntPat))

   } else {

  cooc =   mat %*% Matrix::t(mat)
  diag(cooc) <- 0
  cooc[cooc > 1] <- 1

  Ease <- Matrix::rowSums(cooc, na.rm =T)/Matrix::rowSums(mat, na.rm =T)

  IntPat <- Matrix::colSums (mat, na.rm =T) / (Matrix::t(mat) %*% Ease)
  IntPat[is.infinite(IntPat)] <- 0 

avgIntPat <- (mat %*% IntPat) / Matrix::rowSums(mat, na.rm =T)

  avgIntPat <- data.frame (tech = rownames (mat), 
                          avg.mod.comp = as.numeric (avgIntPat))

   } 

   } else {

   mat <- get.matrix (mat, sparse = TRUE)
  cooc =   mat %*% Matrix::t(mat)
  diag(cooc) <- 0
  cooc[cooc > 1] <- 1

  Ease <- Matrix::rowSums(cooc, na.rm =T)/Matrix::rowSums(mat, na.rm =T)

  IntPat <- Matrix::colSums (mat, na.rm =T) / (Matrix::t(mat) %*% Ease)
  IntPat[is.infinite(IntPat)] <- 0 

avgIntPat <- (mat %*% IntPat) / Matrix::rowSums(mat, na.rm =T)

  avgIntPat <- data.frame (tech = rownames (mat), 
                          avg.mod.comp = as.numeric (avgIntPat))

}

  return(avgIntPat)
}
