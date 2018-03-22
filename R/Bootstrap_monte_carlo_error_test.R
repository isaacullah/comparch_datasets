##################################################################
# This script will analyze SCCS data on subsistence, mobility,   #
# and demography for the existence of attractors                 #
# Copyright: Isaac I. Ullah, 2014                                #
# This script is released as free software under the GNU license #
##################################################################
# UNDERTAKE A BOOTSTRAPPED MONTE CARLO ANALYSIS OF A MULTIDIMENSIONAL
# DATASET TO ASSESS THE AMOUNT OF RANDOM (SPURIOUS) CORRELATION PRESENT
# IN THE DATA
#import required libraries
library(cluster)
library(vegan)
library(maptools)
library(ggplot2)

###################################################################
#Set working directory (EDIT THIS TO YOUR LOCAL WORKING DIRECTORY)
setwd("/home/iullah/Dropbox/Research_Projects/Ethnographic_classification/NEW/New_start_data/Imputed_data/")

#Set the number of bootstraps to do, and thus the number of plots to make
num = 20 #<==Change this number for more iterations
###################################################################

#read in data from csv and make r dataframe
`d2` <- read.csv("input_for_econ_and_mob.csv")
`sccs_econ` <- read.csv("sccs_econ_label.csv")
#convert first column to rownames
rownames(d2) <- d2$socname
#remove the supurflous column of names
d2$socname <- NULL


#undertake the bootstrapped monte carlo reshuffling
#randomize the data in d2, and make requested number of draws from that randomization
testout <- permatswap(d2, times = num, burnin = 20000, thin = 500, mtype = "count")


#enter into loop and do all the analyses with the reshuffled data.
for (i in 1:num ) {
#do mds and clustering on it
mdsdrand1 <- metaMDS(testout$perm[[i]], dist = "manhattan", trymax = 400, autotransform = FALSE)
#print(mdsdrand1)
mclusdrand1.out <- pam(testout$perm[[i]], metric="manhattan", k=6)
#print(mclusdrand1.out)
# put the current plot together
svg(paste("FigRand", i, ".SVG", sep = "", collapse = NULL), width= 10, height=10)
ordiplot(mdsdrand1, type = "none")
ordispider(mdsdrand1, mclusdrand1.out$clustering, label = FALSE, col="#00000050") # Consider not doing an ordispider.
points(mdsdrand1$points, pch=c(0,1,2,3,4,5,6,8,15,10,16,17)[sccs_econ$subsis_ecol], cex=1, col=c("#808000","#00808090","#FF8C00","#800080","#FF000090","#FF00FF","#00FFFF","#800000")[mclusdrand1.out$clustering])
ordispider(mdsdrand1, mclusdrand1.out$clustering, label = TRUE, cex=0.7, col="#00000000")
legend(85,210, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mdsdrand1$species, labels=rownames(mdsdrand1$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
}
