##################################################################
# This script will analyze SCCS data on subsistence, mobility,   #
# and demography for the existence of attractors                 #
# Copyright: Isaac I. Ullah, 2014                                #
# This script is released as free software under the GNU license #
##################################################################

###This version of the script calculates clusters on the NMDS scores.

#import required libraries
library(cluster)
library(vegan)
library(maptools)
library(ggplot2)
#Set working directory (EDIT THIS TO YOUR LOCAL WORKING DIRECTORY)
setwd("~/Dropbox/Research_projects/Ethnographic_classification/NEW/New_start_data/Imputed_data/")

#read in the economic labels assigned by the original ethnographers
sccs_econ <- read.csv("sccs_econ_label.csv")

##FIGURE 1
#######################
#BASIC GEOMETRIC DATA ANALYSIS WORKFLOW:
#read in data from csv and make r dataframe
`d2` <- read.csv("input_for_econ_and_mob.csv")
#convert first column to rownames
rownames(d2) <- d2$socname
#remove the supurflous column of names
d2$socname <- NULL


#non metric MDS with multiple iterations, and species scores calculated internally
mds <- metaMDS(d2, dist = "manhattan", trymax = 400, autotransform = FALSE)
#learn some stuff about the mds results
sink("MDS_Results.txt")
print("BASIC VARIABLES")
print(mds)
sink()
#do k-medoids clustering with all output data for later analysis
mclus.out <- pam(mds$points, metric="manhattan", k=4)
#learn some stuff about the clustering results
sink("MDS_Cluster_Results.txt")
print("BASIC VARIABLES")
print(mclus.out$clusinfo)
print(mclus.out)
sink()
#plotting
#Set an SVG device
svg("Fig1a.SVG", width=10, height=10)
#make an ordiplot object
ordiplot(mds, type = "none", ylim=c(-220,125), main = "Attractors in Human Subsistence Economy", cex.lab=1.5, cex.axis=1, cex.main=2, cex.sub=1.5)
#add spider tree and label to each cluster with 50% transparency
#ordispider(mds, mclus.out$clustering, label = FALSE, col="#00000020")
#add points with symbols for subsistence and semi-transparent colors for each cluster
points(mds$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=2, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus.out$clustering])
#add a label for each cluster 
#ordispider(mds, mclus.out$clustering, label = TRUE, cex=0.7, col="#00000000")
#add a legend
legend(-180,-190, pt.cex=2, pt.lwd=1.5, ncol=4, y.intersp=1.2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=1, bty="n")
#add blue "+" for each column vector
#points(mds$species, pch="+", col="blue", cex = 1)
#label the column vectors using optimally placed labels
#pointLabel(mds$species, labels=rownames(mds$species), col="blue", cex=0.7, method="GA")
#draw bounding box and write out SVG file
box()
dev.off()

#Set an SVG device
svg("Fig1b_v1.SVG", width=10, height=10)
#make an ordiplot object
ordiplot(mds, type = "none", ylim=c(-220,125), main = "Attractors in Human Subsistence Economy", cex.lab=1.5, cex.axis=1, cex.main=2, cex.sub=1.5)
#add spider tree and label to each cluster with 50% transparency
#ordispider(mds, mclus.out$clustering, label = FALSE, col="#00000020")
#add points with symbols for subsistence and semi-transparent colors for each cluster
#points(mds$points, pch=c(0,0,0,0,0,0,0,0,0)[sccs_econ$subsis_ecol], cex=.5, col=c("#808000","#008080","#FF0000","#FF8C00","#800080","#FF00FF","#00FFFF","#800000")[mclus.out$clustering])
#add a label for each cluster 
#ordispider(mds, mclus.out$clustering, label = TRUE, cex=0.7, col="#00000000")
#add a legend
#legend(-180,-190, pt.cex=2, ncol=4, y.intersp=1.2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=1, bty="n")
#add blue "+" for each column vector
points(mds$species, pch="+", col="red", cex = 2)
#label the column vectors using optimally placed labels
pointLabel(mds$species, labels=rownames(mds$species), col="blue", cex=1.2, method="GA")
#draw bounding box and write out SVG file
box()
dev.off()

