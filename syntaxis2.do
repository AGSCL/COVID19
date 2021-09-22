<<dd_version: 2>>
<<dd_include: header.txt>>
<<dd_do: quietly>>
clear all
frame create death
frame change death
import delimited "https://raw.githubusercontent.com/pappubahry/AU_COVID19/master/time_series_deaths.csv"
generate date2 = date(date, "YMD")
drop date
format date %tdMon_DD
order date
rename * deaths*
rename *date2 date
reshape long deaths, i(date) j(state) string
replace state = upper(state)
local yesterday = date("`c(current_date)'", "DMY")
local yesterday = `yesterday' - 1
generate test = .
levelsof state, clean local(state)
foreach item of local state {
replace test = deaths if state == "`item'" & date == `yesterday'
summarize test
local `item'deaths = `r(max)'
replace test = .
}
drop test

frame change default
import delimited "https://raw.githubusercontent.com/pappubahry/AU_COVID19/master/time_series_cases.csv", clear
ds, not(type string)
foreach var of varlist `r(varlist)' {
replace `var' = `var'[_n-1] if `var' == .
}
foreach var of varlist `r(varlist)' {
replace `var' = 0 if `var' == .
}
generate date2 = date(date, "YMD")
drop date
format date %tdMon_DD
order date
rename * cases*
rename *date2 date
reshape long cases, i(date) j(state) string
replace state = upper(state)
local yesterday = date("`c(current_date)'", "DMY")
local yesterday = `yesterday' - 1
generate test = .
levelsof state, clean local(state)
foreach item of local state {
replace test = cases if state == "`item'" & date == `yesterday'
summarize test
local `item'cases = `r(max)'
replace test = .
}
drop test
generate newcases = .
sort state date
by state: replace newcases = cases[_n] - cases[_n-1]
replace newcases = 0 if newcases < 0
foreach item of local state {
twoway (bar newcases date, fcolor(red) lcolor(none%20)) if state == "`item'" & date >= `yesterday' - 29, xlabel(#30, labsize(vsmall) angle(45)) name(`item'case, replace) title("`item' COVID19 Cases in Last 30 Days")
graph export "`item'case.png", as(png) name(`item'case) replace
}

frame create rec
frame change rec
import delimited "https://raw.githubusercontent.com/pappubahry/AU_COVID19/master/time_series_recovered.csv", clear
ds, not(type string)
foreach var of varlist `r(varlist)' {
replace `var' = `var'[_n-1] if `var' == .
}
foreach var of varlist `r(varlist)' {
replace `var' = 0 if `var' == .
}
egen total = rowtotal(nsw vic qld wa sa tas act nt)
generate date2 = date(date, "YMD")
drop date
format date %tdMon_DD
order date
rename * recovered*
rename *date2 date
reshape long recovered, i(date) j(state) string
replace state = upper(state)
local yesterday = date("`c(current_date)'", "DMY")
local yesterday = `yesterday' - 1
generate test = .
levelsof state, clean local(state)
foreach item of local state {
replace test = recovered if state == "`item'" & date == `yesterday'
summarize test
local `item'recovered = `r(max)'
replace test = .
}
drop test
generate newrecovered = .
sort state date
by state: replace newrecovered = recovered[_n] - recovered[_n-1]
replace newrecovered = 0 if newrecovered < 0
foreach item of local state {
twoway (bar newrecovered date, fcolor(lime) lcolor(none%20)) if state == "`item'" & date >= `yesterday' - 29, xlabel(#30, labsize(vsmall) angle(45)) name(`item'rec, replace) title("`item' COVID19 Recoveries in Last 30 Days")
graph export "`item'rec.png", as(png) name(`item'rec) replace
}
frlink 1:1 state date, frame(default)
frlink 1:1 state date, frame(death)
frget cases, from(default)
frget deaths, from(death)
generate active = cases - recovered - deaths
generate test = .
levelsof state, clean local(state)
foreach item of local state {
replace test = active if state == "`item'" & date == `yesterday'
summarize test
local `item'active = `r(max)'
replace test = .
}
drop test

frame create gender
frame change gender
use gender_10yr.dta, clear
graph bar (asis) cases if gender != "unknown" & age != 11, over(gender, label(nolabel)) over(age, label(angle(forty_five) labsize(small))) asyvars bar(1, fcolor(orange) lcolor(dkorange)) bar(2, fcolor(midblue) lcolor(navy)) name(gender, replace) title("COVID19 Cases by Gender and Age")
graph export "gender.png", as(png) name("gender") replace

frame create tests
frame change tests
import delimited "https://raw.githubusercontent.com/pappubahry/AU_COVID19/master/time_series_tests.csv", clear
drop *pending
ds, not(type string)
foreach var of varlist `r(varlist)' {
replace `var' = `var'[_n-1] if `var' == .
}
foreach var of varlist `r(varlist)' {
replace `var' = 0 if `var' == .
}
egen total = rowtotal(nsw vic qld wa sa tas act nt)
generate date2 = date(date, "YMD")
drop date
format date %tdMon_DD
order date
rename * tests*
rename *date2 date
reshape long tests, i(date) j(state) string
replace state = upper(state)
local yesterday = date("`c(current_date)'", "DMY")
local yesterday = `yesterday' - 1
generate test = .
levelsof state, clean local(state)
foreach item of local state {
replace test = tests if state == "`item'" & date == `yesterday'
summarize test
local `item'tests = `r(max)'
replace test = .
}
drop test
graph bar (asis) tests if date == `yesterday' & state != "TOTAL", over(state, sort(tests) descending) bar(1, fcolor(pink) fintensity(inten70) lcolor(none%20)) name(tests, replace) title("COVID19 Tests Performed")
graph export "tests.png", as(png) name("tests") replace
generate newtests = .
sort state date
by state: replace newtests = tests[_n] - tests[_n-1]
twoway (bar newtests date, fcolor(yellow) lcolor(none%20)) if state == "TOTAL" & date >= `yesterday' - 29, xlabel(#30, labsize(vsmall) angle(forty_five)) name(tests30, replace) title("COVID19 Tests in Last 30 Days")
graph export "tests30.png", as(png) name(tests30) replace
twoway (connected tests date, fcolor(lavender) lcolor(none%20)) if date >= `yesterday' - 29 & state == "TOTAL", xlabel(#30, labsize(vsmall) angle(forty_five)) name(testtotal30, replace) title("Total COVID19 Tests")

frame change default
frame put if date == `yesterday', into(today)

