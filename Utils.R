rm(list = ls())


# Simplify Matrix ####
setwd("C:/Users/USER/OneDrive/Desktop/UniPD/Network Science/ModularityClass")


data <- read.csv("Community_sharing_across_products.csv", header = T, sep = ",")

names <- data[,1]
data <- data[,-1]

rownames(data) <- colnames(data) <- names 

data[data<0.9] <- 0

write.csv(file = "Community_sharing_across_products_reduced2.csv", x = data, sep = ",", row.names = T, col.names = T)


#
# Modify Adjacency Matrix ####

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")


selected_file <- file.choose()
file <- basename(selected_file)
data <- as.matrix(read.csv(file = file, row.names = 1))
colnames(data) <- rownames(data)

data_reduced <- data

t <- 10000

data_reduced[data_reduced < t] <- 0

print(paste(sum(data>0), " -> ", sum(data_reduced>0), sep = ""))

n <- rownames(data_reduced)

count_blank_countries <- function(data){
  count <- 0
  
  for (r in 1:238) {
    a <- sum(data[r,])
    b <- sum(data[,r])
    if (a+b == 0) {
      count <- count+1
      
    }
  }
  return(count)
}

n_nodes <- dim(data)[1]-count_blank_countries(data_reduced)

new_name <- paste(unlist(strsplit(file, ".csv")), "_reduced_",n_nodes,".csv", sep = "")
write.csv(data_reduced, new_name, col.names = n, row.names = n, sep = ",")

# Make Matrix Undirected ####

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2")

make_undirected <- function(mat){
  mat1 <- matrix(0,nrow=ncol(mat),ncol=ncol(mat))
  for (i in 1:ncol(mat)) {
    for (j in i:ncol(mat)) {
      mat1[i,j] <- mat[i,j]+mat[j,i]
      mat1[j,i] <- mat[i,j]+mat[j,i]
    }
  }
  colnames(mat1) <- rownames(mat1) <- colnames(mat)
  return(mat1-diag(diag(mat1)))
}

selected_file <- file.choose()
file <- basename(selected_file)

data <- as.matrix(read.csv(file, header = T, row.names = 1))
colnames(data) <- rownames(data)

new_name <- paste(unlist(strsplit(file, ".csv")), "_UNDIRECTED.csv", sep = "")

data_undir <- make_undirected(data)

write.csv(file = new_name, x = data_undir, sep = ",", row.names = T, col.names = T)

# Aggregate Resources ####

setwd("C:/Users/USER/OneDrive/Desktop/UniPD/Network Science/ModularityClass")

agric <- as.matrix(read.csv(file = "ModAgric.csv", header = T, sep = ";"))
rownames(agric) <- agric[,1]
food <- as.matrix(read.csv(file = "ModFood.csv", header = T, sep = ";"))
rownames(food) <- food[,1]
foodprod <- as.matrix(read.csv(file = "ModFoodProd.csv", header = T, sep = ";"))
rownames(foodprod) <- foodprod[,1]
fuels <- as.matrix(read.csv(file = "ModFuels.csv", header = T, sep = ";"))
rownames(fuels) <- fuels[,1]
ores <- as.matrix(read.csv(file = "ModOres.csv", header = T, sep = ";"))
rownames(ores) <- ores[,1]

country_available <- intersect(intersect(intersect(intersect(agric[,1], food[,1]), foodprod[,1]), fuels[,1]), ores[,1])

same_community <- function(c1,c2,mat){ # It requires two countries and a matrix with names in the first
                                       # column and communities in the remaining columns.
  n_methods <- ncol(mat)-1 # Number of Products = Number of columns minus the country column
  c1_idx <- which(mat[,1] == c1)
  c2_idx <- which(mat[,1] == c2)
  c1_classes <- mat[c1_idx,-1]
  c2_classes <- mat[c2_idx,-1]
  return(sum(c1_classes == c2_classes)/n_methods)
}

