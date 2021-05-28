setwd("C:/Users/ilian/OneDrive - University of Bergen/Documents/R/win-library/4.1/biostats.tutorials/tutorials/Dates-and-times")
install.packages("devtools")
install.packages("tidyverse")
devtools::install_github("biostats-r/biostats.apps")
install.packages("palmerpenguins")
devtools::install_github("biostats-r/biostats.tutorials")
install.packages("lme4")
library(biostats.apps)
library(tidyr)
library(biostats.tutorials)
library(lme4)

publication_bias_app()
data("penguins", package="palmerpenguins")
penguins
penguins_raw


##########Tutorial 1 : Naming objects################
mean(1:10) # mean of sequence of numbers from 1:10

result <- mean(1:10) # mean of sequence of numbers from 1:10 named as result
result# result printed to screen

#The object can now be used in further calculations.
result * result

#Object names can only include
#lower case letters
#UPPER case letters
#numbers
#dots . and underscores _
#The first character must be a letter or a dot.
#The object . will be invisible The object .banana will be invisible Names with <U+00E6>, o, 
#or a are legal but can cause huge problems with locale. Avoid.

#Object names can include characters with diacritics such as Γ¦, ΓΈ, and  Γ¥ but these are best avoided.
#If the first character in a name is a dot, the object is invisible (this is sometime useful). 
#Use ls(all.names = TRUE) to find any invisible objects

#Some names are reserved for R. These include function, if, else,  for, while, next and TRUE. 
#You can see the full list with ?Reserved. 
#If you try to use one of these names, you will get an error.
?Reserved
#R is a case sensitive language. This means that fun, Fun and FUN are all different objects

#Make the word breaks clear. Here are some strategies.
#snake_case
#camelCase
#UpperCamelCase
#best.avoided (possible confusion with R functions)
#I usually use snake_case as I find it easiest to read.
#Code completion in RStudio can help with typing longer names (type the first few letters then wait or press tab).




#############Tutorial 2: Dates and times#################3
#When entering data into a spreadsheet or similar, I strongly recommend using the international standard format for dates and times.
#Year-Month-Day Hour:Minute:Second
#2020-12-5 12:23:13
date1 <- "28/02/1999"
as.Date(date1, format = "%d/%m/%Y")
date2 <- "July 1 2001 2:14"
as.POSIXct(date2, format = "%B %d %Y %H:%M")

library("lubridate")
dat <- "26 October 2016 14:39:10"
dmy_hms(dat)#function with the day, month and year in the correct order.

#lubridate can even cope when the format is mixed, provided the elements are in the same order.
dmy_hms(c("26-10-16 14.39.10", "26th Oct 2016 14 39 10", "261016143910"))

#The default timezone for the lubridate functions is UTC (approximately Greenwich Mean Time). 
#This is normally fine unless you are dealing with local times in multiple time-zones, or because you need to allow 
#for daylight saving time.
mdy_hm("July 1 2001 2:14", tz = "Europe/Oslo")

#The function OlsonNames() returns a vector of valid time zones. See the help file for details.


ymd("2020-5-18") - 5 #base unit is days for dates
## [1] "2020-05-13"
ymd("2020-5-18") - period(5, unit = "months")
## [1] "2019-12-18"
ymd("2020-5-18") - ymd("2020-5-13")
## Time difference of 5 days

#Excersice
#How many days until Christmas
ymd("2021-12-25") - ymd ("2021-5-20")
#Time difference of 219 days


#Find the current datetime with Sys.time() or now()
Sys.time
#[1] "2021-05-20 12:53:11 CEST"

#R uses locales to know what language to expect the date to be written in. 
Sys.getlocale(category = "LC_TIME")

#As an ecologist, I spend a lot of time processing climate data for comparison with ecological data. 
#The data are typically in R in a data.frame, so dplyr is useful for manipulating them. 
#This section shows how to use lubridate together with dplyr.

#I want to make a single date-time column. 
#To do this I need to combine the data and time columns with paste, 
#and then use a lubridate function for the conversion.
temperature2 <- temperature %>% 
                                mutate(date_time = paste(Dato, Tid), #combine
                                      date_time = ymd_hms(date_time)) #convert 
              
