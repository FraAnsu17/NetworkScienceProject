rm(list = ls())

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")

# data <- read.csv("Export.csv", sep = ";", header = T)
# data <- read.csv("Fuels.csv", sep = ";", header = T)
# data <- read.csv("Food.csv", sep = ";", header = T)
# data <- read.csv("FoodProducts.csv", sep = ";", header = T)
# data <- read.csv("OresMets.csv", sep = ";", header = T)
data <- read.csv("Agric.csv", sep = ";", header = T)



data[,3] <- as.double(gsub(",", ".", data[,3]))


exp_c <- unique(data[,1])
imp_c <- unique(data[,2])

country_tot <- sort(unique(c(exp_c, imp_c)))

# adj_mat <- data.frame(matrix(data = 0, nrow = length(exp_c), ncol = length(exp_c)), row.names = exp_c)
adj_mat <- data.frame(matrix(data = 0, nrow = length(country_tot), ncol = length(country_tot)), row.names = country_tot)


i <- 1

while(i <= length(country_tot)){
  a <- data[which(data[,2] == country_tot[i]),1]
  b <- data[which(data[,2] == country_tot[i]),3]
  adj_mat[a,i] <- b
  i <- i+1
}

colnames(adj_mat) <- country_tot


# write.csv(file = "Export_AdjacencyMatrix.csv", x = adj_mat, sep = ",", row.names = T, col.names = T)


# write.csv(file = "Fuels_AdjacencyMatrix.csv", x = adj_mat, sep = ",", row.names = T, col.names = T)

 
# write.csv(file = "Food_AdjacencyMatrix.csv", x = adj_mat, sep = ",", row.names = T, col.names = T)

 
# write.csv(file = "FoodProducts_AdjacencyMatrix.csv", x = adj_mat, sep = ",", row.names = T, col.names = T)


# write.csv(file = "OresMets_AdjacencyMatrix.csv", x = adj_mat, sep = ",", row.names = T, col.names = T)


write.csv(file = "Agric_AdjacencyMatrix.csv", x = adj_mat, sep = ",", row.names = T, col.names = T)
prova2 <- read.csv(file = "Agric_AdjacencyMatrix.csv", header = T, row.names = 1)
View(prova2)


