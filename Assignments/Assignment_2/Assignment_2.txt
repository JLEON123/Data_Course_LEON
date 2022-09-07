# Assignment 2 #

# Adding all .csv files from Data directory into an object
csv_files <- list.files(path = "Data", 
                        pattern = ".csv", 
                        recursive = TRUE, 
                        full.names = TRUE)

# print the number of .csv files
length(csv_files)

# Finding the wingspan_vs_mass.csv file
wing <- list.files(path = "Data", 
               pattern = "wingspan_vs_mass.csv", 
               recursive = TRUE, 
               full.names = TRUE)

# Placing the wingspan_vs_mass.csv file into an object and printing the first 5 lines
df = read.csv(file = wing)
head(df, n=5)

# A faster way of printing the first line of all files that start with 'b'
x <- list.files(path = "Data", 
           pattern = "^b", 
           recursive = TRUE, 
           full.names = TRUE)

# Even faster by using a for loop
for(i in x){
  print(readLines(i,n=1))
}

# Printing the first line for all .csv files (csv_files)
for (i in csv_files){
  print(readLines(i, n = 1))
}