#lubridate functions make_date and make_datetime are useful if the year, month, day etc are in different columns
tibble(year = 2020, month = 10, day = 3) %>%  mutate(date = make_date(year = year, month = month, day = day))

#I often need to filter data to remove bad data or restrict the dates and times in the dataset.
#For example, to calculate the mean temperature of the afternoon of the 21st April, we first need to filter the data. 
#between is a useful helper function here to avoid having to write a more complicated logical condition.
temperature2 %>% 
filter(between(date_time, left = ymd_hm("2020-04-21 12:00"), right = ymd_hm("2020-04-21 17:00"))) %>% 
summarise(mean_temp = mean(Lufttemperatur))
#Include only mornings
temperature2 %>%  filter(hour(date_time)<12)

#Summarise
temperature2 %>% 
                 mutate(hour = hour(date_time)) %>% 
                 group_by(hour) %>% 
                 summarise(mean_temperature = mean(Lufttemperatur))


######Tutorial 3: Functions and packages############

#To get help on a function, use a ?.
#The examples at the bottom of the help file can be useful to understand how to use the function. 
#You can run the examples either by copying and pasting them, or using  example()

#There is a special type of function called an infix function that does not use brackets 
#but is placed between two objects.
#For example, in  5 < 3

#To get help of an infix function surround it with backticks.  ?`%in%
7 %/% 4 # integer division
7 %% 4 # modulus (finds the remainder)

#Often you know what package you want to install. 
#If you dont know the name of the package you need for your analyses the task views can help. 
#The Environmetrics task view describes packages for the analysis of ecological and environmental data.

#The safest solution is to use the conflicted package. 
#The conflicted package converts any conflicts between packages into errors.

#You should also cite R. Again, the citation function can be used

citation()


#The workflow when working with renv is:
  
#  Call renv::init() to initialise a private R library for the project

#  Work in the project as normal, installing R packages as needed in the project

#  Call renv::snapshot() to save the state of the project library

#  Continue working on your project, installing and updating R packages as needed. 
#  Use renv::install to install packages from CRAN or github.

#  If the changes were sucessful, call renv::snapshot() again. 
#  If the updated packages introduced problems, call renv::restore() to revert to the previous state of the library.


#To make a function, you need to use the reserved word function followed by brackets with zero or more arguments. 
#After the brackets, braces encompas the body of the function.



#############Tutorial 4: Importing data####################


#read_delim has many arguments. In addition to file and delim, some of the most useful are

#  locale : use this to change the decimal separator with  locale = locale(decimal_mark = ",")
#  skip : skips some lines at the top of the file. Useful if the file starts with some metadata.
#  col_types : read_delim will guess what type of data is in each column and convert it accordingly. 
#  Sometimes it will make a mistake. col_types will force it to use the correct type.

#library(tidyverse)#purrr is part of tidyverse
#list.files(path = "data", pattern = "\\.csv$", full.names = TRUE) %>% 
#  map_dfr(~read_delim(file = .x, delim = ","))

#Or you can use tribble(). tribble takes the column names preceded by a tilde, and then the data, all separated by commas. 
#Anything other than a number need to be enclosed in quotation marks.

#svalbard_islands <-  tribble( ~ island, ~ Latitude, ~ Longitude,
#                              "Nordaustlandet", 79.558405, 24.017351,
#                              "Prins Karls Forland", 78.554090, 11.256545)



######################Tutorial 5: Processing text with stringr#############

#In this tutorial, you will learn how to manipulate character (text) vectors with the  stringr package.
#Each element in the character vector is known as a string. 
#We might want to detect which strings have a particular pattern, or replace, remove or extract part of the text. 
#We can do this with the stringr package which is loaded when tidyverse is loade
#library("tidyverse")# load stringr, ggplot2, dplyr etc
#We might want to detect which of the species are in the genus Navicula. 
#We can do this with str_detect (the base R equivalent is grepl).
str_detect(string = diatoms, pattern = "Navicula")


#Metacharacters are like wildcards in that they can match different literal characters.

