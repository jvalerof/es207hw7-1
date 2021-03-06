Some advices

1. All the exercises were presented in a single file. It is recommended to create a file for each exercise, because according to the blog: "write classes that do only one thing and have only one reason to change".
2. It is recommended to indent the code to facilitate its reading.
3. It should be evident where is the file path.
4. It is recommended that the code be more ordered: A section for path definition, other for loading of libraries, other for the results section, etc.
5. In the case of exercise 9 it is recommended to leave spaces between blocks of code dedicated to a specific function. It is also recommended to include texts to guide the reader.
6. For function 10 it is recommended to include additional criteria to know if the address is correct, for example: the following texts in the address field are also errors: "address not known", "location approximate", "", and zip code less than 90000.
7. Comments should be included in exercises 14 and 15 to facilitate their interpretation.
8. Now of executing the code of exercises 14 and 15, some errors were generated.



#9.How many site names in the CA air quality location dataset "Site Name" contain "San" or "Santa?".

location = read.csv("location.csv", header = TRUE, na.strings = "") #requiring R to recognize that there is NAs
str(location)
library(dplyr)
library(tidyverse)
allsites = select(location, Site.Name) # selecting only one column i.e. specifically all sites .
library(stringr)
allsites$lower <- tolower(allsites$Site.Name) #converting into lower case
q <- str_detect(allsites$lower,"san")
table(q)["TRUE"] 
q2 <- str_detect(allsites$lower,"santa")
table(q2)["TRUE"]
# san = 104
#santa = 36
#san only = 104-36 = 68


#10.Identify the number of sites that do not have a complete address (full street address and zip code).
# Note that, prior to importing data NAs has to be specificied as: na.strings = ""

sum(is.na(location$Address)) # summing up the nos of NAs represent to account for nos of incomplete address. 
sum(is.na(location$Zip.Code)) # summing up the nos of NAs represent to account for nos of incomplete zipcode

# There are 120 incomplete address and 142 incomplete zipcodes.
#Alternatively, I also use the "skimr" library.

library(skimr)
skim(location)


#14.Write a function to calculate the ANNUAL (calendar year) mean, median, max and min of all sites that have "San" or "Santa" in their name. 

summarystats= function(){
  
  colnames(location)[1] <- "site"
  
  daily.site <- daily %>%
    left_join(location, by = "site")
  
  descriptives= daily.site %>%
    filter(str_detect(`Site.Name`, "Santa|San")) %>%
    group_by(year(date)) %>%
    summarise(mean=mean(o3,na.rm =TRUE ), median=median(o3, na.rm =TRUE), max=max(o3, na.rm =TRUE), min=min(o3, na.rm =TRUE))
  return(descriptives)
}

descriptives = summarystats()
print(descriptives)



#15.Write a function to calculate the annual daily mean (what is the annual mean of the daily mean?). Apply that function to Merced County. What is the annual daily mean of o3 for Merced County? Report your results in quantititive format (i.e., prose, or a table), and in visual format (i.e., a graph). 

mercedstats= function(){
  
  colnames(location)[1] <- "site"
  
  daily.site <- daily %>%
    left_join(location, by = "site")
  
  merced_annual_daily_mean= daily.site %>%
    filter(str_detect(`County.Name`, "Merced")) %>%
    group_by(year(date)) %>%
    summarise(mean=mean(o3), na.rm =TRUE)
  return( merced_annual_daily_mean)
}

merced_daily_annual_dailymean = mercedstats()
print(merced_daily_annual_dailymean)
str(merced_daily_annual_dailymean)

plot(merced_daily_annual_dailymean$`year(date)`, merced_daily_annual_dailymean$mean, type = "l", lty = 1,col = "red", xlab = "Years", ylab = "Mean Annual o3")
