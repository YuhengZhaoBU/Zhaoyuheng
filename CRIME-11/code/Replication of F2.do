*** generate a figure parallel to Figure 4 in Marie paper
*** 1005 begin

clear
cd "../input"
use "GA cleaned Ganong"

keep if ratedate<td(27jun2007) // after this date, sucscore also takes values in 20-97 range
keep if ratedate>td(1jan1982) & ratedate<td(27jun2003)
keep if duplicateGanong==0
keep if validDates==1
keep if servdaysprsnjail>=90 & servdaysprsnjail<=10*365

*** replication of figure 2
*** 1008

*** take the mean of every 3 month
gen servmonthsprsnjail = servdaysprsnjail/365.25*12


gen period = .
replace period = 1  if ratedate >= td(1apr1990) & ratedate < td(1jul1990)
replace period = 2  if ratedate >= td(1jul1990) & ratedate < td(1oct1990)
replace period = 3  if ratedate >= td(1oct1990) & ratedate < td(1jan1991)
replace period = 4  if ratedate >= td(1jan1991) & ratedate < td(1apr1991)
replace period = 5  if ratedate >= td(1apr1991) & ratedate < td(1jul1991)
replace period = 6  if ratedate >= td(1jul1991) & ratedate < td(1oct1991)
replace period = 7  if ratedate >= td(1oct1991) & ratedate < td(1jan1992)
replace period = 8  if ratedate >= td(1jan1992) & ratedate < td(1apr1992)
replace period = 9  if ratedate >= td(1apr1992) & ratedate < td(1jul1992)
replace period = 10 if ratedate >= td(1jul1992) & ratedate < td(1oct1992)
replace period = 11 if ratedate >= td(1oct1992) & ratedate < td(1jan1993)
replace period = 12 if ratedate >= td(1jan1993) & ratedate < td(1apr1993)
replace period = 13 if ratedate >= td(1apr1993) & ratedate < td(1jul1993)
replace period = 14 if ratedate >= td(1jul1993) & ratedate < td(1oct1993)
replace period = 15 if ratedate >= td(1oct1993) & ratedate < td(1jan1994)
replace period = 16 if ratedate >= td(1jan1994) & ratedate < td(1apr1994)
replace period = 17 if ratedate >= td(1apr1994) & ratedate < td(1jul1994)
replace period = 18 if ratedate >= td(1jul1994) & ratedate < td(1oct1994)
replace period = 19 if ratedate >= td(1oct1994) & ratedate < td(1jan1995)
replace period = 20 if ratedate >= td(1jan1995) & ratedate < td(1apr1995)
replace period = 21 if ratedate >= td(1apr1995) & ratedate < td(1jul1995)
replace period = 22 if ratedate >= td(1jul1995) & ratedate < td(1oct1995)
replace period = 23 if ratedate >= td(1oct1995) & ratedate < td(1jan1996)
replace period = 24 if ratedate >= td(1jan1996) & ratedate < td(1apr1996)

collapse  (mean) adjguidemos servmonthsprsnjail rtp3, by(period)

*** figure2_1
scatter adjguidemos period if period <13, c(1) xlabel(1(1)24) ylabel(20(5)35, labsize(small)) ysc(r(20 35)) ///
 || scatter adjguidemos period if period >12, c(1) ylabel(20(5)35,labsize(small)) ysc(r(20 35)) ///
 || scatter servmonthsprsnjail period if period <13, msymbol(T) c(1) ylabel(20(5)35, angle(hor) labsize(small))  ///
 || scatter servmonthsprsnjail period if period >12, msymbol(T) c(1) ylabel(20(5)35, angle(hor) labsize(small)) ///
 ||, legend(order(1 2 3 4) label(1 "Guidelines (pre) ") label(2 "Guidelines (post) ") ///
 label(3 "Month served (pre) ") label(4 "Month served (post) ")  size(small)) ///
 xline(12.5) ///
			 xtitle("Period",  size(small)) ///
			 ytitle("Guidelines",  size(small)) ///
			 scheme(s1mono)