frame create map
frame change map
use STE_2016_AUST_shp.dta
keep if _ID == 8
save actmap.dta, replace
use STE_2016_AUST.dta, clear
spset
frlink 1:1 state, frame(today)
frget cases, from(today)
sort cases
generate seq = _n
replace seq = . if state != "ACT"
summarize seq
local act = `r(min)'
if `act' == 1 | `act' == 2 {
local actgr = "navy*0.2"
}
if `act' == 3 | `act' == 4 {
local actgr = "navy*0.5"
}
if `act' == 5 | `act' == 6 {
local actgr = "navy*0.7"
}
if `act' == 7 | `act' == 8 {
local actgr = "navy*1.0"
}
generate casespercent = (cases/population)*100
grmap casespercent, fcolor(navy*0.2 navy*0.5 navy*0.7 navy*1.0) polygon(data("C:\Users\LauraWhiting\Documents\Maps\AUS\actmap.dta") fcolor(`actgr')) title("COVID19 Cases as Percent of Population")
graph export "map.png", as(png) name("Graph") replace


<</dd_do>>

#COVID19 Australia on <<dd_display: %tdDD_Month_CCYY `yesterday'>>


<span style="float:right" style="vertical-align:top"><<dd_graph: graphname(Graph) replace height(300)>></span>

| Confirmed | Deaths | Recovered | Active |
|:---------:|:------:|:---------:|:------:|
|<<dd_display: `TOTALcases'>>|<<dd_display: `TOTALdeaths'>>|<<dd_display: `TOTALrecovered'>>|<<dd_display: `TOTALactive'>>|

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;

| State | Confirmed | Deaths | Recovered | Active |
|:-----:|:---------:|:------:|:---------:|:------:|
|**ACT**|<<dd_display: `ACTcases'>>|<<dd_display: `ACTdeaths'>>|<<dd_display: `ACTrecovered'>>|<<dd_display: `ACTactive'>>|
|**NSW**|<<dd_display: `NSWcases'>>|<<dd_display: `NSWdeaths'>>|<<dd_display: `NSWrecovered'>>|<<dd_display: `NSWactive'>>|
|**NT** |<<dd_display: `NTcases'>>|<<dd_display: `NTdeaths'>>|<<dd_display: `NTrecovered'>>|<<dd_display: `NTactive'>>|
|**QLD**|<<dd_display: `QLDcases'>>|<<dd_display: `QLDdeaths'>>|<<dd_display: `QLDrecovered'>>|<<dd_display: `QLDactive'>>|
|**SA** |<<dd_display: `SAcases'>>|<<dd_display: `SAdeaths'>>|<<dd_display: `SArecovered'>>|<<dd_display: `SAactive'>>|
|**TAS**|<<dd_display: `TAScases'>>|<<dd_display: `TASdeaths'>>|<<dd_display: `TASrecovered'>>|<<dd_display: `TASactive'>>|
|**VIC**|<<dd_display: `VICcases'>>|<<dd_display: `VICdeaths'>>|<<dd_display: `VICrecovered'>>|<<dd_display: `VICactive'>>|
|**WA** |<<dd_display: `WAcases'>>|<<dd_display: `WAdeaths'>>|<<dd_display: `WArecovered'>>|<<dd_display: `WAactive'>>|

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
<span>
<table border="0">
<tr>
<span style="float:left"><<dd_graph: sav("gender.png") graphname(gender) replace height(300)>></span>
</tr><tr>
<span style="float:right"><<dd_graph: sav("tests.png") graphname(tests) replace height(300)>></span>
</tr>
</table>
<table border="0">
<tr>
<span style="float:left"><<dd_graph: sav("tests30.png") graphname(tests30) replace height(300)>></span>
</tr><tr>
<span style="float:right"><<dd_graph: sav("testtotal30.png") graphname(testtotal30) replace height(300)>></span>
</tr>
</table>
</span>
<table border="0">
</table>

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;


##Individual State/Territory

<select name='State' id='dlist' onChange='swapImage()'>
<option value="TOTAL">ALL</option>
<option value="WA">WA</option>
<option value="SA">SA</option>
<option value="NT">NT</option>
<option value="VIC">VIC</option>
<option value="NSW">NSW</option>
<option value="QLD">QLD</option>
<option value="ACT">ACT</option>
<option value="TAS">TAS</option>
</select>
<br></br>

<script type="text/javascript">
function swapImage(){
	var image1 = document.getElementById("imageToSwap1");
	var image2 = document.getElementById("imageToSwap2");
	var dropd = document.getElementById("dlist");
	image1.src = dropd.value + "case.png";
	image2.src = dropd.value + "rec.png";
};
</script>


<table border="0">
<tr>
<span style="float:left"><img id="imageToSwap1" src="TOTALcase.png" height="300" width="450" /></span>
</tr><tr>
<span style="float:right"><img id="imageToSwap2" src="TOTALrec.png" height="300" width="450" /></span>
</tr>
</table>