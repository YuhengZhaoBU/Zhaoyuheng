********************** Kuziemko (11/03) **********************

clear
use "../input/GA_crime15"

*keep if ratedate!=.
sort ratedate
dis td(1jan1998)  // 13880

************************ RD with different time range (10/14) ******************
******** PART1 1jan1998 treatment
******** rtp3

** restricted sample to serve time between 4 and 5 years
** because This condition means that inmates who begin their sentence in the final year of my sample period (2001) will be
** released by 2006 and will thus have spent all or the large majority of their time in prison while the 90% policy was in effect.
** also because this will form a better control group (not to light crime)

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
binscatter rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999), tline(13880) n(60) savedata(binned_1y) replace line(none)
clear
qui do binned_1y
save "../input/binned_1y",replace

clear
use "../input/GA_crime15"
binscatter rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000), tline(13880) n(100) savedata(binned_2y) replace line(none)
clear
qui do binned_2y
save "../input/binned_2y",replace


clear
use "../input/GA_crime15"
** MSE-optimal bandwidth 60.308 (6 month)
append using "../input/binned_6m", gen(binned_6m)
twoway lpolyci rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jan1998) , bw(60.308) clcolor(black) degree (1) kernel(triangle) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1jan1998) & ratedate<td(1jul1998), bw(60.308) clcolor(black) degree (1) kernel(triangle) || ///
	   scatter rtp3 ratedate if binned_6m == 1 , mc(blue) ||, ///
			 tline(1jan1998) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1jul1997)'(`=365.25/12')`=td(1jul1998)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp_6m.eps", replace

** MSE-optimal bandwidth 102.364 (1 year)
append using "../input/binned_1y", gen(binned_1y)
twoway lpolyci rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1998) , bw(102.364) clcolor(black) degree (1) kernel(triangle) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1jan1998) & ratedate<td(1jan1999) , bw(102.364) clcolor(black) degree (1) kernel(triangle) || ///
	   scatter rtp3 ratedate if binned_1y == 1 , mc(blue) ||, ///
			 tline(1jan1998) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1jan1997)'(`=365.25/6')`=td(1jan1999)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp_1y.eps", replace

** MSE-optimal bandwidth 140.682 (2 years)
append using "../input/binned_2y", gen(binned_2y)
twoway lpolyci rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan1998) , bw(140.682) clcolor(black) degree (1) kernel(triangle) || ///
	   lpolyci rtp3 ratedate if ratedate>=td(1jan1998) & ratedate<td(1jan2000) , bw(140.682) clcolor(black) degree (1) kernel(triangle) || ///
	   scatter rtp3 ratedate if binned_2y == 1 , mc(blue) ||, ///
			 tline(1jan1998) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1jan1996)'(`=365.25/3')`=td(1jan2000)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp_2y.eps", replace




******** PART2 18mar1981 treatment
clear
use "../input/GA_crime15"

sort tentparoledate
order tentparoledate
dis td(18mar1981)

******** RD with 6 months
* This doesn't work, Invertibility problem in the computation of preliminary bandwidth below the threshold...
*rdbwselect rtp3 tentparoledate if tentparoledate>=td(18sep1980) & tentparoledate<td(18sep1981), ///
*kernel(triangular) p(1) bwselect(mserd) c(7747) // MSE-optimal bandwidth is 16.761
*rdrobust rtp3 tentparoledate if tentparoledate>=td(18sep1980) & tentparoledate<td(18sep1981), ///
*kernel(triangular) p(1) bwselect(mserd) c(7747) // insignificant


******** RD with 1 year
rdbwselect rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1982), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) // MSE-optimal bandwidth is 107.200
rdrobust rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1982), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) // insignificant


******** RD with 2 years
rdbwselect rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1983), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) // MSE-optimal bandwidth is 248.694 
rdrobust rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1983), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) // insignificant


clear
use "../input/GA_crime15"
binscatter rtp3 tentparoledate if tentparoledate>=td(18sep1980) & tentparoledate<td(18sep1981), tline(7747) n(40) savedata(binned81_6m) replace line(none)
clear
qui do binned81_6m
save "../input/binned81_6m",replace

clear
use "../input/GA_crime15"
binscatter rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1982), tline(7747) n(60) savedata(binned81_1y) replace line(none)
clear
qui do binned81_1y
save "../input/binned81_1y",replace

clear
use "../input/GA_crime15"
binscatter rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1983), tline(7747) n(100) savedata(binned81_2y) replace line(none)
clear
qui do binned81_2y
save "../input/binned81_2y",replace



** MSE-optimal bandwidth 37.733 (1 year), restricted time on the early period
append using "../input/binned81_1y", gen(binned81_1y)
twoway lpolyci rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1981) , bw(107.200) clcolor(black) degree (1) kernel(triangle) || ///
	   lpolyci rtp3 tentparoledate if tentparoledate>=td(18mar1981) & tentparoledate<td(18mar1982) , bw(107.200) clcolor(black) degree (1) kernel(triangle) || ///
	   scatter rtp3 tentparoledate if binned81_1y == 1 , mc(blue) ||, ///
			 tline(18mar1981) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1feb1981)'(`=365.25/6')`=td(18mar1982)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///	
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp81_1y2.eps", replace

** MSE-optimal bandwidth 62.193 (2 years), restricted time on the early period
append using "../input/binned81_2y", gen(binned81_2y)
twoway lpolyci rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1981) , bw(248.694) clcolor(black) degree (1) kernel(triangle) || ///
	   lpolyci rtp3 tentparoledate if tentparoledate>=td(18mar1981) & tentparoledate<td(18mar1983) , bw(248.694) clcolor(black) degree (1) kernel(triangle) || ///
	   scatter rtp3 tentparoledate if binned81_2y == 1 , mc(blue) ||, ///
			 tline(18mar1981) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1feb1981)'(`=365.25/3')`=td(18mar1983)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///	
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp81_2y2.eps", replace
