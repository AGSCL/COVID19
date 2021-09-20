*Preparing dataset*

 merge 1:1 country using "C:\Users\Thamara\OneDrive\Escritorio\Covid-19\Datasets\population2017.dta" 
 drop _merge
   merge 1:1 countrycode using "C:\Users\Thamara\OneDrive\Escritorio\Covid-19\women.dta"
  drop if population==.
  
 list if cases_deaths_30==.
 list if cases_deaths_60==.
 list if cases_deaths_90==.
 
 list if cases_deaths_60==.
 *LESOTHO LSO missing cases deaths 90 and 11 more variables*
 
 
 *OUTCOMES DISTRIBUTION*
 
histogram low_resp_inf_dths, norm
qnorm low_resp_inf_dths
 
 *amplied just per 100 because we want probabilities* 
generate low_resp_inf_mortality= (low_resp_inf_dths/Population2017)*100
generate diabetes_mortality = (diabetes_deaths/ Population2017)*100

 *potential predictors*
generate resp_mortality = (respiratory_diseases_deaths/ Population2017)*100

qnorm low_resp_inf_mortality
kdensity low_resp_inf_mortality, normal

*log transform*
gen log_lowrespmortality = log(low_resp_inf_mortality)
qnorm log_lowrespmortality
kdensity log_lowrespmortality, normal

*relationship with predictors*

pwcorr low_resp_inf_mortality women median_age aged_70_older gdp_per_capita diabetes_prevalence life_expectancy hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality, sig 

*Full initial model*

regress log_lowrespmortality women median_age aged_70_older gdp_per_capita diabetes_prevalence life_expectancy hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality
estat ic

collin women median_age aged_70_older gdp_per_capita diabetes_prevalence life_expectancy hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality

*median age, aged 70, HDI, life expectacy no WB, life expectancy WB huge VIF* 

Final Model 
stepwise, pr(.10):regress log_lowrespmortality women median_age  diabetes_prevalence hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality
estat ic

collin women median_age  diabetes_prevalence hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality
estat ic

predict d, cooksd
list country log_lowrespmortality women pop_density dalys_lung_disease diabetes_prevalence life_exp d if d>4/152
predict dfit, dfits
list country log_lowrespmortality women pop_density dalys_lung_disease diabetes_prevalence life_exp dfit if abs(dfit)>2*sqrt(3/152)
predict residuals, resid
rvfplot, yline(0)
stem residuals
estat imtest
drop if country=="Lesotho"
drop if country=="Qatar"
swilk log_lowrespmortality

stepwise, pr(.10):regress log_lowrespmortality women median_age  diabetes_prevalence hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality 
predict residuals, resid
rvfplot, yline(0)
stem residuals
estat imtest

stepwise, pr(.10):regress log_lowrespmortality women median_age  diabetes_prevalence hdi_index_2018 air_pollution_year_pm25 life_exp dalys_asthma_normalized dalys_lung_disease obesity_both_percent diabetes_mortality resp_mortality, vce(robust)
estat ic
generate sample = e(sample)
predict yhat
generate predicted= exp(yhat)
predict residuals, resid
sum yhat predicted residuals
qnorm residuals
qnorm predicted
qnorm yhat
swilk residuals
linktest
ovtest

*Second Stage Models*
*Second model cross-sectional*

generate covid_mortality30 = (cases_deaths_30/total_pop)*10000
generate covid_mortality60 = (cases_deaths_60/total_pop)*10000
generate covid_mortality90 = (cases_deaths_90/total_pop)*10000
generate covid_prevalence30 = (cases_30/total_pop)*10000

replace covid_mortality30=1 if covid_mortality30==0
replace covid_mortality60=1 if covid_mortality60==0
replace covid_mortality90=1 if covid_mortality90==0

gen log_covid_mortality30 = log(covid_mortality30)
gen log_covid_mortality60 = log(covid_mortality60)
gen log_covid_mortality90 = log(covid_mortality90)
kdensity log_covid_mortality60, normal
kdensity log_covid_mortality90, normal

