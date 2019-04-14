ClimateMortLocalK <- function(pops.new, stochastic.popn){

#matrix with number of climate scaled dispersers per population
pop.n.fix <-stochastic.popn[stochastic.popn > 0]
pops.new2 <- cbind(1:length(pops.new[, 1]), pops.new) #add 1:end of pops.new so can index faster

#remove pops found in pop.n.fix aren't found in pops.new2
unique <- unique(pops.new2[,2]) #unique pops in current generation
pop.n.fix.matrix <- cbind(as.numeric(names(pop.n.fix)), pop.n.fix) #unvectorize pop.n.fix
find.me <- match(pop.n.fix.matrix[,1], unique, nomatch = 0) #find matches
remove.them <- cbind(pop.n.fix.matrix, find.me) #cbind matches so can remove 0s
remove.them2 <- subset(remove.them, remove.them[,3] > 0) #remove 0s from unmatching 
pop.n.fix2 <- remove.them2[,2] #revectorizes pop.n.fix2
names(pop.n.fix2) <- remove.them2[,1] #add pop names

#how many dispersers are there in each population (that has suitable habitat)?
dispers.pop <- table(pops.new2[,2]) #number of dispersers in each pop 
dispers.pop <- matrix(cbind(as.numeric(names(dispers.pop)), dispers.pop), ncol = 2) #add names to number of dispersers in each pop
find.me.2 <- match(dispers.pop[,1], matrix(as.numeric(names(pop.n.fix2), ncol=1)), nomatch = 0) #find matches
remove.them2 <- cbind(dispers.pop, find.me.2) #cbind matches so can remove 0s
dispers.pop <- remove.them2[remove.them2[,3] > 0 ,]
dispers.pop <- dispers.pop[,1:2]

#find how many short meta-population K
ind.short <- dispers.pop[,2] - pop.n.fix2
total.short <- sum(abs(ind.short[ind.short <= 0]))

if(total.short > 0) {
  rescale <- round((pop.n.fix2 / sum(pop.n.fix2)) * ((sum(pop.n.fix2) + total.short)))
  pop.n.fix2 <- rescale
  }

#pick next generation from pool of migrants
DISPERSERS.KEPT <- vector(mode = "numeric", length = sum(pop.n.fix2)) 
start <- 1
for (p in 1:length(pop.n.fix2)) { #for each population in pop.n.fix with local k > 0
 pop.size <- pop.n.fix2[p] #each population and local K
pull <- matrix(pops.new2[pops.new2[, 2] == as.numeric(names(pop.n.fix2)[p]),], ncol=3) #pull out individuals from pops.new from p population
  if(pop.size >= as.numeric(nrow(pull))){ #if there aren't enough individuals to sample
   dispersers.next <- pull[,1] #keep individuals that are there
  DISPERSERS.KEPT[start:(start-1 + length(dispersers.next))] <- dispersers.next
  start <- start + length(dispersers.next)
} else { 
 dispersers.keep <- sample(pull[, 1], pop.size, replace=FALSE) #sample the climate scaled no. dispersers from p population
  DISPERSERS.KEPT[start:(start-1 + pop.n.fix2[p])] <- dispersers.keep
  start <- start + pop.n.fix2[p]
}
}

DISPERSERS.KEPT <- DISPERSERS.KEPT[DISPERSERS.KEPT != 0] #remove ind
DISPERSERS.KEPT <- pops.new[DISPERSERS.KEPT, ] #fill back in individuals sampled from pops.new

return(DISPERSERS.KEPT)
} 


