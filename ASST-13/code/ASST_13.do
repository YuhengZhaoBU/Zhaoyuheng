*******************************************************************************
*******************************************************************************
*****    ASST-13                                                  *************
*****    Explore data from Chattopadhyay and Duflo ECMA 2004.     *************
*****    Yuheng Zhao 10/25/2019.                                  *************
*******************************************************************************
*******************************************************************************

** [comments] the data provided online only include West Bengal, not Rajasthan
** https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/USBFNOMLAT
** All below summary are for West Bengal only and campared with the West Bengal data in the paper

clear
use "../input/womenpolicymakers_parta.dta"

replace womres=0 if womres==2
replace prsex=0 if prsex==1
replace prsex=1 if prsex==2

tab womres prsex
asdoc tab womres prsex, save(T1) replace  // 

*tab2xl2 womres prsex using T1, row(2) col(2) replace
*tab2xl womres prsex using T1, row(2) col(2) replace  // for stata 15 and above
** [T1][comments] a little bit different since the Proportion of Female Pradhans for Unreserved GP here is 7.5% rather than 6.5% in the paper.

** [T2][comments] village variables in T2 are collected by the 1991 census of India, not included here

merge 1:1 gpnum using "womenpolicymakers_partb.dta", gen (_mb)
merge 1:1 gpnum using "womenpolicymakers_resurveya", gen (_mra)
merge 1:1 gpnum using "womenpolicymakers_resurveyd", gen (_mrd)
save "merged data_ECMA2004.dta",replace

merge 1:m gpnum using "womenpolicymakers_partc.dta", gen (_mc) // different villnum within gpnum
merge 1:1 gpnum villnum using "womenpolicymakers_partd.dta", gen (_md)
save "merged data_ECMA2004_GP.dta",replace
********

clear
use "../input/merged data_ECMA2004_GP.dta"


replace gpwiss=0 if gpwiss==2
replace vgswq=. if vgswq==9
replace vgswq=0 if vgswq==2
replace rwomissue=0 if rwomissue==2
replace rmissue=0 if rmissue==2

asdoc bysort  womres: sum vgswp rwomissue rmissue, save(T3) replace  // 
** [T3][comments] part of T3 is close, but some are quite different from the paper.
** Fraction of Men Filed a Complaint to the GP is exactly the same as in the paper.
** Fraction of women among participant here is 10.38% and 6.87% for reserved and unreserved, but 9.80% and 6.88% in the paper
** Fraction of Women Filed a Complaint to the GP is 61.11% and 74.19% for reserved and unreserved, but 20% and 11% in the paper

** [T4][comments] information on T4 (ISSUES RAISED BY WOMEN AND MEN IN THE LAST 6 MONTH) were not provided in the data
** some information about detail issues in vwiss1-vwiss4, but the total number is about 91, far less from 500 in the paper

gen roadcon = (vroad==1)
gen numvssk = .
replace numvssk=0 if vssk==2
replace numvssk=vsskn if vssk==1

replace gminrn=. if gminrn==99
replace gminrn=0 if gminr==2
replace gminbn=0 if gminb==2

gen numirri =.
replace numirri=0 if gminb==2 & gminr==2
replace numirri=gminbn + gminrn if gminb==1 | gminr==1

asdoc bysort womres: sum roadcon numvssk numirri, save(T5_village) replace

** [T5][comments] 
** [T5 village level] different from the paper.
** Information on "Number of Drinking Water Facilities Newly Built or Repaired" were not provided in the data
** Condition of Roads (1 if in good condition) is 0.18 and 0.12 for reserved and unreserved, but 0.41 and 0.23 in the paper.
** Number of Panchayat Run Education Centers is 0.07 and 0.13 for reserved and unreserved, while it is 0.06 and 0.12 in the paper.
** Number of Irrigation Facilities Newly Built or Repaired is 1.04 and 0.65 for reserved and unreserved, but 3.01 and 3.39 in the paper.
** Information on community building is not provided.

************
clear
use "../input/merged data_ECMA2004.dta"

replace gmetb=0 if gmetb==2
replace gmetr=0 if gmetr==2
replace gtubb=0 if gtubb==2
replace gssk=0 if gssk==2
replace gshalb=0 if gshalb==2

