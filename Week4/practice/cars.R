## Import the variable "cars" in the working environment
data(cars)
class(cars)
## [1] "data.frame"
## Visualise the first six rows of the variable
head(cars)
# The plot function on this type of dataset (class = data.frame, 2 column)
# automatically generates a scatterplot
plot(cars)
