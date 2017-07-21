# getting-and-cleaning-data-project

The R script `run_analysis.R` does the following:
	
1. Download the requered dataset in `dataset.zip` into the working directory
2. Load the activity and feature infos
3. Load and adjust the correct variables' name
4. Load only the required columns of the train and test datasets
5. Load the activity and subject data for each dataset
6. Merge the columns from activity and subject with each dataset
7. Merge the train and test datasets
8. Convert the `activity` and `subject` columns into factors
9. Create a tidy dataset using the melt() and dcast() functions.

The end result is shown in the file `independent_tidy.txt`.
  
