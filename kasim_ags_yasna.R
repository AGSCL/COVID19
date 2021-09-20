#####################################################################
#         Analysis 2m temperature (Near-Surface Temperature) ERA5
#         Profiling each country to obtain monthly temp information
#####################################################################

#####################################################################
# Data and Sources
#####################################################################
# 1. TEMPERATURE 
# 2m temperature or near surface temperature is the air temperature 
# at 2 meters above the surface, so it is the temperature that 
# affects people.
# Reanalysis data uses forecast models and data assimilation systems
# to "reanalyse" archived observations, creating global data sets 
# describing the recent history of the atmosphere, land surface, and oceans.
# What was obtained: 2m temperature from ERA5 monthly averaged data 
# on single levels from 1979 to present. 
# The request included data from Nov2019 to Oct2020, area: globally,
# grid: 0.25 x 0.25.
# ERA 5: https://cds.climate.copernicus.eu/cdsapp#!/home

# 2. COUNTRY PROFILES
# To obtain country information, 148 country profiles were obtained from:
# GADM: https://gadm.org/index.html
# These profiles are used to obtain specific country areas considering 
# temperature grids. Two countries were not find in this database, so were
# profiled using coordinate in ERA5 requirement. 

## Some libraries:
library(raster)    # raster spatial data processing
library(rasterVis)
library(sf)        # vector spatial data processing
library(sp)
library(ncdf4)
library(rgdal)
library(dplyr)

#####################################################################
# Loading profiles of countries
#####################################################################
#setwd("C:/Users/yasna/OneDrive/Escritorio/Kasim/Countries")

setwd(gsub("kasim_ags_yasna.R","TemperatureGRID/TemperaturesGRIDdata/Countries",rstudioapi::getSourceEditorContext()$path))


