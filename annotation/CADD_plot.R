# ----------------------------------------------------------------------#
# This R programme is for plot CADD sorce, need two parameters
options <- commandArgs(trailingOnly = T)
infile = options[1];
outfile = options[2];

library(ggplot2)

#infile<-"drug_gene.exonUpDownstream.cadd_score.median_order.xls"
data<-read.table(infile,sep="\t",header=T)
#data<-data[1:15,]
data$Score<-as.numeric(data$Score)

#outfile="drug_gene_CADD.pdf"
pdf(outfile, width=8, height=40);
theme_set(theme_bw());

gord<-rev(unique(data$Gene))
p<-ggplot(data, aes(x=factor(Gene,levels=gord),y=Score));
p<-p+stat_boxplot(geom = "errorbar", width=0.4,aes(x=factor(Gene,levels=gord),y=Score,group=Gene))
p<-p+geom_boxplot(width=0.4,fill="cornflowerblue");
p<-p+coord_flip()
p<-p+theme(axis.text.x=element_text(size=8))
p<-p + ylab("Phred-normalized CADD Score")+xlab("")
print(p);
dev.off();

