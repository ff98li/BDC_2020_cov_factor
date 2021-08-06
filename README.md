# Investigating factors contributing to COVID-19 control via PCA

[Link to the analysis report](https://docs.google.com/viewer?url=https://raw.githubusercontent.com/ff98li/BDC_2020_cov_factor/master/Covid_19_data_analysis.pdf)

All the datasets and R scripts are here

## Download
Make sure you have git on your PC.
```bash
git clone https://github.com/ff98li/BDC_2020_cov_factor.git
```

## Usage
This project requires the following packages:
- tidyverse
- R0
- devtools
- ggbiplot
To install them all, run the following in your R console
```R
install.packages(c("tidyverse",
                   "R0",
                   "devtool",
                   "ggbiplot"),
                   dependencies = TRUE)
```
could take a pretty long while to get the dependencies done. Work on the report while you are waiting.

## Plots
I'm posting the plots here for those who have trouble using R to read.
### PCA on 6 variables, 144 countries
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_6var.png)
### Loading Plot
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_6var_loading.png)
### Decision Tree
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/tree.png)
### ROC curve for the decision tree model
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/ROC.png)
### PCA on 2 variables, 144 countries
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_2var.png)
### Linear Regression for Populations
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/LM_population.png)
### Linear Regression for Obesity
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/LM_obesity.png)

## Contributing
