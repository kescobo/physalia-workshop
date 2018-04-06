---
layout: default
title: "Lab #7.1 - Introduction to R"
lab_num: 7
permalink: /labs/7_1_Introduction_to_R
is_lab: true
custom_css: tocbot
custom_js: 
    - tocbot.min
    - labs
---

# Introduction to R

R is a language and environment for statistical computing and graphics. R and its libraries/packages implement a wide variety of statistical (linear and nonlinear modelling, classical statistical tests, time-series analysis, classification, clustering, …) and graphical techniques, and is highly extensible. 

* Vast capabilities, wide range of statistical and graphical techniques
* Excellent community support: mailing list, blogs, tutorials
* Easy to extend by writing new functions

### Lab Setup

1. Option: Use **RStudio** (free and open-source integrated development environment for R)

* Start the RStudio program
* Open a new document and save the file.

<img src="{{ "/assets/img/labs/lab_7_1_Rstudio.png" | prepend: site.baseurl }}" alt="RStudio"/>

* The window in the upper-left is your R script. This is where you will write instructions for R to carry out.
* The window in the lower-left is the R console. This is where results will be displayed.

2. Option: Use the **terminal**.

Start R session:

```R
R
```

<img src="{{ "/assets/img/labs/lab_7_1_R_start.png" | prepend: site.baseurl }}" alt="Terminal"/>


End R session:

```R
q()
```

<img src="{{ "/assets/img/labs/lab_7_1_R_start.png" | prepend: site.baseurl }}" alt="Terminal"/>


### Excercise 0: Explore the interface of RStudio.

* Execute commands.
* Try tab completion. 

#### Add 3 plus 3 in R.

```R
3 + 3
```

#### Calculate the squre root of 7.

```R
sqrt(7)
```

#### Install and load the package ggplot2.

```R
install.packages("ggplot2")
library(ggplot2)
```

Alternative: In Rstudio, go to the "Packages" tab and click the "Istall" button.
Search in the pop-up window and click "Install".


#### Using R help.

```R
help(help)
help(sqrt)
?sqrt
```




### Excercise 1: R basics.

#### Variable assignment

Values can be assigned names and used in subsequent operations.

The ```<-``` (less than followed by a dash) or ```=``` operator is used to save values. The name on the left gets the value on the right.

```R
sqrt(7) #calculate square root of 7; result is not stored anywhere

x <- sqrt(7) #assign result to a variable named x
```

#### Calling R functions and reading data

We will use an example project of the most popular baby names in the United States and the United Kingdom. A cleaned and merged version of the data file is available at ***http://tutorials.iq.harvard.edu/R/Rintro/dataSets/babyNames.csv***.


In order to read data from a file, you have to know what kind of file it is. 

```R
?read.csv
```

What would you use for other file types?

Read in the file and assign the result to the name ```baby.names```.

```R
baby.names = read.csv(file="http://tutorials.iq.harvard.edu/R/Rintro/dataSets/babyNames.csv")
```

Look at the first 10 lines:

```R
head(baby.names)
```

What kind of object is our variable?

```R
class(baby.names)
str(baby.names)
```




### Excercise 2: data.frame objects

Usually data read into R will be stored as a **data.frame**.

* A data.frame is a list of vectors of equal length
* Each vector in the list forms a column
* Each column can be a differnt type of vector
* Typically columns are variables and the rows are observations

A data.frame has two dimensions corresponding the number of rows and the number of columns (in that order).



Extract the first three rows of the data.frame.
```R
baby.names[1:3,]
```

Extract the first three columns of the data.frame.
```R
baby.names[,1:3]
```

Output a specific columns of the data.frame.
```R
baby.names$Name
```

Have many babies were called "jill"?
```R
sum(baby.names$Name == "jill")
```

Extract rows where Name == "jill"
```R
baby.names[baby.names$Name == "jill",]
```

	
#### Relational and logical operators

Operator | Meaning
--- | --- | ---
`==` | equal to
`!=` | not equal to
`>` | greater than
`>=` | greater than or equal to
`<` | less than
`<=` | less than or equal to
`%in%` | contained in
`&` | and
`|` | or

How many female babies are listed in the table?

How many babies were born after 2003? Save the subset in a new dataframe.



#### Adding columns

Add a new column specifying the country.

```R
head(baby.names)
table(baby.names$Location)
```

