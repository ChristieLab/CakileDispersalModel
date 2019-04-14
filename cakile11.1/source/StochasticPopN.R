StochasticPopN <- function(adult.survival.var, pop.n) {

needed.popn <-pop.n[pop.n > 0]

OUT <- NULL
for(n in 1:length(needed.popn)){
  out <- abs(round(rnorm(1, mean = needed.popn[n], sd = adult.survival.var)))  # variation in number [of offspring] that die 
  OUT <- c(OUT, out)
}
needed.n <- OUT # above introduces density independence

pop.loc.names <- names(needed.popn)  #popid of pops
needed.n <- structure(needed.n, names=pop.loc.names)  #add popid names 

return(needed.n) #  output is vector of needed number of offspring per pop

}