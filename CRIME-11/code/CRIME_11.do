********************** binscatter of the raw data (10/14) **********************
clear
use "../input/GA_cleaned_Ganong"

keep if ratedate<td(27jun2007) // after this date, sucscore also takes values in 20-97 range
keep if ratedate>td(1jan1982) & ratedate<td(27jun2003)
keep if duplicateGanong==0
keep if validDates==1
keep if servdaysprsnjail>=90 & servdaysprsnjail<=10*365
save "../input/GA_crime11",replace

******** Return-to-prison rate
clear
use "../input/GA_crime11"

twoway lpolyci rtp3 ratedate, tline(1Apr1993) ///
 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) //
graph export "../output/scatter_rtp.eps", replace
 
twoway lpolyci reconv3 ratedate, tline(1Apr1993) ///
 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) //
graph export "../output/scatter_reconv.eps", replace

binscatter rtp3 ratedate, n(100) savedata(binned) replace line(none)
clear
qui do binned
save "../input/binned",replace
*erase "../code/binned.csv"

clear
use "../input/GA_crime11"

append using "../input/binned", gen(binned)
twoway lpolyci rtp3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993) , bw(100) clcolor(black) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1Apr1993) , bw(100) clcolor(black) || ///
	   scatter rtp3 ratedate if binned == 1 , mc(blue) ||, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Return-to-prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return-to-prison rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp.eps", replace

********** Reconviction rate
clear
use "../input/GA_crime11"

binscatter reconv3 ratedate, n(100) savedata(binned2) replace line(none)
clear
qui do binned2
save "../input/binned2",replace
*erase "../code/binned2.csv"

clear
use "../input/GA_crime11"

append using "../input/binned2", gen(binned2)
twoway lpolyci reconv3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993) , bw(100) clcolor(black) || ///
	   lpolyci reconv3 ratedate if ratedate>=td(1Apr1993) , bw(100) clcolor(black) || ///
	   scatter reconv3 ratedate if binned2 == 1 , mc(blue) ||, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Reconviction rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov.eps", replace

** MSE-optimal bandwidth 52.405 (6 month)
twoway lpolyci reconv3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993) , bw(52.405) clcolor(black) || ///
	   lpolyci reconv3 ratedate if ratedate>=td(1Apr1993) , bw(52.405) clcolor(black) || ///
	   scatter reconv3 ratedate if binned2 == 1 , mc(blue) ||, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Reconviction rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_bw52.eps", replace


** MSE-optimal bandwidth 97.783 (1 year)
twoway lpolyci reconv3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993) , bw(97.783) clcolor(black) || ///
	   lpolyci reconv3 ratedate if ratedate>=td(1Apr1993) , bw(97.783) clcolor(black) || ///
	   scatter reconv3 ratedate if binned2 == 1 , mc(blue) ||, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Reconviction rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_bw97.eps", replace

** MSE-optimal bandwidth 125.188 (2 years)
twoway lpolyci reconv3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993) , bw(125.188) clcolor(black) || ///
	   lpolyci reconv3 ratedate if ratedate>=td(1Apr1993) , bw(125.188) clcolor(black) || ///
	   scatter reconv3 ratedate if binned2 == 1 , mc(blue) ||, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Reconviction rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_bw125.eps", replace


** MSE-optimal bandwidth 393.859 (5 years)
twoway lpolyci reconv3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993) , bw(393.859) clcolor(black) || ///
	   lpolyci reconv3 ratedate if ratedate>=td(1Apr1993) , bw(393.859) clcolor(black) || ///
	   scatter reconv3 ratedate if binned2 == 1 , mc(blue) ||, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Reconviction rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_bw393.eps", replace

************************ RD with different time range (10/14) ******************
********RD with 6 months
clear
use "../input/GA_crime11"

dis td(1Apr1993)  // 12144

**** rtp3
rdbwselect rtp3 ratedate if ratedate>=td(1oct1992) & ratedate<td(1oct1993), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 57.986
rdrobust rtp3 ratedate if ratedate>=td(1oct1992) & ratedate<td(1oct1993), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // insignificant

**** reconv3
rdbwselect reconv3 ratedate if ratedate>=td(1oct1992) & ratedate<td(1oct1993), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 52.405 
rdrobust reconv3 ratedate if ratedate>=td(1oct1992) & ratedate<td(1oct1993), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // insignificant


******** RD with 1 year
rdbwselect rtp3 ratedate if ratedate>=td(1apr1992) & ratedate<td(1apr1994), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 89.350 
rdrobust rtp3 ratedate if ratedate>=td(1apr1992) & ratedate<td(1apr1994), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // insignificant

**** reconv3
rdbwselect reconv3 ratedate if ratedate>=td(1apr1992) & ratedate<td(1apr1994), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 97.783  
rdrobust reconv3 ratedate if ratedate>=td(1apr1992) & ratedate<td(1apr1994), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // insignificant


******** RD with 2 years
rdbwselect rtp3 ratedate if ratedate>=td(1apr1991) & ratedate<td(1apr1995), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 112.473
rdrobust rtp3 ratedate if ratedate>=td(1apr1991) & ratedate<td(1apr1995), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // insignificant

**** reconv3
rdbwselect reconv3 ratedate if ratedate>=td(1apr1991) & ratedate<td(1apr1995), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 125.188 
rdrobust reconv3 ratedate if ratedate>=td(1apr1991) & ratedate<td(1apr1995), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // insignificant


******** RD with 5 years
rdbwselect rtp3 ratedate if ratedate>=td(1apr1988) & ratedate<td(1apr1998), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 445.741  
rdrobust rtp3 ratedate if ratedate>=td(1apr1988) & ratedate<td(1apr1998), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // significant (-.05973)

**** reconv3
rdbwselect reconv3 ratedate if ratedate>=td(1apr1988) & ratedate<td(1apr1998), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // MSE-optimal bandwidth is 393.859 
rdrobust reconv3 ratedate if ratedate>=td(1apr1988) & ratedate<td(1apr1998), ///
kernel(triangular) p(1) bwselect(mserd) c(12144) // significant (-.04739)



********************** replication of F2 (10/12) *******************************
clear
use "../input/GA_crime11"

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

