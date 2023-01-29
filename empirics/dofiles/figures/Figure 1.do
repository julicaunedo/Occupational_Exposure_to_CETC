/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates Figure 1 from draft

Data from previous files 
********************************************/


	
********************************************
*1) Figure 1: Panel A 
********************************************	

	use "$final_data/[10]stocks_occuCPS_2020_DOTONET_base85.dta", replace
	
	drop if year<1985
		egen total = sum(total_workers), by(year)
		gen employ = total_workers/total
		foreach var in stock_all{
			sum `var' 
			replace `var' = 0.00001 if `var' == 0 | (`var' == . & stock_all==.) 
		}


	ren stock_all total_stock


*/
	*%%%% Generate classification by 1 digit
		gen occ1d  = .
			replace occ1d = 1 if occ2d >= 4 & occ2d <= 37
			replace occ1d = 2 if occ2d >= 43 & occ2d <= 199
			replace occ1d = 3 if occ2d >= 203 & occ2d <= 235
			replace occ1d = 4 if occ2d >= 243 & occ2d <= 285
			replace occ1d = 5 if occ2d >= 303 & occ2d <= 389
			replace occ1d = 6 if occ2d >= 405 & occ2d <= 471
			replace occ1d = 7 if occ2d >= 503 & occ2d <= 599
			replace occ1d = 8 if occ2d >= 628 & occ2d <= 696
			replace occ1d = 9 if occ2d >= 699 & occ2d <= 799
			replace occ1d = 7 if occ2d >= 803 & occ2d <= 889

	keep  occ1d total_workers total_stock stock* employ year occ2d total_hours


	duplicates drop occ2d year, force
	collapse (sum) total_stock stock* total_workers total_hours, by(year occ1d)

	* Variables in logs
	gen level_total=log(total_stock)
	gen level_total_f_share=log(stock_f_share)
	gen level_total_adj_share=log(stock_adj_share)
	gen level_total_f_agg=log(stock_f_agg)
	gen level_total_pure=log(stock_pure)

	drop stock_per_worker*

	gen per_worker_stock=total_stock/total_hours
			gen per_worker_f_agg= stock_f_agg/total_hours
			gen per_worker_f_share= stock_f_share/total_hours
			gen per_worker_pure= stock_pure/total_hours
			gen per_worker_adj_share= stock_adj_share/total_hours
	gen per_worker_stock_HCETC=stock_HCETC/total_hours
	gen per_worker_stock_LCETC=stock_LCETC/total_hours
	gen per_worker_stock_COMPUTERS=stock_COMPUTERS/total_hours

	gen level_computers=log(stock_COMPUTERS)
	gen level_hcetc= log(stock_HCETC)
	gen level_lcetc= log(stock_LCETC)

	gen l_per_w_stock=log(per_worker_stock)
			gen l_per_w_f_agg=log(per_worker_f_agg)
			gen l_per_w_f_share=log(per_worker_f_share)
			gen l_per_w_pure=log(per_worker_pure)
			gen l_per_w_adj_share=log(per_worker_adj_share)
	gen l_per_w_stock_HCETC=log(per_worker_stock_HCETC)
	gen l_per_w_stock_LCETC=log(per_worker_stock_LCETC)
	gen l_per_w_stock_COMPUTERS=log(per_worker_stock_COMPUTERS)


	levelsof(occ1d), local(locc1d)
	foreach i of local locc1d {
	gen level_total_`i'=level_total if occ1d==`i'
	gen level_worker_`i'=log(total_workers) if occ1d==`i'
	gen level_hours_`i'=log(total_hours) if occ1d==`i'
	gen per_worker_`i'=l_per_w_stock if occ1d==`i'
	gen per_worker_level_`i'=per_worker_stock if occ1d==`i'
	gen l_per_w_f_agg_`i'=l_per_w_f_agg if occ1d==`i'
	gen l_per_w_f_share_`i'=l_per_w_f_share if occ1d==`i'
	gen l_per_w_pure_`i'=l_per_w_pure if occ1d==`i'
	gen l_per_w_adj_share_`i'=l_per_w_adj_share if occ1d==`i'
			
	gen per_worker_HCETC_`i'=l_per_w_stock_HCETC if occ1d==`i'
	gen per_worker_LCETC_`i'=l_per_w_stock_LCETC if occ1d==`i'
	gen per_worker_COMPUTERS_`i'=l_per_w_stock_COMPUTERS if occ1d==`i'
	gen level_total_f_share_`i'=level_total_f_share if occ1d==`i'
	gen level_total_adj_share_`i'=level_total_adj_share if occ1d==`i'
	gen level_total_f_agg_`i'=level_total_f_agg if occ1d==`i'
	gen level_total_pure_`i'=level_total_pure if occ1d==`i'
	}


	gen averagepw_lev=.
	replace averagepw=per_worker_level_1 if year==1985
	egen avepw_lev=mean(averagepw_lev)
	
	levelsof(occ1d), local(locc1d)
	foreach i of local locc1d{
	replace per_worker_level_`i'=log(per_worker_level_`i'/avepw_lev)
	ren per_worker_level_`i' per_worker_lev_`i'
	}
	
	gen averagepw=.
	replace averagepw=per_worker_1 if year==1985
	egen avepw=mean(averagepw)
	bys occ1d: su avepw
	su per_worker_*
	su per_worker_1 per_worker_2 per_worker_3 per_worker_4 per_worker_5 per_worker_6 per_worker_7 per_worker_8 per_worker_9 if year==1985
	su per_worker_1 per_worker_2 per_worker_3 per_worker_4 per_worker_5 per_worker_6 per_worker_7 per_worker_8 per_worker_9 if year==2016

	levelsof(occ1d), local(locc1d)
	foreach i of local locc1d{
	replace per_worker_`i'=per_worker_`i'/avepw
	}
	sort occ1d year


	two (connect per_worker_lev_1 per_worker_lev_2 per_worker_lev_3 per_worker_lev_4 per_worker_lev_5 per_worker_lev_6 per_worker_lev_7 per_worker_lev_8 per_worker_lev_9 year), ytitle("Capital per worker (logs)") xtitle("year") xmtick(1982(10)2020) xlabel(1982(10)2020) legend(pos(7) ring(1) col(3) lab(1 "managers") lab(2 "professionals") lab(3 "technicians") lab(4 "sales") lab(5 "admin serv.") lab(6 "low-skill serv.") lab(7 "mechanics & transp.") lab(8 "precision") lab(9 "machine operators") ) graphregion(margin(right) fcolor(white) lcolor(white))

	graph export "$results/[Figure1_panelA]Perworker_lev_stock-byoccupation_DOTONET_base85_tmech.pdf",replace


	
********************************************
*1) Figure 1: Panel B
********************************************	


use "$intermediate_data/[15]usercost_implied_base85.dta",clear


ren implied_usercost k_price1d

sort occ1d year

		ren k_price1d k_price
	
bys occ1d: gen normp=k_price if year==1985
    bys occ1d: egen normalize=mean(normp)

levelsof(occ1d), local(locc1d)
foreach i of local locc1d{
gen level_total_`i'=log(k_price)-log(normalize) if occ1d==`i'
}
keep if year>=1985 & year<=2016

replace year=year-1
two (connect  level_total_1 level_total_2 level_total_3 level_total_4 level_total_5 level_total_6 level_total_8 level_total_10 level_total_11  year), ytitle("Usercost of capital relative to consump. (logs)") xtitle("year") xmtick(1980(10)2020) xlabel(1980(10)2020)  legend(pos(7) ring(1) col(3) lab(1 "managers") lab(2 "professionals") lab(3 "technicians") lab(4 "sales") lab(5 "admin serv.") lab(6 "low-skill serv.") lab(7 "mechanics & transp.") lab(8 "precision") lab(9 "machine operators")) graphregion(margin(right) fcolor(white) lcolor(white)) 
graph export "$results/[Figure1_panelB]usercostbytime_implied_052021_base85_tmech.pdf", replace