aggregated_classes <- data.frame("Country"=country_available,
                                 "Agricolture" = as.numeric(agric[country_available,2]),
                                 "Food" = as.numeric(food[country_available,2]),
                                 "FoodProd" = as.numeric(foodprod[country_available,2]),
                                 "Fuels" = as.numeric(fuels[country_available,2]),
                                 "Ores" = as.numeric(ores[country_available,2]))

# write.csv(file = "Classes_by_product.csv", x = aggregated_classes, sep = ",", row.names = F, col.names = T)

community_sharing <- matrix(0, ncol = length(country_available), nrow = length(country_available))

for (c1 in 1:length(country_available)) {
  for (c2 in c1:length(country_available)) {
    community_sharing[c1,c2] <- community_sharing[c2,c1] <- same_community(c1 = country_available[c1],
                                                                           c2 = country_available[c2],
                                                                           mat = aggregated_classes) 
  }
}

community_sharing <- community_sharing-diag(diag(community_sharing)) # To remove self loops

rownames(community_sharing) <- colnames(community_sharing) <- country_available

write.csv(file = "Community_sharing_across_products.csv", x = community_sharing, sep = ",", row.names = T, col.names = T)

community_sharing_reduced <- community_sharing # keep only the ones who are in the same 
# community at least 3 times
community_sharing_reduced[community_sharing_reduced<0.7] <- 0

write.csv(file = "Community_sharing_across_products_reduced.csv", x = community_sharing_reduced, sep = ",", row.names = T, col.names = T)


# Correct names for DataWrapper ####

setwd("C:/Users/USER/OneDrive/Desktop/UniPD/Network Science")
name_corrections <- read.csv("names_correction_for_datawrapper.csv", header = T)
dwnames <- as.vector(read.csv("DataWrapperNames.csv", header = T, sep = "\n"))$ï..DataWrapper

# setwd("C:/Users/USER/OneDrive/Desktop/UniPD/Network Science/Multilayer/")
# setwd("C:/Users/USER/OneDrive/Desktop/UniPD/Network Science/ModularityClass")
# setwd("C:/Users/USER/OneDrive/Desktop/PythonLouvain")
setwd("C:/Users/USER/OneDrive/Desktop/Final_communitydetection")
selected_file <- file.choose()
file <- basename(selected_file)

data <- read.csv(file, header = T, row.names = NULL)

name_correction_for_dw <- function(data, df, dwnames){
  for (i in 1:nrow(df)) {
    if (df[i,2] %in% data[,1]) {
      idx <- which(data[,1] == df[i,2])
      data[idx,1] <- df[i,1]
    }
  }
  return(data[data[,1] %in% dwnames, ])
}

data_corrected <- name_correction_for_dw(data = data, df = name_corrections, dwnames = dwnames)

new_name <- paste(unlist(strsplit(file, ".csv")), "_corrected.csv", sep = "")

write.csv(data_corrected, new_name, col.names = T, row.names = F, sep = ",")


# K means on classes by product ####

setwd("C:/Users/USER/OneDrive/Desktop/UniPD/Network Science/ModularityClass")

data <- read.csv("Classes_by_product.csv", header = T, row.names = 1)

k <- 4

kmeans_result <- kmeans(data, centers = k)

t <- kmeans_result$cluster

results <- cbind(names(t), as.vector(t))

colnames(results) <- c("Country", "Class")
name_file <- paste("K",k,"-Means_AggregatedClasses.csv", sep = "")
write.csv(results, name_file, sep = ",", col.names = T, row.names = F)

name_corrections <- read.csv("names_correction_for_datawrapper.csv", header = T)
dwnames <- as.vector(read.csv("DataWrapperNames.csv", header = T, sep = "\n"))$ï..DataWrapper

results_corrected <- name_correction_for_dw(data = results, df = name_corrections, dwnames = dwnames)

name_file <- paste("K",k,"-Means_AggregatedClasses_DW.csv", sep = "")

write.csv(results_corrected, name_file, sep = ",", col.names = T, row.names = F)


# Aggregate Product Communities (Python Louvain) ####

setwd("C:/Users/USER/OneDrive/Desktop/PythonLouvain")

