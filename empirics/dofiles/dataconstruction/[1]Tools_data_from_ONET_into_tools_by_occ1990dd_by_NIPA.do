/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Code counting tool data from ONET by comodity family and occupation. 

Computation of intensity of tool use for each occupation on the different NIPA categories 
1) We classify each of the tools and technology into the lines in NIPA tables. All technology is considered software. 

2) For each occupation, we estimate the number of tools that they use in each NIPA category 

3) Match the tool-use intensity to the occupation code in Ipums based on Deming (2017) occupation crosswalks.


Data from ONET is public and comes from : https://www.onetcenter.org/db_releases.html (see version 23.1) (accesed Juanary 2019)
********************************************/


	
*********************************************************************
* call original data

import excel "$raw_data/Tool_data_ONET/Tools and Technology_23_1.xlsx", sheet("`Tools and Technology'") firstrow cellrange (A1:H69615) clear 
ren CommodityCode commoditycode
ren ONETSOCCode onetsoccode

*Generates tool family code to merge with NIPA
	gen familycode = int(commoditycode/10000)* 10000

*Gen occupation code
	gen aux1 = substr(onetsoccode,1,2)
	gen aux2 = substr(onetsoccode,4,4)
	egen occupation = concat(aux1 aux2)
	destring occupation,replace
	drop aux*

* Merge with data with NIPA classification
* This cross-walk was created by the authors and corresponds to the one presented in the online appendix of the paper.
	merge m:1 familycode using "$raw_data/Tool_data_ONET/Crosswalk_tools_to_nipa.dta" 


*1) Collapse data by occupation and NIpa cathegory
	gen count_t_t_ = 1
	collapse (sum) count_t_t_, by (occupation nipa_code)
	drop if nipa_code == .
	reshape wide count_t_t_, i(occupation) j(nipa_code)


	label var count_t_t_4  "Computers and peripheral"
	label var count_t_t_5  "Communication"
	label var count_t_t_6  "Medical instruments"
	label var count_t_t_9  "Nonmedical instruments"
	label var count_t_t_10  "Photocopy equip"
	label var count_t_t_11  "Office and accounting equip"
	label var count_t_t_13  "Fabricated metal products"
	label var count_t_t_14  "Engines and turbines"
	label var count_t_t_17  "Metalworking machinery"
	label var count_t_t_18  "Special industry machinery"
	label var count_t_t_19  "General industry mach"
	label var count_t_t_20  "Electrical transmision"
	label var count_t_t_41  "Electrical equip"
	label var count_t_t_2225  "Truks,cars"
	label var count_t_t_26  "Aircraft"
	label var count_t_t_27  "Ships and boats"
	label var count_t_t_28  "Railroad"
	label var count_t_t_29  "Other equip"
	label var count_t_t_30  "Furniture"
	label var count_t_t_33  "Agricultural machinery"
	label var count_t_t_36  "Construction machinery"
	label var count_t_t_39  "Mining machinery"
	label var count_t_t_40  "Service machinery"
	label var count_t_t_99  "Software"

	* rename 
	ren occupation occsoc
	
* 2) Match with occ1990dd data 

	*a) Firts merge with 2010 classification
	merge 1:1 occsoc using "$raw_data/Crosswalks/occsoc_ONET_to_occ2010.dta"

	
	drop if _merge == 2
	egen aux =count(occ2010)
	ren occ2010 occ
	drop _merge
	

	*b) Merge with Deaming occ1990dd
	merge m:1 occ using "$raw_data/Crosswalks/occ2010_occ1990dd.dta"


	drop if _merge == 2

	drop _merge
	drop occ
	
	*Data by occ1990dd
	collapse (mean) count_t_t_4 count_t_t_5 count_t_t_6 count_t_t_9 count_t_t_10 count_t_t_11 count_t_t_13 count_t_t_14 count_t_t_17 count_t_t_18 count_t_t_19 count_t_t_20 count_t_t_26 count_t_t_27 count_t_t_28 count_t_t_29 count_t_t_30 count_t_t_33 count_t_t_36 count_t_t_39 count_t_t_40 count_t_t_41 count_t_t_99 count_t_t_2225, by(occ1990dd)


	label var count_t_t_4  "Computers and peripheral"
	label var count_t_t_5  "Communication"
	label var count_t_t_6  "Medical instruments"
	label var count_t_t_9  "Nonmedical instruments"
	label var count_t_t_10  "Photocopy equip"
	label var count_t_t_11  "Office and accounting equip"
	label var count_t_t_13  "Fabricated metal products"
	label var count_t_t_14  "Engines and turbines"
	label var count_t_t_17  "Metalworking machinery"
	label var count_t_t_18  "Special industry machinery"
	label var count_t_t_19  "General industry mach"
	label var count_t_t_20  "Electrical transmision"
	label var count_t_t_26  "Aircraft"
	label var count_t_t_27  "Ships and boats"
	label var count_t_t_28  "Railroad"
	label var count_t_t_29  "Other equip"
	label var count_t_t_30  "Furniture"
	label var count_t_t_33  "Agricultural machinery"
	label var count_t_t_36  "Construction machinery"
	label var count_t_t_39  "Mining machinery"
	label var count_t_t_40  "Service machinery"
	label var count_t_t_41  "Electrical equip"
	label var count_t_t_99  "Software"
	label var count_t_t_2225  "Truks,cars"

*3) Save final data 
	save "$intermediate_data/[1]equiptment_nipa_of_occ1990dd.dta", replace

// End of do file
