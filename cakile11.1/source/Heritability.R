Heritability <- function(pops, alpha.heritability, beta.heritability, n.loci) {
number.rows <- as.numeric(nrow(pops))

#create a new beta parameter based on heritability value
BETA.M <- vector(mode = "numeric", length= number.rows)
for (i in 1:nrow(pops)) {  
    k.beta <- abs(pops[i, 10]) #ith beta
    BETA.M[i] <- rnorm(1, mean = k.beta, sd = beta.heritability) #sd = the sd of beta based on heritability value
  }  

BETA.M[BETA.M < 0.000001] <- 0.01 #if beta is x e-6 then then model crashes, so filter these out
BETA.M[BETA.M < 0] <- 0 #if beta is negative then make it equal zero

pops<- cbind(pops[,1:9], BETA.M, pops[,11:((n.loci * 2) + 11)])  #updated pops matrix 
return(pops)
}

