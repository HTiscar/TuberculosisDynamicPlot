# TuberculosisDynamicPlot

A repository which it meants to includes a variety of visualization using Maps library in R. This repo was created with the intention of testing how to transform data into a shapeable form in order to merge the dataframe by the countries listed in the Maps library. 

This would permit us to use the poligon data included in the Maps library to encode the longitude and latitude of the contries and plot them to a static ggplot. Since we downloaded the data from the World Health Organization, we have the records of the cases found in the WHO afiliated countries all the way back from 2000, with the last update being from 2018. 

## Plotting the Static Map

By using the dplyr library, we are able to select the exact year in which the country reported their Tuberculosis cases. Since the countries listed in the WHO don't entirely match the countries listed in the Maps Library, we have to use the recode() function in order the encode them exactly the same. The implementation I used isn't the most data driven one, since it requires to write a function which manually recodes the names of the countries after finding out where they don't match. I believe there is a better way to do this, by using the <b>%in%</b> operator, and I will try to implement it in the future. 

 <p align="center"><img src="https://github.com/HTiscar/TuberculosisDynamicPlot/blob/master/TB_2018%20Percentage.png"></p>
 
This is the visualization of the static plot using the data available in 2018. There is some caviats, mainly in the continous scale used to visualize the data. I believe there is a better visualization, mainly by assigning individual colors to a specific range. Will implement it later using the <b>aes = </b> in ggplot2.

## Plotting the Dynamic Map

In order to produce a dynamic plot of the entire data, I used the <b>gganimate</b> library. This includes a variety of functions that allow you to recover gif format images, however you have to transform your data in very specific manner in order for it to work. 

The main challenge here was to produce a plot which would be able to differentiate the real cases by countries. Since there is little variation in the original dataset year by year, I implemented a range in order to have a more pronounce data visualization effect. 

<p align="center"><img src="https://github.com/HTiscar/TuberculosisDynamicPlot/blob/master/TB%20100%20K.gif"></p>


This is the plot produced by R, and there are still some problems with the visualization. Mainly, I have to reshape the plot in a higher resolution, cahnge the continous scale to a better range, and there are some countries with no available data that don't appear in the plot at the beginning. This is mainly because of the way that the <b>transition_manual()</b> function works. I believe that transition_time() would be a better implementation, however, there is a problem I havent been able to identify of how my data is transformed in order to use this function correctly. I will be updating soon. 
