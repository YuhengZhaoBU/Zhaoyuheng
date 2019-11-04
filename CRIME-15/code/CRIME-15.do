********************** Kuziemko (11/03) **********************

clear
use "../input/GA_crime15"

keep if ratedate!=.
sort ratedate
dis td(1jan1998)  // 13880

************************ RD with different time range (10/14) ******************
******** PART1 1jan1998 treatment
******** rtp3

******** RD with 6 months
rdbwselect rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998), ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 60.308
rdrobust rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998), ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant


******** RD with 1 year
rdbwselect rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999), ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 102.364
rdrobust rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999), ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant


******** RD with 2 years
rdbwselect rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000), ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 140.682
rdrobust rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000), ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant


********************************************************************************
******** 3 graphs: fitted lines from the data range that each optimal bandwidth 
******** got computed from (6m, 1y, 2y) + binscatter cover the same data range. (11/04/2019)

clear
use "../input/GA_crime15"
binscatter rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998), tline(13880) n(40) savedata(binned_6m) replace line(none)
clear
qui do binned_6m
save "../input/binned_6m",replace

clear
use "../input/GA_crime15"
binscatter rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999), tline(13880) n(40) savedata(binned_1y) replace line(none)
clear
qui do binned_1y
save "../input/binned_1y",replace

clear
use "../input/GA_crime15"
binscatter rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000), tline(13880) n(40) savedata(binned_2y) replace line(none)
clear
qui do binned_2y
save "../input/binned_2y",replace


clear
use "../input/GA_crime15"
** MSE-optimal bandwidth 60.308 (6 month)
append using "../input/binned_6m", gen(binned_6m)
twoway lpolyci rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jan1998) , bw(60.308) clcolor(black) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1jan1998) & ratedate<td(1jul1998), bw(60.308) clcolor(black) || ///
	   scatter rtp3 ratedate if binned_6m == 1 , mc(blue) ||, ///
			 tline(1jan1998) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1jul1997)'(`=365.25/12')`=td(1jul1998)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_6m.eps", replace

** MSE-optimal bandwidth 102.364 (1 year)
append using "../input/binned_1y", gen(binned_1y)
twoway lpolyci rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1998) , bw(102.364) clcolor(black) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1jan1998) & ratedate<td(1jan1999) , bw(102.364) clcolor(black) || ///
	   scatter rtp3 ratedate if binned_1y == 1 , mc(blue) ||, ///
			 tline(1jan1998) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1jan1997)'(`=365.25/6')`=td(1jan1999)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_1y.eps", replace

** MSE-optimal bandwidth 140.682 (2 years)
append using "../input/binned_2y", gen(binned_2y)
twoway lpolyci rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan1998) , bw(140.682) clcolor(black) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1jan1998) & ratedate<td(1jan2000) , bw(140.682) clcolor(black) || ///
	   scatter rtp3 ratedate if binned_2y == 1 , mc(blue) ||, ///
			 tline(1jan1998) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1jan1996)'(`=365.25/3')`=td(1jan2000)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_recov_2y.eps", replace





