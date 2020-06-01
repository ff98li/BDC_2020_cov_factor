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


two_var <- six_var[-c(2, 3, 5, 6),]

data.matrix <- as.matrix(sapply(two_var, as.double))

colnames(data.matrix) <- colnames(two_var)
rownames(data.matrix) <- rownames(two_var)

pca_two_var <- prcomp(t(data.matrix),
                      scale = TRUE)

pca_two_var.data <- data.frame(Sample = rownames(pca_two_var$x),
                               X = pca_two_var$x[,1],
                               Y = pca_two_var$x[,2])

pca_two_var_r0.data <- merge(
  pca_two_var.data, basic_reproductive_numbers,
  by.x = 'Sample', by.y = 'location'
)

# DO NOT RUN BOTH AT ONCE
# Run only either of the two for ploting a graph

# Show PCA plot

group <- pca_two_var_r0.data %>%
  mutate(
    group = case_when(
      (0 < R_0)&(R_0 < 1) ~ "R_0 < 1",
      (1 <= R_0)&(R_0 <= 1.4) ~ "1 <= R_0 <= 1.4",
      R_0 > 1.4 ~ "R_0 > 1.4"
    )
  )

group <- factor(group$group)

pca_two_var %>%
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