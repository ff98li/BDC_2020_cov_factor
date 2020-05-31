# Investigating factors contributing to COVID-19 control via PCA

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
### PCA on 6 variables
#### With respect to R0
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_6var.png)
#### Loading Plot
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_6var_loading.png)
#### With respect to CFR
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_CFR_6var.png)
### PCA on 11 variables
#### With respect to R0
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_29_country.png)
#### Loading Plot
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_R0_29_country_loading.png)
#### With respect to CFR
![alt text](https://github.com/ff98li/BDC_2020_cov_factor/blob/master/plots/PCA_CFR_29_country.png)

Note that I did not post the loading plot for the CFR because I'm seriously considering abandoning this measurement.
## Contributing
