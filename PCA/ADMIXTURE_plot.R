library(ggplot2)
library(scales)

setwd("~/Desktop/员工药物科研PCA/Chinese")

bardata <- read.csv("tmp.csv", header = T)

mydata <- bardata[order(bardata$Component), ]

#write.csv(bardata, file = "tmp.csv")
mydata$Province <- factor(mydata$Province, levels = unique(mydata$Province))
mydata$Component <- factor(mydata$Component, levels = unique(mydata$Component))

p1 <- ggplot(data=mydata, aes(x=Province, y=Proportion, fill=Component))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = c("chartreuse4","coral1","cornflowerblue"))+
  coord_cartesian(ylim=c(0,1))+
  labs(x="Provinces", y="ADMIXTURE Proportions")+
  guides(fill = guide_legend(title = "Hypothetical Ancestral Components", title.position = "right", keyheight = 4))+
  theme(
    panel.background = element_blank(),
    axis.line = element_line(colour = "grey50"),
    axis.text.x = element_text(angle = 60, vjust=0.6),
    legend.title = element_text(angle = 90, face = "bold"),
    axis.title = element_text(face = "bold")
  )
p1



piedata <- read.csv("ADMIXTUR_k_3_pie.csv", header = T)
piedata$Component <- factor(piedata$Component, levels = unique(piedata$Component))
#piedata$Proportion <- factor(piedata$Proportion, levels = unique(piedata$Proportion))



north <- piedata[piedata$Region=="North", ]

p2 <- ggplot(data=north, aes(x="", y=Proportion, fill=Component))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = c("chartreuse4","coral1","cornflowerblue"))+
  coord_polar("y", start = 0)+
  geom_text(aes(label = percent(Proportion)), size=3, position = position_stack(vjust = 0.5))+
  labs(title = "North")+
  theme_void()+
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 12)
    )
p2



central <- piedata[piedata$Region=="Central", ]

p3 <- ggplot(data=central, aes(x="", y=Proportion, fill=Component))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = c("chartreuse4","coral1","cornflowerblue"))+
  coord_polar("y", start = 0)+
  geom_text(aes(label = percent(Proportion)), size=3, position = position_stack(vjust = 0.5))+
  labs(title = "Central")+
  theme_void()+
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 12)
  )
p3



south <- piedata[piedata$Region=="South", ]

p4 <- ggplot(data=south, aes(x="", y=Proportion, fill=Component))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = c("chartreuse4","coral1","cornflowerblue"))+
  coord_polar("y", start = 0)+
  geom_text(aes(label = percent(Proportion)), size=3, position = position_stack(vjust = 0.5))+
  labs(title = "South")+
  theme_void()+
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 12)
  )
p4



lingnan <- piedata[piedata$Region=="Lingnan", ]

p5 <- ggplot(data=lingnan, aes(x="", y=Proportion, fill=Component))+
  geom_bar(stat="identity")+
  scale_fill_manual(values = c("chartreuse4","coral1","cornflowerblue"))+
  coord_polar("y", start = 0)+
  geom_text(aes(label = percent(Proportion)), size=3, position = position_stack(vjust = 0.5))+
  labs(title = "Lingnan")+
  theme_void()+
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 12)
  )
p5


library(ggpubr)

final1 <- ggarrange(p2,p3,p4,p5, ncol=4, nrow=1)
final1

final <- ggarrange(final1, p1, ncol=1, nrow=2, heights=c(1,3))
final
