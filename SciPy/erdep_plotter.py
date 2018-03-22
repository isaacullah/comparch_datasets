# -*- coding: utf-8 -*-
#!/usr/bin/python
"""
Created on Mon Feb 29 14:59:28 2016

@author: Isaac Ullah
"""

import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import os


######## Edit these plot style variables as needed ########
clr = "grey" # color for unit traces
clr2 = "black" # color of mean lines
clr3 = "black" # color of the control model lines
sns.set_style("ticks") # set plot style with seaborn
sns.set_context("poster", font_scale = 1.5) # set plot context with seaborn
ci = [99.9] # confidence intervals for the varation envelopes around the plot lines (showing the variation between runs)
transp = .3 # set transparencey value
wdth = 3 # width of mean lines
sty = "-" # style of mean lines
sty2 = "--" # style of the control model lines
es = ["unit_traces"] # set error style
ylims = (-0.04,0.065) # set y limits
###########################################################

colors=sns.light_palette("grey",4) # set plot color table

os.chdir("./AggregatedStatsFiles/") # set working directory to grab the stats

# import the erosion stas
P200Md_erosion = np.genfromtxt("P200Md_mean_erosion.csv", skip_header=1, delimiter=',',usecols=range(1,37)).T # dynamic population, tenured plots.
P200Rs_erosion = np.genfromtxt("P200Rs_mean_erosion.csv", skip_header=1, delimiter=',',usecols=range(1,30)).T # static population, randomized plots.
P200S_erosion = np.genfromtxt("P200s_M_all_erosion.csv", delimiter=',') # static land-use configurations.
CTL_erosion = np.genfromtxt("Control_model_erdep.csv", skip_header=3, delimiter=',', usecols=2) # control model.
# import the deposition stats
P200Md_deposition = np.genfromtxt("P200Md_mean_deposition.csv", skip_header=1, delimiter=',',usecols=range(1,37)).T # dynamic population, tenured plots.
P200Rs_deposition = np.genfromtxt("P200Rs_mean_deposition.csv", skip_header=1, delimiter=',',usecols=range(1,30)).T # static population, randomized plots.
P200S_deposition = np.genfromtxt("P200s_M_all_deposition.csv", delimiter=',') # static land-use configurations.
CTL_deposition = np.genfromtxt("Control_model_erdep.csv", skip_header=3, delimiter=',', usecols=3) # control model.

os.chdir("..") # set working directory to write the plots