bordersAFG <- readRDS("gadm36_AFG_0_sp.rds")
bordersALB <- readRDS("gadm36_ALB_0_sp.rds")
bordersDZA <- readRDS("gadm36_DZA_0_sp.rds")
bordersAGO <- readRDS("gadm36_AGO_0_sp.rds")
bordersARG <- readRDS("gadm36_ARG_0_sp.rds")
bordersAUS <- readRDS("gadm36_AUS_0_sp.rds")
bordersAUT <- readRDS("gadm36_AUT_0_sp.rds")
bordersAZE <- readRDS("gadm36_AZE_0_sp.rds")
bordersBHR <- readRDS("gadm36_BHR_0_sp.rds")
bordersBGD <- readRDS("gadm36_BGD_0_sp.rds")
bordersBRB <- readRDS("gadm36_BRB_0_sp.rds")
bordersBLR <- readRDS("gadm36_BLR_0_sp.rds")
bordersBEL <- readRDS("gadm36_BEL_0_sp.rds")
bordersBLZ <- readRDS("gadm36_BLZ_0_sp.rds")
bordersBEN <- readRDS("gadm36_BEN_0_sp.rds")
bordersBTN <- readRDS("gadm36_BTN_0_sp.rds")
bordersBOL <- readRDS("gadm36_BOL_0_sp.rds")
bordersBIH <- readRDS("gadm36_BIH_0_sp.rds")
bordersBWA <- readRDS("gadm36_BWA_0_sp.rds")
bordersBRA <- readRDS("gadm36_BRA_0_sp.rds")
bordersBRN <- readRDS("gadm36_BRN_0_sp.rds")
bordersBGR <- readRDS("gadm36_BGR_0_sp.rds")
bordersBFA <- readRDS("gadm36_BFA_0_sp.rds")
bordersBDI <- readRDS("gadm36_BDI_0_sp.rds")
bordersKHM <- readRDS("gadm36_KHM_0_sp.rds")
bordersCMR <- readRDS("gadm36_CMR_0_sp.rds")
bordersCPV <- readRDS("gadm36_CPV_0_sp.rds")
bordersCAF <- readRDS("gadm36_CAF_0_sp.rds")
bordersTCD <- readRDS("gadm36_TCD_0_sp.rds")
bordersCAN <- readRDS("gadm36_CAN_0_sp.rds")
bordersCHL <- readRDS("gadm36_CHL_0_sp.rds")
bordersCHN <- readRDS("gadm36_CHN_0_sp.rds")
bordersCOL <- readRDS("gadm36_COL_0_sp.rds")
bordersCRI <- readRDS("gadm36_CRI_0_sp.rds")
bordersCIV <- readRDS("gadm36_CIV_0_sp.rds")
bordersHRV <- readRDS("gadm36_HRV_0_sp.rds")
bordersCYP <- readRDS("gadm36_CYP_0_sp.rds")
bordersCZE <- readRDS("gadm36_CZE_0_sp.rds")
bordersCOD <- readRDS("gadm36_COD_0_sp.rds")
bordersDNK <- readRDS("gadm36_DNK_0_sp.rds")
bordersDJI <- readRDS("gadm36_DJI_0_sp.rds")
bordersDOM <- readRDS("gadm36_DOM_0_sp.rds")
bordersECU <- readRDS("gadm36_ECU_0_sp.rds")
bordersEGY <- readRDS("gadm36_EGY_0_sp.rds")
bordersSLV <- readRDS("gadm36_SLV_0_sp.rds")
bordersEST <- readRDS("gadm36_EST_0_sp.rds")
bordersETH <- readRDS("gadm36_ETH_0_sp.rds")
bordersFJI <- readRDS("gadm36_FJI_0_sp.rds")
bordersFIN <- readRDS("gadm36_FIN_0_sp.rds")
bordersFRA <- readRDS("gadm36_FRA_0_sp.rds")
bordersGAB <- readRDS("gadm36_GAB_0_sp.rds")
bordersGMB <- readRDS("gadm36_GMB_0_sp.rds")
bordersGEO <- readRDS("gadm36_GEO_0_sp.rds")
bordersDEU <- readRDS("gadm36_DEU_0_sp.rds")
bordersGHA <- readRDS("gadm36_GHA_0_sp.rds")
bordersGRC <- readRDS("gadm36_GRC_0_sp.rds")
bordersGTM <- readRDS("gadm36_GTM_0_sp.rds")
bordersGIN <- readRDS("gadm36_GIN_0_sp.rds")
bordersGUY <- readRDS("gadm36_GUY_0_sp.rds")
bordersHTI <- readRDS("gadm36_HTI_0_sp.rds")
bordersHND <- readRDS("gadm36_HND_0_sp.rds")
bordersHUN <- readRDS("gadm36_HUN_0_sp.rds")
bordersISL <- readRDS("gadm36_ISL_0_sp.rds")
bordersIND <- readRDS("gadm36_IND_0_sp.rds")
bordersIRN <- readRDS("gadm36_IRN_0_sp.rds")
bordersIRQ <- readRDS("gadm36_IRQ_0_sp.rds")
bordersIRL <- readRDS("gadm36_IRL_0_sp.rds")
bordersIDN <- readRDS("gadm36_IDN_0_sp.rds")
bordersISR <- readRDS("gadm36_ISR_0_sp.rds")
bordersITA <- readRDS("gadm36_ITA_0_sp.rds")
bordersJAM <- readRDS("gadm36_JAM_0_sp.rds")
bordersJPN <- readRDS("gadm36_JPN_0_sp.rds")
bordersJOR <- readRDS("gadm36_JOR_0_sp.rds")
bordersKAZ <- readRDS("gadm36_KAZ_0_sp.rds")
bordersKEN <- readRDS("gadm36_KEN_0_sp.rds")
bordersKWT <- readRDS("gadm36_KWT_0_sp.rds")
bordersKGZ <- readRDS("gadm36_KGZ_0_sp.rds")
bordersLAO <- readRDS("gadm36_LAO_0_sp.rds")
bordersLVA <- readRDS("gadm36_LVA_0_sp.rds")
bordersLBN <- readRDS("gadm36_LBN_0_sp.rds")
bordersLBR <- readRDS("gadm36_LBR_0_sp.rds")
bordersLBY <- readRDS("gadm36_LBY_0_sp.rds")
bordersLTU <- readRDS("gadm36_LTU_0_sp.rds")
bordersLUX <- readRDS("gadm36_LUX_0_sp.rds")
bordersMDG <- readRDS("gadm36_MDG_0_sp.rds")
bordersMWI <- readRDS("gadm36_MWI_0_sp.rds")
bordersMYS <- readRDS("gadm36_MYS_0_sp.rds")
bordersMLI <- readRDS("gadm36_MLI_0_sp.rds")
bordersMRT <- readRDS("gadm36_MRT_0_sp.rds")
bordersMUS <- readRDS("gadm36_MUS_0_sp.rds")
bordersMEX <- readRDS("gadm36_MEX_0_sp.rds")
bordersMDA <- readRDS("gadm36_MDA_0_sp.rds")
bordersMNG <- readRDS("gadm36_MNG_0_sp.rds")
bordersMAR <- readRDS("gadm36_MAR_0_sp.rds")
bordersMOZ <- readRDS("gadm36_MOZ_0_sp.rds")
bordersNPL <- readRDS("gadm36_NPL_0_sp.rds")
bordersNLD <- readRDS("gadm36_NLD_0_sp.rds")
bordersNIC <- readRDS("gadm36_NIC_0_sp.rds")
bordersNZL <- readRDS("gadm36_NZL_0_sp.rds")
bordersNER <- readRDS("gadm36_NER_0_sp.rds")
bordersNGA <- readRDS("gadm36_NGA_0_sp.rds")
bordersNOR <- readRDS("gadm36_NOR_0_sp.rds")
bordersOMN <- readRDS("gadm36_OMN_0_sp.rds")
bordersPAK <- readRDS("gadm36_PAK_0_sp.rds")
bordersPAN <- readRDS("gadm36_PAN_0_sp.rds")
bordersPNG <- readRDS("gadm36_PNG_0_sp.rds")
bordersPRY <- readRDS("gadm36_PRY_0_sp.rds")
bordersPER <- readRDS("gadm36_PER_0_sp.rds")
bordersPHL <- readRDS("gadm36_PHL_0_sp.rds")
bordersPOL <- readRDS("gadm36_POL_0_sp.rds")
bordersPRT <- readRDS("gadm36_PRT_0_sp.rds")
bordersROU <- readRDS("gadm36_ROU_0_sp.rds")
bordersRUS <- readRDS("gadm36_RUS_0_sp.rds")
bordersRWA <- readRDS("gadm36_RWA_0_sp.rds")
bordersSAU <- readRDS("gadm36_SAU_0_sp.rds")
bordersSEN <- readRDS("gadm36_SEN_0_sp.rds")
bordersSYC <- readRDS("gadm36_SYC_0_sp.rds")
bordersSLE <- readRDS("gadm36_SLE_0_sp.rds")
bordersSGP <- readRDS("gadm36_SGP_0_sp.rds")
bordersSVK <- readRDS("gadm36_SVK_0_sp.rds")
bordersSVN <- readRDS("gadm36_SVN_0_sp.rds")
bordersZAF <- readRDS("gadm36_ZAF_0_sp.rds")
bordersKOR <- readRDS("gadm36_KOR_0_sp.rds")
bordersESP <- readRDS("gadm36_ESP_0_sp.rds")
bordersLKA <- readRDS("gadm36_LKA_0_sp.rds")
bordersSUR <- readRDS("gadm36_SUR_0_sp.rds")
bordersSWZ <- readRDS("gadm36_SWZ_0_sp.rds")
bordersSWE <- readRDS("gadm36_SWE_0_sp.rds")
bordersCHE <- readRDS("gadm36_CHE_0_sp.rds")
bordersTJK <- readRDS("gadm36_TJK_0_sp.rds")
bordersTZA <- readRDS("gadm36_TZA_0_sp.rds")
bordersTHA <- readRDS("gadm36_THA_0_sp.rds")
bordersTGO <- readRDS("gadm36_TGO_0_sp.rds")
bordersTTO <- readRDS("gadm36_TTO_0_sp.rds")
bordersTUN <- readRDS("gadm36_TUN_0_sp.rds")
bordersTUR <- readRDS("gadm36_TUR_0_sp.rds")
bordersUGA <- readRDS("gadm36_UGA_0_sp.rds")
bordersUKR <- readRDS("gadm36_UKR_0_sp.rds")
bordersARE <- readRDS("gadm36_ARE_0_sp.rds")
bordersGBR <- readRDS("gadm36_GBR_0_sp.rds")
bordersURY <- readRDS("gadm36_URY_0_sp.rds")
bordersUSA <- readRDS("gadm36_USA_0_sp.rds")
bordersUZB <- readRDS("gadm36_UZB_0_sp.rds")
bordersVEN <- readRDS("gadm36_VEN_0_sp.rds")
bordersVNM <- readRDS("gadm36_VNM_0_sp.rds")
bordersYEM <- readRDS("gadm36_YEM_0_sp.rds")
bordersZMB <- readRDS("gadm36_ZMB_0_sp.rds")
bordersZWE <- readRDS("gadm36_ZWE_0_sp.rds")

