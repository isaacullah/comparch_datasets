#! /usr/bin/python
# -*- coding: utf-8 -*-
"""
Created on Tue Jun  7 11:36:39 2016

@author: iullah
"""

import numpy as np
from scipy import stats
import seaborn as sns
import matplotlib.pyplot as plt
import os

dirs =("good_AG_V1_stats", "good_AG_V2_stats", "good_AP_V1_stats", "good_AP_V2_stats", "good_PA_V1_stats", "good_PA_V2_stats", "greed_AG_V1_stats", "greed_AG_V2_stats", "greed_AP_V1_stats", "greed_AP_V2_stats", "greed_PA_V1_stats", "greed_PA_V2_stats")
h = os.path.expanduser('~')
colors = sns.cubehelix_palette(8, start=.5, rot=-.75)
sns.set_style("ticks")
sns.set_context("poster", font_scale = 1.5)
statlist = []
for d in dirs:
    os.chdir("%s/Dropbox/Dissertation/Experiment_records/Raw_Stats/%s/LC_stats/" % (h,d))
    input = ["R1.txt", "R2.txt",  "R3.txt", "R4.txt", "R5.txt", "R6.txt"]
    outlist = []
    for vegfile in input:
        if os.path.isfile(vegfile):
            try:
                vegmatrix = np.genfromtxt(vegfile, delimiter=',', skip_header = 3, usecols=range(1,52))
            except:
                vegmatrix = np.genfromtxt(vegfile, delimiter='\t', skip_header = 3, usecols=range(1,52))
            cv = stats.variation(vegmatrix)
            np.savetxt(vegfile.split('.')[0] + "_coefvar.txt", cv)
            outlist.append(cv.T)
            # Set up the matplotlib figure
            f = plt.figure(figsize=(12, 9))
            sns.heatmap
            sns.heatmap(vegmatrix, robust=False, cmap="bone_r", vmin=0, vmax=10000000, square=False, yticklabels=100, xticklabels=5).invert_yaxis()
            plt.ylabel("Years")
            plt.xlabel("Vegetation Succession Stage")        
            f.tight_layout()
            plt.savefig(vegfile.split('.')[0] + "_heatmap.png", dpi = 300)
            plt.close()
        else: 
            pass
    stat = np.vstack(outlist)
    np.savetxt("%s_coefvar_stats.txt" % d, stat)
    statlist.append(stat)

#make master coef-var plot
GAG = np.vstack((statlist[0], statlist[1]))
GAP = np.vstack((statlist[2], statlist[3]))
GPA = np.vstack((statlist[4], statlist[5]))
GRAG = np.vstack((statlist[6], statlist[7]))
GRAP = np.vstack((statlist[8], statlist[9]))
GRPA = np.vstack((statlist[10], statlist[11]))

os.chdir("%s/Dropbox/Dissertation/Experiment_records/FollowUp/Veg/" % h)
ci = [99] #confidence intervals for the plot
lim = (0,3) # y limits for the plots
transp = 0.25 #transparancey level for lines
fig, (ax1, ax2) = plt.subplots(2, figsize=(18,18), sharex = True)
#Good
sns.tsplot(GPA, ax = ax1, ci = ci, color = colors[1], condition = "Pastoralists", legend = False)
sns.tsplot(GAP, ax = ax1, ci = ci, color = colors[3], condition = "Agropastoralists", legend = False)
sns.tsplot(GAG, ax = ax1, ci = ci, color = colors[5], condition = "Agriculturalits", legend = False)
ax1.set_ylim(lim)
ax1.locator_params(axis = 'y', nbins = 5)
ax1.set_xlabel('')
ax1.set_ylabel('')
ax1.grid(b="off")
#Greedy
sns.tsplot(GRPA, ax = ax2, ci = ci, color = colors[1], condition = "Pastoralists", legend = True)
sns.tsplot(GRAP, ax = ax2, ci = ci, color = colors[3], condition = "Agropastoralists", legend = True)
sns.tsplot(GRAG, ax = ax2, ci = ci, color = colors[5], condition = "Agriculturalists", legend = True)
ax2.set_ylim(lim)
ax2.locator_params(axis = 'y', nbins = 5)
ax2.set_ylabel('')
ax2.grid(b="off")
ax1.text(1,3,'Good', fontsize = 42, ha="left", va='top')
ax2.text(1,3,'Greedy', fontsize = 42, ha="left", va='top')
plt.xlim(0,50)
plt.tight_layout()
lgd = ax2.legend(bbox_to_anchor=(0., -0.27, 1., .102), loc=3, ncol=3, mode="expand", borderaxespad=0., markerscale = 3)
fig.subplots_adjust(bottom=0.12, left=0.1)
fig.text(0.025,0.5,'Temporal Coefficient of Variation', fontsize = 42, va='center', ha='center', rotation='vertical')
ax2.set_xlabel('Vegetation Succession Stage', fontsize = 42, labelpad = 15)
sns.despine()
plt.savefig("ZIQLAB_GoodVGreed_VEG_COEFVAR.png", dpi = 300)
plt.close()

