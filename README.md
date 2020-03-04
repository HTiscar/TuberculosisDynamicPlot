# TuberculosisDynamicPlot

A repository which it meants to includes a variety of visualization using Maps library in R. This repo was created with the intention of testing how to transform data into a shapeable form in order to merge the dataframe by the countries listed in the Maps library. 

This would permit us to use the poligon data included in the Maps library to encode the longitude and latitude of the contries and plot them to a static ggplot. Since we downloaded the data from the World Health Organization, we have the records of the cases found in the WHO afiliated countries all the way back from 2000, with the last update being from 2018. 

## Plotting the Static Map

By using the dplyr library, we are able to select the exact year in which the country reported their Tuberculosis cases. Since the countries listed in the WHO don't entirely match the countries listed in the Maps Library, we have to use the recode() function in order the encode them exactly the same. The implementation I used isn't the most data driven one, since it requires to write a function which manually recodes the names of the countries after finding out where they don't match. I believe there is a better way to do this, by using the <b>%in%</b> operator, and I will try to implement it in the future. 

 <p align="center"><img src="https://github.com/HTiscar/TuberculosisDynamicPlot/blob/master/TB_2018%20Percentage.png"></p>
 
 This is the visualization of the static plot using the data available in 2018. There is some caviats, mainly in the continous scale used to visualize the data. I believe there is a better visualization, mainly by assigning individual colors to a specific range. Will implement it later using the <b>aes = </b> in ggplot2.

<p align="center"><img src="https://github.com/HTiscar/TuberculosisDynamicPlot/blob/master/TB%20100%20K.gif"></p>
