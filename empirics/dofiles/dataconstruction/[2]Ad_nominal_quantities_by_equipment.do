
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Generate the time series of nominal quantity of stocks by nipa equipment

Data from Bureau of Economic Analisys is public and comes from : https://apps.bea.gov/iTable/index_nipa.cfm (downloaded June 2021)
********************************************/




*1* Nominal quantity data
	import excel "$raw_data/BEA_NIPA/Table2.1_BEA_current_cost_stock.xls", sheet("Sheet0") firstrow cellrange(A6:CR110) clear 


	ren Line equipment
	destring equipment, replace

	* lines to nipa_codes
	gen nipa_code =. 
	replace nipa_code = 4 if equipment == 5
	replace nipa_code = 5 if equipment == 6
	replace nipa_code = 6 if equipment == 7
	replace nipa_code = 9 if equipment == 8
	replace nipa_code = 10 if equipment == 9
	replace nipa_code = 11 if equipment == 10
	replace nipa_code = 13 if equipment == 12
	replace nipa_code = 14 if equipment == 13
	replace nipa_code = 17 if equipment == 14
	replace nipa_code = 18 if equipment == 15
	replace nipa_code = 19 if equipment == 16
	replace nipa_code = 20 if equipment == 17
	replace nipa_code = 22 if equipment == 19
	replace nipa_code = 25 if equipment == 22
	replace nipa_code = 26 if equipment == 23
	replace nipa_code = 27 if equipment == 24
	replace nipa_code = 28 if equipment == 25
	replace nipa_code = 30 if equipment == 27
	replace nipa_code = 33 if equipment == 28
	replace nipa_code = 36 if equipment == 29
	replace nipa_code = 39 if equipment == 30
	replace nipa_code = 40 if equipment == 31
	replace nipa_code = 41 if equipment == 32
	replace nipa_code = 29 if equipment == 33
	replace nipa_code = 99 if equipment == 78

	drop if nipa_code == .

	* Only need nominal stock of 1980
	ren C nominal_stock_1925
	ren D nominal_stock_1926
	ren E nominal_stock_1927
	ren F nominal_stock_1928
	ren G nominal_stock_1929
	ren H nominal_stock_1930
	ren I nominal_stock_1931
	ren J nominal_stock_1932
	ren K nominal_stock_1933
	ren L nominal_stock_1934
	ren M nominal_stock_1935
	ren N nominal_stock_1936
	ren O nominal_stock_1937
	ren P nominal_stock_1938
	ren Q nominal_stock_1939
	ren R nominal_stock_1940
	ren S nominal_stock_1941
	ren T nominal_stock_1942
	ren U nominal_stock_1943
	ren V nominal_stock_1944
	ren W nominal_stock_1945
	ren X nominal_stock_1946
	ren Y nominal_stock_1947
	ren Z nominal_stock_1948
	ren AA nominal_stock_1949
	ren AB nominal_stock_1950
	ren AC nominal_stock_1951
	ren AD nominal_stock_1952
	ren AE nominal_stock_1953
	ren AF nominal_stock_1954
	ren AG nominal_stock_1955
	ren AH nominal_stock_1956
	ren AI nominal_stock_1957
	ren AJ nominal_stock_1958
	ren AK nominal_stock_1959
	ren AL nominal_stock_1960
	ren AM nominal_stock_1961
	ren AN nominal_stock_1962
	ren AO nominal_stock_1963
	ren AP nominal_stock_1964
	ren AQ nominal_stock_1965
	ren AR nominal_stock_1966
	ren AS nominal_stock_1967
	ren AT nominal_stock_1968
	ren AU nominal_stock_1969
	ren AV nominal_stock_1970
	ren AW nominal_stock_1971
	ren AX nominal_stock_1972
	ren AY nominal_stock_1973
	ren AZ nominal_stock_1974
	ren BA nominal_stock_1975
	ren BB nominal_stock_1976
	ren BC nominal_stock_1977
	ren BD nominal_stock_1978
	ren BE nominal_stock_1979
	ren BF nominal_stock_1980
	ren BG nominal_stock_1981
	ren BH nominal_stock_1982
	ren BI nominal_stock_1983
	ren BJ nominal_stock_1984
	ren BK nominal_stock_1985
	ren BL nominal_stock_1986
	ren BM nominal_stock_1987
	ren BN nominal_stock_1988
	ren BO nominal_stock_1989
	ren BP nominal_stock_1990
	ren BQ nominal_stock_1991
	ren BR nominal_stock_1992
	ren BS nominal_stock_1993
	ren BT nominal_stock_1994
	ren BU nominal_stock_1995
	ren BV nominal_stock_1996
	ren BW nominal_stock_1997
	ren BX nominal_stock_1998
	ren BY nominal_stock_1999
	ren BZ nominal_stock_2000
	ren CA nominal_stock_2001
	ren CB nominal_stock_2002
	ren CC nominal_stock_2003
	ren CD nominal_stock_2004
	ren CE nominal_stock_2005
	ren CF nominal_stock_2006
	ren CG nominal_stock_2007
	ren CH nominal_stock_2008
	ren CI nominal_stock_2009
	ren CJ nominal_stock_2010
	ren CK nominal_stock_2011
	ren CL nominal_stock_2012
	ren CM nominal_stock_2013
	ren CN nominal_stock_2014
	ren CO nominal_stock_2015
	ren CP nominal_stock_2016
	ren CQ nominal_stock_2017
	ren CR nominal_stock_2018

	
	reshape long nominal_stock_, i(nipa_code) j(year)

	
	keep nominal_stock nipa_code year
		
replace nipa_code = 2225 if nipa_code == 22
replace nipa_code = 2225 if nipa_code == 25
	
collapse (sum)	nominal_stock, by(nipa_code year)  // collapse cars and trucks
saveold "$intermediate_data/[2]stock_nominal_quantity_long.dta", replace


// End of do file
