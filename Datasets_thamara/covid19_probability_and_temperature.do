 


**********************************************************
replace log_resp_mortality2=log_resp_mortality+6.05218

*FINAL RESPIRATORY*
regress log_resp_mortality2 obesity_both_percent dalys_asthma_normalized stdgdp women median_age life_exp i.airpollution, vce(robust)
estat ic
predict y 
est sto y
estout y using resultyz17.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p) starlevels(* 0.1 ** 0.05 *** 0.01) eform

r2=0.6440
AIC=157.3979

gen expz=exp(y)


stepwise, pr(.10): regress log_resp_mortality overweight aged_70_older women pop7wb dalys_asthma_normalized bloodp airpollution diabetes_prevalence universalcoverage stdgdp
estat ic

xtile airpollution = airpollution2016, nq(3)
gen stdgdp= (gdp_per_capita - r(mean)) / r(sd)
egen stdgdp = std(gdp_per_capita)
********************************************************

*TEMPERATURE*
gen real_temperature=0
replace real_temperature=jan_2020 if month=="jan"
replace real_temperature=feb_2020 if month=="feb"
replace real_temperature=mar_2020 if month=="mar"
replace real_temperature=apr_2020 if month=="apr"
replace real_temperature=may_2020 if month=="may"
replace real_temperature=jun_2020 if month=="jun"
replace real_temperature=jul_2020 if month=="jul"
replace real_temperature=aug_2020 if month=="aug"
replace real_temperature=sep_2020 if month=="sep"
replace real_temperature=oct_2020 if month=="oct"
replace real_temperature=nov_2019 if month=="nov"
replace real_temperature=dec_2019 if month=="dec"

gen real_temperature1=0
replace real_temperature1=jan_2020 if month=="feb"
replace real_temperature1=feb_2020 if month=="mar"
replace real_temperature1=mar_2020 if month=="apr"
replace real_temperature1=apr_2020 if month=="may"
replace real_temperature1=may_2020 if month=="jun"
replace real_temperature1=jun_2020 if month=="jul"
replace real_temperature1=jul_2020 if month=="aug"
replace real_temperature1=aug_2020 if month=="sep"
replace real_temperature1=sep_2020 if month=="oct"
replace real_temperature1=oct_2020 if month=="nov"
replace real_temperature1=nov_2019 if month=="dec"
replace real_temperature1=dec_2019 if month=="jan"


g temperature_var2=real_temperature2 if days==1
replace temperature_var2=real_temperature2-real_temperature2[_n-1] if days==2
replace temperature_var2=real_temperature2-real_temperature2[_n-1] if days==3
replace temperature_var2=real_temperature2-real_temperature2[_n-1] if days==4
replace temperature_var2=real_temperature2-real_temperature2[_n-1] if days==5

 g temperature_var3=real_temperature2
replace temperature_var3=real_temperature2-real_temperature2[_n-1] if days==2
replace temperature_var3=real_temperature2-real_temperature2[_n-2] if days==3
replace temperature_var3=real_temperature2-real_temperature2[_n-3] if days==4
replace temperature_var3=real_temperature2-real_temperature2[_n-4] if days==5


Drop if days==1 (t=30)
**************************************************

**OUTCOME**
*median + 1sd*

gen mortality_cat=0 if covid_mortality<=14.229711 & days==5
replace mortality_cat=1 if covid_mortality>14.229711 & days==5
replace mortality_cat=1 if covid_mortality>11.63784 & days==4
replace mortality_cat=1 if covid_mortality>4.06070106 & days==3
replace mortality_cat=0 if covid_mortality<=4.06070106 & days==3
replace mortality_cat=0 if covid_mortality<=11.63784 & days==4
tab mortality_cat

*****************************************************
**PANEL**

Model 1

xtlogit mortality_cat real_temperature1 if days!=2, or pa vce(robust) nolog
est sto r1du2
estout  r1du2 using covidpanelr1du2.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

Model 2

xtlogit mortality_cat expz real_temperature1 if days!=2, or pa vce(robust) nolog
est sto r1du1
estout  r1du1 using covidpanelr1du1.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

Model 3

xtlogit mortality_cat expz real_temperature1 oxford_index if days!=2, or pa vce(robust) nolog
est sto r1du4
estout  r1du4 using covidpanelr1du4.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

Model 4
xtlogit mortality_cat expz real_temperature1 oxford_index cases_lag if days!=2, or pa vce(robust) nolog
est sto r1du
estout  r1du using covidpanelr1du.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform


********************************************************
*CROSS-SECTIONAL*
logistic mortality_cat real_temperature1 expz oxford cases_lag  if days==4, or vce(robust) nolog
estat ic
est sto r1du3n
estout  r1du3n using covidpanelr1du3n.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

days==3: t=60
days==4: t=90
days==5: t=120
********************************************************
*********************************************************
*SUPPLEMENTARY*
*Cat mortality using median*

gen covid_mort_cat=0 if covid_mortality<=1.469221 & days==5
replace covid_mort_cat=1 if covid_mortality>1.469221 & days==5
replace covid_mort_cat=1 if covid_mortality>.9085146 & days==4
replace covid_mort_cat=1 if covid_mortality>.4616166 & days==3
replace covid_mort_cat=0 if covid_mortality<=.4616166 & days==3
replace covid_mort_cat=0 if covid_mortality<=.9085146 & days==4
replace covid_mort_cat=0 if days==2
tab covid_mort_cat
********************************************************
Model 4

xtlogit covid_mort_cat expz real_temperature1 oxford_index cases_lag if days!=2, or pa vce(robust) nolog
est sto r1duo
estout  r1duo using covidpanelr1duo.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

Model 3
xtlogit covid_mort_cat expz real_temperature1 oxford_index if days!=2, or pa vce(robust) nolog
est sto r1du4r
estout  r1du4r using covidpanelr1du4r.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

Model 2
xtlogit covid_mort_cat expz real_temperature1 if days!=2, or pa vce(robust) nolog
est sto r1du1m
estout  r1du1m using covidpanelr1du1m.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

Model 1
xtlogit covid_mort_cat real_temperature1 if days!=2, or pa vce(robust) nolog
est sto r1du2u
estout  r1du2u using covidpanelr1du2u.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

********************************************************
*...................................................*
**cross-sectional*
*days==2: 30 days; days==3: t=60 days==4: t=90 and days==5: t=120*

regress log_covid_mortality expu100 temperature_var2  oxford_index  cases if days==2, vce(robust) 
est sto r1du
estout  r1du using covidpanelr1du.xls, cells("b(star fmt(3)) se(par fmt(3)) ci") stats(r2 N vce aic bic p sigma_u sigma_e rho) starlevels(* 0.1 ** 0.05 *** 0.01) eform

*********************************************************

gen letalidad=deaths/cases
replace letalidad=1 if letalidad==0
gen log_letalidad = log(letalidad)

**************************************************

xtnbreg deaths real_temperature1 oxford cases_lag aged_70_older hdi2017 women dalys_asthma_normalized bloodp, irr nolog

xtnbreg deaths real_temperature1 oxford cases_lag obesity_both_percent, irr nolog