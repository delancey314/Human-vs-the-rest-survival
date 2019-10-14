UAA R Code
===========
### This doc illustrates the R code used to generate UAA system scores.
### The code is divided into two parts: *score calculation* and *loss prediction*.
##### *Important Note: All the files inside the folder cannot be renamed and moved, they must stay exactly the same as they were. Otherwise, R might report errors and lead to execution failure.*
##### Below is a step-wise instruction for each of them.

1. Score Calculation  
    Step 1: Under the folder: CompiledRCode/R, open the file: auto_preparation.R with R or RStudio(recommend RStudio).
    Step 2: Locate line 3, this is the working directory, it is **imperative** to change the directory to where the CompiledRCode folder is stored.
    Step 3: Run the entire chunk of code, this would generate the folder of UAA scores.

2. Loss Prediction
       Step 1:  Under the folder: CompiledRCode, open the file: LossPredictionCompile.r with R or RStudio(recommend RStudio).
       Step 2:  There are three packages used in this chunk of code: dplyr, lavaan, pscl, install them if your R hasn’t yet.
       Step 3:  Locate line 6, this is the working directory, it is **imperative** to change the directory to where the CompiledRCode folder is stored.
       Step 4: Run the code, two files: flood_cost.csv, drought_cost.csv will be generated.
