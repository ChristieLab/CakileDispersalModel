#FunctionSourcer
# Set working directory, import packages, source functions, 
setwd(paste(base.directory,"/source/", sep = ''))    # set temp working directory 
library(fields)  # used for calculation dispersal distance matrix

#read in habitat maps
habitat.t <- read.csv ('2000.nor85.EXTCC.csv', header = T) #initiation map
habitat.2000 <- read.csv ('2000.nor85.EXTCC.csv', header = T) #historical map year 1971-2000
habitat.2025 <- read.csv ('2025.nor85.EXTCC.csv', header = T) #2025
habitat.2035 <- read.csv ('2035.nor85.EXTCC.csv', header = T) #2035
habitat.2045 <- read.csv ('2045.nor85.EXTCC.csv', header = T) #2045
habitat.2055 <- read.csv ('2055.nor85.EXTCC.csv', header = T) #2055
habitat.2065 <- read.csv ('2065.nor85.EXTCC.csv', header = T) #2065
habitat.2075 <- read.csv ('2075.nor85.EXTCC.csv', header = T) #2075
habitat.2085 <- read.csv ('2085.nor85.EXTCC.csv', header = T) #2085
habitat.2095 <- read.csv ('2095.nor85.EXTCC.csv', header = T) #2095

source(paste(getwd(), "/PopSetupClimate.R", sep = ''))
source(paste(getwd(), "/HabitatScaleInitial.R", sep = ''))
source(paste(getwd(), "/StochasticPopN.R", sep = ''))
source(paste(getwd(), "/Genotypes.R", sep = ''))
source(paste(getwd(), "/RunModel.R", sep = ''))
source(paste(getwd(), "/Migrants.R", sep = ''))
source(paste(getwd(), "/DispersersIDs.R", sep = ''))
source(paste(getwd(), "/ClimateMortLocalK.R", sep = ''))
source(paste(getwd(), "/Heritability.R", sep = ''))
source(paste(getwd(), "/ScaleLocalK.R", sep = ''))
source(paste(getwd(), "/PopNew.R", sep = ''))
source(paste(getwd(), "/Output.R", sep = ''))
source(paste(getwd(), "/Output0.R", sep = ''))
