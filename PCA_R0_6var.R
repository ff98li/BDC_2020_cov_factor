# Run PCA for only 189 countries having only 6 variables non empty

# install.packages("tidyverse")
library("tidyverse")
# install.packages("devtools")
library(devtools)
# install_github("vqv/ggbiplot")
library(ggbiplot)

basic_reproductive_numbers <- read_csv("basic_reproductive_numbers.csv")

six_var <- read_csv("six_var.csv")

six_var <- six_var %>%
  column_to_rownames('Country Name')

six_var <- six_var[,
                   !(names(six_var) %in% setdiff(
                     colnames(six_var),
                     basic_reproductive_numbers$location
                   )
                   )
                   ]

data.matrix <- as.matrix(sapply(six_var, as.double))

colnames(data.matrix) <- colnames(six_var)
rownames(data.matrix) <- rownames(six_var)

pca_six_var <- prcomp(t(data.matrix),
                      scale = TRUE)

pca_six_var.data <- data.frame(Sample = rownames(pca_six_var$x),
                               X = pca_six_var$x[,1],
                               Y = pca_six_var$x[,2])

pca_six_var_r0.data <- merge(
  pca_six_var.data, basic_reproductive_numbers,
  by.x = 'Sample', by.y = 'location'
)

# DO NOT RUN BOTH AT ONCE
# Run only either of the two for ploting a graph

# Show PCA plot

# pca_six_var_r0.data %>%
#   ggplot() +
#   aes(x = X, y = Y) +
#   geom_point(alpha = 0.5, aes(color = R_0, size = R_0)) +
#   scale_color_viridis_c(direction = -1, option = "magma") +
#   xlab(paste("PC1 - ", summary(pca_six_var)$importance[2,1]*100, "%", sep = "")) +
#   ylab(paste("PC2 - ", summary(pca_six_var)$importance[2,2]*100, "%", sep = ""))
group <- pca_six_var_r0.data %>%
  mutate(
    group = case_when(
      (0 < R_0)&(R_0 < 1) ~ "R_0 < 1",
      (1 <= R_0)&(R_0 <= 1.4) ~ "1 <= R_0 <= 1.4",
      R_0 > 1.4 ~ "R_0 > 1.4"
    )
  )

group <- factor(group$group)

pca_six_var %>%
  ggbiplot(ellipse = TRUE,
           circle = FALSE,
           groups = group,
           varname.size = 3,
           labels.size = 3,
           obs.scale = 1,
           var.scale = 1) +
  scale_color_manual(name="R0 level", values=c("orange", "green", "red")) +  
  scale_shape_manual(name="R0 level", values=c(8:10)) +
  geom_point(aes(colour=group, shape=group), size = 3) +
  theme(legend.direction ="horizontal", 
        legend.position = "top")

# Show loading plot
loadings <- rownames_to_column(
  as.data.frame(
    pca_six_var$rotation
    ),
  "Variable")

loadings_group <- loadings %>%
  gather(key = "PC",
         value = "Loadings",
         -Variable)

loadings_group %>%
  ggplot(aes(fill=Variable, y = Loadings, x = PC)) +
  geom_bar(position="dodge", stat="identity") +
  theme(legend.position="bottom", legend.box = "horizontal")