agric <- as.matrix(read.csv(file = "Louvain_Agricolture.csv", header = T, sep = ","))
rownames(agric) <- agric[,1]
foodprod <- as.matrix(read.csv(file = "Louvain_FoodProducts.csv", header = T, sep = ","))
rownames(foodprod) <- foodprod[,1]
fuels <- as.matrix(read.csv(file = "Louvain_Fuels.csv", header = T, sep = ","))
rownames(fuels) <- fuels[,1]
ores <- as.matrix(read.csv(file = "Louvain_OresMets.csv", header = T, sep = ","))
rownames(ores) <- ores[,1]


country_available <- intersect(intersect(intersect(agric[,1],foodprod[,1]), fuels[,1]), ores[,1])


aggregated_classes <- data.frame("Country"=country_available,
                                 "Agricolture" = as.numeric(agric[country_available,2]),
                                 "FoodProd" = as.numeric(foodprod[country_available,2]),
                                 "Fuels" = as.numeric(fuels[country_available,2]),
                                 "Ores" = as.numeric(ores[country_available,2]))
# write.csv(file = "Classes_by_product_Python.csv", x = aggregated_classes, sep = ",", row.names = F, col.names = T)


same_community <- function(c1,c2,mat){ # It requires two countries and a matrix with names in the first
  # column and communities in the remaining columns.
  n_methods <- ncol(mat)-1 # Number of Products = Number of columns minus the country column
  c1_idx <- which(mat[,1] == c1)
  c2_idx <- which(mat[,1] == c2)
  c1_classes <- mat[c1_idx,-1]
  c2_classes <- mat[c2_idx,-1]
  return(sum(c1_classes == c2_classes)/n_methods)
}


community_sharing <- matrix(0, ncol = length(country_available), nrow = length(country_available))


for (c1 in 1:length(country_available)) {
  for (c2 in c1:length(country_available)) {
    community_sharing[c1,c2] <- community_sharing[c2,c1] <- same_community(c1 = country_available[c1],
                                                                           c2 = country_available[c2],
                                                                           mat = aggregated_classes) 
  }
}

community_sharing <- community_sharing-diag(diag(community_sharing)) # To remove self loops

rownames(community_sharing) <- colnames(community_sharing) <- country_available

write.csv(file = "Community_sharing_across_products_Python.csv", x = community_sharing, sep = ",", row.names = T, col.names = T)

community_sharing_reduced <- community_sharing # keep only the ones who are in the same 
# community at least 4 times
community_sharing_reduced[community_sharing_reduced<0.7] <- 0


sum(community_sharing_reduced>0)

write.csv(file = "Community_sharing_across_products_Python_reduced.csv", x = community_sharing_reduced, sep = ",", row.names = T, col.names = T)



# K-means

data <- read.csv("Classes_by_product_Python.csv", header = T, row.names = 1)

k <- 4

kmeans_result <- kmeans(data, centers = k)

t <- kmeans_result$cluster
# names(t)
# as.vector(t)

results <- cbind(names(t), as.numeric(t))

colnames(results) <- c("Country", "Class")

name_corrections <- read.csv("names_correction_for_datawrapper.csv", header = T)
dwnames <- as.vector(read.csv("DataWrapperNames.csv", header = T, sep = "\n"))$ï..DataWrapper

results_corrected <- name_correction_for_dw(data = results, df = name_corrections, dwnames = dwnames)

name_file <- paste("K",k,"-Means_AggregatedClasses_DW_Python.csv", sep = "")

write.csv(results_corrected, name_file, sep = ",", col.names = T, row.names = F)





# Compute PowerLaw Slope ####

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")
library("poweRlaw")

selected_file <- file.choose()
file <- basename(selected_file)
data <- as.matrix(read.csv(file = file, row.names = 1))
colnames(data) <- rownames(data)


compute_slope <- function(d, k_min){
  d <- d[d > k_min]
  # k_min <- min(d)
  N <- length(d)
  g <- 1+(N/(sum(log(d/k_min))))
  return(g)
}


