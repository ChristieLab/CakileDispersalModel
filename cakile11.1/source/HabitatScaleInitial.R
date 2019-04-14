HabitatScaleIntial <- function(k.adults, n.pops, habitat.t) {

habitat.t.nozeros <- habitat.t[habitat.t[, 5] > 0, ]  #remove patches that have zero habitat suitability
n.total <- nrow(habitat.t.nozeros) * k.adults #must adjust meta-K based on patches to be occupied
                                              #otherwise meta-k is too large at start
first.pop <- cbind(habitat.t[, 2], rep(k.adults, n.pops))

#  on/off switch for habitat suitability - turn generation.t[,5] into 1s so just get average pop size

first.pop <- round(first.pop[, 2] * habitat.t[, 5]) #multiply current population size by habitat suitability

#  on/off switch for habitat suitability scaling to n.total
#  on = no extinction
#  off = extinction is allowed
#  just turn off the scale. pop line after this comment 

first.pop <- round(first.pop / sum(first.pop) * n.total)  #scale pop.n so that total number of individuals equals n.total 


#pop.n <-cbind(generation.t[, 2], pop.n)  #add popID back in as a col
names(first.pop) <- habitat.t[,2] #add popID as rownames
return(first.pop)  #output is number of scale adults in each pop

#  To choose the correct number of migrants in Dispersal.R if allowing for extinction
#  Take the sum of pop.n[,2] to get new n.total (to choose correct number of migrants)

}