# . Matches any character.
# \d Matches any digit.
# \D matches anything that is not a digit.
# \s matches any whitespace.
# \S matches anything that is not whitespace
# \w matches any alphanumeric character or underscore
# \W matches anything that is not alphanumeric or underscore
#Because the \ is a special character, it needs to be escaped with another backslash. 
#So to match white space character, use \\s.

#Sometimes it is useful to make our own set of characters. We can do this with square brackets.

# [aeiou] matches vowels
# [^aeiou] matches anything but vowels
# [a-z] matches lower case letters
# [a-zA-Z] matches upper or lower case letters
#The vertical line | matches the group of characters either before or after it. 
#So  "Navicula|Nitzschia" will match either genus.


#We can control how many times something gets matched by following it with a quantifier.

# ?: Zero or one times
# +: One or more times
# *: Any number of times
# {2}: Exactly twice
# {2,4}: Between two and four times
# {,4}: At most four times
# {2,}: At least twice
# To match a four digit sequence we can use "\\d{4}".

#You can use anchors so that matches are only made at the start or end of a string.

# ^A Matches A but only at the start of a string
# A$ Matches A but only at the end of a string



#If you want to detect a literal . then there is a problem as .is a metacharacter. 
#We need to escape the .with two backslashes so it can be treated as a literal fullstop. 
#We also need to escape metacharacters  {}[]()^$.|*+? and \.

#If we donβ€™t want to use any metacharacters as metacharacters, 
#it is easier to use a helper function which forces R to treat everything as a literal.

has_dot <- c("Navicula.elkab", "Navicula radiosa")
str_detect(string = has_dot, pattern = coll("."))

#We can replace characters in some text using str_replace. 
#So to replace the underscore in diatoms with a space, we could use

str_replace(diatoms, pattern = "_", replacement = " ")


#If there were several underscores and we want to replace them all, we can use str_replace_all. 
#If we want to remove some characters, we can either use str_replace and set  replacement = "", or use str_remove.

#Sometimes you want to extract some characters from a string.
str_extract(filename, pattern = "\\d{4}")

#You can change the case of a character vector with str_to_upper and  str_to_lower. 
#Changing the case can often solve formatting inconsistencies.
mess <- c("ponds", "Ponds", "PONDS")
str_to_lower(mess)

#str_trim will remove whitespace from the start or end of a string.
str_trim(c("Navicula ", " Navicula"))

#str_wrap puts a line return (\n) into long lines of text. 
#This is useful in when making a figure if captions or labels are too long.
str_wrap("The quick brown fox jumps over the lazy dog.", width = 30)


###################Tutorial 6: tidying data with tidyr#########3

2+2

add<- function(x,y){x+y}
add(2,2)



####################Tutorial 7: Using dplyr#################333333
#You can choose which columns of the data frame you want with select().
#select species, bill_length_mm & bill_depth_mm
penguins %>%  select(species, bill_length_mm, bill_depth_mm)
#select species, bill_length_mm & bill_depth_mm
penguins %>%  select(species, bill_length_mm, bill_depth_mm)
#select columns from species to bill_depth_mm
penguins %>% select(species:bill_depth_mm)
#select everything but year and sex
penguins %>% select(-year, -sex)
#select bill_length_mm & bill_depth_mm" 
penguins %>% select(starts_with("bill"))
#select all the numeric columns we can use the is.numeric function inside select with the helper where.
penguins %>% select(where(is.numeric)) # No brackets on the function

#Conversely, if we want to select all columns that end with mm, we can use the function ends_with(). 
#contains() is more flexible and matches() is the most powerful of the helper functions,
#Other is.* functions exist, for example, is.character for text,  lubridate::is.Date for dates.

#You can also select columns by number (1 being the first column), 
#but this is generally a bad idea because it makes the code difficult to understand and 
#if a new column is added, or the column order is changed, the code will break

#You can use rename() to rename columns
penguins %>% rename(Species = species)
#You can also rename a column when selecting. This is convenient if you are using  select anyway.

#Sometimes it is useful to reorder the columns.
penguins %>% relocate(island)
#To filter rows of penguins that have a bill length greater than 40 mm, we can use
penguins %>% filter(bill_length_mm > 40)
penguins[penguins$bill_length_mm > 40, ]


