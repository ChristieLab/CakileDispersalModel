PopSetupClimate <- function(n.pops, first.pop, habitat.t, dispersal.mean, dispersal.var, beta, alpha, beta.var, alpha.var, center, edge, a.geo, b.geo, c.geo) {
  
  total.n <- sum(first.pop) 
 
  pops <- sort(rep(habitat.t[, 2], first.pop))  #repeat popid from gen1 by k.adult times and sort
  
  ids  <- rep(1:n.pops, first.pop)   # not right - need to be 1:n for each pop
  pid  <- 1:total.n   #total number of global individuals 
  x <- rep(habitat.t[, 3], times=first.pop)  #x 
  y <- rep(habitat.t[, 4], times=first.pop)  #y
  h.suit <- rep(habitat.t[, 5], times=first.pop) #habitat suitability
  
  
  emigrate <- rbinom (total.n, 1, 0.688)  #0 is stay, 1 is disperse based on proportion of distal seeds
  kernel.mean <- abs(rnorm(total.n, mean = dispersal.mean, sd = dispersal.var))
  kernel.var <- abs(rnorm(total.n, mean = dispersal.var, sd = dispersal.var))
  
  #dispersal kernel ----------
  #can set starting mean dispersal of kernel at center vs. edge
  #geo.kernel<- ifelse(y > 43.5 & y < 46.5, center, edge) #between x = 43.5-46.5 center, otherwise edge dispersal mean
  
  #set kernel as quadratic with latitude
  y.beta <- a.geo * y ^2 + b.geo * y + c.geo #a, b, c coefficients are set for each set of beta parameters
  beta <- rnorm(total.n, mean = y.beta, sd = beta.var)
  beta[beta < 0.000001] <- 0.01 #if beta is x e-6 then then model crashes, so filter these out
  beta[beta < 0] <- 0 #if beta is negative then make it equal zero
  
  alpha <- abs(rnorm(total.n, mean = alpha, sd = alpha.var))
  
  population <- cbind(pops, ids, pid, x, y, h.suit, emigrate, kernel.mean, kernel.var, beta, alpha)
  
  return(population)
}


