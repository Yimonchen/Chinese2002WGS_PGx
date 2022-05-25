############## china1976 PCA north central south lingnan ###############
library(tidyverse)


### processing the data ###
# read in data
pca <- read_table2("china1976.noabroad.rmBSX.eigenvec", col_names = FALSE)
eigenval <- scan("china1976.eigenval")


# sort out the pca data
# remove nuisance column
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))


# sort out the individual species and pops
# spp
#spp <- rep(NA, length(pca$ind))
#spp[grep("PunPund", pca$ind)] <- "pundamilia"
#spp[grep("PunNyer", pca$ind)] <- "nyererei"

# location
#loc <- rep(NA, length(pca$ind))
#loc[grep("Mak", pca$ind)] <- "makobe"
#loc[grep("Pyt", pca$ind)] <- "python"
# combine - if you want to plot each in different colours
#spp_loc <- paste0(spp, "_", loc)


# province
province <- read_table2("province_for_PCA", col_names = FALSE)
names(province)[1] <- "province"


# remake data.frame
pca <- as_tibble(data.frame(pca, province))


# region
region <- rep(NA, length(pca$ind))
region[grep("Hubei", pca$province)] <- "South"
region[grep("Hunan", pca$province)] <- "South"
region[grep("Henan", pca$province)] <- "North"
region[grep("Guangdong", pca$province)] <- "Lingnan"
region[grep("Guangxi", pca$province)] <- "Lingnan"
#region[grep("Xianggang", pca$province)] <- "HN"
region[grep("Hainan", pca$province)] <- "Lingnan"
region[grep("Shandong", pca$province)] <- "North"
#region[grep("Shanghai", pca$province)] <- "HD"
region[grep("Zhejiang", pca$province)] <- "South"
region[grep("Jiangsu", pca$province)] <- "Central"
region[grep("Anhui", pca$province)] <- "Central"
region[grep("Jiangxi", pca$province)] <- "South"
region[grep("Fujian", pca$province)] <- "South"
#region[grep("Beijing", pca$province)] <- "HB"
region[grep("Tianjin", pca$province)] <- "North"
region[grep("Hebei", pca$province)] <- "North"
region[grep("Neimenggu", pca$province)] <- "North"
region[grep("Shanxi", pca$province)] <- "North"
region[grep("Shannxi", pca$province)] <- "North"
region[grep("Gansu", pca$province)] <- "North"
region[grep("Ningxia", pca$province)] <- "North"
region[grep("Qinghai", pca$province)] <- "North"
region[grep("Xinjiang", pca$province)] <- "North"
region[grep("Sichuan", pca$province)] <- "South"
region[grep("Chongqing", pca$province)] <- "South"
region[grep("Guizhou", pca$province)] <- "South"
region[grep("Yunnan", pca$province)] <- "South"
region[grep("Heilongjiang", pca$province)] <- "North"
region[grep("Liaoning", pca$province)] <- "North"
region[grep("Jilin", pca$province)] <- "North"
region[grep("M", pca$province)] <- "Minority"
names(region)[1] <- "region"

# remake data.frame
pca <- as_tibble(data.frame(pca, region))


### plotting the data ###
# first convert to percentage variance explained
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)


# make plot
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()


# calculate the cumulative sum of the percentage variance explained
cumsum(pve$pve)


# plot pca
b <- ggplot(pca, aes(PC2, PC1, col = region)) + geom_point(size = 1)
b <- b + scale_colour_manual(values = c("goldenrod1", "tomato", "gray0","green4","dodgerblue"))
b <- b + coord_equal() + theme_light() + guides(color = guide_legend(title = "Region"))
b + ylab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + xlab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))




#############################################################

# plot pca
north <- ggplot(pca, aes(PC2, PC1, col = region)) + geom_point(size = 1)
north <- north + scale_colour_manual(values = c("gray", "gray", "gray","green4","gray"))
north <- north + coord_equal() + theme_light() + labs(title="North") + 
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5)) +
  guides(color = guide_legend(title = "Region"))
north + ylab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + xlab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))



# plot pca
central <- ggplot(pca, aes(PC2, PC1, col = region)) + geom_point(size = 1)
central <- central + scale_colour_manual(values = c("goldenrod1", "gray", "gray","gray","gray"))
central <- central + coord_equal() + theme_light() + labs(title="Central") + 
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5)) +
  guides(color = guide_legend(title = "Region"))
central + ylab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + xlab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))




# plot pca
south <- ggplot(pca, aes(PC2, PC1, col = region)) + geom_point(size = 1)
south <- south + scale_colour_manual(values = c("gray", "gray", "gray","gray","dodgerblue"))
south <- south + coord_equal() + theme_light() + labs(title="South") + 
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5)) +
  guides(color = guide_legend(title = "Region"))
south + ylab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + xlab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))




# plot pca
lingnan <- ggplot(pca, aes(PC2, PC1, col = region)) + geom_point(size = 1)
lingnan <- lingnan + scale_colour_manual(values = c("gray", "tomato", "gray","gray","gray"))
lingnan <- lingnan + coord_equal() + theme_light() + labs(title="Lingnan") + 
  theme(plot.title = element_text(face = "bold", size = 12, hjust = 0.5)) +
  guides(color = guide_legend(title = "Region"))
lingnan + ylab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + xlab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))




library(ggpubr)

final1 <- ggarrange(north,central,south,lingnan, ncol=2, nrow=2)
final1
