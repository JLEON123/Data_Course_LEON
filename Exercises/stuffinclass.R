x <- read.csv("./Data/lw.csv")

x$Area <- x$Length * x$Width

x$LastName <- "Smith"

x$FullName <- paste0(x$Name," ",x$LastName)
x$FullName <- paste0(x$LastName,", ",x$Name)

plot(x$Length,x$Area)

cor(x$Length, x$Area) # correlation stuff

x$LastName <- NULL # remove a column
