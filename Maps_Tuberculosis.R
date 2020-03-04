###Download libraries
#install.packages("ggplot2")
#install.packages("gganimate")
#install.packages('dplyr')
#install.packages("png")
#install.packages('maps')
#install.packages('tidyverse')
#install.packages('ggmap')
#install.packages('forcats')
#install.packages('rvest')
#install.packages('magrittr')
#install.packages('gifski')
setwd("~/R Projects/Maps")

library(ggplot2)
library(ggmap)
library(gganimate)
library(tydiverse)
library(stringr)
library(rvest)
library(magrittr)
library(dplyr)
library(gifski)

data_preprocessing <- function(df){
  df1 <- df %>% select(country, year, e_pop_num, e_inc_num, e_mort_num, e_inc_100k)
  colnames(df1) <- c("country", "year", "Population", "IncidenceT", "MortalityT", "Inc100K")
  return(df1)
}
get_data <- function(df, select_year = FALSE, year_input = NULL){
  df_name = c()
  if (select_year == FALSE) { 
      df_name = "tb_years"
      assign(df_name, df %>% select(country, year, Inc100K), envir = globalenv())
  }
  else if (select_year == TRUE){
    df_name = paste("tb_", as.character(year_input), sep = "")
    assign(df_name, df %>% filter(year == year_input), envir = globalenv())
  }
}
years.as.columns <- function(df){
  df_years <- as.data.frame(as.factor(levels(df$country)))
  colnames(df_years) <- "country"
  
  content <- NULL
  for (i in seq(min(df$year), max(df$year), by = 1)){
    content <- df %>% filter(year == i)
    content <- content %>% select(country, Inc100K)
    
    df_years <- left_join(df_years, content,
                          by = c("country" = "country"))
    content <- NULL
  }
  colnames(df_years) <- c("country", seq(min(df$year), max(df$year), by = 1))
  
  return(df_years)
}

recode_dataset <- function(df1, df2 = world_map){
  
  world_countries <- as.factor(df2$region) %>% levels()
  tb_countries <- as.factor(df1$country) %>% levels()
  
  countries_match <- tb_countries %in% world_countries
  
  countries_recode <- c()
  for(i in which(countries_match == FALSE)) {
    countries_recode <- c(countries_recode, tb_countries[i])
  }
  countries_recode
  
  df1$country <- recode(df1$country, 
                        "Antigua and Barbuda" = "Barbuda",
                        "Bolivia (Plurinational State of)" = "Bolivia",
                        "Bonaire, Saint Eustatius and Saba" = "Sint Eustatius",
                        "British Virgin Islands" = "Virgin Islands",
                        "Brunei Darussalam" = "Brunei",
                        "Côte d'Ivoire" = "Ivory Coast",
                        "Cabo Verde" = "Cape Verde",
                        "China, Hong Kong SAR" = "Hong Kong",
                        "China, Macao SAR" = "Macao",
                        "Congo" = "Democratic Republic of the Congo",
                        "Curaçao" = "Curacao",
                        "Czechia" = "Czech Republic",
                        "Democratic People's Republic of Korea" = "North Korea",
                        "Iran (Islamic Republic of)" = "Iran",
                        "Lao People's Democratic Republic" = "Laos",
                        "Micronesia (Federated States of)" = "Micronesia",
                        "North Macedonia" = "Macedonia", 
                        "Republic of Korea" = "South Korea",
                        "Republic of Moldova" = "Moldova",
                        "Russian Federation" = "Russia",
                        "Saint Kitts and Nevis" = "Nevis",
                        "Saint Vincent and the Grenadines" = "Grenadines",
                        "Sint Maarten (Dutch part)" = "Saint Martin",
                        "Syrian Arab Republic" = "Syria",
                        "Trinidad and Tobago" = "Trinidad",
                        "United Kingdom of Great Britain and Northern Ireland" = "UK",
                        "United Republic of Tanzania" = "Tanzania",
                        "United States of America" = "USA",
                        "Venezuela (Bolivarian Republic of)" = "Venezuela",
                        "Viet Nam" = "Vietnam",
                        "Wallis and Futuna Islands" = "Wallis and Futuna",
                        "West Bank and Gaza Strip" = "Gaza Strip")
  
  df1 <- df1 %>% filter(country != "Eswatini")
  df1 <- df1 %>% filter(country != "Tokelau")
  df1 <- df1 %>% filter(country != "Tuvalu")
  
  return(df1)
}
set_code <- function(df){
  Code <- c()
  Range <- c()
  
  for(i in which(is.na(df$Inc100K == TRUE))){
    df$Inc100K[i] = 0
  }
  
  for(i in df$Inc100K){
    if(i == 0){
      Code <- c(Code, "lightgray")
      Range <- c(Range, 0)
    } 
    else if (i <= mean(df$Inc100K) - 90 & i != 0){
      Code <- c(Code, "lightsalmon")
      Range <- c(Range, 81)
    } 
    else if (i <= mean(df$Inc100K) - 45 & i > mean(df$Inc100K) - 90){
      Code <- c(Code, "salmon")
      Range <- c(Range, 126)
    }
    else if (i <= mean(df$Inc100K) & i > mean(df$Inc100K) - 45){
      Code <- c(Code, "orange")
      Range <- c(Range, 171)
    }
    else if (i > mean(df$Inc100K) & i <= mean(df$Inc100K) + 45){
      Code <- c(Code, "red")
      Range <- c(Range, 216)
    }
    else if (i > mean(df$Inc100K) + 45 & i <= mean(df$Inc100K) + 90){
      Code <- c(Code, "crimson")
      Range <- c(Range, 261)
    }
    else if (i > mean(df$Inc100K) + 90){
      Code <- c(Code, "brick")
      Range <- c(Range, 306)
    }
  }
  
  df$Code <- Code
  df$Range <- Range
  
  return(df)
}

