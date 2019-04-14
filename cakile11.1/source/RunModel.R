RunModel <- function(n.generations) {
  

#--------- Initiation --------------
unique <- runif(1, 10, 100) #include a unique identifier for each run 
time <- as.numeric(format(Sys.time(), "%j%H%M%S")) #day of year, hour, minute, second
model.parameters <- matrix(c(unique, time, n.pops, global.k.var, alpha, beta, center, edge, beta.var, beta.heritability, k.adults, adult.survival.var, n.generations, n.replicates, n.loci, n.alleles, n.offspring), nrow = 1)

#calculate intitial global k and population size 
first.pop <- HabitatScaleIntial(k.adults, n.pops, habitat.t) #calculate intitial global k and population size

#set up populations
pops <- PopSetupClimate(n.pops, first.pop, habitat.t, dispersal.mean, dispersal.var, beta, alpha, beta.var, alpha.var, center, edge, a.geo, b.geo, c.geo) #setup populations
pops <- Genotypes(pops, n.loci, n.alleles) # creates geneotypes
output0 <- Output0(pops, habitat.t, r, n, model.parameters, beta.heritability, n.loci)

#-------------Climate change-----------------   
for(n in 1:n.generations){
  if(n == 1) {generation.new <- habitat.2000}
  if(n == 26) {generation.new <- habitat.2025}
  if(n == 36) {generation.new <- habitat.2035}
  if(n == 46) {generation.new <- habitat.2045}
  if(n == 56) {generation.new <- habitat.2055}
  if(n == 66) {generation.new <- habitat.2065}
  if(n == 76) {generation.new <- habitat.2075}
  if(n == 86) {generation.new <- habitat.2085}
  if(n == 96) {generation.new <- habitat.2095}

   #calcuate dispersal probabilities for next year's possible offspring
   migrants <- Migrants(generation.new, pops, n.pops, n.offspring, alpha) 
   #creates pop id and dispersers ids matix to keep track who disperses where
   pops.new <- DispersersIDs(pops, migrants, generation.new) 
   
   #control local K for current map (year)
   pop.n <- ScaleLocalK(n.pops, k.adults, generation.new) 
   #density independence for pop size
   stochastic.popn <- StochasticPopN(adult.survival.var, pop.n) 
   
   #sample dispersers for local K by climate
   pops.new.climate <- ClimateMortLocalK(pops.new, stochastic.popn) 
     
   #create new population for next generation
   pops <- PopNew(pops, generation.new, n.loci, pops.new.climate) 
   #include heritability in alpha and beta
   pops<- Heritability(pops, alpha.heritability, beta.heritability, n.loci) 
   
   #generate output every 10 years
   output <- Output(pops, generation.new, r, n, model.parameters, beta.heritability, n.loci) # add in new variables here
  }
}




