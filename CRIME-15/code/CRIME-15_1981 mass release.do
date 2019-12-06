******** PART2 18mar1981 treatment
clear all
use "../input/GA_crime15"

** drop outliers in tentparoledate
format tentparoledate %td
drop if tentparoledate < admitdate & admitdate!=.
save "../temp/GA_crime15_clean", replace


******** RD with 6 months
* This doesn't work, Invertibility problem in the computation of preliminary bandwidth below the threshold...
clear all
use "../temp/GA_crime15_clean"
sort tentparoledate
order tentparoledate
dis td(18mar1981)
cap rdbwselect rtp3 tentparoledate if tentparoledate>=td(18apr1980) & tentparoledate<td(18feb1982), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) //  Invertibility problem
cap rdrobust rtp3 tentparoledate if tentparoledate>=td(18apr1980) & tentparoledate<td(18feb1982), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) //  Invertibility problem


******** RD with 1 year
clear all
use "../temp/GA_crime15_clean"
sort tentparoledate
order tentparoledate
dis td(18mar1981)
cap rdbwselect rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1982), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) //  Invertibility problem
cap rdrobust rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1982), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) //  Invertibility problem


******** RD with 2 years
clear all
use "../temp/GA_crime15_clean"
sort tentparoledate
order tentparoledate
dis td(18mar1981)
rdbwselect rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1983), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) // MSE-optimal bandwidth is 157.676 
rdrobust rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1983), ///
kernel(triangular) p(1) bwselect(mserd) c(7747) // insignificant


********
clear
use "../temp/GA_crime15_clean"
binscatter rtp3 tentparoledate if tentparoledate>=td(18sep1980) & tentparoledate<td(18sep1981), tline(7747) n(40) savedata(binned81_6m) replace line(none)
clear
qui do binned81_6m
save "../temp/binned81_6m",replace
erase "../code/binned81_6m.do"
erase "../code/binned81_6m.csv"

clear
use "../temp/GA_crime15_clean"
binscatter rtp3 tentparoledate if tentparoledate>=td(18mar1980) & tentparoledate<td(18mar1982), tline(7747) n(60) savedata(binned81_1y) replace line(none)
clear
qui do binned81_1y
save "../temp/binned81_1y",replace
erase "../code/binned81_1y.do"
erase "../code/binned81_1y.csv"

clear
use "../temp/GA_crime15_clean"
binscatter rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1983), tline(7747) n(100) savedata(binned81_2y) replace line(none)
clear
qui do binned81_2y
save "../temp/binned81_2y",replace
erase "../code/binned81_2y.do"
erase "../code/binned81_2y.csv"


** MSE-optimal bandwidth 157.676 (2 years), restricted time on the early period
append using "../temp/binned81_2y", gen(binned81_2y)
twoway lpolyci rtp3 tentparoledate if tentparoledate>=td(18mar1979) & tentparoledate<td(18mar1981) , bw(157.676) clcolor(black) degree (1) kernel(triangle) || ///
	   lpolyci rtp3 tentparoledate if tentparoledate>=td(18mar1981) & tentparoledate<td(18mar1983) , bw(157.676) clcolor(black) degree (1) kernel(triangle) || ///
	   scatter rtp3 tentparoledate if binned81_2y == 1 , mc(blue) ||, ///
			 tline(18mar1981) ///
			 legend(order(1) label(1 "Return to prison rate, 95% CI") region(style(none)) margin(zero) size(small)) ///
			 xtitle("Date of parole decision",  size(small)) ///
			 ytitle("Return to prison rate"  ,  size(small)) ///
			 xlabel(`=td(1feb1981)'(`=365.25/3')`=td(18mar1983)', format(%tdMon-YY) labsize(small)) ///
			 ylabel(.05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%" .3 "30%" .35 "35%" .4 "40%", angle(hor) labsize(small)) ///	
			 scheme(s1color) name(rtp, replace)
graph export "../output/bin_fix_rtp81_2y2.eps", replace
