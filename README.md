# Build database for landuse / landcover spatial dataset 

This repo was developed under API-SMAL project to combine RPG data, CLC data, and AROPAj output data for a basis of inter-disciplinary, inter-dept models and scenarios.

### Goals at first go:

1. load CLC vector files by year
2. load pre-processed PRA files (ilot files containing geom objects, culture files) by year
3. load AROPAj spatialized data

Organize above objects it in a postgresql database with postgis extension.

Following the convention recommendations here:

  https://richpauloo.github.io/2018-10-17-How-to-keep-your-R-projects-organized/
  
### Results:

1. when summing by region, CLC and RPG data are problematic
2. Some .RDA files appear to have wrong dataheaders
3. Appear to be missing departments I thought were already loaded (map, below)
4. 


![map of missing geom load.ilots depts](docimg/missingdepts.png)