gen gmetbr = gmetb + gmetr
replace gmetbr=1 if gmetbr==1 | gmetbr==2

asdoc bysort womres: sum gtubb gmetbr gssk gshalb, save(T5_GP) replace

** [T5 GP level] almost the same from the paper.
** New Tubewell Was Built is 1 and 0.93 for reserved and unreserved, which is the same as in the paper
** Metal Road Was Built or Repaired is 0.67 and 0.48 for reserved and unreserved, which is the same as in the paper
** An Informal Education Center in the GP is 0.67 and 0.82 for reserved and unreserved, which is the same as in the paper
** At Least One Irrigation Pump Was Built is 0.15 and 0.09 for reserved and unreserved, while it is 0.17 and 0.09 in the paper

** [T6][comments] T6 is regression table, not included here

bysort womres: sum predu prlit mars nboy ngirl hesit
** [T7][comments] TBC
sum nboy ngirl
gen nchi = nboy+ngirl

sum hhtel hhelec hhtv hhcyc hhmcyc hhcar
replace hhtel=0 if hhtel==2
replace hhelec=0 if hhelec==2
replace hhtv=0 if hhtv==2
replace hhcyc=0 if hhcyc==2
replace hhmcyc=0 if hhmcyc==2
replace hhcar=0 if hhcar==2
replace prlit=1 if predu>=5
replace prlit=0 if prlit==2
replace hhbpl=0 if hhbpl==2
replace hesit=0 if hesit==2
replace hesit=. if hesit==7
replace mars=. if mars==3
replace mars=0 if mars==4

gen hhasset = hhtel + hhelec + hhtv + hhcyc + hhmcyc + hhcar

replace oldpr=0 if oldpr==2
replace prexp=0 if prexp==2

* population of Pradhan's own villages is given by India census
* panel a
asdoc bysort womres: sum prage predu prlit mars nchi hhbpl hhasset hesit, save(T7_a) replace
** [T7_a][comments] age, number of children, below poverty line, number of hh assets, hessitates in answering is exactly the same as in the paper
** for edu, it's 10.36 (womres==0) and 8.33 (womres==1), while it's 7.13 and 9.92 in the paper
** for literacy, it's 0.99 (womres==0) and 0.87 (womres==1), while it's 0.98 and 0.80 in the paper
** for marriage, it's 0.87 (womres==0) and 0.94 (womres==1), while it's 0.87 and 0.89 in the paper

* information on Was Elected to the GP Council Before 1998 is not available
* panel b
replace knfunc=0 if knfunc==2 | knfunc==3
replace notrain=0 if notrain==2
replace spelect=0 if spelect==2
replace spelect=0 if spelect==2
gen nofutrun=.
replace nofutrun=1 if futrun==2
replace nofutrun=0 if futrun!=2
replace sphelp=0 if sphelp==2
asdoc bysort womres: sum oldpr prexp knfunc notrain spelect sphelp nofutrun, save(T7_b) replace
** [T7_b][comments] prexp, knfunc, notrain, nofutrun is exactly the same as in the paper
** for Pradhan Before 1998 (oldpr), it's 0.02 (womres==0) and 0 (womres==1), while it's 0.12 and 0 in the paper
** for Spouse ever Elected to the Panchayat (spelect), it's 0.2 (womres==0) and 0.64 (womres==1), while it's 0.02 and 0.17 in the paper (much fewer obs)
** for Spouse Helps (sphelp), it's 0.54 (womres==0) and 0.92 (womres==1), while it's 0.13 and 0.43 in the paper  (much fewer obs)

* panel c
gen right = .
replace right =0
replace right =1 if praff==6 | praff==7   // see wikipedia https://en.wikipedia.org/wiki/All_India_Trinamool_Congress
gen left =.
replace left  =0 
replace left  =1 if praff==1  // see wikipedia https://en.wikipedia.org/wiki/Left_Front_(West_Bengal)

asdoc bysort womres: sum left right, save(T7_c) replace
** [T7_c][comments] Right (Trinamul or BJP) is exactly the same as in the paper
** for Left Front, it's 0.62 (womres==0) and 0.65 (womres==1), while it's 0.69 and 0.69 in the paper







