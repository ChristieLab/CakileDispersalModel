PopNew <- function(pops, generation.new, n.loci, pops.new.climate) {

new.inds.table <- table(pops.new.climate[,2], pops.new.climate[,1]) #create contingency table clone ids x pop id
new.popnames <- as.numeric(colnames(new.inds.table)) #pop names for colonized populations
new.clones <- as.numeric(rownames(new.inds.table)) #unique clone names
#patch
clones <- pops[new.clones, ] #pops info for unique clones for successful dispersers
clones <- clones[order(clones[,3]),]

offspring.number <- colSums(new.inds.table, na.rm = TRUE)  #how many offspring going to each new pop
total.offs <- sum(offspring.number)  #total offspring created

#find lat, long and habitat suitability for pops that have individuals this generation
match.popsinfo <- generation.new[new.popnames, ]
newlong <- match.popsinfo[,3] 
newlat <- match.popsinfo[,4]
newh.suit <- match.popsinfo[,5]

#create labels to match first 5 col of pops
newpops.id <- rep(new.popnames, times=offspring.number)  #new pop id
ids  <- rep(new.popnames, offspring.number)   # not right - need to be 1:n for each pop
pid  <- 1:total.offs   #total number of global individuals 
x <- rep(newlong, times=offspring.number)  #x 
y <- rep(newlat, times=offspring.number)  #y
h.suit <- rep(newh.suit, times=offspring.number)
labels <- cbind(newpops.id, ids, pid, x, y, h.suit)  #1st 5 cols of pops

#repeat migrants matrix to repeat each individual within population it should be dispersed to
POPS <- matrix(nrow = total.offs, ncol = ((n.loci * 2) + 11))
rownumber <- 1
for(c in 1:ncol(new.inds.table)) {
  POPS[rownumber:(rownumber - 1 + sum(new.inds.table[,c])), 1:((n.loci * 2) + 11)] <- clones[rep(seq(nrow(clones)), new.inds.table[,c]) ,]
  rownumber <- rownumber + nrow(clones[rep(seq(nrow(clones)), new.inds.table[,c]), , drop=FALSE])
}

#cut out old pop ids
POPS <- POPS[,7:((n.loci * 2) + 11)]

#cbind labels and traits
pops <- cbind(labels,POPS)
return(pops)
}

