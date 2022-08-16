
library(ithir)
library(raster)
library(rgdal)
library(randomForest)





########################## DATA PREPERATION ###############################


# Point Data, dataframe of 341 observations from edgeroi district, Austrailia
data("edgeroi_splineCarbon")
names(edgeroi_splineCarbon)[2:3]= c("x","y")


# Natural log transform of dataset ( assumption of normality of dataset for the parametric models)
edgeroi_splineCarbon$log_cStock0_5 <- log(edgeroi_splineCarbon$X0.5.cm)


# Grids
data(edgeroiCovariates)
coordinates(edgeroi_splineCarbon) = ~ x+y

# Stack the rasters:
covstack= stack(elevation, landsat_b3, landsat_b4, radK, twi)

# Extract data 
DSM_data= extract(covstack, edgeroi_splineCarbon, sp=1, method= "simple")

# Store the raster data as a dataframe so that we can run ML models on it
DSM_data= as.data.frame(DSM_data)

# Reduce the dataframe to what is necessary
DSM_data= DSM_data[ , c(2:3 , 11:16) ]

# If there is any missing value?
which(!complete.cases(DSM_data))
DSM_data <- DSM_data[complete.cases(DSM_data), ]






########################  RANDOM FOREST MODEL ########################


set.seed(123)

training = sample(nrow(DSM_data), 0.7*nrow(DSM_data)) 

# Fitting RF model- predicting soc gor 0-5 cm soil depth
edge.RF.Exp <- randomForest(log_cStock0_5 ~ elevation + twi + radK +
                              landsat_b3 + landsat_b4, data = DSM_data[training, ],
                            importance = TRUE, ntree = 1000)
print(edge.RF.Exp)

#Visualize the importance of covariates
varImpPlot(edge.RF.Exp)

# Internal validation (Calibration)
RF.pred.C= predict(edge.RF.Exp, DSM_data[training,])
goof(observed = DSM_data$log_cStock0_5[training] ,predicted= RF.pred.C)

#External validation
RF.pred.V= predict(edge.RF.Exp, DSM_data[-training,])
goof(observed= DSM_data$log_cStock0_5[-training] , predicted= RF.pred.V)


# predicting the cstock 0-5 cm for the whole raster(covstack) using our RF training model

map.RF.r1 <- predict(covstack, edge.RF.Exp, "cStock_0_5_RF.tif",
                     format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

# Map
plot(map.RF.r1, main = "Random Forest model predicted 0-5cm log carbon stocks (0-5cm)")





