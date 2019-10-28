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
** [T1][comments] a little bit different since the Proportion of Female Pradhans for Unreserved GP here is 7.5% rather than 6.5% in the paper.

** [T2][comments] village variables in T2 are collected by the 1991 census of India

merge 1:1 gpnum using "womenpolicymakers_partb.dta", gen (_mb)
merge 1:1 gpnum using "womenpolicymakers_resurveya", gen (_mra)
merge 1:1 gpnum using "womenpolicymakers_resurveyd", gen (_mrd)

replace gpwiss=0 if gpwiss==2
replace rwomissue=0 if rwomissue==2
replace rmissue=0 if rmissue==2
replace gpgswp =. if gpgswp==99

save "merged data_ECMA2004_GP.dta",replace

bysort womres: sum gpgswp rwomissue rmissue  // gpwiss
** [T3][comments] quite different from the paper.
** Fraction of women among participant here is 7.58% and 6.01% for reserved and unreserved, but 9.80% and 6.88% in the paper
** Fraction of Women Filed a Complaint to the GP is 61.11% and 74.19% for reserved and unreserved, but 20% anf 11% in the paper
** Fraction of Women Filed a Complaint to the GP is 94.44% and 100% for reserved and unreserved, which is the same as in the paper.

** [T4][comments] information on T4 (ISSUES RAISED BY WOMEN AND MEN IN THE LAST 6 MONTH) were not provided in the data

************
merge 1:m gpnum using "womenpolicymakers_partc.dta", gen (_mc) // different villnum within gpnum
merge 1:1 gpnum villnum using "womenpolicymakers_partd.dta", gen (_md)
save "merged data_ECMA2004.dta",replace

clear
use "../input/merged data_ECMA2004.dta"

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

bysort womres: sum roadcon numvssk numirri
** [T5][comments] 
** [T5 village level] different from the paper.
** Information on "Number of Drinking Water Facilities Newly Built or Repaired" were not provided in the data
** Condition of Roads (1 if in good condition) is 0.18 and 0.12 for reserved and unreserved, but 0.41 and 023 in the paper.
** Number of Panchayat Run Education Centers is 0.07 and 0.13 for reserved and unreserved, while it is 0.06 and 0.12 in the paper.
** Number of Irrigation Facilities Newly Built or Repaired is 1.04 and 0.65 for reserved and unreserved, but 3.01 and 3.39 in the paper.
** Information on community building is not provided.

************
clear
use "../input/merged data_ECMA2004_GP.dta"

replace gmetb=0 if gmetb==2
replace gmetr=0 if gmetr==2
replace gtubb=0 if gtubb==2
replace gssk=0 if gssk==2
replace gshalb=0 if gshalb==2

gen gmetbr = gmetb + gmetr
replace gmetbr=1 if gmetbr==1 | gmetbr==2

bysort womres: sum gtubb gmetbr gssk gshalb
** [T5 GP level] almost the same from the paper.
** New Tubewell Was Built is 1 and 0.93 for reserved and unreserved, which is the same as in the paper
** Metal Road Was Built or Repaired is 0.67 and 0.48 for reserved and unreserved, which is the same as in the paper
** An Informal Education Center in the GP is 0.67 and 0.82 for reserved and unreserved, which is the same as in the paper
** At Least One Irrigation Pump Was Built is 0.15 and 0.09 for reserved and unreserved, while it is 0.17 and 0.09 in the paper

** [T6][comments] T6 is regression table, not included here

bysort womres: sum predu prlit mars nboy ngirl hesit
** [T7][comments] TBC