# == exactly equals. Often a bad idea to use with numeric data
# near safe function for testing equality of numeric data as it has a tolerance for rounding errors.
# != not equal to
# < less than
# <= less than or equal to
# > greater than
# >= greater than or equal to
# is.na() for filtering by missing values.
# between() for filtering values with a range
# %in% is used when you want to test if a value is in a vector
penguins %>%   filter(species %in% c("Adelie", "Chinstrap"))
#equivalent to 
penguins %>% filter(species == "Adelie" | species == "Chinstrap") # with many alternatives, this gets long
#Filtering on multiple criteria
#If we want all criteria to be TRUE, we can separate them by a comma 
penguins %>%   filter(bill_length_mm > 40, bill_depth_mm > 18)
#If we want any criteria to be TRUE, we can separate them by a |.
penguins %>% filter(bill_length_mm > 40 | bill_depth_mm > 18)
#We can negate a criterion by putting ! in front of it. 
#So to filter rows that do not have bills longer than 40 mm we can use
penguins %>% filter(!bill_length_mm > 40)
#we could also use <= as the test.
#Sometimes it is useful to extract rows by row number.
penguins %>% slice(3:7)
# only interested in some of the columns
penguins %>% distinct(island)
#slice_sample and sample_frac. This can either sample a constant n rows or constant fraction of the rows.
penguins %>% slice_sample(n = 10)
#The function mutate() can add an new column or replace an existing one.
#To make a new column called body_mass_kg we can use
penguins %>% mutate(body_mass_kg = body_mass_g / 1000)
#summarise lets us summarise data.  Remember to separate arguments with a comma.
penguins %>% summarise(flipper_len_mean = mean(flipper_length_mm, na.rm = TRUE), 
                       flipper_len_sd = sd(flipper_length_mm, na.rm = TRUE))
#summarise multiple columns at the same time
penguins %>% summarise(across(c(bill_length_mm, bill_depth_mm), .fns = mean, na.rm = TRUE))
#using a list of functions
penguins %>% summarise(across(.cols = starts_with("bill"), .fns = list(sd = sd, mean = mean), na.rm = TRUE))
#To find the mean flipper length for each species, we need to group_by species and then summarise.
penguins %>% group_by(species) %>%  summarise(mean_flipper_length = mean(flipper_length_mm))
#To sort the data frame by one or more of the variables we can use arrange.
penguins %>% arrange(bill_length_mm, bill_depth_mm)
#This will sort smallest first. To reverse the sort order, use desc()
penguins %>% arrange(desc(bill_length_mm), desc(bill_depth_mm))
#The function n can count how many rows there are in the each group (or, less usefully, the entire data frame if it is not grouped). 
#It can be used with either mutate or  summarise.
penguins %>% group_by(species) %>% summarise(n = n())
#Or with count
penguins %>%  count(species)

#We can use a join to merge these data with the original penguin data. 
#The by argument tells the join which column to make the join by. 
#Here, we are joining by a single column with the same name in both data frames. 
#It is possible to join by multiple columns and where the columns have different names in each dataset.
penguin2 %>%  left_join(penguin_islands, by = "island")
# left_join will take all rows from the first (left) data frame and matching rows from the second (right).
# right_join does the opposite to left_join, taking all rows from the second (right) data frame and matching rows from the first.
# inner_join will take only rows that match in both data frames.
# full_join will take all rows from in both data frames.
#In all cases, missing values will are given an NA.

#semi_join finds rows that have a matching row
penguin_islands %>%   semi_join(penguins, by = "island")
#anti_join finds rows that do not have a matching row
penguin_islands %>%   anti_join(penguins, by = "island")
#More columns - bind_cols
#If the data frames contain information about the same observations, they can be combined with bind_cols.
bind_cols(data1, data2, data3)
#More rows - bind_rows
# .id argument that makes an extra column for an identifier
bind_rows(Palmer = penguin_islands, Svalbard = svalbard_islands, .id = "Archipelago")



################tutorial 8:Data Basics###############