*** figure2_2 
scatter rtp3 period if period <13, c(1) xlabel(1(1)24) ylabel(.2(.05).4, labsize(small)) ///
yaxis(1) ///
 || scatter rtp3 period if period >12, c(1) ylabel(.2(.05).4,labsize(small)) yaxis(1)  ///
 || scatter servmonthsprsnjail period if period <13, msymbol(T) c(1) ylabel(20(5)35, axis(2)) yaxis(2) ///
 || scatter servmonthsprsnjail period if period >12, msymbol(T) c(1) ylabel(20(5)35, axis(2)) yaxis(2) ///
 ||, legend(order(1 2 3 4) label(1 "Rtp rate (pre) ") label(2 "Rtp rate (post) ") ///
 label(3 "Month served (pre) ") label(4 "Month served (post) ")  size(small)) ///
 xline(12.5) ///
			 xtitle("Period",  size(small)) ///
			 ytitle("Return-to-prison rate",  size(small)) ///			 
			 ytitle("Months served", axis(2)  size(small)) ///
			 scheme(s1mono)
			 
			 
			 			 

/*

** return-to-prison 
twoway lpolyci rtp3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993)            , bw(100) clcolor(black) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1Apr1993)                                    , bw(100) clcolor(black) || ///
	   if  servdaysprsnjail>=90 & servdaysprsnjail<=10*365, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Return-to-prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return-to-prison rate"  ,  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "Ganong rtp.png", replace width(666)


** reconviction
twoway lpolyci reconv3 ratedate if ratedate>=td(1may1983) & ratedate<td(1Apr1993)         , bw(100) clcolor(black) || ///
	   lpolyci reconv3 ratedate if ratedate>=td(1Apr1993)                                 , bw(100) clcolor(black) || ///
	   if  servdaysprsnjail>=90 & servdaysprsnjail<=10*365, ///
			 tline(1Apr1993) ///
			 legend(order(1) label(1 "Reconviction rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate",  size(small)) ///
			 xlabel(`=td(1may1983)'(`=2*365.25')`=td(27jun2003)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.20 "20%" .25 "25%" .3 "30%" .35 "35%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(reconv, replace)
graph export "Ganong reconv.png", replace width(666)


*** rtp only			 
scatter rtp3 period if period <13, c(1) xlabel(1(1)24) ylabel(.2(.05).4, labsize(small)) ///
 || scatter rtp3 period if period >12, c(1) ylabel(.2(.05).4,labsize(small))  ///
 ||, legend(order(1 2) label(1 "Rtp rate (pre) ") label(2 "Rtp rate (post) ")) ///
 xline(12.5) ///
			 xtitle("Period",  size(small)) ///
			 ytitle("Return-to-prison rate",  size(small)) ///			 
			 scheme(s1mono)		
			 
*** months served only			 
scatter servmonthsprsnjail period if period <13, msymbol(T) c(1) xlabel(1(1)24) ylabel(20(5)35)  ///
 || scatter servmonthsprsnjail period if period >12, msymbol(T) c(1) ylabel(20(5)35) ///
 ||, legend(order(3 4) label(3 "Month served (pre) ") label(4 "Month served (post) ")  size(small)) ///
 xline(12.5) ///
			 xtitle("Period",  size(small)) ///
			 ytitle("Months served", size(small)) ///
			 scheme(s1mono)			 
			 
			 
scatter rtp3 period if period <13, c(1) xlabel(1(1)24) ylabel(.2(.05).4, labsize(small)) ///
yaxis(1 2) ///
 || scatter rtp3 period if period >12, c(1) ylabel(.2(.05).4,labsize(small))  ///
 || scatter servmonthsprsnjail period if period <13, msymbol(T) c(1) ylabel(20(5)35, axis(2))  ///
 || scatter servmonthsprsnjail period if period >12, msymbol(T) c(1) ylabel(20(5)35, axis(2)) ///
 ||, legend(order(1 2 3 4) label(1 "Rtp rate (pre) ") label(2 "Rtp rate (post) ") ///
 label(3 "Month served (pre) ") label(4 "Month served (post) ")  size(small)) ///
 xline(12.5) ///
			 xtitle("Period",  size(small)) ///
			 ytitle("Return-to-prison rate",  size(small)) ///			 
			 ytitle("Months served", axis(2)  size(small)) ///
			 scheme(s1mono)

twoway lpolyci rtp3 ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993)            , bw(100) clcolor(black) || ///
       lpolyci rtp3 ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996)            , bw(100) clcolor(black) || ///
			 lpolyci servmonthsprsnjail ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 lpolyci servmonthsprsnjail ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 if  servdaysprsnjail>=90 & servdaysprsnjail<=10*365, ///
			 tline(1Apr1993) ///
			 legend(order(1 7) label(1 "Return-to-prison rate, 95% CI (left axis)") label(7 "Months served, 95% CI (right axis)") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return-to-prison rate"  ,  size(small)) ///
			 ytitle("Months served", axis(2) orient(rvertical) size(small)) ///
			 xlabel(`=td(1apr1990)'(`=2*365.25')`=td(1apr1996)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 ylabel(20(5)35, angle(hor) axis(2) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
			 			 

twoway lpolyci adjguidemos ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993)          , bw(100) clcolor(black) || ///
       lpolyci adjguidemos ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996)          , bw(100) clcolor(black) || ///
			 lpolyci servmonthsprsnjail ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 lpolyci servmonthsprsnjail ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 if  servdaysprsnjail>=90 & servdaysprsnjail<=10*365, ///
			 tline(1Apr1993) ///
			 legend(order(1 7) label(1 "Guidelines, 95% CI (left axis)") label(7 "Months served, 95% CI (right axis)") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Guidelines",  size(small)) ///
			 ytitle("Months served", axis(2) orient(rvertical) size(small)) ///
			 xlabel(`=td(1apr1990)'(`=2*365.25')`=td(1apr1996)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(20(5)35, angle(hor) labsize(small)) ///
			 ylabel(20(5)35, angle(hor) axis(2) labsize(small)) ///
			 scheme(s1color) name(reconv, replace)

*/

		 
			 
			 
			 
			 
/*			 
gen monthserve = timeserv *	12		 
			 
twoway lpolyci rtp3 ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993)            , bw(100) clcolor(black) || ///
       lpolyci rtp3 ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996)            , bw(100) clcolor(black) || ///
			 lpolyci monthserve ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 lpolyci monthserve ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 if  servdaysprsnjail>=90 & servdaysprsnjail<=10*365, ///
			 tline(1Apr1993) ///
			 legend(order(1 7) label(1 "Return-to-prison rate, 95% CI (left axis)") label(7 "Months served, 95% CI (right axis)") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return-to-prison rate"  ,  size(small)) ///
			 ytitle("Months served", axis(2) orient(rvertical) size(small)) ///
			 xlabel(`=td(1apr1990)'(`=2*365.25')`=td(1apr1996)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 ylabel(20(5)35, angle(hor) axis(2) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
			 
			 
twoway lpolyci reconv3 ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993)          , bw(100) clcolor(black) || ///
       lpolyci reconv3 ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996)          , bw(100) clcolor(black) || ///
			 lpolyci servmonthsprsnjail ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 lpolyci servmonthsprsnjail ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 if  servdaysprsnjail>=90 & servdaysprsnjail<=10*365, ///
			 tline(1Apr1993) ///
			 legend(order(1 7) label(1 "Reconviction rate, 95% CI (left axis)") label(7 "Months served, 95% CI (right axis)") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Reconviction rate",  size(small)) ///
			 ytitle("Months served", axis(2) orient(rvertical) size(small)) ///
			 xlabel(`=td(1apr1990)'(`=2*365.25')`=td(1apr1996)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .30 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 ylabel(20(5)35, angle(hor) axis(2) labsize(small)) ///
			 scheme(s1color) name(reconv, replace)

			 
twoway lpolyci rtp3 ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993)            , bw(100) clcolor(black) || ///
       lpolyci rtp3 ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996)            , bw(100) clcolor(black) || ///
			 lpolyci parmonths ratedate if ratedate>=td(1Apr1990) & ratedate<td(1Apr1993), bw(100) lcolor(black) lpat(dash) yaxis(2) || ///
			 lpolyci parmonths ratedate if ratedate>=td(1may1993) & ratedate<td(1Apr1996), bw(100) lcolor(black) lpat(dash) yaxis(2) , ///
			 tline(1Apr1993) ///
			 legend(order(1 7) label(1 "Return-to-prison rate, 95% CI (left axis)") label(7 "parmonths, 95% CI (right axis)") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return-to-prison rate"  ,  size(small)) ///
			 ytitle("parmonths", axis(2) orient(rvertical) size(small)) ///
			 xlabel(`=td(1apr1990)'(`=2*365.25')`=td(1apr1996)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.30 "30%" .35 "35%" .40 "40%" .45 "45%", angle(hor) labsize(small)) ///
			 ylabel(20(5)35, angle(hor) axis(2) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)			 
*/

