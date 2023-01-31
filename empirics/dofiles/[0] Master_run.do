
/*********************************************************************
Master_run.do
*	Occupational exposure to capital-embodied technical change

*Caunedo, Jaume and Keller 10/2022

The program starts with raw data, compute datasets for the model, and ends with the
regression outputs.


********************************************/

* HOME DIRECTORY (researchers must specify the home directory in which the replication folder has been saved).
glo path_loc = "/Users/jdc364admin/Dropbox/Feedbacks_human_physical_capital/Replication/togithub/empirics/"

glo path_wrk = "$path_loc/dofiles/"


* Paths
glo raw_data = "$path_loc/rawdata"

glo intermediate_data = "$path_loc/intermediatedata"

glo final_data= "$path_loc/finaldata"

glo model_data= "$path_loc/modeldata"

glo results= "$path_loc/results/"
	
*********************************************************************


* Packages to install
ssc install weibullfit

/*
** Preserving the steps made in STATA
capture log close
log using "$path_wrk/Results/PrintedResults.log", replace
*/
*** Section 1 ************************************** 
* Construction of intermediate and final datasets
****************************************************


*1) Code counting tool data from ONET by comodity family and occupation.
do "$path_wrk/dataconstruction/[1]Tools_data_from_ONET_into_tools_by_occ1990dd_by_NIPA.do"

*2) Generate the time series of nominal quantity of stocks by nipa equipment
do "$path_wrk/dataconstruction/[2]Ad_nominal_quantities_by_equipment.do"

*3) Generate a series of non-quality adjusted price series
do "$path_wrk/dataconstruction/[3]Non_Quality_Adjusted_Investment_Price.do"

*4) Generate a series of investment quantities by NIPA equipment
do "$path_wrk/dataconstruction/[4] Adj Investment quantities by equipment.do"


*5)Reescaled tool share using measures from 1977 Dictionary of Occupational Titles (DOT)
do "$path_wrk/dataconstruction/[5]Reescaled_tool_share_DOT.do"

*6) Takes Data from IPUMS, generates employment and wage series by year and occupation
*It also generates supply and demand IVs to be used in the computation of elasticities. 
do "$path_wrk/dataconstruction/[6]Employment_By_Occupation_CPS_byhours.do"

*7) Takes employment and wage series by year and 3 digit occupation, and
*merge with tools and investment to generate investment series for the construction of stocks
do "$path_wrk/dataconstruction/[7] Investment_By_Occupation_CPS_byhours_DOTONET.do"

*8) Estimates the stocks by nipa_code, 3 digit occupation and year
do "$path_wrk/dataconstruction/[8] Aggregate capital stock at the occupational levelCPS_byhours_stockassign.do"

*9) Construcs user cost by Nipa code and year
do "$path_wrk/dataconstruction/[9] Construction_usercost_CPS.do"

*10) Construcs stocks by worker by occupation (3 digit, 2 digit and 1 digit) and year
	* Generates data on total stocks by occupation for website
do "$path_wrk/dataconstruction/[10] Data CPS for Empirical Facts by Hours.do"


*11) Construcs stocks by worker by occupation (3 digit, 2 digit, and 1 digit), year and detailed equipment
do "$path_wrk/dataconstruction/[11] Data CPS for Model by Hours.do"


*12)  Constructs for 3 digit, 2 digit and 1 digit occupation: 
	*1) Relative price of investment to consumption by occuptaion and year
	*2) Price of equipment bundle by occupation and year
	*3) Expenses in capital by occupation and year*
do "$path_wrk/dataconstruction/[12] Construction_priceindexoccup_CPS.do"

*13) This file construct supply and demand IVS for the estimations of elasticities
do "$path_wrk/dataconstruction/[13] Merge_IV_Data_for_lags_CPS_base85.do"


*14) This file prepares the data for the estimation of the elasticities
do "$path_wrk/dataconstruction/[14] Data CPS for Elasticities.do"


*15) This file finish with the data preparation for the estimation of the elasticities
do "$path_wrk/dataconstruction/[15] Data for Estimation_Elasticity_1d_base85.do"

*16) This file adds data for the model at the skill, gender occupation label
do "$path_wrk/dataconstruction/[16] Data for model_CPS.do"


*17) This file finish with the data preparation for the estimation of the elasticities at the aggregate level
do "$path_wrk/dataconstruction/[17] Aggregate stocks.do"

*18) This file process the computer use data for figure appendix BII
do "$path_wrk/dataconstruction/[18] Data for computer use picture.do"


*** Section 2 ************************************** 
* Final regressions outputs for paper

* Inputs, data created in the previous do files
**************************************************** 


* 1) Main text
*** Figures ***
do "$path_wrk/figures/Figure 1.do"
do "$path_wrk/figures/Figure2.do"
do "$path_wrk/figures/Figure3.do"
do "$path_wrk/figures/Figure4.do"
**This figure is not shown in the main paper but it is available in our dedicated website.
do "$path_wrk/figures/ExtraFigure_Elasticity_2d.do"

*** Tables ***



* 2) Online appendix
*** Figures ***
*Figures B.I and B.II are created in matlab using routine tool_shares.m
do "$path_wrk/figures/Figure B.III.do"

*** Tables ***
do "$path_wrk/tables/TableBI.do"
do "$path_wrk/tables/TableBII.do"
do "$path_wrk/tables/TableBIII.do"

*log close