#You can use as_tibble() to return a tibble version of any data frame. 
#For example, this would return a tibble version of mpg: as_tibble(mpg).

#int stands for integers.

#dbl stands for doubles, or real numbers.

#chr stands for character vectors, or strings.

#dttm stands for date-times (a date + a time).

#lgl stands for logical, vectors that contain only TRUE or FALSE.

#fctr stands for factors, which R uses to represent categorical variables with fixed possible values.

#date stands for dates.


########################Tutorial 9: Filter Observations###############33
#R provides a suite of comparison operators that you can use to compare values:
#  >,  >=, <, <=, != (not equal), and == (equal).
#Boolean operators
#These include & (and), | (or), ! (not or negation), and xor() (exactly or).
#Both | and xor() will return TRUE is one or the other logical comparison returns TRUE. 
#xor() differs from | in that it will return FALSE if both logical comparisons return TRUE. 
#The name xor stands for exactly or.

#A useful short-hand for this problem is x %in% y. This will select every row where x is one of the values in y. We could use it to rewrite the code in the question above:
nov_dec <- filter(flights, month %in% c(11, 12))
#find flights that werenβ€™t delayed (on arrival or departure) by more than two hours, you could use either of the following two filters:
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
#If you want to determine if a value is missing, use is.na():
 is.na(x)

 
 ################################Tutorial 10: Creating new variables###################
 
# If you want to return only the new variables, use transmute().
 
# Over time, Iβ€™ve found that several families of vectorised functions are particularly useful with mutate():
   
#Arithmetic operators: +, -, *, /, ^. 
#These are all vectorised, using the so called β€recycling rulesβ€. 
#If one parameter is shorter than the other, it will automatically be repeated multiple times to create a vector of the same length. 
#This is most useful when one of the arguments is a single number:  air_time / 60, hours * 60 + minute, etc.
 
#Modular arithmetic: %/% (integer division) and %% (remainder), where  x == y * (x %/% y) + (x %% y).
#Modular arithmetic is a handy tool because it allows you to break integers up into pieces.

#Logs: log(), log2(), log10(). 
#Logarithms are an incredibly useful transformation for dealing with data that ranges across multiple orders of magnitude. 
#They also convert multiplicative relationships to additive, a feature weβ€™ll come back to in modelling.
#All else being equal, I recommend using log2() because itβ€™s easy to interpret: 
#a difference of 1 on the log scale corresponds to doubling on the original scale and a difference of -1 corresponds to halving.

#Offsets: lead() and lag() allow you to refer to leading or lagging values. 
#This allows you to compute running differences (e.g.Β x - lag(x)) or find when values change (x != lag(x)). 
#They are most useful in conjunction with  group_by(), which youβ€™ll learn about shortly

#Cumulative and rolling aggregates:  
#R provides functions for running sums, products, mins and maxes: cumsum(), cumprod(), cummin(), cummax(); 
#and dplyr provides cummean() for cumulative means. If you need rolling aggregates (i.e.Β a sum computed over a rolling window), 
#try the RcppRoll package

#Logical comparisons, <, <=, >, >=, !=, which you learned about earlier. 
#If youβ€™re doing a complex sequence of logical operations itβ€™s often a good idea 
#to store the interim values in new variables so you can check that each step is working as expected.

#Ranking: there are a number of ranking functions, but you should start with  min_rank(). 
#It does the most usual type of ranking (e.g.Β 1st, 2nd, 2nd, 4th). The default gives smallest values the small ranks; 
#use desc(x) to give the largest values the smallest ranks

#If min_rank() doesnβ€™t do what you need, 
#look at the variants  row_number(), dense_rank(), percent_rank(), cume_dist(), ntile(). 
#See their help pages for more details.

 
 
 
 #########GIT#############3
 install.packages("usethis")
 
 library(usethis)
 use_git_config(
    user.name = "ilianauib", 
    user.email = "int001@uib.no")
 create_github_token() 
 gitcreds::gitcreds_set()
 use_git()
 use_github()
 create_from_github("ilianauib/bio302")
 
 library(usethis)
 create_from_github("kingsleyshacklebolt/dragon_study", fork = TRUE)
############

