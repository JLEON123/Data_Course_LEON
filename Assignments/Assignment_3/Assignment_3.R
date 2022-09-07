###########################
#                         #
#    Assignment Week 3    #
#                         # 
###########################

# Instructions ####
# Fill in this script with stuff that we do in class.
# It might be a good idea to include comments/notes as well so you remember things we talk about
# At the end of this script are some comments with blank space after them
# They are plain-text instructions for what you need to accomplish.
# Your task is to write the code that accomplished those tasks.

# Then, make sure to upload this to both Canvas and your GitHub repository




# Vector operations! ####

# Vectors are 1-dimensional series of values in some order
1:10 # ':' only works for integers
letters # built-in pre-made vector of a - z
LETTERS
head(LETTERS, n = 5) # first five letters
tail(LETTERS, n = 5) # last five letters
LETTERS[15] # Just the 15th character
length(LETTERS) # how many items are in the vector


vector1 <- c(1,2,3,4,5,6,7,8,9,10)
vector1 <- 1:10 # another way that is much quicker
vector2 <- c(5,6,7,8,4,3,2,1,3,10)
vector3 <- letters # letters and LETTERS are built-in vectors

letters[c(1,5)] <- c("a","e") # puts a and e at position 1 and 5
vector1 + 5
vector2 / 2
vector1*vector2

vector3 + 1 # can't add 1 to "a"
class(vector3) # Find out what type of vector



# Logical expressions (pay attention to these...they are used ALL THE TIME)
vector1 > 3
vector1 >= 3
vector1 < 5
vector1 <= 5
vector1 == 7
letters == "a"
letters != "c"
letters %in% c("a","b","c","z") # which elements in letters are found in this new vector?
vector1 %in% 1:6
grep("a", letters) # returns the position of the pattern in the vector
grepl("a", letters) # returns logical values for each of the elements in the vector



# Data Frames ####
# R has quite a few built-in data sets
data("iris") # load it like this

# For built-in data, there's often a 'help file'
?iris

# "Iris" is a 'data frame.' 
# Data frames are 2-dimensional (think Excel spreadsheet)
# Rows and columns
# Each row or column is a vector


dat <- iris # can rename the object to be easier to type if you want

# ways to get a peek at our data set
names(dat) # Returns the variable names
dim(dat) #  Returns the number of cases (rows) and the number of variables (columns)
head(dat) # Returns the first 6 rows of the data frame


# You can access specific columns of a "data frame" by name using '$'
dat$Species
class(dat$Species) # Returns a factor type.  It's a character with levels.  Every variable must be one of the levels
dat$Sepal.Length
class(dat$Sepal.Length)
# You can also use square brackets to get specific 1-D or 2-D subsets of a data frame (rows and/or columns)
dat[1,1] # [Rows, Columns]
dat[1:3,5]

vector2[1]
letters[1:7]
letters[c(1,3,5,7)]


# Plotting ####

# Can make a quick plot....just give vectors for x and y axes
plot(x=dat$Petal.Length, y=dat$Sepal.Length)
plot(x=dat$Species, y=dat$Sepal.Length)


# Object "Classes" ####

#check the classes of these vectors
class(dat$Petal.Length)
class(dat$Species)

# plot() function behaves differently depending on classes of objects given to it!

# Check all classes (for each column in dat)
str(dat) # shows the structures of the dataset

# "Classes" of vectors can be changed if needed (you'll need to, for sure, at some point!)

# Let's try
nums <- c(1,1,2,2,2,2,3,3,3,4,4,4,4,4,4,4,5,6,7,8,9)
class(nums) # make sure it's numeric

# convert to a factor
as.factor(nums) # show in console
nums_factor <- as.factor(nums) #assign it to a new object as a factor
class(nums_factor) # check it


# convert numeric to character
as.character(vector1)
as.character(vector1) + 5 # numbers can be strings with " "

# convert character to numeric
as.numeric(vector3) # strings can't be numbers




#check it out
plot(nums) 
plot(nums_factor)
# take note of how numeric vectors and factors behave differently in plot()
# So far, it looks like numeric vectors usually come out as scatter plots
# factor vectors produce bar graphs or histograms



# Simple numeric functions
# R is a language built for data analysis and statistics so there is a lot of functionality built-in

max(vector1)
min(vector1)
median(vector1)
mean(vector1)
range(vector1)
summary(vector1)

# cumulative functions
cumsum(vector1)
cumprod(vector1)
cummin(vector1)
cummax(vector1)

# even has built-in statistical distributions (we will see more of these later)
dbinom(50,100,.5) # probability of getting exactly 50 heads out of 100 coin flips




# YOUR REMAINING HOMEWORK ASSIGNMENT (Fill in with code) ####

# 1.  Get a subset of the "iris" data frame where it's just even-numbered rows
data("iris")
dat <- iris
seq(2,150,2) # here's the code to get a list of the even numbers between 2 and 150

dat[seq(2,150,2),] # leaving the column or row blank gives you all of them


# 2.  Create a new object called iris_chr which is a copy of iris, except where every column is a character class

iris_chr <- dat
iris_chr$Sepal.Length <- as.character(iris_chr$Sepal.Length)
iris_chr$Sepal.Width <- as.character(iris_chr$Sepal.Width)
iris_chr$Petal.Length <- as.character(iris_chr$Petal.Length)
iris_chr$Petal.Width <- as.character(iris_chr$Petal.Width)
iris_chr$Species <- as.character(iris_chr$Species)
# Can I do this in a loop?

# 3.  Create a new numeric vector object named "Sepal.Area" which is the product of Sepal.Length and Sepal.Width

Sepal.Area <- dat$Sepal.Length * dat$Sepal.Width

# 4.  Add Sepal.Area to the iris data frame as a new column

dat$Sepal.Area <- Sepal.Area


# 5.  Create a new dataframe that is a subset of iris using only rows where Sepal.Area is greater than 20 
      # (name it big_area_iris)

big_area_iris <- dat[ which(dat$Sepal.Area > 20,),]
# This was more difficult for some reason 

# 6.  Upload the last numbered section of this R script (with all answers filled in and tasks completed) 
      # to canvas
      # I should be able to run your R script and get all the right objects generated

