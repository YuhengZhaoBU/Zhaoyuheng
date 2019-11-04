insheet using binned_1y.csv

twoway (scatter rtp3 ratedate, mcolor(navy) lcolor(maroon)) , graphregion(fcolor(white))  xtitle(ratedate) ytitle(rtp3) legend(off order()) tline(13880)
