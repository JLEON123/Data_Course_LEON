# 1.  Get a subset of the "iris" data frame where it's just even-numbered rows
data("iris")
dat <- iris
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
# This was difficult for some reason 