make_staticplot <- function(df1, df2 = world_map, plot_title = "Tuberculosis Incidence"){
  world_map_joined <- left_join(df2, df1, 
                                by = c('region' = 'country'))
  
  p <- ggplot() +
    geom_polygon(data = world_map_joined, aes(x = long, y = lat, group = group, fill = Inc100K)) +
    labs(title = plot_title, subtitle = "Source: World Health Organization") +
    theme(text = element_text(family = "Gill Sans", color = "#444444")
          ,panel.background = element_rect(fill = "#FFFCEC")
          ,plot.background = element_rect(fill = "#FFFCEC")
          ,panel.grid = element_blank()
          ,plot.title = element_text(size = 30)
          ,plot.subtitle = element_text(size = 10)
          ,axis.text = element_blank()
          ,axis.title = element_blank()
          ,axis.ticks = element_blank()
    )
  return(p)
}
make_dynamicplot <- function(df1, df2 = world_map, plot_title = "TB Incidence 2000-2018"){
  world_map_joined <- left_join(df2, df1, 
                                by = c('region' = 'country'))
  
  q <- ggplot() +
    geom_polygon(data = world_map_joined, aes(x = long, y = lat, group = group, fill = Range)) +
    labs(title = plot_title, subtitle = "Source: World Health Organization") +
    transition_manual(year) + 
    theme(text = element_text(family = "Gill Sans", color = "#444444")
          ,panel.background = element_rect(fill = "#FFFCEC")
          ,plot.background = element_rect(fill = "#FFFCEC")
          ,panel.grid = element_blank()
          ,plot.title = element_text(size = 30)
          ,plot.subtitle = element_text(size = 10)
          ,axis.text = element_blank()
          ,axis.title = element_blank()
          ,axis.ticks = element_blank() 
    )
  
  return(q + coord_fixed(ratio = 2))
}


### Phase One: Load and Preprocess Data 

tuberculosis <- read.csv('TB2020.csv')
tb <- data_preprocessing(tuberculosis)

### Phase Two: Make Static Plot according to selected Year

get_data(df = tb, select_year = TRUE, year_input = 2018)

world_map <- map_data("world")

tb_2018 <- recode_dataset(df1 = tb_2018)

tb_plot2018 <- make_staticplot(df1 = tb_2018, plot_title = "Incidence of TB 2018")
tb_plot2018

### Phase Three: Make a Dynamic Plot that Transitions by Years 

get_data(tb)

tb_years <- set_code(tb_years)
tb_years <- recode_dataset(df1 = tb_years)

tb_dynamicplot <- make_dynamicplot(df1 = tb_years)
tb_dynamicplot










