

/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Construcs user cost by Nipa code and year


Data comes from previous files
********************************************/

	


	use "$intermediate_data/[4]prices_by_asset_type.dta", clear
	
tab nipa_code

	reshape long price_, i( nipa_code) j(year)
merge 1:1 nipa_code year using "$intermediate_data/[8]depreciation_adjusted_DOTONET.dta"

drop _merge
merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"


ren pcepi cpi


sort nipa_code year
bysort nipa_code: gen pricechange=(price_[_n]/cpi[_n]*cpi[_n-1]/price_[_n-1])
local R_opt=1.02
local delta=0.05


gen occ_change_price = 1 if year ==  1985  // base year (as in the data, see Comparison of our stock) 100

	xtset nipa_code year
		replace occ_change_price = L.occ_change_price * (price_/L.price_) if year >1985
		replace occ_change_price = F.occ_change_price * (price_/F.price_) if year <1985

replace price_=occ_change_price
drop occ_change_price

gen usercost=price_[_n-1]*(`R_opt'-(1-depreciation_decade)*pricechange)

drop _merge

save "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta", replace