pwcorr cases_deaths_60  predicted monthly_temp_30 monthly_prec_30 stringency_ind_oxf_60 cases_30, sig
pwcorr cases_deaths_90  predicted monthly_temp_60 monthly_prec_60 stringency_ind_oxf_90 cases_60, sig

*Final 60*
nbreg cases_deaths_60  predicted monthly_temp_30 monthly_prec_30 stringency_ind_oxf_60 cases_30, irr vce (robust) nolog
collin predicted monthly_temp_30 monthly_prec_30 stringency_ind_oxf_60 cases_30

*Final 90*
nbreg cases_deaths_90  predicted monthly_temp_60 monthly_prec_60 stringency_ind_oxf_90 cases_60, irr vce (robust) nolog
collin predicted monthly_temp_60 monthly_prec_60 stringency_ind_oxf_90 cases_60
estat ic

*PANEL*
g id=_n
drop d

rename dates_30 a2
rename dates_60 a3
rename dates_90 a4

rename cases_30  c2
rename cases_60  c3
rename cases_90  c4

rename cases_deaths_30 d2
rename cases_deaths_60 d3
rename cases_deaths_90 d4

rename stringency_ind_oxf_30 o2
rename stringency_ind_oxf_60 o3
rename stringency_ind_oxf_90 o4


rename monthly_temp_30 m2
rename monthly_temp_60 m3
rename monthly_temp_90 m4


rename monthly_prec_30 p2
rename monthly_prec_60 p3
rename monthly_prec_90 p4

rename month_temp_16_30 t2
rename month_temp_16_60 t3
rename month_temp_16_90 t4

rename month_rainfall_mm_16_30 r2
rename month_rainfall_mm_16_60 r3
rename month_rainfall_mm_16_90 r4

reshape long a c d o m p t r, i(id) j(days)


rename a dates
rename c cases
rename d deaths
rename o oxford
rename m av_temperature
rename p av_rain
rename t temperature
rename r rain 

gen interaccion= temperature*oxford
gen interaccion2= rain*oxford
replace deaths=1 if deaths==0
pwcorr deaths temperature predicted rain oxford, sig
collin temperature predicted rain oxford
swilk deaths covid_mortality
global regresores predicted temperature rain oxford interaccion 
global regresors predicted temperature rain oxford 
xtset id days

*SECOND MODEL*
*Mortality x 100000*
drop covid_mortality
drop log_covid_mortality
replace deaths=1 if deaths==0
replace covid_mortality=1 if covid_mortality==0
generate covid_mortality = (deaths/total_pop)*100000
kdensity covid_mortality, normal
gen log_covid_mortality = log(covid_mortality)
kdensity log_covid_mortality, normal

gen sq_covid_mortality = sqrt(covid_mortality)
egen sd_covid_mortality = std(covid_mortality)


*pa no possible to calculate AIC and BIC*
xtnbreg deaths $regresores, irr fe nolog
predict fe6
estout, stats (r2 N vce aic bic p)
xtnbreg deaths $regresores, re irr nolog
predict re5
estout, stats (r2 N vce aic bic p)
xtnbreg deaths $regresores, pa irr nolog vce(robust)
predict pa6
estout, stats (r2 N vce aic bic p)


*log linear regression covid deaths*
xtreg log_covid_mortality $regresores, vce(robust) re 
predict logre
estout, stats (r2 N vce aic bic p)

xtreg log_covid_mortality $regresores, vce(robust) fe
predict logfe
estout, stats (r2 N vce aic bic p)

xtreg log_covid_mortality $regresores, vce(robust) pa
predict logpa
estout, stats (r2 N vce aic bic p)


xtpoisson deaths $regresores, irr fe nolog
predict deathfero
estout, stats (r2 N vce aic bic p)
xtpoisson deaths $regresores interaccion, irr re vce(robust) nolog
predict deathrero
estout, stats (r2 N vce aic bic p)
xtpoisson deaths $regresores interaccion, irr pa vce(robust) nolog
predict deathparo
estout, stats (r2 N vce aic bic p)

collin $regresores



