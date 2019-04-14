#==================================================================================================#
# Script created by Mark Christie, contact at Redpath.Christie@gmail.com
#and by Elizabeth LaRue, contact at elizabethannlarue@gmail.com
# Script created in version R 3.1.1
# This script:  Generates model output for Cakile Dispersal project
# Usage notes: Set all parameters below and then source this file
#==================================================================================================#
# Set working directory and output directory
# Directory where model.R and 'source' folder reside  
#setwd
setwd("C:/Users/eliza/Documents/DD/cakile11.1")

base.directory <- getwd()
source(paste(base.directory, "/source/FunctionSourcer.R", sep = '')) #loads source functions, and sets source director
outdir <- paste(base.directory,"/output/",sep="")  # directory to save model output  

#unique name to add to output file names for each parameter set
name <- "cakile" 

#Population parameters
n.pops  <- nrow(habitat.t) #total number of patches in landscape
global.k.var <- 100 #density independence in regional carrying capacity 
  
#Dispersal kernel - Weibull distribution
alpha <- 1 #shape of the curve - high density at zero dispersal distance
beta <- 0 #fixed value of scale parameter (beta)

center <- c(5) #beta at center of range, can run multiple parameters at once
edge <- c(5) #beta at edge of range 
beta.var <- 0.5 #starting variation in beta (higher = starting genetic variation)
beta.heritability <- c(0.1) #heritability of beta to add some environmental variation

#coefficients to model geographic var. in beta as quadratic model
#for homogeneous a & b = 0, c = center/edge value
#invert sign of a, b, c to get opposite center edge values
a.geo <- c(0)
b.geo <- c(0)
c.geo <- c(5)

#within pop.parameters
k.adults   <- 50 #average number of adults in each population
adult.survival.var   <- 2 #density independence in local carrying capacity

#Model paramters
n.generations <- 105 #number of generations
n.replicates  <- 4  # number of replicates for each combination of parametmers
n.offspring <- 50 #number of offspring per individual

#neutral genetic variation
n.loci <- 50 #number of microsatellite loci
n.alleles <- 50 #number of microsatellite alleles


#built-in options that are currently not being used - in case of changes later
dispersal.mean <- 0 
dispersal.var <- 0 
alpha.var <- 0 
alpha.heritability <- 0 

#================================================ RUN THE MODEL WITH REPLICATES AND DIFERENT SCENARIOS ==========================================================#

replicates <- cbind(center, edge, beta.heritability, a.geo, b.geo, c.geo)
replicates <- replicates[rep(seq_len(nrow(replicates)), n.replicates), ]
reps <- length(replicates[, 1])

for(r in 1:reps){
  center <<- replicates[r, 1]
  edge <<- replicates[r, 2]
  beta.heritability <<- replicates[r, 3]
  a.geo <<- replicates[r, 4]
  b.geo <<- replicates[r, 5]
  c.geo <<- replicates[r, 6]
  runmodel <- RunModel(n.generations)
}


