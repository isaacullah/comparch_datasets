library(maptools)
library(vegan)
##############################
#Basic plotting for imported data with some clustering and mds info already in it
##############################

#Basic black and white plot with jitter applied to aviod overplotting points
plot(jitter(d1$MDS1, amount=0.5), jitter(d1$MDS2, amount=0.5), asp=0.4, pch=3, cex=0.7)

#Same as above, but with colors applied to clusters
plot(jitter(d1$MDS1, amount=0.5), jitter(d1$MDS2, amount=0.5), asp=0.4, pch=3, cex=0.7, col=c("red","blue","green","orange","purple")[d1$Cluster])

#Basic labels for each society in the above graph, avoiding overlap
pointLabel(d1$MDS1, d1$MDS2, labels = d1$row_ID, cex=0.4)

############################
# Plotting for mds and pam done in R
###########################

#Basic plot
plot(jitter(mds$points, amount=0.5), asp=0.4, pch=3, cex=0.7, col=c("red","blue","green","orange","purple")[mclus.out$clustering])

#or a two step process for a different view
plot(mds$points, type = "n", xlim=c(-150,225), ylim=c(-180,130), main = "Attractors in Human Subsistence Economy", asp=1)

#do it with numbers for subsistence type
text(jitter(mds$points, amount=10), adj=0,labels=sccs_econ_label$subsis_ecol, cex=1, col=c("red","blue","green","orange","purple","magenta","cyan","brown")[mclus])
#do it with no jitter
text(mds$points, adj=0,labels=sccs_econ_label$subsis_ecol, cex=1, col=c("red","blue","green","orange","purple","magenta","cyan","brown")[mclus])

# do it with points with symbols for subsitence
points(mds$points, pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19)[sccs_econ_label$subsis_ecol], cex=1, col=c("red","blue","green","orange","purple","magenta","cyan","brown")[mclus])
#add a legend
legend(150,135, pt.cex=1, text.width=60, inset=10, y.intersp=0.8 , c("Gathering", "Hunting and/or \nMarine Animals", "Fishing", "Anadromous Fishing", "Mounted Hunting", "Pastoralism", "Shifting Cultivation, \nWooden Implements", "Shifting Cultivation, \nMetal Implements", "Horticultural Gardens \nor Tree Fruits", "Intensive Agriculture, \nNo Plow", "Intensive Agriculture, \nPlow"), pch=c(0,1,2,3,4,5,6,8,15,16,17,18,19), cex=0.7)
box()

#add spider tree and label to each cluster
ordispider(mds,  mclus.out$clustering, display="sites", col="#00000050", label=TRUE, cex=0.5)


#same as previous but colored points and black text
plot(jitter(mds$points, amount=10), type = "p", pch=20, main = "Attractors in Human Subsistence Economy", asp=1, col=c("red","blue","green","orange","purple","magenta","cyan","brown")[mclus])
text(jitter(mds$points, amount=0), labels=sccs_econ$subsis_ecol, cex=1, pos=2)

#Black and white with alpha
fig <- ordiplot(mds, type = "none", main = "Attractors in Human Subsistence Economy")
points(fig, "sites", pch=20, col="#00000050", bg="black", cex = 1)
ordispider(mds$points, label = TRUE, mclus, col="#00000050", cex=0.5)
points(fig, "species", pch="+", col="blue", cex = 1)

#label the variables ("species")
mds.species <- as.data.frame(as.table(mds$species))  #first make the matrix into a dataframe
text(mds$species, label=mds.species$Var1, cex=0.7)

#or, avoiding overlap
pointLabel(mds$species, labels = mds.species$Var1, cex=0.8, col="blue")
