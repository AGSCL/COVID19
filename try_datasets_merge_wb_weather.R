install.packages("remotes")
remotes::install_github("ecmwf/caliver")

invisible(paste("Estos son datos actuales del día, por ciudad. Yo necesito los datos históricos. No me sirve tener los datos a la fecha"))
invisible(paste("¿Hay datos nacionales?"))

#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
invisible(paste("Ver que los datos estén homogeneizados"))
    #https://www.icesi.edu.co/CRAN/web/packages/owmr/owmr.pdf
    install.packages("owmr")
    library(owmr)
    
    # first of all you have to set up your api key
    owmr::owmr_settings(Sys.setenv(OWM_API_KEY = "0eb45834f5de7a9ad3e353d1b45cc51b"))
    
    # or store it in an environment variable called OWM_API_KEY (recommended)
    Sys.setenv(OWM_API_KEY = "0eb45834f5de7a9ad3e353d1b45cc51b") # if not set globally
    
    #https://cran.r-project.org/web/packages/ROpenWeatherMap/ROpenWeatherMap.pdf
    #https://github.com/mukul13/ROpenWeatherMap
    #https://crazycapivara.github.io/owmr/
    #https://rpubs.com/aashishkpandey/data-collection-from-api
    install.packages("ROpenWeatherMap")
    library(ROpenWeatherMap)
    #get_multiple_cities get current weather data for multiple cities
    ROpenWeatherMap::get_multiple_cities("0eb45834f5de7a9ad3e353d1b45cc51b", bbox = NA, coordinates = NA, count = NA,
                        cityIDs = NA, cluster = "yes", units = "metric")
    #https://www.gis-blog.com/r-raster-data-acquisition/
    
    
    
    
#https://cran.r-project.org/web/packages/climate/vignettes/getstarted.html#:~:text=The%20goal%20of%20the%20climate,data%20from%20publicly%20available%20repositories%3A&text=Polish%20Institute%20of%20Meterology%20and,Research%20Institute%20(IMGW%2DPIB)
  
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
    
    library(climate)
    #stations_ogimet() - Downloading information about all stations available in the selected country in the Ogimet repository
    #"nearest_stations_ogimet() - Downloading information about nearest stations to the selected point available for the selected country in the Ogimet repository
    library(dplyr)
    
    library(climate)
    PL = stations_ogimet(country ="Chile", add_map = TRUE)
    
    library(climate)
    ns = climate::nearest_stations_nooa(country ="CHILE",point = c(-4, 56),
                                 no_of_stations = 50, add_map = TRUE)
    
    #meteo_ogimet() - Downloading hourly and daily meteorological data from the SYNOP stations 
    #available in the ogimet.com collection. Any meteorological (aka SYNOP) station working under the World Meteorological Organizaton framework after year 2000 should be accessible.
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    
    df = meteo_imgw(interval = 'monthly', rank='synop', year = 2018:2020, 
                    station = c("Temuco Airport"))   
    
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
    library(wbstats)
    #https://cran.r-project.org/web/packages/wbstats/vignettes/Using_the_wbstats_package.html
    gdp_percap_data <- wb(indicator= "NY.GDP.PCAP.PP.CD")
    #https://rdrr.io/cran/wbstats/man/wb.html
    wb(country = "all", indicator, startdate, enddate, mrv, return_wide = FALSE,
       gapfill, freq, cache, lang = c("en", "es", "fr", "ar", "zh"),
       removeNA = TRUE, POSIXct = FALSE, include_dec = FALSE,
       include_unit = FALSE, include_obsStatus = FALSE,
       include_lastUpdated = FALSE)
    
    wbsearch() 
#searches through the indicators data frame to find indicators that match a search pattern. An example of the structure of this data frame is below
    
  
    #https://cran.r-project.org/web/packages/rWBclimate/rWBclimate.pdf
    #Monthly average	The monthly average for all 12 months for a given time period
    #Annual average	a single average for a given time period
    #Monthly anomaly	Average monthly change (anomaly). The control period is 1961-1999 for temperature and precipitation variables, and 1961-2000 for derived statistics.
    #Annual anomaly	Average annual change (anomaly). The control period is 1961-1999 for temperature and precipitation variables, and 1961-2000 for derived statistics.
    #install.packages("rWBclimate")
    remotes::install_github("ropensci/rWBclimate")
    #https://github.com/ropensci/rWBclimate
    
    library(rWBclimate)
    
    ‘’
    rWBclimate::get_climate_data(locator, 
                     "country", #basin or country depending on the locator type
                     type= "mavg", #monthly average
                     cvar,  #variable para precipitación, "tas" para temperatura en celsius
                     2019, 
                     2020)
    
    get_historical_precip(c("USA","AUS","BRA","IDN"),time_scale="month")

  
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_
#remotes::install_github("adamhsparks/GSODRdata")
    library("GSODRdata")   
    library("GSODR")
    
    future::plan("multisession")
    global <- GSODR::get_GSOD(years = 2018:2019)
    
    str(global) 