###EXPLORE EFFECT OF ADDING SOCIAL VARIABLES TO THE MDS
###Bring in a new set of data with the social components added in
`d4` <- read.csv("input_for_econ_and_mob_plus_soc.csv")
#fix row names
rownames(d4) <- d4[,1]
d4[,1] <- NULL
#do mds and clustering
mdsd4 <- metaMDS(d4, dist = "manhattan", trymax = 400, autotransform = FALSE)
sink("MDS_Results.txt", append=TRUE)
print("ADDITION OF SOCIAL VARIABLES")
print(mdsd4)
sink()
mclusd4.out <- pam(mdsd4$points, metric="manhattan", k=4)
sink("MDS_Cluster_Results.txt", append=TRUE)
print("ADDITION OF SOCIAL VARIABLES")
print(mclusd4.out$clusinfo)
print(mclusd4.out)
sink()
#make the plot
svg("Fig1b.SVG", width= 10, height=10)
ordiplot(mdsd4, type = "none", xlim=c(-240,230), main = "Addition of Social Variables")
ordispider(mdsd4, mclusd4.out$clustering, label = FALSE, col="#00000050")
points(mdsd4$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=1, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclusd4.out$clustering])
ordispider(mdsd4, mclusd4.out$clustering, label = TRUE, cex=0.7, col="#00000000")
legend(85,210, pt.cex=1, pt.lwd=1.5, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=0.7)
pointLabel(mdsd4$species, labels=rownames(mdsd4$species), col="blue", cex=0.7, method="GA")
box()
dev.off()



###EXPLORE EFFECT OF ADDING ENVIRONMENTAL VARIABLES
###Bring in a new set of data with the environmental components added in
`d4a` <- read.csv("input_for_econ_and_mob_plus_env.csv")
#fix row names
rownames(d4a) <- d4a[,1]
d4a[,1] <- NULL
#do mds and clustering
mdsd4a <- metaMDS(d4a, dist = "manhattan", trymax = 400, autotransform = TRUE)
sink("MDS_Results.txt", append=TRUE)
print("ADDITION OF ENVIRONMENTAL VARIABLES")
print(mdsd4a)
sink()
mclusd4a.out <- pam(mdsd4a$points, metric="manhattan", k=5)
sink("MDS_Cluster_Results.txt", append=TRUE)
print("ADDITION OF ENVIRONMENTAL VARIABLES")
print(mclusd4a.out$clusinfo)
print(mclusd4a.out)
sink()
#make the plot
svg("Fig1c.SVG", width= 10, height=10)
ordiplot(mdsd4a, type = "none", xlim=c(-0.875,0.45), main = "Addition of Environmental Variables")
ordispider(mdsd4a, mclusd4a.out$clustering, label = FALSE, col="#00000050")
points(mdsd4a$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=1, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclusd4a.out$clustering])
ordispider(mdsd4a, mclusd4a.out$clustering, label = TRUE, cex=0.7, col="#00000000")
legend(-0.85,-0.25, pt.cex=1, pt.lwd=1.5, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=0.7)
pointLabel(mdsd4a$species, labels=rownames(mdsd4a$species), col="blue", cex=0.7, method="GA")
box()
dev.off()


#plot basic MDS but with clusters from Env data
#Set an SVG device
svg("Fig1cc.SVG", width=10, height=10)
#make an ordiplot object
ordiplot(mds, type = "none", xlim=c(-175,180), ylim=c(-150,125), main = "Attractors in Human Subsistence Economy")
#add spider tree and label to each cluster with 50% transparency
ordispider(mds, mclusd4a.out$clustering, label = FALSE, col="#00000050")
#add points with symbols for subsistence and semi-transparent colors for each cluster
points(mds$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=1, col=c("#808000","#00808090","#FF000090","#FF8C00","#800080","#FF00FF","#00FFFF","#800000")[mclusd4a.out$clustering])
#add a label for each cluster 
ordispider(mds, mclusd4a.out$clustering, label = TRUE, cex=0.7, col="#00000000")
#add a legend
legend(70,-115, pt.cex=1, inset=10, ncol=2, y.intersp=1.5 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=0.7)
#legend(85,210, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#add blue "+" for each column vector
#points(mds$species, pch="+", col="blue", cex = 1)
#label the column vectors using optimally placed labels
#pointLabel(mds$species, labels=rownames(mds$species), col="blue", cex=0.7, method="GA")
#draw bounding box and write out SVG file
box()
dev.off()


