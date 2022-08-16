# Random-forest-model-for-predicting-log-carbon
Random forest model for predicting the log carbon stock (0-5 cm) for edgeroi township, Australia
We have point Data, dataframe of 341 observations from edgeroi district, Austrailia (Experimental data), from ithir package.
We did natural log transform of dataset.
We have 5 covariates (elevation ,twi, radK, landsat_b3, landsat_b4) for edgeroi as a grid/raster data from ithir package for which we have to 
predict the log stock carbon.
We have stacked our raster and then extracted the data and store the raster data as a dataframe so that we can run ML model on it.
Now, fitted RF model- predicting soc for 0-5 cm soil depth.
Visualization of the importance of covariates. And performing calibration and validation gave reasonable R squared value.
Finally predicting the cstock 0-5 cm for the whole raster(covstack) using our RF training model.
Hence going from the few point data, we predited the log carbon stock for the whole raster.