Output: 
```
> head(baby.names)
           Location Year    Sex    Name Count  Percent Name.length
1 England and Wales 1996 Female  sophie  7087 2.394273           6
2 England and Wales 1996 Female   chloe  6824 2.305421           5
3 England and Wales 1996 Female jessica  6711 2.267245           7
4 England and Wales 1996 Female   emily  6415 2.167244           5
5 England and Wales 1996 Female  lauren  6299 2.128055           6
6 England and Wales 1996 Female  hannah  5916 1.998662           6
```

```
> table(baby.names$Location)

               AK                AL                AR                AZ 
             8685             31652             23279             42775 
               CA                CO                CT                DC 
           133257             35181             21526             11074 
               DE England and Wales                FL                GA 
             8625            227449             77218             58715 
               HI                IA                ID                IL 
            12072             22748             16330             66576 
               IN                KS                KY                LA 
            40200             24548             27041             35370 
               MA                MD                ME                MI 
            33190             35279             10030             51601 
               MN                MO                MS                MT 
            32946             37078             24520              9759 
               NC                ND                NE                NH 
            51874              8470             17549              9806 
               NJ                NM                NV                NY 
            47219             18673             21894             89115 
               OH                OK                OR                PA 
            55633             29857             27524             53943 
               RI                SC                SD                TN 
             9020             29738              9687             39714 
               TX                UT                VA                VT 
           113754             29828             44859              5519 
               WA                WI                WV                WY 
            41231             32858             13726              5786 
```

```R
baby.names$Country = "US"
baby.names$Country[baby.names$Location == "England and Wales"] = "UK"
head(baby.names)
```

Output: 
```
> head(baby.names)
           Location Year    Sex    Name Count  Percent Name.length Country
1 England and Wales 1996 Female  sophie  7087 2.394273           6      UK
2 England and Wales 1996 Female   chloe  6824 2.305421           5      UK
3 England and Wales 1996 Female jessica  6711 2.267245           7      UK
4 England and Wales 1996 Female   emily  6415 2.167244           5      UK
5 England and Wales 1996 Female  lauren  6299 2.128055           6      UK
6 England and Wales 1996 Female  hannah  5916 1.998662           6      UK
```

```R
table(baby.names$Country)
```

#### Replacing data entries

```R
table(baby.names$Sex)
```

Do you notice any discrepency in the output?

```R
baby.names$Sex = gsub("M$", "Male", baby.names$Sex)
```

Why do we need the ```$``` sign? What happens if we omit it? 

Check the output table again.


### Excercise 4: Exporting data.

Now that we have made some changes to our data set, we might want to save those changes to a file.

#### Save the output as a csv file

```R
getwd() # Check current working directory. Is this where you want to save your file?
dir.create("R_Tutorial") # Create a new directory
setwd("/Users/melanie/R_tutorial") # Change the current working directory 
write.csv(baby.names, file="babyNames_v2.csv")
```

How would you save other file formats?

Locate and open the file outside of R.


#### Save the output as an R object

```R
save(baby.names, file="babyNames.Rdata")
```

How do you load an R object? 

```R
?load
```

### Excercise 5: Basic stats.

Descriptive statistics of single variables are straightforward:

```R
mean(baby.names$Name.length)
```

```R
median(baby.names$Name.length)
```

```R
sd(baby.names$Name.length)
```

```R
summary(baby.names$Name.length)
```

Which are the longest names? 

Which are the shortest names?

#### Summary of the whole data.frame

```R
summary(baby.names)
```



### Excercise 6: Simple graphs.


#### Boxplots

Compare the length of baby names for boys and girls using a boxplot.

```R
boxplot(Name.length~Sex,data=baby.names)
```

Adding colour to the boxplot:

```R
boxplot(Name.length~Sex,data=baby.names, col=c("cornflowerblue", "deeppink3"))
```

Change the layout of the plot:
* Add a plot title.
* Add a title to the y-axis.
* Change the colour of the boxplot. Good place to look up colour names are:
    * http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
    * http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3


### Save plot as a pdf 

```R
pdf(file="boxplot.pdf")

boxplot(Name.length~Sex,data=baby.names, col=c("cornflowerblue", "deeppink3"))

dev.off()
```


What about other file formats?



#### Histograms

How many names were recorded for each year?

* Check the timeframe that is included in the table.
* How many records were obtained in total?

```R
hist(baby.names$Year)
```

Take a look at ```?hist``` and change the layout of the plot.

<!---
```R
pdf(file="histogram.pdf", height=5, width=7)
hist(baby.names$Year, main="Histogram", col="darkseagreen1", xlab="Years")
dev.off()
```
--->