fit_power_law <- function(d, k_min, IN = T){
  m = displ$new(sort(d+1))
  if (IN) {
    t <- "Power Law Fit - In Degree"
  }else{
    t <- "Power Law Fit - Out Degree"
  }
  plot(m, xlim = c(1, (max(d)+20)), col = "blue", pch = 16, main = t,
       xlab = "k", ylab = "pk")
  colors <- c("black", "red", "green")
  c <- 1
  leg <- c()
  for (k in k_min) {
    s <- compute_slope(d, k)
    m$setXmin(k)
    m$setPars(s)
    leg <- c(leg, paste("kmin =", k, "- Slope =", round(s,2)))
    # abline(v = k, col = "red", lty = 2, lwd = 0.5)
    lines(m, col=colors[c], lwd = 3)
    c <- c+1
  }

  legend("bottomleft", bty = "n", legend = leg, col = colors, lty = 1, lwd = 3)
  
}


data1 <- data
t <- 10000
data1[data1<=t] <- 0
data1[data1>t] <- 1
n <- dim(data)[1]

d_in <- t(data1) %*% rep(1,n)
d_out <- data1 %*% rep(1,n)
par(mfrow = c(1,2))
fit_power_law(d_in, k_min = c(1,30,80), IN = T)
fit_power_law(d_out, k_min = c(1,50,100), IN = F)


# Average Adjacency Matrices ####

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")

agric <- as.matrix(read.csv(file = "Agric_AdjacencyMatrix.csv", header = T, row.names = 1))

foodprod <- as.matrix(read.csv(file = "FoodProducts_AdjacencyMatrix.csv", header = T, row.names = 1))

fuels <- as.matrix(read.csv(file = "Fuels_AdjacencyMatrix.csv", header = T, row.names = 1))

ores <- as.matrix(read.csv(file = "OresMets_AdjacencyMatrix.csv", header = T, row.names = 1))


country_available <- intersect(intersect(intersect(rownames(agric), rownames(foodprod)), rownames(fuels)), rownames(ores))

idx <- which(country_available %in% rownames(agric))
agric1 <- agric[idx,idx] 
write.csv(file = "Agric_AdjacencyMatrix_Standard.csv", x = agric1, sep = ",", row.names = country_available, col.names = country_available)



idx <- which(country_available %in% rownames(foodprod))
foodprod1 <- foodprod[idx,idx]
write.csv(file = "FoodProducts_AdjacencyMatrix_Standard.csv", x = foodprod1, sep = ",", row.names = country_available, col.names = country_available)

idx <- which(country_available %in% rownames(fuels))
fuels1 <- fuels[idx,idx]
write.csv(file = "Fuels_AdjacencyMatrix_Standard.csv", x = fuels1, sep = ",", row.names = country_available, col.names = country_available)

idx <- which(country_available %in% rownames(ores))
ores1 <- ores[idx,idx]
write.csv(file = "OresMets_AdjacencyMatrix_Standard.csv", x = ores1, sep = ",", row.names = country_available, col.names = country_available)

mean_adj_mat <- (agric1 + foodprod1 + fuels1 + ores1)/4



write.csv(file = "MeanAdjacencyMatrix.csv", x = mean_adj_mat, sep = ",", row.names = country_available, col.names = country_available)


# Compute Modularity ####

retrieve_C_matrix <- function(comm_ass){
  n_comm <- length(unique(comm_ass[,2]))
  community_assignment_matrix <- matrix(0, nrow = n_comm, ncol = dim(comm_ass)[1])
  for (r in 1:dim(comm_ass)[1]) {
    idx <- comm_ass[r,2]+1
    community_assignment_matrix[idx,r] <- 1
  }
  colnames(community_assignment_matrix) <- comm_ass[,1]
  return(community_assignment_matrix)
}

