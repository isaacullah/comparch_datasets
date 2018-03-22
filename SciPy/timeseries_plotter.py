#!/usr/bin/python
from numpy import *
import seaborn as sns
import matplotlib.pyplot as plt

agdata1 = genfromtxt("GAGV1.csv",delimiter = ",", usecols = (1, 2, 3), skip_header = 1)
agdata2 = genfromtxt("GAGV2.csv",delimiter = ",", usecols = (1, 2), skip_header = 1)
agdata3 = genfromtxt("GRAGV1.csv",delimiter = ",", usecols = (1, 2), skip_header = 1)
agdata4 = genfromtxt("GRAGV2.csv",delimiter = ",", usecols = (1, 2), skip_header = 1)


apdata1 = genfromtxt("GAPV1.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)
apdata2 = genfromtxt("GAPV2.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)
apdata3 = genfromtxt("GRAPV1.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)
apdata4 = genfromtxt("GRAPV2.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)
   
padata1 = genfromtxt("GPAV1.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)
padata2 = genfromtxt("GPAV2.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)
padata3 = genfromtxt("GRPAV1.csv",delimiter = ",", usecols = (1, 2, 3, 4), skip_header = 1)
padata4 = genfromtxt("GRPAV2.csv",delimiter = ",", usecols = (1, 2, 3, 4, 5), skip_header = 1)

#c1, c2, c3, c4 = sns.color_palette("cubehelix", 4)
colors = sns.cubehelix_palette(8, start=.5, rot=-.75)
#colors[1], colors[3], colors[5], colors[7]
sns.set_style("ticks")
sns.set_context("poster", font_scale = 1.5)
ci = [95] #confidence intervals for the plot
lim = (0, 1000)
lim2 = (0,500)
fig, (ax1, ax2, ax3) = plt.subplots(3, figsize=(18,24), sharex = True)
#Agriculturalists
sns.tsplot(agdata1.T, ax = ax1, ci = ci, color = colors[1], condition = "Good Hardworking", legend = False)
sns.tsplot(agdata2.T, ax = ax1, ci = ci, color = colors[3], condition = "Good Lazy", legend = False)
sns.tsplot(agdata3.T, ax = ax1, ci = ci, color = colors[5], condition = "Greedy Hardworking", legend = False)
sns.tsplot(agdata4.T, ax = ax1, ci = ci, color = colors[7], condition = "Greedy Lazy", legend = False)
ax1.text(10,900,'agriculturalists', fontsize = 42)
ax1.set_ylim(lim)
#Agropastoralists
sns.tsplot(apdata1.T, ax = ax2, ci = ci, color = colors[1], condition = "Good Hardworking", legend = False)
sns.tsplot(apdata2.T, ax = ax2, ci = ci, color = colors[3], condition = "Good Lazy", legend = False)
sns.tsplot(apdata3.T, ax = ax2, ci = ci, color = colors[5], condition = "Greedy Hardworking", legend = False)
sns.tsplot(apdata4.T, ax = ax2, ci = ci, color = colors[7], condition = "Greedy Lazy", legend = False)
ax2.text(10,450,'agropastoralists', fontsize = 42)
ax2.set_ylim(lim2)
#Pastoralists
sns.tsplot(padata1.T, ax = ax3, ci = ci, color = colors[1], condition = "Good Hardworking", legend = True)
sns.tsplot(padata2.T, ax = ax3, ci = ci, color = colors[3], condition = "Good Lazy", legend = True)
sns.tsplot(padata3.T, ax = ax3, ci = ci, color = colors[5], condition = "Greedy Hardworking", legend = True)
sns.tsplot(padata4.T, ax = ax3, ci = ci, color = colors[7], condition = "Greedy Lazy", legend = True)
ax3.text(10,450,'pastoralists', fontsize = 42)
ax3.set_ylim(lim2)

lgd = ax3.legend(bbox_to_anchor=(0., -0.3, 1., .102), loc=3, ncol=4, mode="expand", borderaxespad=0., markerscale = 3)
plt.tight_layout()
fig.subplots_adjust(bottom=0.1, left=0.1)
ax2.set_ylabel('Population', fontsize = 42, labelpad = 15)
ax3.set_xlabel('Year', fontsize = 42, labelpad = 15)
plt.savefig("ZIQLAB_ALL_MODELS_POP.png", dpi = 300)
#plt.show()
plt.close()

