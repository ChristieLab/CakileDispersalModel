DispersersIDs <- function(pops, migrants, generation.new) {

newpops <- generation.new[,2]  #new pop names

offspring.number <- colSums(migrants, na.rm = TRUE)  #how many offspring going to each new pop
total.offs <- sum(offspring.number)  #total offspring created

newpops.id <- rep(newpops, times=offspring.number)  #new pop id


migrants.nozeros <- subset(migrants, select = (colSums(migrants) > 0)) #find col migrants = 0
pops.pid <- matrix(pops[,3], ncol = 1) #cut down pops to unique "clone" ids to repeat with migrants matrix

#repeat migrants matrix to repeat each individual within population it should be dispersed to
MIGRANT.GENETICS <- matrix(nrow = total.offs, ncol = 1)
rownumber <- 1
for(c in 1:ncol(migrants.nozeros)) {
  MIGRANT.GENETICS[rownumber:(rownumber - 1 + sum(migrants.nozeros[,c])), 1] <- matrix(pops.pid[rep(seq(nrow(pops.pid)), migrants.nozeros[,c]),], ncol = 1)
  rownumber <- rownumber + sum(migrants.nozeros[,c])
}

pops.new <- cbind(newpops.id, MIGRANT.GENETICS) #col 1 is new pop ID, col 2 is the clone ID
return(pops.new)
}


