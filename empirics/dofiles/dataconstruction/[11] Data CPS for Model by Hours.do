/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Construcs stocks by worker by occupation (3 digit, 2 digit, and 1 digit), year and detailed equipment

Data from previous files
********************************************/

	
*********************************************************************



* 1) 3 Digit aggregation

	use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear

	gen stock_per_worker= stock/total_hours

	keep average_eq* average_inv occ2d  occ1d year stock* total_workers total_hours low_skill_workers* high_skill_workers* female_workers wage nipa_code relat_price_change 
 
	drop stock_f* stock_pure stock_adj*

	
	ren stock total_stock
	ren stock_per_worker stock

	su total_stock if nipa_code==4 & year==2000
	disp r(sum)


	merge m:1 nipa_code year using  "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"
	drop _merge
	preserve 
	keep nipa_code occ2d stock total_stock year total_workers total_hours price_ usercost average_inv average_eq* low_skill_workers* high_skill_workers*  wage occ1d
	save "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_DOTONET_base85.dta", replace
	restore 
	
	drop pricechange depreciation* average_eq* 
	drop if nipa_code==.
	*Save stocks_per_worker instead of aggregates
	keep average_inv stock total_stock relat_price_change price_ usercost occ2d year nipa_code
	reshape wide average_inv stock total_stock relat_price_change price_ usercost, i(occ2d year) j(nipa_code)

	*collapse (sum) stock*, by (year)
		ren stock4 computers
		ren stock5 communication
		ren stock6 med_ins
		ren stock9 non_med_ins
		ren stock10 photocopy
		ren stock11  office
		ren stock13  metal_products
		ren stock14  engines
		ren stock17  metal_machinery
		ren stock18  special_machinery
		ren stock19  general_industry_machinery
		ren stock20  elctrical_trans
		ren stock41  electrical
		ren stock2225  cars_trucks
		ren stock26  aircraft
		ren stock27  ships
		ren stock28  rail
		ren stock29  other_transport
		ren stock30  furniture
		ren stock33  agricultural
		ren stock36  construction
		ren stock39  mining
		ren stock40  service
		ren stock99  software
		
		ren average_inv4 computers_sh
		ren average_inv5 communication_sh
		ren average_inv6 med_ins_sh
		ren average_inv9 non_med_ins_sh
		ren average_inv10 photocopy_sh
		ren average_inv11  office_sh
		ren average_inv13  metal_products_sh
		ren average_inv14  engines_sh
		ren average_inv17  metal_machinery_sh
		ren average_inv18  special_machinery_sh
		ren average_inv19  general_industry_machinery_sh
		ren average_inv20  elctrical_trans_sh
		ren average_inv41  electrical_sh
		ren average_inv2225  cars_trucks_sh
		ren average_inv26  aircraft_sh
		ren average_inv27  ships_sh
		ren average_inv28  rail_sh
		ren average_inv29  other_transport_sh
		ren average_inv30  furniture_sh
		ren average_inv33  agricultural_sh
		ren average_inv36  construction_sh
		ren average_inv39  mining_sh
		ren average_inv40  service_sh
		ren average_inv99  software_sh

		ren total_stock4 computers_ts
		ren total_stock5 communication_ts
		ren total_stock6 med_ins_ts
		ren total_stock9 non_med_ins_ts
		ren total_stock10 photocopy_ts
		ren total_stock11  office_ts
		ren total_stock13  metal_products_ts
		ren total_stock14  engines_ts
		ren total_stock17  metal_machinery_ts
		ren total_stock18  special_machinery_ts
		ren total_stock19  general_industry_machinery_ts
		ren total_stock20  elctrical_trans_ts
		ren total_stock41  electrical_ts
		ren total_stock2225  cars_trucks_ts
		ren total_stock26  aircraft_ts
		ren total_stock27  ships_ts
		ren total_stock28  rail_ts
		ren total_stock29  other_transport_ts
		ren total_stock30  furniture_ts
		ren total_stock33  agricultural_ts
		ren total_stock36  construction_ts
		ren total_stock39  mining_ts
		ren total_stock40  service_ts
		ren total_stock99  software_ts
			
		saveold "$intermediate_data/[11]stocks_bydetailedequipmentCPS_DOTONET_base85.dta", replace
		
		
		
		
