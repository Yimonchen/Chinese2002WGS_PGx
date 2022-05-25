############## G1K2504 & china1956 PCA ###############
library(tidyverse)


### processing the data ###
# read in data
pca <- read_table2("G1K2054.china1956.eigenvec", col_names = FALSE)
eigenval <- scan("china1976_G1K2054.eigenval")


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



# region
region <- read_table2("region_for_PCA", col_names = FALSE)
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
b <- b + scale_colour_manual(values = c("green4", "tomato", "gray50","goldenrod1","dodgerblue","darkmagenta"))
b <- b + coord_equal() + theme_light()
b + ylab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + xlab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))