#plot env MDS but with basic clusters
#Set an SVG device
svg("Fig1cc.SVG", width=10, height=10)
ordiplot(mdsd4a, type = "none", xlim=c(-0.9,0.25), main = "Addition of Environmental Variables")
#ordispider(mdsd4a, mclus.out$clustering, label = FALSE, col="#00000020")
points(mdsd4a$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=1, col=c("#800080","#808000","#FF000090","#FF8C00","#00808090","#FF00FF","#00FFFF","#800000")[mclus.out$clustering])
#ordispider(mdsd4a, mclus.out$clustering, label = TRUE, cex=0.7, col="#00000000")
legend(-0.9,-0.4, pt.cex=1, ncol=2, inset=10, y.intersp=1.5 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=0.7)
pointLabel(mdsd4a$species, labels=rownames(mdsd4a$species), col="blue", cex=0.7, method="GA")
box()
dev.off()


##FIGURE 2
#######################
#GEOMETRIC DATA ANALYSIS WORKFLOW FOR CCA:

###CCA FOR SUBSISTENCE ECONOMY DATA
###Bring in a parsed set of the economic data to do some CCA with
`d3` <- read.csv("input_for_econ_and_mob_CCA_varb.csv")
#fix row names
rownames(d3) <- d3[,1]
d3[,1] <- NULL
econd <- read.csv("input_for_econ_and_mob_CCA_vara.csv")
#remember that we've got dataframe 'd2' with all the other data we want to analyze, so lets do the cca now with these two data
#econ data
out3.cca <- cca(d3,econd)
#print something about the cca results
sink("CCA_Results.txt")
print("SUBSISTENCE")
print(out3.cca)
sink()
#Make a plot for economic data
svg("Fig2a.SVG", width= 10, height=10)
fig <- ordiplot(out3.cca, scaling=3, type = "none", xlim=c(-2.4,1.8), main = "Constrained Along Gradients of Subsistence Economy", cex.lab=1.5, cex.axis=1, cex.main=2, cex.sub=1.5)
#add spider with no labels
#ordispider(out3.cca, scaling=3, mclus.out$clustering, label = FALSE, col="#00000050")
#add points with symbols for subsistence and semi-transparent colors for each cluster
points(fig, "sites", pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=2, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus.out$clustering])
#add a label for each cluster 
#ordispider(out3.cca, scaling=3 , mclus.out$clustering, label = TRUE, cex=0.7, col="#00000000")
#add a legend
#legend(1,-1, pt.cex=2, ncol=1, inset=10, y.intersp=1.2, c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=1.5, bty="n")
#add the biplot
text(out3.cca, display='bp', col="blue", lwd=2, cex=1.75)
box()
dev.off()