# Pending: Congo and Timor
# Get these countries based on coordinates:
# Congo: N=5.1; S=-11 ; E=28 ; W=12
# Timor: N=-8; S=-9 ; E=127 ; W=125

#####################################################################
# Temperature - Global grids
#####################################################################

setwd(gsub("kasim_ags_yasna.R","TemperatureGRID/TemperaturesGRIDdata/Temperature",rstudioapi::getSourceEditorContext()$path))

# Exploring .nc
t2019 <- nc_open("kasim2019.nc")
print(t2019)

t2020 <- nc_open("kasim2020.nc") # For 2020, 2 variables. Why? 01 for Jan-Aug, 05 for Sep,Nov
print(t2020)
names(t2020)
names(t2020$var)
head(t2020$var)

t2020Congo <- nc_open("kasim2020Congo.nc")
print(t2020Congo)

# TRANSFORM TO BRICK AND DELETE SOME LAYERS
# T Global
t2019B <- brick("kasim2019.nc", varname="t2m")

t2020B_01 <- brick("kasim2020.nc", varname="t2m_0001")
names(t2020B_01)
t2020B_01 <- dropLayer(t2020B_01, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01)

t2020B_05 <- brick("kasim2020.nc", varname="t2m_0005")
names(t2020B_05)
t2020B_05 <- dropLayer(t2020B_05, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                    "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                    "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05)