* 2) 1 Digit aggregation		
		

	use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear

	
	collapse (sum) stock* total_investment total_hours total_workers low_skill_workers* high_skill_workers* female_workers  average_eq1d share_eq1 (mean) wage average_inv relat_price_change, by(occ1d nipa_code year)



			gen stock_per_worker= stock/total_hours

			drop stock_f* stock_pure* stock_adj_share
	keep average_eq* occ1d year stock* total_workers total_hours low_skill_workers* high_skill_workers* female_workers wage nipa_code relat_price_change average_inv share_eq1


	ren stock total_stock
	ren stock_per_worker stock



	merge m:1 nipa_code year using   "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"

	drop _merge
	preserve 
	keep nipa_code occ1d stock total_stock year total_workers total_hours wage price_ usercost average_eq* share_eq1 average_inv occ1d
	save "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_byhours_1d_from3d_DOTONET_base85.dta", replace
	restore 

	drop pricechange depreciation* average_eq* share_eq1
	drop if nipa_code==.

	*Save stocks_per_worker 
	reshape wide average_inv stock total_stock relat_price_change price_ usercost, i(occ1d year) j(nipa_code)

		ren stock4 computers
		ren stock5 communication
		ren stock6 med_ins
		ren stock9 non_med_ins
		ren stock10 photocopy
		ren stock11  office
		ren stock13  metal_products
		ren stock14  engines
		ren stock17  metal_machinery
		ren stock18  special_machinery
		ren stock19  general_industry_machinery
		ren stock20  elctrical_trans
		ren stock41  electrical
		ren stock2225  cars_trucks
		ren stock26  aircraft
		ren stock27  ships
		ren stock28  rail
		ren stock29  other_transport
		ren stock30  furniture
		ren stock33  agricultural
		ren stock36  construction
		ren stock39  mining
		ren stock40  service
		ren stock99  software
		
		ren average_inv4 computers_sh
		ren average_inv5 communication_sh
		ren average_inv6 med_ins_sh
		ren average_inv9 non_med_ins_sh
		ren average_inv10 photocopy_sh
		ren average_inv11  office_sh
		ren average_inv13  metal_products_sh
		ren average_inv14  engines_sh
		ren average_inv17  metal_machinery_sh
		ren average_inv18  special_machinery_sh
		ren average_inv19  general_industry_machinery_sh
		ren average_inv20  elctrical_trans_sh
		ren average_inv41  electrical_sh
		ren average_inv2225  cars_trucks_sh
		ren average_inv26  aircraft_sh
		ren average_inv27  ships_sh
		ren average_inv28  rail_sh
		ren average_inv29  other_transport_sh
		ren average_inv30  furniture_sh
		ren average_inv33  agricultural_sh
		ren average_inv36  construction_sh
		ren average_inv39  mining_sh
		ren average_inv40  service_sh
		ren average_inv99  software_sh

		ren total_stock4 computers_ts
		ren total_stock5 communication_ts
		ren total_stock6 med_ins_ts
		ren total_stock9 non_med_ins_ts
		ren total_stock10 photocopy_ts
		ren total_stock11  office_ts
		ren total_stock13  metal_products_ts
		ren total_stock14  engines_ts
		ren total_stock17  metal_machinery_ts
		ren total_stock18  special_machinery_ts
		ren total_stock19  general_industry_machinery_ts
		ren total_stock20  elctrical_trans_ts
		ren total_stock41  electrical_ts
		ren total_stock2225  cars_trucks_ts
		ren total_stock26  aircraft_ts
		ren total_stock27  ships_ts
		ren total_stock28  rail_ts
		ren total_stock29  other_transport_ts
		ren total_stock30  furniture_ts
		ren total_stock33  agricultural_ts
		ren total_stock36  construction_ts
		ren total_stock39  mining_ts
		ren total_stock40  service_ts
		ren total_stock99  software_ts
	
		saveold "$intermediate_data/[11]stocks_bydetailedequipmentCPS_byhours_1d_agg3d_DOTONET_base85.dta", replace
			
			
	* 3) 2 Digit occupation			

	use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear

	ren occ2d occ1990dd
	***Service Occupations
	g occ_2d=.
	/* housekeeping, cleaning, laundry */
	replace occ_2d=1 if     (occ1990dd>=405 & occ1990dd<=408)
	 /* all protective service */
	replace occ_2d=2 if (occ1990dd>=415 & occ1990dd<=427)
	/* supervisors of guards; guards */
	**Included under 2 in David's file
	replace occ_2d=2 if (occ1990dd==415 | (occ1990dd>=425 & occ1990dd<=427))
	 /* food preparation and service occs */
	replace occ_2d=3 if (occ1990dd>=433 & occ1990dd<=444)
	/* health service occs (dental ass., health/nursing aides) */
	replace occ_2d=4 if (occ1990dd>=445 & occ1990dd<=447)
	 /* building and grounds cleaning and maintenance occs */
	replace occ_2d=5 if (occ1990dd>=448 & occ1990dd<=455)
	/* personal appearance occs */
	replace occ_2d=6 if (occ1990dd>=457 & occ1990dd<=458)
	/* recreation and hospitality occs */
	replace occ_2d=6 if (occ1990dd>=459 & occ1990dd<=467)
	/* child care workers */
	replace occ_2d=7 if (occ1990dd==468)
	/* misc. personal care and service occs */
	replace occ_2d=6 if (occ1990dd>=469 & occ1990dd<=472)

	***Non-service occupations
	/* executive, administrative and managerial occs */
	replace occ_2d=8 if (occ1990dd>=3 & occ1990dd<=22)
	/* management related occs */
	replace occ_2d=9 if (occ1990dd>=23 & occ1990dd<=37)
	/* professional specialty occs */
	replace occ_2d=10 if (occ1990dd>=43 & occ1990dd<=200)
	/* technicians and related support occs */
	replace occ_2d=11 if (occ1990dd>=203 & occ1990dd<=235)
	/* financial sales and related occs */
	replace occ_2d=12 if (occ1990dd>=243 & occ1990dd<=258)
	/* retail sales occs */
	replace occ_2d=13 if (occ1990dd>=274 & occ1990dd<=283)
	/* administrative support occs */
	replace occ_2d=14 if (occ1990dd>=303 & occ1990dd<=389)
	/* fire fighting, police, and correctional insitutions */
	**Included in  2 in David's file
	replace occ_2d=2 if (occ1990dd>=417 & occ1990dd<=423)
	/* farm operators and managers */
	replace occ_2d=15 if (occ1990dd>=473 & occ1990dd<=475)
	/* other agricultural and related occs */
	replace occ_2d=16 if (occ1990dd>=479 & occ1990dd<=498)
	/* mechanics and repairers */
	replace occ_2d=17 if (occ1990dd>=503 & occ1990dd<=549)
	/* construction trades */
	replace occ_2d=18 if (occ1990dd>=558 & occ1990dd<=599)
	/* extractive occs */
	replace occ_2d=19 if (occ1990dd>=614 & occ1990dd<=617)
	/* precision production occs */
	replace occ_2d=20 if (occ1990dd>=628 & occ1990dd<=699)
	/* machine operators, assemblers, and inspectors */
	replace occ_2d=21 if (occ1990dd>=703 & occ1990dd<=799)
	/* transportation and material moving occs */
	replace occ_2d=17 if (occ1990dd>=803 & occ1990dd<=889)

	ren occ1990dd occ2d


	collapse (sum) stock* total_investment total_hours total_workers low_skill_workers* high_skill_workers* female_workers  average_eq1d share_eq1 (mean) wage average_inv relat_price_change, by(occ_2d nipa_code year)



			gen stock_per_worker= stock/total_hours

			drop stock_f* stock_pure* stock_adj_share
	keep average_eq* occ_2d year stock* total_workers total_hours low_skill_workers* high_skill_workers* female_workers wage nipa_code relat_price_change average_inv share_eq1


	ren stock total_stock
	ren stock_per_worker stock

	su total_stock if nipa_code==4 & year==2000
	disp r(sum)


	merge m:1 nipa_code year using  "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"

	drop _merge
		preserve 
		keep nipa_code stock total_stock year total_workers total_hours wage price_ usercost average_eq* share_eq1 average_inv occ_2d
		save "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_byhours_2d-elast_from3d_DOTONET_base85.dta", replace
		restore 

	drop pricechange depreciation* average_eq* share_eq1
	drop if nipa_code==.

	*Save stocks_per_worker 
	reshape wide average_inv stock total_stock relat_price_change price_ usercost, i(occ_2d year) j(nipa_code)

	*collapse (sum) stock*, by (year)
		ren stock4 computers
		ren stock5 communication
		ren stock6 med_ins
		ren stock9 non_med_ins
		ren stock10 photocopy
		ren stock11  office
		ren stock13  metal_products
		ren stock14  engines
		ren stock17  metal_machinery
		ren stock18  special_machinery
		ren stock19  general_industry_machinery
		ren stock20  elctrical_trans
		ren stock41  electrical
		ren stock2225  cars_trucks
		ren stock26  aircraft
		ren stock27  ships
		ren stock28  rail
		ren stock29  other_transport
		ren stock30  furniture
		ren stock33  agricultural
		ren stock36  construction
		ren stock39  mining
		ren stock40  service
		ren stock99  software
		
		ren average_inv4 computers_sh
		ren average_inv5 communication_sh
		ren average_inv6 med_ins_sh
		ren average_inv9 non_med_ins_sh
		ren average_inv10 photocopy_sh
		ren average_inv11  office_sh
		ren average_inv13  metal_products_sh
		ren average_inv14  engines_sh
		ren average_inv17  metal_machinery_sh
		ren average_inv18  special_machinery_sh
		ren average_inv19  general_industry_machinery_sh
		ren average_inv20  elctrical_trans_sh
		ren average_inv41  electrical_sh
		ren average_inv2225  cars_trucks_sh
		ren average_inv26  aircraft_sh
		ren average_inv27  ships_sh
		ren average_inv28  rail_sh
		ren average_inv29  other_transport_sh
		ren average_inv30  furniture_sh
		ren average_inv33  agricultural_sh
		ren average_inv36  construction_sh
		ren average_inv39  mining_sh
		ren average_inv40  service_sh
		ren average_inv99  software_sh

		ren total_stock4 computers_ts
		ren total_stock5 communication_ts
		ren total_stock6 med_ins_ts
		ren total_stock9 non_med_ins_ts
		ren total_stock10 photocopy_ts
		ren total_stock11  office_ts
		ren total_stock13  metal_products_ts
		ren total_stock14  engines_ts
		ren total_stock17  metal_machinery_ts
		ren total_stock18  special_machinery_ts
		ren total_stock19  general_industry_machinery_ts
		ren total_stock20  elctrical_trans_ts
		ren total_stock41  electrical_ts
		ren total_stock2225  cars_trucks_ts
		ren total_stock26  aircraft_ts
		ren total_stock27  ships_ts
		ren total_stock28  rail_ts
		ren total_stock29  other_transport_ts
		ren total_stock30  furniture_ts
		ren total_stock33  agricultural_ts
		ren total_stock36  construction_ts
		ren total_stock39  mining_ts
		ren total_stock40  service_ts
		ren total_stock99  software_ts


		saveold "$intermediate_data/[11]stocks_bydetailedequipmentCPS_byhours_2d-elast_agg3d_DOTONET_base85.dta", replace	




		
		
