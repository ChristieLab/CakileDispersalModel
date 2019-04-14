ScaleLocalK <- function(n.pops, k.adults, generation.new) {

#n.total <- n.pops * k.adults #meta-population k with all patches
###CURRENTLY TURNED ON TO CALCULATE meta-population K BASED ON K.ADULTS * CURRENT NO. PATCHES HABITAT SUITABILIYT > 0
generation.new.nozeros <- generation.new[generation.new[,5]>0,]
n.pops.nozero <- nrow(generation.new.nozeros)
n.total <- n.pops.nozero* k.adults #global k with only patches with habitat suitability > 0) 

#next.pop <- cbind(generation.new [, 2], rep(k.adults, n.pops)) #starting local k all constant
next.pop <- cbind(generation.new.nozeros[, 2], rep(k.adults, n.pops.nozero)) #starting local k all constant

#on/off switch for habitat suitability - turn generation.new[,5] into 1s so just get average pop size
#next.pop <- round(next.pop[, 2] * generation.new[, 5]) #multiply current population size by habitat suitability
next.pop <- round(next.pop[, 2] * generation.new.nozeros[, 5]) #multiply current population size by habitat suitability

#  on/off switch for habitat suitability scaling to n.total
#  on = no extinction
#  off = extinction is allowed
#  just turn off the scale. pop line after this comment 

next.pop <- round(next.pop / sum(next.pop) * n.total)  #scale pop.n so that total number of individuals equals n.total 


#pop.n <-cbind(generation.t[, 2], pop.n)  #add popID back in as a col
#names(next.pop) <- generation.new[,2] #add popID as rownames
names(next.pop) <- generation.new.nozeros[,2] #add popID as rownames
return(next.pop)  #output is number of scale adults in each pop

#  To choose the correct number of migrants in Dispersal.R if allowing for extinction
#  Take the sum of pop.n[,2] to get new n.total (to choose correct number of migrants)

}