###CCA FOR ENVIRONMENTAL DATA
#Bring in some environmental data for canonical correlation
#import
sccs_env <- read.csv("sccs_env-imputed_averages.csv")
#fix row names
rownames(sccs_env) <- sccs_env[,1]
sccs_env[,1] <- NULL
##pick out some variables for the cannonical correspondence axes (several commented out options here)
# envd<-data.frame(temperature=sccs_env$temperature,precip=sccs_env$precip)
# envd<-data.frame(NPP=sccs_env$NPP_3x3max)
# envd<-data.frame(NPP=sccs_env$NPP_3x3max,temperature=sccs_env$temperature,precip=sccs_env$precip)
# envd<-data.frame(NPP=sccs_env$NPP_3x3max,altitude=sccs_env$altitude,latitude=sccs_env$latitude,num_dry_mon=sccs_env$num_dry_mon, num_wet_mon=sccs_env$num_wet_mon,region=sccs_env$region,niche_temp=sccs_env$niche_temp,niche_precip=sccs_env$niche_precip,num_niches=sccs_env$num_niches,climate_type=sccs_env$climate_type,num_habitats=sccs_env$num_habitats,ocean=sccs_env$ocean)
# envd<-data.frame(NPP=sccs_env$NPP_3x3max,temperature=sccs_env$temperature,precip=sccs_env$precip,altitude=sccs_env$altitude,latitude=sccs_env$latitude,num_dry_mon=sccs_env$num_dry_mon, num_wet_mon=sccs_env$num_wet_mon,climate_type=sccs_env$climate_type,num_habitats=sccs_env$num_habitats,ocean=sccs_env$ocean)
# envd<-data.frame(NPP=sccs_env$NPP_3x3max,num_dry_mon=sccs_env$num_dry_mon,temperature=sccs_env$temperature,precip=sccs_env$precip)
#these are the best variables, accounting for the most variation
envd<-data.frame(NPP=sccs_env$NPP_3x3max, temperature=sccs_env$temperature, precip=sccs_env$precip, coefvar_precip=sccs_env$coefvar_precip, latitude=abs(sccs_env$latitude), num_dry_mon=sccs_env$num_dry_mon, num_frost_mon=sccs_env$num_frost_mon)
#remember that we've got dataframe 'd2' with all the other data we want to analyze, so lets do the cca now with these two data
#CCA for environmental data
out.cca <- cca(d2, envd)
#learn something about the results of the cca
sink("CCA_Results.txt", append=TRUE)
print("ENVIRONMANTAL")
print(out.cca)
sink()
#Make a plot for environmental data
svg("Fig2b.SVG", width= 10, height=10)
fig <- ordiplot(out.cca, scaling=3, type = "none", main = "Constrained Along Environmental Gradients", cex.lab=1.5, cex.axis=1, cex.main=2, cex.sub=1.5)
#add spider with no labels
#ordispider(fig, mclus.out$clustering, label = FALSE, col="#00000050")
#add points with symbols for subsitence and semi-transparent colors for each cluster
points(fig, "sites", pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=2, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus.out$clustering])
##add the points colored by cluster with transparency
# points(fig, "sites", pch=20, cex = 1, col=c("#80800050","#00808050","#FF000050","#FF8C0050","#80008050","#FF00FF50","#00FFFF50","#80000050")[mclus.out$clustering])
##or just black with transparency
# points(fig, "sites", pch=20, col="#00000050", bg="black", cex = 1)
#label the clusters
#ordispider(fig, mclus.out$clustering, label = TRUE, cex=0.7, col="#00000000")
##add a legend
#legend(0,-2.5, pt.cex=2, pt.lwd=1.5, ncol=3, inset=10, y.intersp=1.2, c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=1.5, bty="n")
#add the biplot
text(out.cca, scaling=3, display='bp', col="blue", lwd=2, cex=1.5)
box()
dev.off()

