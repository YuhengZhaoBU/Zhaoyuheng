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
save "../temp/binned_6m",replace
erase "../input/binned_6m.do"
erase "../input/binned_6m.csv"

clear
use "../input/GA_crime15"
binscatter rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999), tline(13880) n(60) savedata(binned_1y) replace line(none)
clear
qui do binned_1y
save "../temp/binned_1y",replace
erase "../input/binned_1y.do"
erase "../input/binned_1y.csv"

clear
use "../input/GA_crime15"
binscatter rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000), tline(13880) n(100) savedata(binned_2y) replace line(none)
clear
qui do binned_2y
save "../temp/binned_2y",replace
erase "../input/binned_2y.do"
erase "../input/binned_2y.csv"

clear
use "../input/GA_crime15"
** MSE-optimal bandwidth 60.308 (6 month)
append using "../temp/binned_6m", gen(binned_6m)
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
append using "../temp/binned_1y", gen(binned_1y)
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
append using "../temp/binned_2y", gen(binned_2y)
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



**** reg “percent of sentence served” on inmate’s personal characteristic in pre-reform period, 
**** and use the regression to predict the "percent of sentence served" for inmates influenced by the reform (1993-2001). 
dis td(1jan1993)  // 12054
dis td(31dec2001)  // 15340


replace ageatadmission = . if ageatadmission <0
replace ageatsentencing= . if ageatsentencing<0
gen male = sexcode
replace male=0 if male==1
replace male=1 if male==2

sum servdaysprsnjail tentparoledate admitdate ageatadmission ageatfirstcommit ageatsentencing priorincars numpriorincars typeadmission inmatetype

reg servdaysprsnjail male ageatadmission priorincars i.racecode i.typeadmission i.inmatetype if tentparoledate<13880
* male           114.93
* ageatadmission  -3.69
* priorincars     74.40
* cons          -455.72

reg servdaysprsnjail male ageatadmission priorincars if tentparoledate<13880
* male           113.85
* ageatadmission  -2.41
* priorincars     76.72
* cons           449.05


// need to distinguish individuals convicted serious(treat) and less serious(control).
// and use serious(treat) group to generate the p10 p25

* follow Roodman's code to generate pct90crime
gen byte pct90crime = inlist(curoff1 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff1 ,1123,1601) & ((parcrimecode1==curoff1  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff1  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff1  & parcrimeseverity3==5 & parcrimesuffix3==1))) | ///
	                  inlist(curoff2 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff2 ,1123,1601) & ((parcrimecode1==curoff2  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff2  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff2  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
	                  inlist(curoff3 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff3 ,1123,1601) & ((parcrimecode1==curoff3  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff3  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff3  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
	                  inlist(curoff4 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff4 ,1123,1601) & ((parcrimecode1==curoff4  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff4  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff4  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
	                  inlist(curoff5 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff5 ,1123,1601) & ((parcrimecode1==curoff5  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff5  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff5  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
	                  inlist(curoff6 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff6 ,1123,1601) & ((parcrimecode1==curoff6  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff6  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff6  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
	                  inlist(curoff7 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff7 ,1123,1601) & ((parcrimecode1==curoff7  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff7  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff7  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
					  inlist(curoff8 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff8 ,1123,1601) & ((parcrimecode1==curoff8  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff8  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff8  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
					  inlist(curoff9 ,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff9 ,1123,1601) & ((parcrimecode1==curoff9  & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff9  & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff9  & parcrimeseverity3==5 & parcrimesuffix3==1))) | /// 
					  inlist(curoff10,1102,1103,1121,1190,1302,1305,1314,1315,1321,1901,1903,1904,1905,1911,2006,2018,2019,2020,2091,2751,2801) | (inlist(curoff10,1123,1601) & ((parcrimecode1==curoff10 & parcrimeseverity1==5 & parcrimesuffix1==1) | (parcrimecode2==curoff10 & parcrimeseverity2==5 & parcrimesuffix2==1) | (parcrimecode3==curoff10 & parcrimeseverity3==5 & parcrimesuffix3==1)))

gen predictserv = male*113.85 - 2.41*ageatadmission + 76.72*priorincars + 449.05 if tentparoledate>=13880 & sentdate<15340 & pct90crime==1
sort predictserv
order predictserv

sum predictserv, detail 
gen p25=(predictserv<=485.78) if tentparoledate>=13880 & sentdate<15340 & pct90crime==1
gen p10=(predictserv<=451.06) if tentparoledate>=13880 & sentdate<15340 & pct90crime==1


******** RD with 6 months p25
rdbwselect rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998) & pct90crime==1 & p25==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 52.783
rdrobust rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998) & pct90crime==1 & p25==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant p=0.438

******** RD with 1 year p25
rdbwselect rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999) & pct90crime==1 & p25==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 108.365
rdrobust rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999) & pct90crime==1 & p25==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant p=0.483

******** RD with 2 years p25
rdbwselect rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000) & pct90crime==1 & p25==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 178.715
rdrobust rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000) & pct90crime==1 & p25==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant p=0.175


******** RD with 6 months p10
rdbwselect rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998) & pct90crime==1 & p10==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 72.838
rdrobust rtp3 ratedate if ratedate>=td(1jul1997) & ratedate<td(1jul1998) & pct90crime==1 & p10==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant p=0.294

******** RD with 1 year p10
rdbwselect rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999) & pct90crime==1 & p10==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 142.596
rdrobust rtp3 ratedate if ratedate>=td(1jan1997) & ratedate<td(1jan1999) & pct90crime==1 & p10==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant p=0.581

******** RD with 2 years p10
rdbwselect rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000) & pct90crime==1 & p10==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // MSE-optimal bandwidth is 328.566
rdrobust rtp3 ratedate if ratedate>=td(1jan1996) & ratedate<td(1jan2000) & pct90crime==1 & p10==1, ///
kernel(triangular) p(1) bwselect(mserd) c(13880) // insignificant p=0.717



