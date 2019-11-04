** DATA CLEAN by Roodman

cap program drop PrepKuziemko
program define PrepKuziemko
	syntax, dataset(string)
	use "../input/GA_cleaned_Ganong", clear

	recode racecode (9 = .)
	gen byte drugcrime = curoff1>=4000 & curoff1<=4136
	gen byte violcrime = 3.currvioflag
	gen byte propcrime = !inlist(majoroffensegroup, ., 3, 4, 6, 11, 12, 14, 15, 16, 17) & !inlist(majoroffensegroup, 18, 19, 20, 33, 34, 35, 36) // embodies bug in definition
	gen byte burglary = curoff1==1601
	gen byte hispanic = ethnicity==1
	gen sentlenRound = round(sentLenMos, 12)
	replace timeserv = timeserv * 12
	gen timerec = timeserv + mofd(oldtentreldate)-mofd(actualreldate) // time recommended, mass release
	gen admitmonth = month(admitdate)
	gen actualrelyear  =  year(actualreldate)
	gen sentbeginyear = year(sentbegindate)
	gen crimeyear = year(crimedate)
	gen byte after97 = crimeyear > 1997 if crimeyear<2007 // 90% policy adoption
	gen clust = parcrimeseverity1 * 10000 + sucscore //  parcrimeseverity1 is used, but not quite same as grid severity
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

	* Roodman-preferred definitions
	gen byte drugcrimeDR = inlist(majoroffensegroup, 33, 34, 35, 36)
	gen byte propcrimeDR = inlist(majoroffensegroup, 11, 12, 14, 15, 16) // definitions actually taken from Kuziemko's revised code
	gen byte violcrimeDR = inlist(majoroffensegroup, 3, 4, 6, 17, 18, 19, 20)
	recode majoroff (5 7 = 4) (2 6 8 = 9) // group into 1=violent, 3=property, 4=drug, 9=other
	gen clustDR = sucscore*10 + severitylevel
	gen sentyear = year(sentdate)
	gen timerecDR = timeserv + (oldtentreldate - actualreldate)/365.25*12 // difference in day-resolution rather than month-resolution dates
	gen byte after97DR = sentyear > 1997 // 90% policy applied to sentences decided, not crimes committed, as of 1 January 1998. http://j.mp/29EplKh

	keep if sentLenMos>6 & sentLenMos<121 & admnewprobpar==1
end

global generalSample ageatadmission>17 & sb441flag!=3 & sucscore>0 & sucscore<20 & activeinmateflag==1 & ///
	parconsidtype==1 & parcrimeseverity1>0 & admitdate>=td(1jan1993) & actualreldate<td(1jan2008)

global gridSample   admitdate>=td(1jan1995) & admitdate<td(1jan2006) & sentbegindate>=td(1jan1995) & sentbegindate<td(1jan2006) &  ///
	parconsidtype==1 & timeserv>0 & totalmostoserve>0 & parcrimeseverity1>0 & !pct90crime & sb441flag!=3 & parcrimeseverity1<5 & ///
	sucscore>3 & sucscore<14 & actualreldate<td(1jan2006)
global gridSampleDR admitdate<td(1jan2006) &        sentdate<td(1jan2006) & ///
	parconsidtype==1 & timeserv>0 & totalmostoserve>0 &                       !pct90crime & sb441flag!=3 &     severitylevel<5 & ///
	                           actualreldate<td(1jan2006) & ageatadmission>17

global massReleaseSample activeinmateflag==1 & sentLenMos<73 & timeserv>0 & actualreldate==td(16mar1981) & releasecode==40

global pct90Sample   sentbegindate>=td(1jan1993) & sentbegindate<td(1jan2002) & parconsidtype==1 & timeserv>0 & totalmostoserve>0 & sb441flag!=3 & ///
	sucscore>0 & sucscore<21 & parcrimeseverity1<8 & ageatadmission>17
global pct90SampleDR      sentdate>=td(1jan1993) & sentdate<td(1jan2002)      & parconsidtype==1 & timeserv>0 & totalmostoserve>0 & sb441flag!=3 & ///
	sucscore>0 & sucscore<21 &     severitylevel<8 & ageatadmission>17 & sentlen<=5

global controlsKuziemko 2.racecode 2.sexcode ageatadmission numpriorincars

save "../input/GA_crime15",replace