###CCA FOR MOBILITY/DEMOGRAPHY DATA
#Bring in a parsed set of the mobiliy data to do some CCA with
#these are the unconstrained variables
`d3a` <- read.csv("sccs_econ-imputed_averages.csv")
#fix row names
rownames(d3a) <- d3a[,1]
d3a[,1] <- NULL
#these are the constrained variables
mobd <- read.csv("sccs_mobility-imputed_averages.csv")
#fix row names
rownames(mobd) <- mobd[,1]
mobd[,1] <- NULL
#drop out the column for settlement compactness, as that seems to not have any kind of strong gradient
mobd$settle_compact <- NULL
#lets do the cca with these two data
out3a.cca <- cca(d3a,mobd)
#print something about the cca results
sink("CCA_Results.txt", append=TRUE)
print("MOBILITY - ECONOMIC")
print(out3a.cca)
sink()
#Make a plot for mobility data
svg("Fig2c.SVG", width= 10, height=10)
fig <- ordiplot(out3a.cca, scaling=3, type = "none", xlim=c(-3,2.5), main = "Constrained Along Gradients of Mobility and Demography", cex.lab=1.5, cex.axis=1, cex.main=2, cex.sub=1.5)
#add spider with no labels
#ordispider(out3a.cca, scaling=3, mclus.out$clustering, label = FALSE, col="#00000050")
#add points with symbols for subsitence and semi-transparent colors for each cluster
points(fig, "sites", pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[sccs_econ$subsis_ecol], cex=2, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus.out$clustering])
#add a label for each cluster 
#ordispider(out3a.cca, scaling=3, mclus.out$clustering, label = TRUE, cex=0.7, col="#00000000")
#add a legend
#legend(1.5,3.45, pt.cex=2, pt.lwd=1.5, ncol=1, inset=10, y.intersp=1.2, c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=1, bty="n")
#add the biplot
text(out3a.cca, display='bp', col="blue", lwd=2, cex=1.5)
box()
dev.off()




