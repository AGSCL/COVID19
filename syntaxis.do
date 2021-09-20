*use "C:\Users\ \Dropbox\Covid-19_2020\Article_SecondManuscript\LT Environmental analysis\Databases\merged_data.dta",clear
*dis `c(username)'

cd "`:environment USERPROFILE'/Dropbox/Covid-19_2020/Article_SecondManuscript/LT Environmental analysis/Databases"
use "merged_data.dta",clear

**to get a valid varnames
foreach varname of varlist * {

local i = `i' + 1

if ( "`varname'" != ustrtoname("`varname'") ) {

    mata : st_varrename(`i', ustrtoname("`varname'") )
   }
}
*recode iso_code to transform it into the variable i
encode(iso_code),gen(id)

*just an excersise.It may be bad
	** choose instrumental variables: uncorrelated with errors, but corr with B
	** 1st step-> Auxiliary Regression: variable with endogeneity from the chosen instrumental variables
	** 2nd step -> Replace the B with the estimated in the first step (correct for omitted variables bias).

*MCO/OLS	
regress cases_deaths_mth stringency_ind_oxf_mth monthly_temp monthly_prec month_temp_16 month_rainfall_mm_16 ndays_mth prop_lo_resp_inf_dth, cluster(id)	//*i.dates see how you include, same w/ cases_mth
estimates store ols
matrix A=e(b)
matrix a=e(V)

*2SLS
ivregress 2sls cases_deaths_mth stringency_ind_oxf_mth monthly_temp monthly_prec month_temp_16 month_rainfall_mm_16 ndays_mth (prop_lo_resp_inf_dth = pop_density hdi_rank_2018 life_expectancy diabetes_prevalence gdp_per_capita aged_70_older dalys_asthma_normalized), first cluster(id)
estimates store sls2

************dont run*********
*panel setting to ivregress with FEs
	xtset id dates
	
	xtdescribe