compute_modularity <- function(A0, C){
  A0 <- as.matrix(A0)
  n <- dim(A0)[1]
  D0 <- t(rep(1,n))%*%A0%*%rep(1,n)
  A <- A0/as.numeric(D0)
  d_in <- A%*%rep(1,n)
  d_out <- t(A)%*%rep(1,n)
  C <- as.matrix(C)
  Q <- sum(diag(C%*%(A - d_in%*%t(d_out))%*%t(C)))
  return(Q)
}

setwd("C:/Users/USER/OneDrive/Desktop/Final_communitydetection")
community_assignment <- read.csv("Louvain_MeanAdjMat.csv", header = T)

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")
mean_adj_mat <- read.csv("MeanAdjacencyMatrix.csv", header = T, row.names = 1)


C <- retrieve_C_matrix(community_assignment)
Q <- compute_modularity(A0 = mean_adj_mat, C = C)
Q


setwd("C:/Users/USER/OneDrive/Desktop/Final_communitydetection")
community_assignment <- read.csv("Louvain_Export_Gephi.csv", header = T, sep = ";")

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")
mean_adj_mat <- read.csv("Export_AdjacencyMatrix.csv", header = T, row.names = 1)

C <- retrieve_C_matrix(community_assignment)
Q <- compute_modularity(A0 = mean_adj_mat, C = C)
Q


setwd("C:/Users/USER/OneDrive/Desktop/Final_communitydetection")
community_assignment <- read.csv("Louvain_Export_Python.csv", header = T)

setwd("C:/Users/USER/OneDrive/Desktop/ProvaDataDownload/AggregatedData2/")
mean_adj_mat <- read.csv("Export_AdjacencyMatrix.csv", header = T, row.names = 1)

C <- retrieve_C_matrix(community_assignment)
Q <- compute_modularity(A0 = mean_adj_mat, C = C)
Q


# Agreement between community assignments ####

setwd("C:/Users/USER/OneDrive/Desktop/Final_communitydetection")
tot_export <- read.csv("Louvain_Export_Python_corrected.csv", header = T)
gen_louvain <- read.csv("Generalized_Louvain_Aggregated_corrected.csv", header = T)

a <- c(0:3)
b <- c(0:3)
c <- c(0:3)
d <- c(0:3)
idx <- c()
combinations <- expand.grid(a,b,c,d)
for (r in 1:nrow(combinations)) {
  if (any(duplicated(as.numeric(combinations[r,])))) {
    idx <- c(idx,r)
  }
}

comb1 <- combinations[-idx,]
dim(comb1)

change_notation <- function(data,x){
  a <- unique(data)
  data1 <- data
  for (i in 1:length(a)) {
    data1[data == a[i]] <- x[i]
  }
  return(data1)
}



agreement <- c()
for (i in 1:nrow(comb1)) {
  modified <- change_notation(gen_louvain[,2], x = as.numeric(comb1[i,]))
  res <- sum(tot_export[,2] == modified)/length(tot_export[,1])
  agreement <- c(agreement,res)
}
max(agreement)


abacus <- read.csv("ABACUS_corrected.csv", header = T)
tot_export1 <- tot_export[-which(!(tot_export[,1] %in% abacus[,1])),]

colnames(abacus) <- colnames(tot_export1)

combined_results <- (merge(tot_export1, abacus, by = "Country"))

agreement <- c()
for (i in 1:nrow(comb1)) {
  modified <- change_notation(combined_results[,3], x = as.numeric(comb1[i,]))
  res <- sum(combined_results[,2] == modified)/length(combined_results[,2])
  agreement <- c(agreement,res)
}
max(agreement)



emcd <- read.csv("K4-Means_AggregatedClasses_corrected.csv", header = T)
tot_export1 <- tot_export[-which(!(tot_export[,1] %in% emcd[,1])),]

colnames(emcd) <- colnames(tot_export1)

combined_results <- (merge(tot_export1, emcd, by = "Country"))

agreement <- c()
for (i in 1:nrow(comb1)) {
  modified <- change_notation(combined_results[,3], x = as.numeric(comb1[i,]))
  res <- sum(combined_results[,2] == modified)/length(combined_results[,2])
  agreement <- c(agreement,res)
}
max(agreement)





