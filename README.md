# CakileDispersalModel
Individual-based model of geographic variation in seed dispersal of Cakile edentula
Project title: Geographic variation in dispersal facilitates range expansion of a lakeshore plant in response to climate change

Authors:
Elizabeth LaRue, elizabethannlarue@gmail.com
Mark Christie, christ99@purdue.edu

Motivation:

In order, to answer how changes to geographic gradients associated with climate change affect the evolution of dispersal and influence range dynamics
we needed an individual based, eco-genic model that allowed for disperal evolution. There were no previously existing species distribution models that 
simulataneoulsy allowed for dispersal evolution, geographic variation in the dispersal kernel of individuals, and climate change projections. We used maps 
of climatic niche suitability of coastal habitat in the Great Lakes for Cakile edentula var. lacustris that were created with MaxEnt. These were combined with
the following individual-based model written in R. 

How to run this model: 

This model was built in the R programming platform and is written in a modular format.This code have been made freely available following the publication of DOIxxxxxx-xxxxx
, but was meant to run with parallel processing from a unix supercomputing platform.This model can be run from model.R directly in from R studio or 
R platform run line by line.This model can be run on versions of R of 3.5.1 or later and requires the use of the fields package.

It is necessary to include the following folder structure, so that there is a master model folder that contains model.R, the source folder (containing
the functions), and an output folder. Individual functions are stored in different .R files and called from a main function Runmodel.R. Parameter values for
global variables are set from the model.R file where the simulation with replicates is setup to run from here. The functionsourcer.R file must be called 
to load each function by its modular format.

Model Steps:

Initiation: 

1.	Create matrix for all populations that have habitat great than zero: popid, x, y, habitat suitability using all populations (meta-population K = 
	50 * n.pops > 0 habitat suitability). HabitatScaleIntial.R

2.	Establish populations: Add columns that include popid, x, y, habitat suitability, dispersal kernel mean, dispersal kernel variance. 
	Modify the genetic variance of the dispersal kernel. Can modify the length of the dispersal kernel by latitude that is in center or edge or range 
	based on a quadratic equation (set a, b, c). PopSetupClimate.R, Genotypes.R

3.	Output at generation zero: Output0.R

Yearly Iterations: 

4.	Set the matrix with next year’s habitat suitability for each population: use matrix with: popid, x, y, habitat suitability. The number of populations
	and location stays the same each year. Number of migrants based on dispersal kernel: For each currently existing population, calculate the pairwise 
	Euclidian distance between each existing population with itself and all future populations (pops and pops.new). Using distance matrix and each 
	individuals’ dispersal kernel calculate a vector with probabilities for dispersal to each new and current population. For each individual, multiple 
	n.offspring by the probability vector to produce how many offspring will go to each new population and the current population (can’t > n.offspring) 
	(provides variation in survival in the new population so evolution can occur). Migrants.R

5.	Create list of dispersers: Move offspring to new population. Create matrix from vector with number of individuals going to each population, but only 
	include clone id and new pop id. Sample n.total individuals from this matrix for next year’s adults that successfully dispersed to the new populations. 
	The final matrix will have the same setup as pops. DispersalIDs.R

6.	Control Local K – local K habitat scaling by climate suitability: Scale local K for each population by habitat suitability value, however global K 
	stays constant at n.adults * n.pops. To turn function off in matrix will make habitat suitability in matrix equal to 1 – this will allow extinction. 
	ScaleLocalK.R

7.	Stochasticity in adult survival: Kill some offspring or dispersers due to density independence. StochasticPopN.R. 

8.	Kill excess dispersers to meet local K for each pop: randomly sample the number of dispersers needed after local population size is scaled for 
	climate suitability. If do not meet global K then add how many individuals short to meta-population K and rescale all local K to fill in deficit. 
	Will sometimes be short of meta-population K but this will minimize the gap. ClimateMortLocalK.R 

9.	Create new pops matrix: create the new population of the global number of individuals with genotypes and dispersal kernel traits. PopNew.R

10.	Heritability in dispersal kernel mean and variance: varies the dispersal kernel mean and standard deviation based on the set heritability percentage
	(.1) for beta for every individual after dispersal. Heritability.R

11.	Output: Measure output at 10 year intervals. Output.R

12.	Repeat: Steps 4-11 for 105 years. RunModel.R
