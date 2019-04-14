Output0 <- function(pops, habitat.t, r, n, model.parameters, beta.heritability, n.loci) {
  
# output.range=====================================#
sites.occupied <- nrow(as.data.frame(table(pops[, 1])))
avg.popsize <- mean(table(pops[, 1]))
range.beta <- mean(pops[,10])
range.varbeta <- var(pops[,10])
range.gvar.beta <- range.varbeta - (beta.heritability^2)
range.h2.beta <- range.gvar.beta / range.varbeta

#added feb. 26, 2018 so could add average number of alleles across loci in the range
locis.4.avg <- NULL
l <- seq(1:n.loci)
for(x in l) {
  loci.x <- matrix(c(pops[, (10 + (x*2))], pops[,(11 + (x*2))]) , ncol = 1)
  unq.alleles <- unique(loci.x)
  how.many.alleles <- length(unq.alleles)
  locis.4.avg <- cbind(locis.4.avg, how.many.alleles)
}
avg.alleles<- mean(locis.4.avg) 

output.range <- matrix(c(model.parameters, r, 0, sites.occupied, avg.popsize, nrow(pops), range.beta, range.varbeta,range.gvar.beta, range.h2.beta, avg.alleles), nrow=1)
write.table(output.range, file=paste(outdir, "outrange", name, ".txt", sep = "_"), col.names = FALSE, row.names = FALSE, sep="\t", append = TRUE)

# output.pop =====================================#
#calculate pops size and dispersal kernal genetics
pop.sizes <- data.frame(table(pops[, 1]))
mean.beta <- abs(tapply(pops[,10],pops[,1],mean))
var.beta <- abs(tapply(pops[,10],pops[,1],var))

#calculate three measures of neutral genetic diversity of usats
gtypes <- cbind(pops[,1], pops[,12:111])
pop.name <- unique(pops[,1]) #vector of names of populations
loc.pos <- seq(from = 1+1, to = n.loci*2, by = 2) #column num in matrix of each locus

GENETIC.DIVERSITY <- NULL
for(z in pop.name) {
  pull <- matrix(gtypes[gtypes[, 1] == z,], ncol = (1+n.loci*2)) #genotypes for pop p
  clones <- nrow(unique(pull))
  HET <- NULL
  for(l in loc.pos){
    # per locus heterozygosity
    locus <- matrix(pull[, c(l,l+1)], ncol = 2)
    geno  <- length(locus[, 1])
    het   <- length(which(locus[, 1] != locus[, 2]))
    het.observed  <- het/geno
    
    freqs <- table(locus)
    p <- freqs/(geno*2)
    het.expected <- 1-sum(p^2)
    hets <- cbind(het.observed, het.expected)
    HET <- rbind(HET, hets) 
  }
  Ho <- mean(HET[, 1])
  He <- mean(HET[, 2]) #averaged across loci
  P.poly <- 1-(length(which(HET[, 1] == 0))/length(HET[, 1]))
  GENETIC.DIVERSITY <- rbind(GENETIC.DIVERSITY, cbind(Ho, He, P.poly, clones))
}

#find lat, long and habitat suitability for pops that have individuals this generation
match.pop.n <- match(habitat.t$popid, pop.sizes$Var1, nomatch = 0)
new <- cbind(habitat.t, match.pop.n)
new.generation.new <- subset(new, new$match.pop.n > 0)
pop.env <- new.generation.new[,3:5]
  
output.population <- cbind(pop.sizes, pop.env, mean.beta, var.beta, GENETIC.DIVERSITY)
output.population <- data.matrix(output.population, rownames.force = NA)
names <- as.numeric(rownames(output.population))
output.population <- cbind(names,output.population)
output.population <- output.population[,-2]
output.population <- cbind(model.parameters[rep(nrow(model.parameters), nrow(output.population)) ,], rep(r, nrow(output.population)), rep(0, nrow(output.population)), output.population)
write.table(output.population, file=paste(outdir, "outpop", name, ".txt", sep = "_"), col.names = FALSE, row.names = FALSE, sep="\t", append = TRUE) 

} 
