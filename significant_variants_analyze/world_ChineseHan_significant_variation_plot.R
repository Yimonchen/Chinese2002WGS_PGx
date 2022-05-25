# ----------------------------------------------------------------------#
# This R programme is for variant heatmap with different populations, need two parameters
options <- commandArgs(trailingOnly = T)
infile = options[1];
outfile = options[2];

rm(list=ls())
library(ggplot2)
library(pheatmap)
library(RColorBrewer)

#infile<-"bgier-1kg_AF.txt"
data<-read.table(infile,sep="\t",header=T,check.names=F)
sdata<-data[,2:11]
rownames(sdata)<-data$rsID

bk <- unique(c(seq(0,40, length=4000)))
cols<- rev(brewer.pal(n = 11, name = "RdYlBu"))
color=c(colorRampPalette(cols[3:9])(4000))

pheatmap(t(sdata),color=color,breaks=bk, cluster_rows=F,border_color=NA,cellheight=20,cellwidth=40,cluster_cols=F,display_numbers = TRUE,angle_col=270,number_format = "%.2f",number_color = "black",fontsize_number = 9,filename=outfile)