# T SA
t2019B_SA <- brick("kasim2019SA.nc", varname="t2m")
t2020B_01_SA <- brick("kasim2020SA.nc", varname="t2m_0001")
t2020B_01_SA <- dropLayer(t2020B_01_SA, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01_SA)
t2020B_05_SA <- brick("kasim2020SA.nc", varname="t2m_0005")
t2020B_05_SA <- dropLayer(t2020B_05_SA, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                    "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                    "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05_SA)

# T NA
t2019B_NA <- brick("kasim2019NA.nc", varname="t2m")
t2020B_01_NA <- brick("kasim2020NA.nc", varname="t2m_0001")
t2020B_01_NA <- dropLayer(t2020B_01_NA, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01_NA)
t2020B_05_NA <- brick("kasim2020NA.nc", varname="t2m_0005")
t2020B_05_NA <- dropLayer(t2020B_05_NA, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                          "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                          "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05_NA)

# T C. America & Caribbean
t2019B_Car <- brick("kasim2019Car.nc", varname="t2m")
t2020B_01_Car <- brick("kasim2020Car.nc", varname="t2m_0001")
t2020B_01_Car <- dropLayer(t2020B_01_Car, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01_Car)
t2020B_05_Car <- brick("kasim2020Car.nc", varname="t2m_0005")
t2020B_05_Car <- dropLayer(t2020B_05_Car, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                          "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                          "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05_Car)

# T Africa
t2019B_Africa <- brick("kasim2019Africa.nc", varname="t2m")
t2020B_01_Africa <- brick("kasim2020Africa.nc", varname="t2m_0001")
t2020B_01_Africa <- dropLayer(t2020B_01_Africa, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01_Africa)
t2020B_05_Africa <- brick("kasim2020Africa.nc", varname="t2m_0005")
t2020B_05_Africa <- dropLayer(t2020B_05_Africa, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                          "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                          "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05_Africa)

# T Europe
t2019B_EU <- brick("kasim2019EU.nc", varname="t2m")
t2020B_01_EU <- brick("kasim2020EU.nc", varname="t2m_0001")
t2020B_01_EU <- dropLayer(t2020B_01_EU, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01_EU)
t2020B_05_EU <- brick("kasim2020EU.nc", varname="t2m_0005")
t2020B_05_EU <- dropLayer(t2020B_05_EU, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                          "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                          "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05_EU)

