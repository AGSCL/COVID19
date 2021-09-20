*use "C:\Users\ \Dropbox\Covid-19_2020\Article_SecondManuscript\LT Environmental analysis\Databases\merged_data.dta",clear
*dis `c(username)'

*cd "`:environment USERPROFILE'/Dropbox/Covid-19_2020/Article_SecondManuscript/LT Environmental analysis/Databases"
*use "merged_data.dta",clear

copy "https://dl.dropboxusercontent.com/s/bgp8kre9rimwpjm/merged_data_post_ago.dta?dl=0" merged_data_post_aug.dta,replace
use merged_data_post_aug.dta

**to get a valid varnames
foreach varname of varlist * {

local i = `i' + 1

if ( "`varname'" != ustrtoname("`varname'") ) {

    mata : st_varrename(`i', ustrtoname("`varname'") )
   }
}

*just an excersise.It may be bad
	** choose instrumental variables: uncorrelated with errors, but corr with B
	** 1st step-> Auxiliary Regression: variable with endogeneity from the chosen instrumental variables
	** 2nd step -> Replace the B with the estimated in the first step (correct for omitted variables bias).