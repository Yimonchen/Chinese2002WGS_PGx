library(maptools)
library(rgdal)
library(ggplot2)
library(sp)
library(colorspace)

setwd("~/Desktop/R中国地图模板/NB_latest/")
#fork 九段线
l9 <- rgdal::readOGR("../SouthSea/九段线.shp")
#data reading
china_map <- rgdal::readOGR("../china/bou2_4p.shp", encoding =  "latin1")

x <- china_map@data #读取行政信息

xs <- data.frame(x,id=seq(0:924)-1) #含岛屿共925个形状

china_map1 <- fortify(china_map) #转化为数据框

library(plyr)

china_map_data <- join(china_map1, xs, type = "full") #合并两个数据框


###### diff site 1 #####

mydata <- read.csv("NBdiffSite1.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Region,breaks=c(0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6),labels=c('0.1~0.15','0.15~0.2','0.2~0.25','0.25~0.3','0.3~0.35','0.35~0.4','0.4~0.45','0.45~0.5','0.5~0.55','0.55~0.6'),right=FALSE,order=TRUE)

df <- data.frame(x=c(80),y=c(26.25),text=c("ALDH2"))

p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey30", size=0.2) +
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='rs671 MAF'))+
  labs(tag = "A.") +
  coord_map("polyconic") +
  geom_text(data = df, mapping = aes(x, y, label=text, fontface="bold.italic")) + #添加基因标签
  #geom_text(size=2,aes(x = jd,y = wd,label = province), data =province_city)+ #添加省会标签
  theme(                            #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1  

#绘制小图
p2 <- ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group,fill=ratio),color="black",size=0.2)+ #绘制分省图
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #9段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
pdf("NBdiffSite1.PDF", width = 6.8, height = 6.8)
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图
dev.off()


###### diff site 2 #####

mydata <- read.csv("NBdiffSite2.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Region,breaks=c(0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6),labels=c('0.1~0.15','0.15~0.2','0.2~0.25','0.25~0.3','0.3~0.35','0.35~0.4','0.4~0.45','0.45~0.5','0.5~0.55','0.55~0.6'),right=FALSE,order=TRUE)

df <- data.frame(x=c(79),y=c(25),text=c("CYP2D6"))

p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey30", size=0.2) +
  #scale_fill_manual(values = rhg_cols1)+  
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='rs1065852 MAF'))+
  labs(tag="B.") +
  coord_map("polyconic") +
  geom_text(data = df, mapping = aes(x, y, label=text, fontface="bold.italic")) + #添加基因标签
  #geom_text(size=2,aes(x = jd,y = wd,label = province), data =province_city)+ #添加省会标签
  theme(                            #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1  

#绘制小图
p2 <- ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group,fill=ratio),color="black",size=0.2)+ #绘制分省图
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #9段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
pdf("NBdiffSite2.PDF", width = 6.8, height = 6.8)
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图
dev.off()


###### diff site 3 #####

mydata <- read.csv("NBdiffSite3.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Region,breaks=c(0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6),labels=c('0.1~0.15','0.15~0.2','0.2~0.25','0.25~0.3','0.3~0.35','0.35~0.4','0.4~0.45','0.45~0.5','0.5~0.55','0.55~0.6'),right=FALSE,order=TRUE)

df <- data.frame(x=c(79),y=c(26),text=c("UGT1A1"))

p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey30", size=0.2) +
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='rs4148323 MAF'))+
  labs(tag = "C.") +
  coord_map("polyconic") +
  geom_text(data = df, mapping = aes(x, y, label=text, fontface="bold.italic")) + #添加基因标签
  #geom_text(size=2,aes(x = jd,y = wd,label = province), data =province_city)+ #添加省会标签
  theme(                            #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    #text = element_text(face = "bold"),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1  

#绘制小图
p2 <- ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group,fill=ratio),color="black",size=0.2)+ #绘制分省图
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #9段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
pdf("NBdiffSite3.PDF", width = 6.8, height = 6.8)
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图
dev.off()


###### diff site 4 #####

mydata <- read.csv("NBdiffSite4.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Region,breaks=c(0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6),labels=c('0.1~0.15','0.15~0.2','0.2~0.25','0.25~0.3','0.3~0.35','0.35~0.4','0.4~0.45','0.45~0.5','0.5~0.55','0.55~0.6'),right=FALSE,order=TRUE)

df <- data.frame(x=c(78),y=c(25),text=c("NAT2"))

p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey30", size=0.2) +
  #scale_fill_manual(values = rhg_cols1)+  
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='rs1799930 MAF'))+
  labs(tag = "D.") +
  coord_map("polyconic") +
  geom_text(data = df, mapping = aes(x, y, label=text, fontface="bold.italic")) + #添加基因标签
  #geom_text(size=2,aes(x = jd,y = wd,label = province), data =province_city)+ #添加省会标签
  theme(                            #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1  

#绘制小图
p2 <- ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group,fill=ratio),color="black",size=0.2)+ #绘制分省图
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #9段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
pdf("NBdiffSite4.PDF", width = 6.8, height = 6.8)
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图
dev.off()


###### diff site 5 #####

mydata <- read.csv("NBdiffSite5.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Region,breaks=c(0,0.02,0.04,0.06,0.08,0.1,0.12),labels=c('0~0.02','0.02~0.04','0.04~0.06','0.06~0.08','0.08~0.1','0.1~0.12'),right=FALSE,order=TRUE)

df <- data.frame(x=c(80),y=c(27.5),text=c("HLA-B"))

p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey30", size=0.2) +
  #scale_fill_manual(values = rhg_cols1)+  
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='*15:02 MAF'))+
  labs(tag = "E.") +
  coord_map("polyconic") +
  geom_text(data = df, mapping = aes(x, y, label=text, fontface="bold.italic")) + #添加基因标签
  #geom_text(size=2,aes(x = jd,y = wd,label = province), data =province_city)+ #添加省会标签
  theme(                            #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1  

#绘制小图
p2 <- ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group,fill=ratio),color="black",size=0.2)+ #绘制分省图
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #9段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
pdf("NBdiffSite5.PDF", width = 6.8, height = 6.8)
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图
dev.off()



###### diff site 6 #####

mydata <- read.csv("NBdiffSite6.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Region,breaks=c(0,0.02,0.04,0.06,0.08,0.1,0.12),labels=c('0~0.02','0.02~0.04','0.04~0.06','0.06~0.08','0.08~0.1','0.1~0.12'),right=FALSE,order=TRUE)

df <- data.frame(x=c(80),y=c(26.5),text=c("HLA-B"))

p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey30", size=0.2) +
  #scale_fill_manual(values = rhg_cols1)+  
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='*58:01 MAF'))+
  labs(tag = "F.") +
  coord_map("polyconic") +
  geom_text(data = df, mapping = aes(x, y, label=text, fontface="bold.italic")) + #添加基因标签
  #geom_text(size=2,aes(x = jd,y = wd,label = province), data =province_city)+ #添加省会标签
  theme(                            #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1  

#绘制小图
p2 <- ggplot()+
  geom_polygon(data=china_data,aes(x=long,y=lat,group=group,fill=ratio),color="black",size=0.2)+ #绘制分省图
  #scale_fill_manual(values = rhg_cols1)+
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #9段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2

#嵌合2个图
library(grid) #ggplot也是grid图
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
pdf("NBdiffSite6.PDF", width = 6.8, height = 6.8)
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图
dev.off()


