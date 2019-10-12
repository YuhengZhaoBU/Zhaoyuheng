

clear
use "../input/GA_cleaned_Ganong"

keep if ratedate<td(27jun2007) // after this date, sucscore also takes values in 20-97 range
keep if ratedate>td(1jan1982) & ratedate<td(27jun2003)
keep if duplicateGanong==0
keep if validDates==1
keep if servdaysprsnjail>=90 & servdaysprsnjail<=10*365

*** replication of figure 2

*** take the mean of every 3 month
gen servmonthsprsnjail = servdaysprsnjail/365.25*12

***
dis td(1apr1990)

** loop
local this_period = td(1apr1990)
gen group_date = .
forval i = 1/24 {
    local this_month = month(`this_period')
    local this_year = year(`this_period')
    local next_month = cond(`this_month'<=9, `this_month' + 3, `this_month' + 3 - 12)
    local next_year = cond(`this_month'<=9, `this_year', `this_year' + 1)
    local next_period = mdy(`next_month', 1, `next_year')
    replace group_date = `next_period' if ratedate>=`this_period' & ratedate<`next_period'
    local this_period = `next_period'
}


collapse  (mean) adjguidemos servmonthsprsnjail rtp3, by(group_date)

scatter adjguidemos group_date if group_date <= td(1apr1993), c(1) xlabel(`=td(1Apr1990)'(`=2*365.25')`=td(1Apr1996)', format(%tdMon-YY)) ylabel(20(5)35, labsize(small)) ysc(r(20 35)) ///
 || scatter adjguidemos group_date if group_date > td(1apr1993), c(1) ylabel(20(5)35,labsize(small)) ysc(r(20 35)) ///
 || scatter servmonthsprsnjail group_date if group_date <= td(1apr1993), msymbol(T) c(1) ylabel(20(5)35, angle(hor) labsize(small))  ///
 || scatter servmonthsprsnjail group_date if group_date >  td(1apr1993), msymbol(T) c(1) ylabel(20(5)35, angle(hor) labsize(small)) ///
 ||, legend(order(1 2 3 4) label(1 "Guidelines (pre) ") label(2 "Guidelines (post) ") ///
 label(3 "Month served (pre) ") label(4 "Month served (post) ")  size(small)) ///
 xline(12189) ///
			 xtitle("Date of parole decision", size(small)) ///
			 ytitle("Guidelines",  size(small)) ///
			 scheme(s1mono)
graph export "../output/Figure2_1.eps", replace		 


scatter rtp3 group_date if group_date <= td(1apr1993), c(1) xlabel(`=td(1Apr1990)'(`=2*365.25')`=td(1Apr1996)', format(%tdMon-YY)) ylabel(.3(.05).45, labsize(small)) ///
yaxis(2) ///
 || scatter rtp3 group_date if group_date > td(1apr1993), c(1) ylabel(.3(.05).45,labsize(small)) yaxis(2)  ///
 || scatter servmonthsprsnjail group_date if group_date <= td(1apr1993), msymbol(T) c(1) ylabel(20(5)35, axis(1)) yaxis(1) ///
 || scatter servmonthsprsnjail group_date if group_date >  td(1apr1993), msymbol(T) c(1) ylabel(20(5)35, axis(1)) yaxis(1) ///
 ||, legend(order(1 2 3 4) label(1 "Rtp rate (pre) ") label(2 "Rtp rate (post) ") ///
 label(3 "Month served (pre) ") label(4 "Month served (post) ")  size(small)) ///
 xline(12189) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return-to-prison rate", axis(2) size(small)) ///			 
			 ytitle("Months served", size(small)) ///
			 scheme(s1mono)
graph export "../output/Figure2_2.eps", replace					 