#FIGURE 3
##PARTITIONING ON A VARIABLE, AND THEN BASIC GEOMETRIC DATA ANALYSIS
################
#SORTING BASED ON NPP, AND THEN NMMDS
#temporarily join up the NPP column from sccs_env and the subsis_ecol column from sccs_econ
d2_2 <- as.data.frame(d2)
d2_2$NPP=sccs_env$NPP_3x3max
d2_2$subsis_ecol=sccs_econ$subsis_ecol
#create some subsets with boolean operations on NPP, and then remove NPP values from results, and pull out subsis_ecol for use in plot symbology later
###Subset by dividing range of NPP into three groups:
d2.1=subset(d2_2, NPP <= 1.5)
d2.1$NPP <- NULL
d2.1_label <- data.frame(subsis_ecol<-d2.1$subsis_ecol)
d2.1$subsis_ecol<-NULL
d2.2=subset(d2_2, NPP > 1.5 & NPP <=4)
d2.2$NPP <- NULL
d2.2_label <- data.frame(subsis_ecol<-d2.2$subsis_ecol)
d2.2$subsis_ecol<-NULL
d2.3=subset(d2_2, NPP > 4)
d2.3$NPP <- NULL
d2.3_label <- data.frame(subsis_ecol<-d2.3$subsis_ecol)
d2.3$subsis_ecol<-NULL
#do non-metric MDS
mds1 <- metaMDS(d2.1, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds2 <- metaMDS(d2.2, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds3 <- metaMDS(d2.3, dist = "manhattan", trymax = 400, autotransform = FALSE)
#get clusters
mclus1.out <- pam(mds1$points, metric="manhattan", k=4)
mclus2.out <- pam(mds2$points, metric="manhattan", k=4)
mclus3.out <- pam(mds3$points, metric="manhattan", k=3)
###color/symbol plots
svg("Fig3a.SVG", width=10, height=10)
ordiplot(mds3, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("a) High NPP Attractors", adj=0, cex.main=2)
#ordispider(mds3, mclus3.out$clustering, label = FALSE, col="#00000050")
points(mds3$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d2.3_label$subsis_ecol], cex=3, lwd=1.5, col=c("#FF0000","#FF8C00","#3399FF")[mclus3.out$clustering])
#####Colored by clusters from fig 1
####points(mds3$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d2.3_label$subsis_ecol], cex=2, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus.out$clustering])
#ordispider(mds3, mclus3.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(30,-80, ncol=2, pt.cex=1, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds3$species, labels=rownames(mds3$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3b.SVG", width=10, height=10)
ordiplot(mds2, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("b) Medium NPP Attractors", adj=0, cex.main=2)
#ordispider(mds2, mclus2.out$clustering, label = FALSE, col="#00000050")
points(mds2$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d2.2_label$subsis_ecol], cex=3, lwd=1.5, col=c("#FF0000","#FF8C00","#336600","#3399FF")[mclus2.out$clustering])
#####Colored by clusters from fig 1
####points(mds2$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d2.2_label$subsis_ecol], cex=2, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus.out$clustering])
#ordispider(mds2, mclus2.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(60,180, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds2$species, labels=rownames(mds2$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3c.SVG", width=10, height=10)
ordiplot(mds1, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("c) Low NPP Attractors", adj=0, cex.main=2)
#ordispider(mds1, mclus1.out$clustering, label = FALSE, col="#00000050")
points(mds1$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d2.1_label$subsis_ecol], cex=3, lwd=1.5, col=c("#336600","#3399FF","#FF0000","#FF8C00")[mclus1.out$clustering])
#ordispider(mds1, mclus1.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-190,180, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds1$species, labels=rownames(mds1$species), col="blue", cex=0.7, method="GA")
box()
dev.off()


################
#SORTING BASED ON ABSOLUTE LATITUDE, AND THEN NMMDS
#temporarily join up the NPP column from sccs_env and the subsis_ecol column from sccs_econ
d2_3 <- as.data.frame(d2)
d2_3$abslat=abs(sccs_env$latitude)
d2_3$subsis_ecol=sccs_econ$subsis_ecol
#create some subsets with boolean operations on latitude, and then remove latitude values from results, and pull out subsis_ecol for use in plot symbology later
#Subset by dividing range of latitude into three even groups:
d23.1=subset(d2_3, abslat <= 23.5)
d23.1$abslat <- NULL
d23.1_label <- data.frame(subsis_ecol<-d23.1$subsis_ecol)
d23.1$subsis_ecol<-NULL
d23.2=subset(d2_3, abslat > 23.5 & abslat <=50)
d23.2$abslat <- NULL
d23.2_label <- data.frame(subsis_ecol<-d23.2$subsis_ecol)
d23.2$subsis_ecol<-NULL
d23.3=subset(d2_3, abslat > 50)
d23.3$abslat <- NULL
d23.3_label <- data.frame(subsis_ecol<-d23.3$subsis_ecol)
d23.3$subsis_ecol<-NULL
#do non-metric MDS
mds31 <- metaMDS(d23.1, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds32 <- metaMDS(d23.2, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds33 <- metaMDS(d23.3, dist = "manhattan", trymax = 400, autotransform = FALSE)
#get clusters
mclus31.out <- pam(mds31$points, metric="manhattan", k=4)
mclus32.out <- pam(mds32$points, metric="manhattan", k=4)
mclus33.out <- pam(mds33$points, metric="manhattan", k=3)
#color/symbol plots
svg("Fig3d.SVG", width=10, height=10)
ordiplot(mds31, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("d) Low Latitude (Tropical) Attractors", adj=0, cex.main=2)
#ordispider(mds31, mclus31.out$clustering, label = FALSE, col="#00000050")
points(mds31$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d23.1_label$subsis_ecol], cex=3, lwd=1.5, col=c("#3399FF","#FF0000","#FF8C00","#336600")[mclus31.out$clustering])
#ordispider(mds31, mclus31.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-200,-60, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds31$species, labels=rownames(mds31$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3e.SVG", width=10, height=10)
ordiplot(mds32, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("e) Mid-Latitude (Temperate) Attractors", adj=0, cex.main=2)
#ordispider(mds32, mclus32.out$clustering, label = FALSE, col="#00000050")
points(mds32$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d23.2_label$subsis_ecol], cex=3, lwd=1.5, col=c("#3399FF","#FF0000","#336600","#FF8C00")[mclus32.out$clustering])
#ordispider(mds32, mclus32.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-150,180, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds32$species, labels=rownames(mds32$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3f.SVG", width=10, height=10)
ordiplot(mds33, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("f) High Latitude (Arctic and Subarctic) Attractors", adj=0, cex.main=2)
#ordispider(mds33, mclus33.out$clustering, label = FALSE, col="#00000050")
points(mds33$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d23.3_label$subsis_ecol], cex=3, lwd=1.5, col=c("#FF0000","#336600","#3399FF")[mclus33.out$clustering])
#ordispider(mds33, mclus33.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-30,-90, ncol=2, pt.cex=1, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds33$species, labels=rownames(mds33$species), col="blue", cex=0.7, method="GA")
box()
dev.off()



#SORTING BASED ON FIXITY OF RESIDENCE, AND THEN NMMDS
#temporarily join up the NPP column from sccs_env and the subsis_ecol column from sccs_econ
d2_4 <- as.data.frame(d2)
d2_4$subsis_ecol=sccs_econ$subsis_ecol
#create some subsets with boolean operations on latitude, and then remove latitude values from results, and pull out subsis_ecol for use in plot symbology later
#Subset by dividing range of latitude into three even groups:
d24.1=subset(d2_4, settlement_fixity <= 2)
d24.1$settlement_fixity <- NULL
d24.1_label <- data.frame(subsis_ecol<-d24.1$subsis_ecol)
d24.1$subsis_ecol<-NULL
d24.2=subset(d2_4, settlement_fixity > 2 & settlement_fixity <= 4)
d24.2$settlement_fixity <- NULL
d24.2_label <- data.frame(subsis_ecol<-d24.2$subsis_ecol)
d24.2$subsis_ecol<-NULL
d24.3=subset(d2_4, settlement_fixity > 4)
d24.3$settlement_fixity <- NULL
d24.3_label <- data.frame(subsis_ecol<-d24.3$subsis_ecol)
d24.3$subsis_ecol<-NULL
#do non-metric MDS
mds41 <- metaMDS(d24.1, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds42 <- metaMDS(d24.2, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds43 <- metaMDS(d24.3, dist = "manhattan", trymax = 400, autotransform = FALSE)
#get clusters
mclus41.out <- pam(mds41$points, metric="manhattan", k=3)
mclus42.out <- pam(mds42$points, metric="manhattan", k=4)
mclus43.out <- pam(mds43$points, metric="manhattan", k=2)
#color/symbol plots
svg("Fig3g.SVG", width=10, height=10)
ordiplot(mds43, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("g) Low Residential Mobility Attractors", adj=0, cex.main=2)
#ordispider(mds43, mclus43.out$clustering, label = FALSE, col="#00000050")
points(mds43$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d24.3_label$subsis_ecol], cex=3, lwd=1.5, col=c("#FF0000","#FF8C00")[mclus43.out$clustering])
#ordispider(mds43, mclus43.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-30,-90, ncol=2, pt.cex=1, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds43$species, labels=rownames(mds43$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3h.SVG", width=10, height=10)
ordiplot(mds42, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("h) Medium Residential Mobility Attractors", adj=0, cex.main=2)
#ordispider(mds42, mclus42.out$clustering, label = FALSE, col="#00000050")
points(mds42$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d24.2_label$subsis_ecol], cex=3, lwd=1.5, col=c("#FF0000","#336600","#FF8C00","#3399FF")[mclus42.out$clustering])
#ordispider(mds42, mclus42.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-150,180, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds42$species, labels=rownames(mds42$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3i.SVG", width=10, height=10)
ordiplot(mds41, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("i) High Residential Mobility Attractors", adj=0, cex.main=2)
#ordispider(mds41, mclus41.out$clustering, label = FALSE, col="#00000050")
points(mds41$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d24.1_label$subsis_ecol], cex=3, lwd=1.5, col=c("#FF8C00","#336600","#3399FF")[mclus41.out$clustering])
#ordispider(mds41, mclus41.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-200,-50, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds41$species, labels=rownames(mds41$species), col="blue", cex=0.7, method="GA")
box()
dev.off()



#SORTING BASED ON POPULATION SIZE, AND THEN NMMDS
#temporarily join up the NPP column from sccs_env and the subsis_ecol column from sccs_econ
d2_5 <- as.data.frame(d2)
d2_5$subsis_ecol=sccs_econ$subsis_ecol
#create some subsets with boolean operations on latitude, and then remove latitude values from results, and pull out subsis_ecol for use in plot symbology later
#Subset by dividing range of latitude into three even groups:
d25.1=subset(d2_5, total_pop <= 2)
d25.1$population <- NULL
d25.1_label <- data.frame(subsis_ecol<-d25.1$subsis_ecol)
d25.1$subsis_ecol<-NULL
d25.2=subset(d2_5, total_pop == 3)
d25.2$population <- NULL
d25.2_label <- data.frame(subsis_ecol<-d25.2$subsis_ecol)
d25.2$subsis_ecol<-NULL
d25.3=subset(d2_5, total_pop >= 4)
d25.3$population <- NULL
d25.3_label <- data.frame(subsis_ecol<-d25.3$subsis_ecol)
d25.3$subsis_ecol<-NULL
#do non-metric MDS
mds51 <- metaMDS(d25.1, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds52 <- metaMDS(d25.2, dist = "manhattan", trymax = 400, autotransform = FALSE)
mds53 <- metaMDS(d25.3, dist = "manhattan", trymax = 400, autotransform = FALSE)
#get clusters
mclus51.out <- pam(mds51$points, metric="manhattan", k=3)
mclus52.out <- pam(mds52$points, metric="manhattan", k=4)
mclus53.out <- pam(mds53$points, metric="manhattan", k=3)
#color/symbol plots
svg("Fig3j.SVG", width=10, height=10)
ordiplot(mds53, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("j) High Population (> 10000ppl) Attractors", adj=0, cex.main=2)
#ordispider(mds53, mclus53.out$clustering, label = FALSE, col="#00000050")
points(mds53$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d25.3_label$subsis_ecol], cex=3, lwd=1.5, col=c("#336600","#FF8C00","#FF0000","#3399FF")[mclus53.out$clustering])
#ordispider(mds53, mclus53.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-30,-90, ncol=2, pt.cex=1, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds53$species, labels=rownames(mds53$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3k.SVG", width=10, height=10)
ordiplot(mds52, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("k) Medium Population (1000-10000ppl) Attractors", adj=0, cex.main=2)
#ordispider(mds52, mclus52.out$clustering, label = FALSE, col="#00000050")
points(mds52$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d25.2_label$subsis_ecol], cex=3, lwd=1.5, col=c("#660099","#FF0000","#FF8C00","#3399FF")[mclus52.out$clustering])
#ordispider(mds52, mclus52.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(-150,180, pt.cex=1, ncol=2, inset=10, y.intersp=2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
#pointLabel(mds52$species, labels=rownames(mds52$species), col="blue", cex=0.7, method="GA")
box()
dev.off()
svg("Fig3l.SVG", width=10, height=10)
ordiplot(mds51, type = "none", main = NULL, cex.axis=2, cex.lab=2)
title("l) Low Population (< 1000ppl) Attractors", adj=0, cex.main=2)
#ordispider(mds51, mclus51.out$clustering, label = FALSE, col="#00000050")
points(mds51$points, pch=c(0,1,2,2,3,4,5,5,5,8,8,8)[d25.1_label$subsis_ecol], cex=3, lwd=1.5, col=c("#660099","#FF8C00","#3399FF")[mclus51.out$clustering])
#ordispider(mds51, mclus51.out$clustering, label = TRUE, cex=1, col="#00000000")
#legend(0,-83, pt.cex=3, ncol=2, inset=10, y.intersp=1.5 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=1.5)
#legend(15,-150, pt.cex=3, pt.lwd=1.5, ncol=2, y.intersp=1.2 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation \nor Horticulture", "Intensive Agriculture"), pch=c(0,1,2,3,4,5,8), cex=1.5, bty="n")
#pointLabel(mds51$species, labels=rownames(mds51$species), col="blue", cex=0.7, method="GA")
box()
dev.off()


#END OF SCRIPT
#################################
