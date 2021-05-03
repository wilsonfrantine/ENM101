#'@name thin.env
#'@author Dr. Wilson Frantine-Silva
#'@description return spatially thinned dataset based on PCA coordinations
#'input and a minimum threshold of euclidian distances
#'@param rec.df.orig a PCA dataframe
#'@param thin.par a minimum distance threshold to keep samples apart each other
#'@param reps a number of replications. Each replication saves an random optimum 
#'dataset of points at least as distant as distant or more as thin.par
#'

require("spThin")

thin.env<-function (rec.df.orig, thin.par, reps) 
{
  reduced.rec.dfs <- vector("list", reps)
  #aqui modificamos o código original para uma função de distância euclidiana 
  DistMat.save <- as.matrix(dist(rec.df.orig, method = "euclidian")) < thin.par 
  diag(DistMat.save) <- FALSE
  DistMat.save[is.na(DistMat.save)] <- FALSE
  
  SumVec.save <- rowSums(DistMat.save)
  df.keep.save <- rep(TRUE, length(SumVec.save))
  for (Rep in seq_len(reps)) {
    DistMat <- DistMat.save
    SumVec <- SumVec.save
    df.keep <- df.keep.save
    while (any(DistMat) && sum(df.keep) > 1) {
      RemoveRec <- which(SumVec == max(SumVec))
      if (length(RemoveRec) > 1) {
        RemoveRec <- sample(RemoveRec, 1)
      }
      SumVec <- SumVec - DistMat[, RemoveRec]
      SumVec[RemoveRec] <- 0L
      DistMat[RemoveRec, ] <- FALSE
      DistMat[, RemoveRec] <- FALSE
      df.keep[RemoveRec] <- FALSE
    }
    rec.df <- rec.df.orig[df.keep, , drop = FALSE]
    #colnames(rec.df) <- c("Longitude", "Latitude")
    reduced.rec.dfs[[Rep]] <- rec.df
  }
  reduced.rec.order <- unlist(lapply(reduced.rec.dfs, nrow))
  reduced.rec.order <- order(reduced.rec.order, decreasing = TRUE)
  reduced.rec.dfs <- reduced.rec.dfs[reduced.rec.order]
  return(reduced.rec.dfs)
}