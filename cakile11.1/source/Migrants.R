Migrants <- function(generation.new, pops, n.pops, n.offspring, alpha) {
  
  # calculate euclidian distance between existing pop and new pop
  gent.latlong <- generation.new[, c (3, 4)]  #lat/long from current generation
  gennew.latlong <- generation.new[, c (3, 4)]  #lat/long from new generation
  
  #calculates the distance of each current pop between each new pop
  DISTANCE <- matrix(nrow = n.pops, ncol = n.pops)
  for (n in 1:nrow(gent.latlong)) {   
    DISTANCE[n,] <- rdist.earth(gent.latlong[n,], gennew.latlong, miles = FALSE)
  }
  #maintain column and row names of distance matrix
  colnames(DISTANCE) <- generation.new[,2]
  rownames(DISTANCE) <- t(generation.new[,2])

#create dispersal probability matrix for each individual from every population 
MIGRANT.PROBABILITY <- matrix(nrow = nrow(pops), ncol = n.pops)
#for (p in 1:nrow(DISTANCE)) {
 # pop.dist <- DISTANCE[p,]  #each row in distance matrix is current pop by new pops distances
  for (i in 1:nrow(pops)) {  #each individual's dispersal kernel and var.
    ind <- pops[i, ]
    ind.beta <- ind[10]
    pop.dist <- DISTANCE[ind[1], ]
    MIGRANT.PROBABILITY[i,1:n.pops] <- dweibull(pop.dist, alpha, ind.beta, log = FALSE)  
  }

#add row and col names
rownames(MIGRANT.PROBABILITY) = pops[,1]  
colnames(MIGRANT.PROBABILITY) = colnames(DISTANCE)

#scale probability so that it doesn't exceed 1.0
scaled.migrants <- (MIGRANT.PROBABILITY / rowSums(MIGRANT.PROBABILITY)) * 1

#mult. by n.offspring to get no. of migrants per new pop
migrants <- round(scaled.migrants * n.offspring)
return(migrants)
}