# Start plot
fig, (ax3, ax2, ax1) = plt.subplots(3, sharex=False, sharey=False, figsize=(24,24))
# Two-way feedbacks: dynamic population, tenured plots. Subplot (c)
sns.tsplot(np.cumsum(P200Md_deposition, axis=1), ax = ax1, lw=wdth, ls=sty, err_style = es, alpha=transp,  color = clr, condition = "Human land-use, indvidual runs", legend = True)
sns.tsplot(np.cumsum(P200Md_erosion, axis=1), ax = ax1, lw=wdth, ls=sty, err_style = es, alpha=transp, color = clr, condition = "Simulation indvidual runs", legend = False)
sns.tsplot(np.cumsum(P200Md_deposition, axis=1), ax = ax1, lw=wdth, ls=sty, err_style = None, color = clr2, condition = "Human land-use, inter-run averages", legend = True)
sns.tsplot(np.cumsum(P200Md_erosion, axis=1), ax = ax1, lw=wdth, ls=sty, err_style = None, color = clr2, condition = "Simulation averages", legend = False)
sns.tsplot(np.cumsum(CTL_deposition), ax = ax1, color = clr3, ls=sty2, err_style = None, condition = "Natural vegetation only", legend = True)
sns.tsplot(np.cumsum(CTL_erosion), ax = ax1, color = clr3, ls=sty2, err_style = None, condition = "Control Model", legend = False)
# One-way feedbacks: static population, randomized plots. Subplot (b)
sns.tsplot(np.cumsum(P200Rs_deposition, axis=1), ax = ax2, lw=wdth, ls=sty, err_style = es, alpha=transp, color = clr, condition = "Maximizing, Static Population", legend = False)
sns.tsplot(np.cumsum(P200Rs_erosion, axis=1), ax = ax2, lw=wdth, ls=sty, err_style = es, alpha=transp, color = clr, condition = "Maximizing, Static Population", legend = False)
sns.tsplot(np.cumsum(P200Rs_deposition, axis=1), ax = ax2, lw=wdth, ls=sty, err_style = None, color = clr2, condition = "Maximizing, Static Population", legend = False)
sns.tsplot(np.cumsum(P200Rs_erosion, axis=1), ax = ax2, lw=wdth, ls=sty, err_style = None, color = clr2, condition = "Maximizing, Static Population", legend = False)
sns.tsplot(np.cumsum(CTL_deposition), ax = ax2, color = clr3, ls=sty2, err_style = None, condition = "Control Model", legend = False)
sns.tsplot(np.cumsum(CTL_erosion), ax = ax2, color = clr3, ls=sty2, err_style = None, condition = "Control Model", legend = False)
# No feedback: static land-use configurations. Subplot (a)
sns.tsplot(np.cumsum(P200S_deposition, axis=1), ax = ax3, lw=wdth, ls=sty, err_style = es, alpha=transp, color = clr, condition = "Simulation result", legend = False)
sns.tsplot(np.cumsum(P200S_erosion, axis=1), ax = ax3, lw=wdth, ls=sty, err_style = es, alpha=transp, color = clr,  condition = "Static, Based on Maxzimized", legend = False)
#sns.tsplot(np.cumsum(P200S_deposition, axis=1), ax = ax3, lw=wdth, ls=sty, err_style = None, color = clr2, condition = "Simulation result", legend = False)
#sns.tsplot(np.cumsum(P200S_erosion, axis=1), ax = ax3, lw=wdth, ls=sty, err_style = None, color = clr2,  condition = "Static, Based on Maxzimized", legend = False)
sns.tsplot(np.cumsum(CTL_deposition), ax = ax3, color = clr3, ls=sty2, condition = "Control model result", legend = False)
sns.tsplot(np.cumsum(CTL_erosion), ax = ax3, color = clr3, ls=sty2 , condition = "Control Model", legend = False)
# set axes styles
ax1.set_ylim(ylims)
ax1.set_xlim(0,200)
ax2.set_ylim(ylims)
ax2.set_xlim(0,200)
ax2.set_xticklabels([])
ax3.set_ylim(ylims)
ax3.set_xlim(0,200)
ax3.set_xticklabels([])
ax1.locator_params(axis = 'y', nbins = 6)
ax2.locator_params(axis = 'y', nbins = 6)
ax3.locator_params(axis = 'y', nbins = 6)
ax1.locator_params(axis = 'x', nbins = 12)
ax2.locator_params(axis = 'x', nbins = 12)
ax3.locator_params(axis = 'x', nbins = 12)
# add zero lines
ax1.axhline(y=0.0,xmin=0,xmax=200,c="black",linewidth=1,zorder=0,linestyle=':')
ax2.axhline(y=0.0,xmin=0,xmax=200,c="black",linewidth=1,zorder=0,linestyle=':')
ax3.axhline(y=0.0,xmin=0,xmax=200,c="black",linewidth=1,zorder=0,linestyle=':')
# write some figure labels
ax1.text(2,.055,"c)", fontsize=36)
ax2.text(2,.055,"b)", fontsize=36)
ax3.text(2,.055,"a)", fontsize=36)
ax1.text(0.5,0.005,'Deposition' + u'\u2192', fontsize = 24, ha="left", va='bottom', rotation='vertical')
ax1.text(0.5,-0.005,'Erosion' + u'\u2192', fontsize = 24, ha="left", va='top', rotation='270')
ax2.text(0.5,0.005,'Deposition' + u'\u2192', fontsize = 24, ha="left", va='bottom', rotation='vertical')
ax2.text(0.5,-0.005,'Erosion' + u'\u2192', fontsize = 24, ha="left", va='top', rotation='270')
ax3.text(0.5,0.005,'Deposition' + u'\u2192', fontsize = 24, ha="left", va='bottom', rotation='vertical')
ax3.text(0.5,-0.005,'Erosion' + u'\u2192', fontsize = 24, ha="left", va='top', rotation='270')
fig.text(0.02,0.5,'Cumulative elevation change (m)', fontsize = 42, va='center', ha='center', rotation='vertical')
ax1.set_xlabel('Simulation Year', fontsize = 42, labelpad = 15)
#adjust spacings
plt.tight_layout()
fig.subplots_adjust(left=0.08, bottom=0.09)
sns.despine()
# write legend
lgd = ax1.legend(bbox_to_anchor=(0., -0.3, 1., .102), loc=3, ncol=3, borderaxespad=0., markerscale = 3)
# save and close
plt.savefig("FIG_B.png", dpi = 300)
plt.close()
# Arrivederci