# T Iceland
t2019B_Iceland <- brick("kasim2019Iceland.nc", varname="t2m")
t2020B_01_Iceland <- brick("kasim2020Iceland.nc", varname="t2m_0001")
t2020B_01_Iceland <- dropLayer(t2020B_01_Iceland, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
plot(t2020B_01_Iceland)
t2020B_05_Iceland <- brick("kasim2020Iceland.nc", varname="t2m_0005")
t2020B_05_Iceland <- dropLayer(t2020B_05_Iceland, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                          "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                          "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
plot(t2020B_05_Iceland)

# T Congo
t2019CongoB <- brick("kasim2019Congo.nc", varname="t2m")
t2020CongoB_01 <- brick("kasim2020Congo.nc", varname="t2m_0001")
t2020B_01_Congo <- dropLayer(t2020CongoB_01, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
t2020CongoB_05 <- brick("kasim2020Congo.nc", varname="t2m_0005")
t2020B_05_Congo <- dropLayer(t2020CongoB_05, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                                    "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                                    "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))
# T Timor
t2019TimorB <- brick("kasim2019Timor.nc", varname="t2m")
t2020TimorB_01 <- brick("kasim2020Timor.nc", varname="t2m_0001")
t2020B_01_Timor <- dropLayer(t2020TimorB_01, c("X2020.09.01.01.00.00", "X2020.10.01.01.00.00"))
t2020TimorB_05 <- brick("kasim2020Timor.nc", varname="t2m_0005")
t2020B_05_Timor <- dropLayer(t2020TimorB_05, c("X2020.01.01.00.00.00", "X2020.02.01.00.00.00", "X2020.03.01.00.00.00",
                                               "X2020.04.01.01.00.00", "X2020.05.01.01.00.00", "X2020.06.01.01.00.00",
                                               "X2020.07.01.01.00.00", "X2020.08.01.01.00.00"))

# MERGE FILES 2019-2020
tGlobal <- stack(t2019B, t2020B_01, t2020B_05)
nlayers(tGlobal)
plot(tGlobal)

tSA <- stack(t2019B_SA, t2020B_01_SA, t2020B_05_SA)
tNA <- stack(t2019B_NA, t2020B_01_NA, t2020B_05_NA)
tCar <- stack(t2019B_Car, t2020B_01_Car, t2020B_05_Car)
tAfrica <- stack(t2019B_Africa, t2020B_01_Africa, t2020B_05_Africa)
tEU <- stack(t2019B_EU, t2020B_01_EU, t2020B_05_EU)
tIceland <- stack(t2019B_Iceland, t2020B_01_Iceland, t2020B_05_Iceland)
tCongo <- stack(t2019CongoB, t2020B_01_Congo, t2020B_05_Congo)
tTimor <- stack(t2019TimorB, t2020B_01_Timor, t2020B_05_Timor)

tGlobal <- tGlobal - 273.15 
tSA <- tSA - 273.15 
tNA <- tNA - 273.15 
tCar <- tCar - 273.15 
tAfrica <- tAfrica - 273.15 
tEU <- tEU - 273.15 

#2021-09-05 Agregué la resta
tIceland <- tIceland- 273.15

tCongo <- tCongo - 273.15
tTimor <- tTimor - 273.15


#####################################################################
# Cropping data for each country
#####################################################################

t_AFG <- mask(tGlobal, bordersAFG) %>% crop(bordersAFG)
t_ALB <- mask(tGlobal, bordersALB) %>% crop(bordersALB)
t_DZA <- mask(tGlobal, bordersDZA) %>% crop(bordersDZA)
t_AGO <- mask(tGlobal, bordersAGO) %>% crop(bordersAGO)
t_ARG <- mask(tSA, bordersARG) %>% crop(bordersARG)
t_AUS <- mask(tGlobal, bordersAUS) %>% crop(bordersAUS)
t_AUT <- mask(tGlobal, bordersAUT) %>% crop(bordersAUT)
t_AZE <- mask(tGlobal, bordersAZE) %>% crop(bordersAZE)
t_BHR <- mask(tGlobal, bordersBHR) %>% crop(bordersBHR)
t_BGD <- mask(tGlobal, bordersBGD) %>% crop(bordersBGD)
t_BRB <- mask(tCar, bordersBRB) %>% crop(bordersBRB)
t_BLR <- mask(tGlobal, bordersBLR) %>% crop(bordersBLR)
t_BEL <- mask(tGlobal, bordersBEL) %>% crop(bordersBEL)
t_BLZ <- mask(tCar, bordersBLZ) %>% crop(bordersBLZ)
t_BEN <- mask(tGlobal, bordersBEN) %>% crop(bordersBEN)
t_BTN <- mask(tGlobal, bordersBTN) %>% crop(bordersBTN)
t_BOL <- mask(tSA, bordersBOL) %>% crop(bordersBOL)
t_BIH <- mask(tGlobal, bordersBIH) %>% crop(bordersBIH)
t_BWA <- mask(tGlobal, bordersBWA) %>% crop(bordersBWA)
t_BRA <- mask(tSA, bordersBRA) %>% crop(bordersBRA)
t_BRN <- mask(tGlobal, bordersBRN) %>% crop(bordersBRN)
t_BGR <- mask(tGlobal, bordersBGR) %>% crop(bordersBGR)
t_BFA <- mask(tGlobal, bordersBFA) %>% crop(bordersBFA)
t_BDI <- mask(tGlobal, bordersBDI) %>% crop(bordersBDI)
t_KHM <- mask(tGlobal, bordersKHM) %>% crop(bordersKHM)
t_CMR <- mask(tGlobal, bordersCMR) %>% crop(bordersCMR)
t_CPV <- mask(tAfrica, bordersCPV) %>% crop(bordersCPV)
t_CAF <- mask(tGlobal, bordersCAF) %>% crop(bordersCAF)
t_TCD <- mask(tGlobal, bordersTCD) %>% crop(bordersTCD)
t_CAN <- mask(tNA, bordersCAN) %>% crop(bordersCAN)
t_CHL <- mask(tSA, bordersCHL) %>% crop(bordersCHL)
t_CHN <- mask(tGlobal, bordersCHN) %>% crop(bordersCHN)
t_COL <- mask(tSA, bordersCOL) %>% crop(bordersCOL)
t_COG <- tCongo
t_CRI <- mask(tCar, bordersCRI) %>% crop(bordersCRI)
t_CIV <- mask(tAfrica, bordersCIV) %>% crop(bordersCIV)
t_HRV <- mask(tGlobal, bordersHRV) %>% crop(bordersHRV)
t_CYP <- mask(tGlobal, bordersCYP) %>% crop(bordersCYP)
t_CZE <- mask(tGlobal, bordersCZE) %>% crop(bordersCZE)
t_COD <- mask(tGlobal, bordersCOD) %>% crop(bordersCOD)
t_DNK <- mask(tGlobal, bordersDNK) %>% crop(bordersDNK)
t_DJI <- mask(tGlobal, bordersDJI) %>% crop(bordersDJI)
t_DOM <- mask(tCar, bordersDOM) %>% crop(bordersDOM)
t_ECU <- mask(tSA, bordersECU) %>% crop(bordersECU)
t_EGY <- mask(tGlobal, bordersEGY) %>% crop(bordersEGY)
t_SLV <- mask(tCar, bordersSLV) %>% crop(bordersSLV)
t_EST <- mask(tGlobal, bordersEST) %>% crop(bordersEST)
t_ETH <- mask(tGlobal, bordersETH) %>% crop(bordersETH)
t_FJI <- mask(tGlobal, bordersFJI) %>% crop(bordersFJI)
t_FIN <- mask(tGlobal, bordersFIN) %>% crop(bordersFIN)
t_FRA <- mask(tGlobal, bordersFRA) %>% crop(bordersFRA)
t_GAB <- mask(tGlobal, bordersGAB) %>% crop(bordersGAB)
t_GMB <- mask(tAfrica, bordersGMB) %>% crop(bordersGMB)
t_GEO <- mask(tGlobal, bordersGEO) %>% crop(bordersGEO)
t_DEU <- mask(tGlobal, bordersDEU) %>% crop(bordersDEU)
t_GHA <- mask(tGlobal, bordersGHA) %>% crop(bordersGHA)
t_GRC <- mask(tGlobal, bordersGRC) %>% crop(bordersGRC)
t_GTM <- mask(tCar, bordersGTM) %>% crop(bordersGTM)
t_GIN <- mask(tAfrica, bordersGIN) %>% crop(bordersGIN)
t_GUY <- mask(tSA, bordersGUY) %>% crop(bordersGUY)
t_HTI <- mask(tCar, bordersHTI) %>% crop(bordersHTI)
t_HND <- mask(tCar, bordersHND) %>% crop(bordersHND)
t_HUN <- mask(tGlobal, bordersHUN) %>% crop(bordersHUN)
#2021-09-05 Ver cómo se comporta
t_ISL <- mask(tIceland, bordersISL) %>% crop(bordersISL)
t_IND <- mask(tGlobal, bordersIND) %>% crop(bordersIND)
t_IRN <- mask(tGlobal, bordersIRN) %>% crop(bordersIRN)
t_IRQ <- mask(tGlobal, bordersIRQ) %>% crop(bordersIRQ)
t_IRL <- mask(tEU, bordersIRL) %>% crop(bordersIRL)
t_IDN <- mask(tGlobal, bordersIDN) %>% crop(bordersIDN)
t_ISR <- mask(tGlobal, bordersISR) %>% crop(bordersISR)
t_ITA <- mask(tGlobal, bordersITA) %>% crop(bordersITA)
t_JAM <- mask(tCar, bordersJAM) %>% crop(bordersJAM)
t_JPN <- mask(tGlobal, bordersJPN) %>% crop(bordersJPN)
t_JOR <- mask(tGlobal, bordersJOR) %>% crop(bordersJOR)
t_KAZ <- mask(tGlobal, bordersKAZ) %>% crop(bordersKAZ)
t_KEN <- mask(tGlobal, bordersKEN) %>% crop(bordersKEN)
t_KWT <- mask(tGlobal, bordersKWT) %>% crop(bordersKWT)
t_KGZ <- mask(tGlobal, bordersKGZ) %>% crop(bordersKGZ)
t_LAO <- mask(tGlobal, bordersLAO) %>% crop(bordersLAO)
t_LVA <- mask(tGlobal, bordersLVA) %>% crop(bordersLVA)
t_LBN <- mask(tGlobal, bordersLBN) %>% crop(bordersLBN)
t_LBR <- mask(tAfrica, bordersLBR) %>% crop(bordersLBR)
t_LBY <- mask(tGlobal, bordersLBY) %>% crop(bordersLBY)
t_LTU <- mask(tGlobal, bordersLTU) %>% crop(bordersLTU)
t_LUX <- mask(tGlobal, bordersLUX) %>% crop(bordersLUX)
t_MDG <- mask(tGlobal, bordersMDG) %>% crop(bordersMDG)
t_MWI <- mask(tGlobal, bordersMWI) %>% crop(bordersMWI)
t_MYS <- mask(tGlobal, bordersMYS) %>% crop(bordersMYS)
t_MLI <- mask(tGlobal, bordersMLI) %>% crop(bordersMLI)
t_MRT <- mask(tAfrica, bordersMRT) %>% crop(bordersMRT)
t_MUS <- mask(tGlobal, bordersMUS) %>% crop(bordersMUS)
t_MEX <- mask(tNA, bordersMEX) %>% crop(bordersMEX)
t_MDA <- mask(tGlobal, bordersMDA) %>% crop(bordersMDA)
t_MNG <- mask(tGlobal, bordersMNG) %>% crop(bordersMNG)
t_MAR <- mask(tAfrica, bordersMAR) %>% crop(bordersMAR)
t_MOZ <- mask(tGlobal, bordersMOZ) %>% crop(bordersMOZ)
t_NPL <- mask(tGlobal, bordersNPL) %>% crop(bordersNPL)
t_NLD <- mask(tGlobal, bordersNLD) %>% crop(bordersNLD)
t_NIC <- mask(tCar, bordersNIC) %>% crop(bordersNIC)
t_NZL <- mask(tGlobal, bordersNZL) %>% crop(bordersNZL)
t_NER <- mask(tGlobal, bordersNER) %>% crop(bordersNER)
t_NGA <- mask(tGlobal, bordersNGA) %>% crop(bordersNGA)
t_NOR <- mask(tGlobal, bordersNOR) %>% crop(bordersNOR)
t_OMN <- mask(tGlobal, bordersOMN) %>% crop(bordersOMN)
t_PAK <- mask(tGlobal, bordersPAK) %>% crop(bordersPAK)
t_PAN <- mask(tCar, bordersPAN) %>% crop(bordersPAN)
t_PNG <- mask(tGlobal, bordersPNG) %>% crop(bordersPNG)
t_PRY <- mask(tSA, bordersPRY) %>% crop(bordersPRY)
t_PER <- mask(tSA, bordersPER) %>% crop(bordersPER)
t_PHL <- mask(tGlobal, bordersPHL) %>% crop(bordersPHL)
t_POL <- mask(tGlobal, bordersPOL) %>% crop(bordersPOL)
t_PRT <- mask(tEU, bordersPRT) %>% crop(bordersPRT)
t_ROU <- mask(tGlobal, bordersROU) %>% crop(bordersROU)
t_RUS <- mask(tGlobal, bordersRUS) %>% crop(bordersRUS)
t_RWA <- mask(tGlobal, bordersRWA) %>% crop(bordersRWA)
t_SAU <- mask(tGlobal, bordersSAU) %>% crop(bordersSAU)
t_SEN <- mask(tAfrica, bordersSEN) %>% crop(bordersSEN)
t_SYC <- mask(tGlobal, bordersSYC) %>% crop(bordersSYC)
t_SLE <- mask(tAfrica, bordersSLE) %>% crop(bordersSLE)
t_SGP <- mask(tGlobal, bordersSGP) %>% crop(bordersSGP)
t_SVK <- mask(tGlobal, bordersSVK) %>% crop(bordersSVK)
t_SVN <- mask(tGlobal, bordersSVN) %>% crop(bordersSVN)
t_ZAF <- mask(tGlobal, bordersZAF) %>% crop(bordersZAF)
t_KOR <- mask(tGlobal, bordersKOR) %>% crop(bordersKOR)
t_ESP <- mask(tGlobal, bordersESP) %>% crop(bordersESP)
t_LKA <- mask(tGlobal, bordersLKA) %>% crop(bordersLKA)
t_SUR <- mask(tSA, bordersSUR) %>% crop(bordersSUR)
t_SWZ <- mask(tGlobal, bordersSWZ) %>% crop(bordersSWZ)
t_SWE <- mask(tGlobal, bordersSWE) %>% crop(bordersSWE)
t_CHE <- mask(tGlobal, bordersCHE) %>% crop(bordersCHE)
t_TJK <- mask(tGlobal, bordersTJK) %>% crop(bordersTJK)
t_TZA <- mask(tGlobal, bordersTZA) %>% crop(bordersTZA)
t_THA <- mask(tGlobal, bordersTHA) %>% crop(bordersTHA)
t_TLS <- tTimor
t_TGO <- mask(tGlobal, bordersTGO) %>% crop(bordersTGO)
t_TTO <- mask(tCar, bordersTTO) %>% crop(bordersTTO)
t_TUN <- mask(tGlobal, bordersTUN) %>% crop(bordersTUN)
t_TUR <- mask(tGlobal, bordersTUR) %>% crop(bordersTUR)
t_UGA <- mask(tGlobal, bordersUGA) %>% crop(bordersUGA)
t_UKR <- mask(tGlobal, bordersUKR) %>% crop(bordersUKR)
t_ARE <- mask(tGlobal, bordersARE) %>% crop(bordersARE)
t_GBR <- mask(tGlobal, bordersGBR) %>% crop(bordersGBR)
t_URY <- mask(tSA, bordersURY) %>% crop(bordersURY)
t_USA <- mask(tGlobal, bordersUSA) %>% crop(bordersUSA)
t_UZB <- mask(tGlobal, bordersUZB) %>% crop(bordersUZB)
t_VEN <- mask(tSA, bordersVEN) %>% crop(bordersVEN)
t_VNM <- mask(tGlobal, bordersVNM) %>% crop(bordersVNM)
t_YEM <- mask(tGlobal, bordersYEM) %>% crop(bordersYEM)
t_ZMB <- mask(tGlobal, bordersZMB) %>% crop(bordersZMB)
t_ZWE <- mask(tGlobal, bordersZWE) %>% crop(bordersZWE)


#####################################################################
# From grid data to time series for each country
#####################################################################
# Take the mean of each layer
# then save those averages as TS

tempListPre <- grep("t_", names(.GlobalEnv), value=TRUE)[-"t_mean"]
temp_list <- do.call("list", mget(tempListPre)) # List with all countries

#2021-09-05
tempListPre2<- tempListPre[-which(tempListPre=="t_mean")]

temp_df<-data.frame()
no_mostrar=0
if(no_mostrar==1){
  t_mean <- lapply(temp_list, function(x) cellStats(x, mean)) # List with all "mean per layer"
}
for (i in 1:length(tempListPre2)){
  xi<-tempListPre2[[i]]
  temp_df<-rbind(temp_df,
  cbind(xi,cellStats(temp_list[[xi]], mean, na.rm=T))
  )
}
temp_dt<-data.table::data.table(temp_df, keep.rownames = T)

temp_dt_cons<-
temp_dt %>% 
  #dplyr::filter(xi=="t_NZL") %>% 
  dplyr::mutate(country_cod=gsub("^t_","",xi)) %>% 
  dplyr::mutate(year=dplyr::case_when(grepl("X2019",rn)~"2019",
                                      grepl("X2020",rn)~"2020",
                                      T~NA_character_)) %>% 
  purrr::when(dplyr::filter(.,is.na(year)) %>% nrow()>0 ~ stop("missing months in transformation"), 
              ~.) %>% 
  dplyr::mutate(month=dplyr::case_when(grepl("^X2019.11",rn)~11,
                                       grepl("^X2019.12",rn)~12,
                                      grepl("^X2020.01",rn)~1,
                                      grepl("^X2020.02",rn)~2,
                                      grepl("^X2020.03",rn)~3,
                                      grepl("^X2020.04",rn)~4,
                                      grepl("^X2020.05",rn)~5,
                                      grepl("^X2020.06",rn)~6,
                                      grepl("^X2020.07",rn)~7,
                                      grepl("^X2020.08",rn)~8,
                                      grepl("^X2020.09",rn)~9,
                                      grepl("^X2020.10",rn)~10,
                                      grepl("^X2020.11",rn)~11,
                                      grepl("^X2020.12",rn)~12,
                                      T~NA_real_)) %>% 
  purrr::when(dplyr::filter(.,is.na(month)) %>% nrow()>0 ~ stop("missing months in transformation"), 
              ~.) %>% 
  dplyr::select(country_cod,V2,month, year) %>% 
  dplyr::mutate(V2=as.numeric(V2))%>% 
  dplyr::filter(!is.nan(V2)) %>% 
  dplyr::rename("CountryCode"="country_cod", "TemperatureAvg"="V2","Month"="month","Year"="year") 
  
options(OutDec= ",")
rio::export(temp_dt_cons,paste0(gsub("kasim_ags_yasna.R","",rstudioapi::getSourceEditorContext()$path),"TempCountryGridALL_2021.csv"), format=";")
options(OutDec= ".")
# Save all files as .csv
#2021-09-05
no_mostrar=0
if(no_mostrar==1){
  setwd(gsub("kasim_ags_yasna.R","TemperatureGRID/TemperaturesGRIDdata/allCSV",rstudioapi::getSourceEditorContext()$path))
lapply(1:length(t_mean), function(i) write.csv(t_mean[[i]], 
                                                file=paste0(names(t_mean[i]),".csv")))

}