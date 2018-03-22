stress.list <- c()
for (i in 1:ncol(d2)) {
  mds <- metaMDS(d2, k=i, dist = "manhattan", trymax = 200, autotransform = FALSE)
  stress.list < c(stress.list, mds$stress)
}