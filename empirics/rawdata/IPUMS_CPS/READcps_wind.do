* NOTE: You need to set the Stata working directory to the path
* where the data file is located.
clear
set matsize 800

set more off

clear
quietly infix                  ///
  int     year        1-4      ///
  long    serial      5-9      ///
  byte    month       10-11    ///
  double  hwtfinl     12-21    ///
  double  cpsid       22-35    ///
  byte    asecflag    36-36    ///
  byte    hflag       37-37    ///
  double  asecwth     38-47    ///
  byte    pernum      48-49    ///
  double  wtfinl      50-63    ///
  double  cpsidp      64-77    ///
  double  asecwt      78-87    ///
  byte    age         88-89    ///
  byte    sex         90-90    ///
  byte    empstat     91-92    ///
  int     occ         93-96    ///
  int     ind1990     97-99    ///
  int     ind         100-103  ///
  int     uhrsworkt   104-106  ///
  int     uhrswork1   107-109  ///
  int     educ        110-112  ///
  double  earnwt      113-122  ///
  int     indly       123-126  ///
  int     ind90ly     127-129  ///
  byte    wkswork1    130-131  ///
  byte    wkswork2    132-132  ///
  int     uhrsworkly  133-135  ///
  double  inctot      136-144  ///
  double  incwage     145-152  ///
  using `"$raw_data/IPUMS_CPS/cps_00003.dat"'

replace hwtfinl    = hwtfinl    / 10000
replace asecwth    = asecwth    / 10000
replace wtfinl     = wtfinl     / 10000
replace asecwt     = asecwt     / 10000
replace earnwt     = earnwt     / 10000

format hwtfinl    %10.4f
format cpsid      %14.0f
format asecwth    %10.4f
format wtfinl     %14.4f
format cpsidp     %14.0f
format asecwt     %10.4f
format earnwt     %10.4f
format inctot     %9.0f
format incwage    %8.0f

label var year       `"Survey year"'
label var serial     `"Household serial number"'
label var month      `"Month"'
label var hwtfinl    `"Household weight, Basic Monthly"'
label var cpsid      `"CPSID, household record"'
label var asecflag   `"Flag for ASEC"'
label var hflag      `"Flag for the 3/8 file 2014"'
label var asecwth    `"Annual Social and Economic Supplement Household weight"'
label var pernum     `"Person number in sample unit"'
label var wtfinl     `"Final Basic Weight"'
label var cpsidp     `"CPSID, person record"'
label var asecwt     `"Annual Social and Economic Supplement Weight"'
label var age        `"Age"'
label var sex        `"Sex"'
label var empstat    `"Employment status"'
label var occ        `"Occupation"'
label var ind1990    `"Industry, 1990 basis"'
label var ind        `"Industry"'
label var uhrsworkt  `"Hours usually worked per week at all jobs"'
label var uhrswork1  `"Hours usually worked per week at main job"'
label var educ       `"Educational attainment recode"'
label var earnwt     `"Earnings weight"'
label var indly      `"Industry last year"'
label var ind90ly    `"Industry last year, 1990 basis"'
label var wkswork1   `"Weeks worked last year"'
label var wkswork2   `"Weeks worked last year, intervalled"'
label var uhrsworkly `"Usual hours worked per week (last yr)"'
label var inctot     `"Total personal income"'
label var incwage    `"Wage and salary income"'

label define month_lbl 01 `"January"'
label define month_lbl 02 `"February"', add
label define month_lbl 03 `"March"', add
label define month_lbl 04 `"April"', add
label define month_lbl 05 `"May"', add
label define month_lbl 06 `"June"', add
label define month_lbl 07 `"July"', add
label define month_lbl 08 `"August"', add
label define month_lbl 09 `"September"', add
label define month_lbl 10 `"October"', add
label define month_lbl 11 `"November"', add
label define month_lbl 12 `"December"', add
label values month month_lbl

label define asecflag_lbl 1 `"ASEC"'
label define asecflag_lbl 2 `"March Basic"', add
label values asecflag asecflag_lbl

label define hflag_lbl 0 `"5/8 file"'
label define hflag_lbl 1 `"3/8 file"', add
label values hflag hflag_lbl

label define age_lbl 00 `"Under 1 year"'
label define age_lbl 01 `"1"', add
label define age_lbl 02 `"2"', add
label define age_lbl 03 `"3"', add
label define age_lbl 04 `"4"', add
label define age_lbl 05 `"5"', add
label define age_lbl 06 `"6"', add
label define age_lbl 07 `"7"', add
label define age_lbl 08 `"8"', add
label define age_lbl 09 `"9"', add
label define age_lbl 10 `"10"', add
label define age_lbl 11 `"11"', add
label define age_lbl 12 `"12"', add
label define age_lbl 13 `"13"', add
label define age_lbl 14 `"14"', add
label define age_lbl 15 `"15"', add
label define age_lbl 16 `"16"', add
label define age_lbl 17 `"17"', add
label define age_lbl 18 `"18"', add
label define age_lbl 19 `"19"', add
label define age_lbl 20 `"20"', add
label define age_lbl 21 `"21"', add
label define age_lbl 22 `"22"', add
label define age_lbl 23 `"23"', add
label define age_lbl 24 `"24"', add
label define age_lbl 25 `"25"', add
label define age_lbl 26 `"26"', add
label define age_lbl 27 `"27"', add
label define age_lbl 28 `"28"', add
label define age_lbl 29 `"29"', add
label define age_lbl 30 `"30"', add
label define age_lbl 31 `"31"', add
label define age_lbl 32 `"32"', add
label define age_lbl 33 `"33"', add
label define age_lbl 34 `"34"', add
label define age_lbl 35 `"35"', add
label define age_lbl 36 `"36"', add
label define age_lbl 37 `"37"', add
label define age_lbl 38 `"38"', add
label define age_lbl 39 `"39"', add
label define age_lbl 40 `"40"', add
label define age_lbl 41 `"41"', add
label define age_lbl 42 `"42"', add
label define age_lbl 43 `"43"', add
label define age_lbl 44 `"44"', add
label define age_lbl 45 `"45"', add
label define age_lbl 46 `"46"', add
label define age_lbl 47 `"47"', add
label define age_lbl 48 `"48"', add
label define age_lbl 49 `"49"', add
label define age_lbl 50 `"50"', add
label define age_lbl 51 `"51"', add
label define age_lbl 52 `"52"', add
label define age_lbl 53 `"53"', add
label define age_lbl 54 `"54"', add
label define age_lbl 55 `"55"', add
label define age_lbl 56 `"56"', add
label define age_lbl 57 `"57"', add
label define age_lbl 58 `"58"', add
label define age_lbl 59 `"59"', add
label define age_lbl 60 `"60"', add
label define age_lbl 61 `"61"', add
label define age_lbl 62 `"62"', add
label define age_lbl 63 `"63"', add
label define age_lbl 64 `"64"', add
label define age_lbl 65 `"65"', add
label define age_lbl 66 `"66"', add
label define age_lbl 67 `"67"', add
label define age_lbl 68 `"68"', add
label define age_lbl 69 `"69"', add
label define age_lbl 70 `"70"', add
label define age_lbl 71 `"71"', add
label define age_lbl 72 `"72"', add
label define age_lbl 73 `"73"', add
label define age_lbl 74 `"74"', add
label define age_lbl 75 `"75"', add
label define age_lbl 76 `"76"', add
label define age_lbl 77 `"77"', add
label define age_lbl 78 `"78"', add
label define age_lbl 79 `"79"', add
label define age_lbl 80 `"80"', add
label define age_lbl 81 `"81"', add
label define age_lbl 82 `"82"', add
label define age_lbl 83 `"83"', add
label define age_lbl 84 `"84"', add
label define age_lbl 85 `"85"', add
label define age_lbl 86 `"86"', add
label define age_lbl 87 `"87"', add
label define age_lbl 88 `"88"', add
label define age_lbl 89 `"89"', add
label define age_lbl 90 `"90 (90+, 1988-2002)"', add
label define age_lbl 91 `"91"', add
label define age_lbl 92 `"92"', add
label define age_lbl 93 `"93"', add
label define age_lbl 94 `"94"', add
label define age_lbl 95 `"95"', add
label define age_lbl 96 `"96"', add
label define age_lbl 97 `"97"', add
label define age_lbl 98 `"98"', add
label define age_lbl 99 `"99+"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"NIU"', add
label values sex sex_lbl

label define empstat_lbl 00 `"NIU"'
label define empstat_lbl 01 `"Armed Forces"', add
label define empstat_lbl 10 `"At work"', add
label define empstat_lbl 12 `"Has job, not at work last week"', add
label define empstat_lbl 20 `"Unemployed"', add
label define empstat_lbl 21 `"Unemployed, experienced worker"', add
label define empstat_lbl 22 `"Unemployed, new worker"', add
label define empstat_lbl 30 `"Not in labor force"', add
label define empstat_lbl 31 `"NILF, housework"', add
label define empstat_lbl 32 `"NILF, unable to work"', add
label define empstat_lbl 33 `"NILF, school"', add
label define empstat_lbl 34 `"NILF, other"', add
label define empstat_lbl 35 `"NILF, unpaid, lt 15 hours"', add
label define empstat_lbl 36 `"NILF, retired"', add
label values empstat empstat_lbl

label define ind1990_lbl 000 `"NIU"'
label define ind1990_lbl 010 `"Agricultural production, crops"', add
label define ind1990_lbl 011 `"Agricultural production, livestock"', add
label define ind1990_lbl 012 `"Veterinary services"', add
label define ind1990_lbl 020 `"Landscape and horticultural services"', add
label define ind1990_lbl 030 `"Agricultural services, n.e.c."', add
label define ind1990_lbl 031 `"Forestry"', add
label define ind1990_lbl 032 `"Fishing, hunting, and trapping"', add
label define ind1990_lbl 040 `"Metal mining"', add
label define ind1990_lbl 041 `"Coal mining"', add
label define ind1990_lbl 042 `"Oil and gas extraction"', add
label define ind1990_lbl 050 `"Nonmetallic mining and quarrying, except fuels"', add
label define ind1990_lbl 060 `"All construction"', add
label define ind1990_lbl 100 `"Meat products"', add
label define ind1990_lbl 101 `"Dairy products"', add
label define ind1990_lbl 102 `"Canned, frozen, and preserved fruits and vegetables"', add
label define ind1990_lbl 110 `"Grain mill products"', add
label define ind1990_lbl 111 `"Bakery products"', add
label define ind1990_lbl 112 `"Sugar and confectionery products"', add
label define ind1990_lbl 120 `"Beverage industries"', add
label define ind1990_lbl 121 `"Misc. food preparations and kindred products"', add
label define ind1990_lbl 122 `"Food industries, n.s."', add
label define ind1990_lbl 130 `"Tobacco manufactures"', add
label define ind1990_lbl 132 `"Knitting mills"', add
label define ind1990_lbl 140 `"Dyeing and finishing textiles, except wool and knit goods"', add
label define ind1990_lbl 141 `"Carpets and rugs"', add
label define ind1990_lbl 142 `"Yarn, thread, and fabric mills"', add
label define ind1990_lbl 150 `"Miscellaneous textile mill products"', add
label define ind1990_lbl 151 `"Apparel and accessories, except knit"', add
label define ind1990_lbl 152 `"Miscellaneous fabricated textile products"', add
label define ind1990_lbl 160 `"Pulp, paper, and paperboard mills"', add
label define ind1990_lbl 161 `"Miscellaneous paper and pulp products"', add
label define ind1990_lbl 162 `"Paperboard containers and boxes"', add
label define ind1990_lbl 171 `"Newspaper publishing and printing"', add
label define ind1990_lbl 172 `"Printing, publishing, and allied industries, except newspapers"', add
label define ind1990_lbl 180 `"Plastics, synthetics, and resins"', add
label define ind1990_lbl 181 `"Drugs"', add
label define ind1990_lbl 182 `"Soaps and cosmetics"', add
label define ind1990_lbl 190 `"Paints, varnishes, and related products"', add
label define ind1990_lbl 191 `"Agricultural chemicals"', add
label define ind1990_lbl 192 `"Industrial and miscellaneous chemicals"', add
label define ind1990_lbl 200 `"Petroleum refining"', add
label define ind1990_lbl 201 `"Miscellaneous petroleum and coal products"', add
label define ind1990_lbl 210 `"Tires and inner tubes"', add
label define ind1990_lbl 211 `"Other rubber products, and plastics footwear and belting"', add
label define ind1990_lbl 212 `"Miscellaneous plastics products"', add
label define ind1990_lbl 220 `"Leather tanning and finishing"', add
label define ind1990_lbl 221 `"Footwear, except rubber and plastic"', add
label define ind1990_lbl 222 `"Leather products, except footwear"', add
label define ind1990_lbl 229 `"Manufacturing, non-durable - allocated"', add
label define ind1990_lbl 230 `"Logging"', add
label define ind1990_lbl 231 `"Sawmills, planing mills, and millwork"', add
label define ind1990_lbl 232 `"Wood buildings and mobile homes"', add
label define ind1990_lbl 241 `"Miscellaneous wood products"', add
label define ind1990_lbl 242 `"Furniture and fixtures"', add
label define ind1990_lbl 250 `"Glass and glass products"', add
label define ind1990_lbl 251 `"Cement, concrete, gypsum, and plaster products"', add
label define ind1990_lbl 252 `"Structural clay products"', add
label define ind1990_lbl 261 `"Pottery and related products"', add
label define ind1990_lbl 262 `"Misc. nonmetallic mineral and stone products"', add
label define ind1990_lbl 270 `"Blast furnaces, steelworks, rolling and finishing mills"', add
label define ind1990_lbl 271 `"Iron and steel foundries"', add
label define ind1990_lbl 272 `"Primary aluminum industries"', add
label define ind1990_lbl 280 `"Other primary metal industries"', add
label define ind1990_lbl 281 `"Cutlery, handtools, and general hardware"', add
label define ind1990_lbl 282 `"Fabricated structural metal products"', add
label define ind1990_lbl 290 `"Screw machine products"', add
label define ind1990_lbl 291 `"Metal forgings and stampings"', add
label define ind1990_lbl 292 `"Ordnance"', add
label define ind1990_lbl 300 `"Miscellaneous fabricated metal products"', add
label define ind1990_lbl 301 `"Metal industries, n.s."', add
label define ind1990_lbl 310 `"Engines and turbines"', add
label define ind1990_lbl 311 `"Farm machinery and equipment"', add
label define ind1990_lbl 312 `"Construction and material handling machines"', add
label define ind1990_lbl 320 `"Metalworking machinery"', add
label define ind1990_lbl 321 `"Office and accounting machines"', add
label define ind1990_lbl 322 `"Computers and related equipment"', add
label define ind1990_lbl 331 `"Machinery, except electrical, n.e.c."', add
label define ind1990_lbl 332 `"Machinery, n.s."', add
label define ind1990_lbl 340 `"Household appliances"', add
label define ind1990_lbl 341 `"Radio, TV, and communication equipment"', add
label define ind1990_lbl 342 `"Electrical machinery, equipment, and supplies, n.e.c."', add
label define ind1990_lbl 350 `"Electrical machinery, equipment, and supplies, n.s."', add
label define ind1990_lbl 351 `"Motor vehicles and motor vehicle equipment"', add
label define ind1990_lbl 352 `"Aircraft and parts"', add
label define ind1990_lbl 360 `"Ship and boat building and repairing"', add
label define ind1990_lbl 361 `"Railroad locomotives and equipment"', add
label define ind1990_lbl 362 `"Guided missiles, space vehicles, and parts"', add
label define ind1990_lbl 370 `"Cycles and miscellaneous transportation equipment"', add
label define ind1990_lbl 371 `"Scientific and controlling instruments"', add
label define ind1990_lbl 372 `"Medical, dental, and optical instruments and supplies"', add
label define ind1990_lbl 380 `"Photographic equipment and supplies"', add
label define ind1990_lbl 381 `"Watches, clocks, and clockwork operated devices"', add
label define ind1990_lbl 390 `"Toys, amusement, and sporting goods"', add
label define ind1990_lbl 391 `"Miscellaneous manufacturing industries"', add
label define ind1990_lbl 392 `"Manufacturing industries, n.s."', add
label define ind1990_lbl 400 `"Railroads"', add
label define ind1990_lbl 401 `"Bus service and urban transit"', add
label define ind1990_lbl 402 `"Taxicab service"', add
label define ind1990_lbl 410 `"Trucking service"', add
label define ind1990_lbl 411 `"Warehousing and storage"', add
label define ind1990_lbl 412 `"U.S. Postal Service"', add
label define ind1990_lbl 420 `"Water transportation"', add
label define ind1990_lbl 421 `"Air transportation"', add
label define ind1990_lbl 422 `"Pipe lines, except natural gas"', add
label define ind1990_lbl 432 `"Services incidental to transportation"', add
label define ind1990_lbl 440 `"Radio and television broadcasting and cable"', add
label define ind1990_lbl 441 `"Wired communications"', add
label define ind1990_lbl 442 `"Telegraph and miscellaneous communications services"', add
label define ind1990_lbl 450 `"Electric light and power"', add
label define ind1990_lbl 451 `"Gas and steam supply systems"', add
label define ind1990_lbl 452 `"Electric and gas, and other combinations"', add
label define ind1990_lbl 470 `"Water supply and irrigation"', add
label define ind1990_lbl 471 `"Sanitary services"', add
label define ind1990_lbl 472 `"Utilities, n.s."', add
label define ind1990_lbl 500 `"Motor vehicles and equipment"', add
label define ind1990_lbl 501 `"Furniture and home furnishings"', add
label define ind1990_lbl 502 `"Lumber and construction materials"', add
label define ind1990_lbl 510 `"Professional and commercial equipment and supplies"', add
label define ind1990_lbl 511 `"Metals and minerals, except petroleum"', add
label define ind1990_lbl 512 `"Electrical goods"', add
label define ind1990_lbl 521 `"Hardware, plumbing and heating supplies"', add
label define ind1990_lbl 530 `"Machinery, equipment, and supplies"', add
label define ind1990_lbl 531 `"Scrap and waste materials"', add
label define ind1990_lbl 532 `"Miscellaneous wholesale, durable goods"', add
label define ind1990_lbl 540 `"Paper and paper products"', add
label define ind1990_lbl 541 `"Drugs, chemicals, and allied products"', add
label define ind1990_lbl 542 `"Apparel, fabrics, and notions"', add
label define ind1990_lbl 550 `"Groceries and related products"', add
label define ind1990_lbl 551 `"Farm-product raw materials"', add
label define ind1990_lbl 552 `"Petroleum products"', add
label define ind1990_lbl 560 `"Alcoholic beverages"', add
label define ind1990_lbl 561 `"Farm supplies"', add
label define ind1990_lbl 562 `"Miscellaneous wholesale, nondurable goods"', add
label define ind1990_lbl 571 `"Wholesale trade, n.s."', add
label define ind1990_lbl 580 `"Lumber and building material retailing"', add
label define ind1990_lbl 581 `"Hardware stores"', add
label define ind1990_lbl 582 `"Retail nurseries and garden stores"', add
label define ind1990_lbl 590 `"Mobile home dealers"', add
label define ind1990_lbl 591 `"Department stores"', add
label define ind1990_lbl 592 `"Variety stores"', add
label define ind1990_lbl 600 `"Miscellaneous general merchandise stores"', add
label define ind1990_lbl 601 `"Grocery stores"', add
label define ind1990_lbl 602 `"Dairy products stores"', add
label define ind1990_lbl 610 `"Retail bakeries"', add
label define ind1990_lbl 611 `"Food stores, n.e.c."', add
label define ind1990_lbl 612 `"Motor vehicle dealers"', add
label define ind1990_lbl 620 `"Auto and home supply stores"', add
label define ind1990_lbl 621 `"Gasoline service stations"', add
label define ind1990_lbl 622 `"Miscellaneous vehicle dealers"', add
label define ind1990_lbl 623 `"Apparel and accessory stores, except shoe"', add
label define ind1990_lbl 630 `"Shoe stores"', add
label define ind1990_lbl 631 `"Furniture and home furnishings stores"', add
label define ind1990_lbl 632 `"Household appliance stores"', add
label define ind1990_lbl 633 `"Radio, TV, and computer stores"', add
label define ind1990_lbl 640 `"Music stores"', add
label define ind1990_lbl 641 `"Eating and drinking places"', add
label define ind1990_lbl 642 `"Drug stores"', add
label define ind1990_lbl 650 `"Liquor stores"', add
label define ind1990_lbl 651 `"Sporting goods, bicycles, and hobby stores"', add
label define ind1990_lbl 652 `"Book and stationery stores"', add
label define ind1990_lbl 660 `"Jewelry stores"', add
label define ind1990_lbl 661 `"Gift, novelty, and souvenir shops"', add
label define ind1990_lbl 662 `"Sewing, needlework, and piece goods stores"', add
label define ind1990_lbl 663 `"Catalog and mail order houses"', add
label define ind1990_lbl 670 `"Vending machine operators"', add
label define ind1990_lbl 671 `"Direct selling establishments"', add
label define ind1990_lbl 672 `"Fuel dealers"', add
label define ind1990_lbl 681 `"Retail florists"', add
label define ind1990_lbl 682 `"Miscellaneous retail stores"', add
label define ind1990_lbl 691 `"Retail trade, n.s."', add
label define ind1990_lbl 700 `"Banking"', add
label define ind1990_lbl 701 `"Savings institutions, including credit unions"', add
label define ind1990_lbl 702 `"Credit agencies, n.e.c."', add
label define ind1990_lbl 710 `"Security, commodity brokerage, and investment companies"', add
label define ind1990_lbl 711 `"Insurance"', add
label define ind1990_lbl 712 `"Real estate, including real estate-insurance offices"', add
label define ind1990_lbl 721 `"Advertising"', add
label define ind1990_lbl 722 `"Services to dwellings and other buildings"', add
label define ind1990_lbl 731 `"Personnel supply services"', add
label define ind1990_lbl 732 `"Computer and data processing services"', add
label define ind1990_lbl 740 `"Detective and protective services"', add
label define ind1990_lbl 741 `"Business services, n.e.c."', add
label define ind1990_lbl 742 `"Automotive rental and leasing, without drivers"', add
label define ind1990_lbl 750 `"Automobile parking and carwashes"', add
label define ind1990_lbl 751 `"Automotive repair and related services"', add
label define ind1990_lbl 752 `"Electrical repair shops"', add
label define ind1990_lbl 760 `"Miscellaneous repair services"', add
label define ind1990_lbl 761 `"Private households"', add
label define ind1990_lbl 762 `"Hotels and motels"', add
label define ind1990_lbl 770 `"Lodging places, except hotels and motels"', add
label define ind1990_lbl 771 `"Laundry, cleaning, and garment services"', add
label define ind1990_lbl 772 `"Beauty shops"', add
label define ind1990_lbl 780 `"Barber shops"', add
label define ind1990_lbl 781 `"Funeral service and crematories"', add
label define ind1990_lbl 782 `"Shoe repair shops"', add
label define ind1990_lbl 790 `"Dressmaking shops"', add
label define ind1990_lbl 791 `"Miscellaneous personal services"', add
label define ind1990_lbl 800 `"Theaters and motion pictures"', add
label define ind1990_lbl 801 `"Video tape rental"', add
label define ind1990_lbl 802 `"Bowling centers"', add
label define ind1990_lbl 810 `"Miscellaneous entertainment and recreation services"', add
label define ind1990_lbl 812 `"Offices and clinics of physicians"', add
label define ind1990_lbl 820 `"Offices and clinics of dentists"', add
label define ind1990_lbl 821 `"Offices and clinics of chiropractors"', add
label define ind1990_lbl 822 `"Offices and clinics of optometrists"', add
label define ind1990_lbl 830 `"Offices and clinics of health practitioners, n.e.c."', add
label define ind1990_lbl 831 `"Hospitals"', add
label define ind1990_lbl 832 `"Nursing and personal care facilities"', add
label define ind1990_lbl 840 `"Health services, n.e.c."', add
label define ind1990_lbl 841 `"Legal services"', add
label define ind1990_lbl 842 `"Elementary and secondary schools"', add
label define ind1990_lbl 850 `"Colleges and universities"', add
label define ind1990_lbl 851 `"Vocational schools"', add
label define ind1990_lbl 852 `"Libraries"', add
label define ind1990_lbl 860 `"Educational services, n.e.c."', add
label define ind1990_lbl 861 `"Job training and vocational rehabilitation services"', add
label define ind1990_lbl 862 `"Child day care services"', add
label define ind1990_lbl 863 `"Family child care homes"', add
label define ind1990_lbl 870 `"Residential care facilities, without nursing"', add
label define ind1990_lbl 871 `"Social services, n.e.c."', add
label define ind1990_lbl 872 `"Museums, art galleries, and zoos"', add
label define ind1990_lbl 873 `"Labor unions"', add
label define ind1990_lbl 880 `"Religious organizations"', add
label define ind1990_lbl 881 `"Membership organizations, n.e.c."', add
label define ind1990_lbl 882 `"Engineering, architectural, and surveying services"', add
label define ind1990_lbl 890 `"Accounting, auditing, and bookkeeping services"', add
label define ind1990_lbl 891 `"Research, development, and testing services"', add
label define ind1990_lbl 892 `"Management and public relations services"', add
label define ind1990_lbl 893 `"Miscellaneous professional and related services"', add
label define ind1990_lbl 900 `"Executive and legislative offices"', add
label define ind1990_lbl 901 `"General government, n.e.c."', add
label define ind1990_lbl 910 `"Justice, public order, and safety"', add
label define ind1990_lbl 921 `"Public finance, taxation, and monetary policy"', add
label define ind1990_lbl 922 `"Administration of human resources programs"', add
label define ind1990_lbl 930 `"Administration of environmental quality and housing programs"', add
label define ind1990_lbl 931 `"Administration of economic programs"', add
label define ind1990_lbl 932 `"National security and international affairs"', add
label define ind1990_lbl 940 `"Army"', add
label define ind1990_lbl 941 `"Air Force"', add
label define ind1990_lbl 942 `"Navy"', add
label define ind1990_lbl 950 `"Marines"', add
label define ind1990_lbl 951 `"Coast Guard"', add
label define ind1990_lbl 952 `"Armed Forces, branch not specified"', add
label define ind1990_lbl 960 `"Military Reserves or National Guard"', add
label define ind1990_lbl 998 `"Unknown"', add
label values ind1990 ind1990_lbl

label define uhrsworkt_lbl 997 `"Hours vary"'
label define uhrsworkt_lbl 999 `"NIU"', add
label values uhrsworkt uhrsworkt_lbl

label define uhrswork1_lbl 000 `"0 hours"'
label define uhrswork1_lbl 997 `"Hours vary"', add
label define uhrswork1_lbl 999 `"NIU/Missing"', add
label values uhrswork1 uhrswork1_lbl

label define educ_lbl 000 `"NIU or no schooling"'
label define educ_lbl 001 `"NIU or blank"', add
label define educ_lbl 002 `"None or preschool"', add
label define educ_lbl 010 `"Grades 1, 2, 3, or 4"', add
label define educ_lbl 011 `"Grade 1"', add
label define educ_lbl 012 `"Grade 2"', add
label define educ_lbl 013 `"Grade 3"', add
label define educ_lbl 014 `"Grade 4"', add
label define educ_lbl 020 `"Grades 5 or 6"', add
label define educ_lbl 021 `"Grade 5"', add
label define educ_lbl 022 `"Grade 6"', add
label define educ_lbl 030 `"Grades 7 or 8"', add
label define educ_lbl 031 `"Grade 7"', add
label define educ_lbl 032 `"Grade 8"', add
label define educ_lbl 040 `"Grade 9"', add
label define educ_lbl 050 `"Grade 10"', add
label define educ_lbl 060 `"Grade 11"', add
label define educ_lbl 070 `"Grade 12"', add
label define educ_lbl 071 `"12th grade, no diploma"', add
label define educ_lbl 072 `"12th grade, diploma unclear"', add
label define educ_lbl 073 `"High school diploma or equivalent"', add
label define educ_lbl 080 `"1 year of college"', add
label define educ_lbl 081 `"Some college but no degree"', add
label define educ_lbl 090 `"2 years of college"', add
label define educ_lbl 091 `"Associate's degree, occupational/vocational program"', add
label define educ_lbl 092 `"Associate's degree, academic program"', add
label define educ_lbl 100 `"3 years of college"', add
label define educ_lbl 110 `"4 years of college"', add
label define educ_lbl 111 `"Bachelor's degree"', add
label define educ_lbl 120 `"5+ years of college"', add
label define educ_lbl 121 `"5 years of college"', add
label define educ_lbl 122 `"6+ years of college"', add
label define educ_lbl 123 `"Master's degree"', add
label define educ_lbl 124 `"Professional school degree"', add
label define educ_lbl 125 `"Doctorate degree"', add
label define educ_lbl 999 `"Missing/Unknown"', add
label values educ educ_lbl

label define ind90ly_lbl 000 `"NIU"'
label define ind90ly_lbl 010 `"Agricultural production, crops"', add
label define ind90ly_lbl 011 `"Agricultural production, livestock"', add
label define ind90ly_lbl 012 `"Veterinary services"', add
label define ind90ly_lbl 020 `"Landscape and horticultural services"', add
label define ind90ly_lbl 030 `"Agricultural services, n.e.c."', add
label define ind90ly_lbl 031 `"Forestry"', add
label define ind90ly_lbl 032 `"Fishing, hunting, and trapping"', add
label define ind90ly_lbl 040 `"Metal mining"', add
label define ind90ly_lbl 041 `"Coal mining"', add
label define ind90ly_lbl 042 `"Oil and gas extraction"', add
label define ind90ly_lbl 050 `"Nonmetallic mining and quarrying, except fuels"', add
label define ind90ly_lbl 060 `"All construction"', add
label define ind90ly_lbl 100 `"Meat products"', add
label define ind90ly_lbl 101 `"Dairy products"', add
label define ind90ly_lbl 102 `"Canned, frozen, and preserved fruits and vegetables"', add
label define ind90ly_lbl 110 `"Grain mill products"', add
label define ind90ly_lbl 111 `"Bakery products"', add
label define ind90ly_lbl 112 `"Sugar and confectionery products"', add
label define ind90ly_lbl 120 `"Beverage industries"', add
label define ind90ly_lbl 121 `"Misc. food preparations and kindred products"', add
label define ind90ly_lbl 122 `"Food industries, n.s."', add
label define ind90ly_lbl 130 `"Tobacco manufactures"', add
label define ind90ly_lbl 132 `"Knitting mills"', add
label define ind90ly_lbl 140 `"Dyeing and finishing textiles, except wool and knit goods"', add
label define ind90ly_lbl 141 `"Carpets and rugs"', add
label define ind90ly_lbl 142 `"Yarn, thread, and fabric mills"', add
label define ind90ly_lbl 150 `"Miscellaneous textile mill products"', add
label define ind90ly_lbl 151 `"Apparel and accessories, except knit"', add
label define ind90ly_lbl 152 `"Miscellaneous fabricated textile products"', add
label define ind90ly_lbl 160 `"Pulp, paper, and paperboard mills"', add
label define ind90ly_lbl 161 `"Miscellaneous paper and pulp products"', add
label define ind90ly_lbl 162 `"Paperboard containers and boxes"', add
label define ind90ly_lbl 171 `"Newspaper publishing and printing"', add
label define ind90ly_lbl 172 `"Printing, publishing, and allied industries, except newspapers"', add
label define ind90ly_lbl 180 `"Plastics, synthetics, and resins"', add
label define ind90ly_lbl 181 `"Drugs"', add
label define ind90ly_lbl 182 `"Soaps and cosmetics"', add
label define ind90ly_lbl 190 `"Paints, varnishes, and related products"', add
label define ind90ly_lbl 191 `"Agricultural chemicals"', add
label define ind90ly_lbl 192 `"Industrial and miscellaneous chemicals"', add
label define ind90ly_lbl 200 `"Petroleum refining"', add
label define ind90ly_lbl 201 `"Miscellaneous petroleum and coal products"', add
label define ind90ly_lbl 210 `"Tires and inner tubes"', add
label define ind90ly_lbl 211 `"Other rubber products, and plastics footwear and belting"', add
label define ind90ly_lbl 212 `"Miscellaneous plastics products"', add
label define ind90ly_lbl 220 `"Leather tanning and finishing"', add
label define ind90ly_lbl 221 `"Footwear, except rubber and plastic"', add
label define ind90ly_lbl 222 `"Leather products, except footwear"', add
label define ind90ly_lbl 229 `"Manufacturing, non-durable - allocated"', add
label define ind90ly_lbl 230 `"Logging"', add
label define ind90ly_lbl 231 `"Sawmills, planing mills, and millwork"', add
label define ind90ly_lbl 232 `"Wood buildings and mobile homes"', add
label define ind90ly_lbl 241 `"Miscellaneous wood products"', add
label define ind90ly_lbl 242 `"Furniture and fixtures"', add
label define ind90ly_lbl 250 `"Glass and glass products"', add
label define ind90ly_lbl 251 `"Cement, concrete, gypsum, and plaster products"', add
label define ind90ly_lbl 252 `"Structural clay products"', add
label define ind90ly_lbl 261 `"Pottery and related products"', add
label define ind90ly_lbl 262 `"Misc. nonmetallic mineral and stone products"', add
label define ind90ly_lbl 270 `"Blast furnaces, steelworks, rolling and finishing mills"', add
label define ind90ly_lbl 271 `"Iron and steel foundries"', add
label define ind90ly_lbl 272 `"Primary aluminum industries"', add
label define ind90ly_lbl 280 `"Other primary metal industries"', add
label define ind90ly_lbl 281 `"Cutlery, handtools, and general hardware"', add
label define ind90ly_lbl 282 `"Fabricated structural metal products"', add
label define ind90ly_lbl 290 `"Screw machine products"', add
label define ind90ly_lbl 291 `"Metal forgings and stampings"', add
label define ind90ly_lbl 292 `"Ordnance"', add
label define ind90ly_lbl 300 `"Miscellaneous fabricated metal products"', add
label define ind90ly_lbl 301 `"Metal industries, n.s."', add
label define ind90ly_lbl 310 `"Engines and turbines"', add
label define ind90ly_lbl 311 `"Farm machinery and equipment"', add
label define ind90ly_lbl 312 `"Construction and material handling machines"', add
label define ind90ly_lbl 320 `"Metalworking machinery"', add
label define ind90ly_lbl 321 `"Office and accounting machines"', add
label define ind90ly_lbl 322 `"Computers and related equipment"', add
label define ind90ly_lbl 331 `"Machinery, except electrical, n.e.c."', add
label define ind90ly_lbl 332 `"Machinery, n.s."', add
label define ind90ly_lbl 340 `"Household appliances"', add
label define ind90ly_lbl 341 `"Radio, TV, and communication equipment"', add
label define ind90ly_lbl 342 `"Electrical machinery, equipment, and supplies, n.e.c."', add
label define ind90ly_lbl 350 `"Electrical machinery, equipment, and supplies, n.s."', add
label define ind90ly_lbl 351 `"Motor vehicles and motor vehicle equipment"', add
label define ind90ly_lbl 352 `"Aircraft and parts"', add
label define ind90ly_lbl 360 `"Ship and boat building and repairing"', add
label define ind90ly_lbl 361 `"Railroad locomotives and equipment"', add
label define ind90ly_lbl 362 `"Guided missiles, space vehicles, and parts"', add
label define ind90ly_lbl 370 `"Cycles and miscellaneous transportation equipment"', add
label define ind90ly_lbl 371 `"Scientific and controlling instruments"', add
label define ind90ly_lbl 372 `"Medical, dental, and optical instruments and supplies"', add
label define ind90ly_lbl 380 `"Photographic equipment and supplies"', add
label define ind90ly_lbl 381 `"Watches, clocks, and clockwork operated devices"', add
label define ind90ly_lbl 390 `"Toys, amusement, and sporting goods"', add
label define ind90ly_lbl 391 `"Miscellaneous manufacturing industries"', add
label define ind90ly_lbl 392 `"Manufacturing industries, n.s."', add
label define ind90ly_lbl 400 `"Railroads"', add
label define ind90ly_lbl 401 `"Bus service and urban transit"', add
label define ind90ly_lbl 402 `"Taxicab service"', add
label define ind90ly_lbl 410 `"Trucking service"', add
label define ind90ly_lbl 411 `"Warehousing and storage"', add
label define ind90ly_lbl 412 `"U.S. Postal Service"', add
label define ind90ly_lbl 420 `"Water transportation"', add
label define ind90ly_lbl 421 `"Air transportation"', add
label define ind90ly_lbl 422 `"Pipe lines, except natural gas"', add
label define ind90ly_lbl 432 `"Services incidental to transportation"', add
label define ind90ly_lbl 440 `"Radio and television broadcasting and cable"', add
label define ind90ly_lbl 441 `"Wired communications"', add
label define ind90ly_lbl 442 `"Telegraph and miscellaneous communications services"', add
label define ind90ly_lbl 450 `"Electric light and power"', add
label define ind90ly_lbl 451 `"Gas and steam supply systems"', add
label define ind90ly_lbl 452 `"Electric and gas, and other combinations"', add
label define ind90ly_lbl 470 `"Water supply and irrigation"', add
label define ind90ly_lbl 471 `"Sanitary services"', add
label define ind90ly_lbl 472 `"Utilities, n.s."', add
label define ind90ly_lbl 500 `"Motor vehicles and equipment"', add
label define ind90ly_lbl 501 `"Furniture and home furnishings"', add
label define ind90ly_lbl 502 `"Lumber and construction materials"', add
label define ind90ly_lbl 510 `"Professional and commercial equipment and supplies"', add
label define ind90ly_lbl 511 `"Metals and minerals, except petroleum"', add
label define ind90ly_lbl 512 `"Electrical goods"', add
label define ind90ly_lbl 521 `"Hardware, plumbing and heating supplies"', add
label define ind90ly_lbl 530 `"Machinery, equipment, and supplies"', add
label define ind90ly_lbl 531 `"Scrap and waste materials"', add
label define ind90ly_lbl 532 `"Miscellaneous wholesale, durable goods"', add
label define ind90ly_lbl 540 `"Paper and paper products"', add
label define ind90ly_lbl 541 `"Drugs, chemicals, and allied products"', add
label define ind90ly_lbl 542 `"Apparel, fabrics, and notions"', add
label define ind90ly_lbl 550 `"Groceries and related products"', add
label define ind90ly_lbl 551 `"Farm-product raw materials"', add
label define ind90ly_lbl 552 `"Petroleum products"', add
label define ind90ly_lbl 560 `"Alcoholic beverages"', add
label define ind90ly_lbl 561 `"Farm supplies"', add
label define ind90ly_lbl 562 `"Miscellaneous wholesale, nondurable goods"', add
label define ind90ly_lbl 571 `"Wholesale trade, n.s."', add
label define ind90ly_lbl 580 `"Lumber and building material retailing"', add
label define ind90ly_lbl 581 `"Hardware stores"', add
label define ind90ly_lbl 582 `"Retail nurseries and garden stores"', add
label define ind90ly_lbl 590 `"Mobile home dealers"', add
label define ind90ly_lbl 591 `"Department stores"', add
label define ind90ly_lbl 592 `"Variety stores"', add
label define ind90ly_lbl 600 `"Miscellaneous general merchandise stores"', add
label define ind90ly_lbl 601 `"Grocery stores"', add
label define ind90ly_lbl 602 `"Dairy products stores"', add
label define ind90ly_lbl 610 `"Retail bakeries"', add
label define ind90ly_lbl 611 `"Food stores, n.e.c."', add
label define ind90ly_lbl 612 `"Motor vehicle dealers"', add
label define ind90ly_lbl 620 `"Auto and home supply stores"', add
label define ind90ly_lbl 621 `"Gasoline service stations"', add
label define ind90ly_lbl 622 `"Miscellaneous vehicle dealers"', add
label define ind90ly_lbl 623 `"Apparel and accessory stores, except shoe"', add
label define ind90ly_lbl 630 `"Shoe stores"', add
label define ind90ly_lbl 631 `"Furniture and home furnishings stores"', add
label define ind90ly_lbl 632 `"Household appliance stores"', add
label define ind90ly_lbl 633 `"Radio, TV, and computer stores"', add
label define ind90ly_lbl 640 `"Music stores"', add
label define ind90ly_lbl 641 `"Eating and drinking places"', add
label define ind90ly_lbl 642 `"Drug stores"', add
label define ind90ly_lbl 650 `"Liquor stores"', add
label define ind90ly_lbl 651 `"Sporting goods, bicycles, and hobby stores"', add
label define ind90ly_lbl 652 `"Book and stationery stores"', add
label define ind90ly_lbl 660 `"Jewelry stores"', add
label define ind90ly_lbl 661 `"Gift, novelty, and souvenir shops"', add
label define ind90ly_lbl 662 `"Sewing, needlework, and piece goods stores"', add
label define ind90ly_lbl 663 `"Catalog and mail order houses"', add
label define ind90ly_lbl 670 `"Vending machine operators"', add
label define ind90ly_lbl 671 `"Direct selling establishments"', add
label define ind90ly_lbl 672 `"Fuel dealers"', add
label define ind90ly_lbl 681 `"Retail florists"', add
label define ind90ly_lbl 682 `"Miscellaneous retail stores"', add
label define ind90ly_lbl 691 `"Retail trade, n.s."', add
label define ind90ly_lbl 700 `"Banking"', add
label define ind90ly_lbl 701 `"Savings institutions, including credit unions"', add
label define ind90ly_lbl 702 `"Credit agencies, n.e.c."', add
label define ind90ly_lbl 710 `"Security, commodity brokerage, and investment companies"', add
label define ind90ly_lbl 711 `"Insurance"', add
label define ind90ly_lbl 712 `"Real estate, including real estate-insurance offices"', add
label define ind90ly_lbl 721 `"Advertising"', add
label define ind90ly_lbl 722 `"Services to dwellings and other buildings"', add
label define ind90ly_lbl 731 `"Personnel supply services"', add
label define ind90ly_lbl 732 `"Computer and data processing services"', add
label define ind90ly_lbl 740 `"Detective and protective services"', add
label define ind90ly_lbl 741 `"Business services, n.e.c."', add
label define ind90ly_lbl 742 `"Automotive rental and leasing, without drivers"', add
label define ind90ly_lbl 750 `"Automobile parking and carwashes"', add
label define ind90ly_lbl 751 `"Automotive repair and related services"', add
label define ind90ly_lbl 752 `"Electrical repair shops"', add
label define ind90ly_lbl 760 `"Miscellaneous repair services"', add
label define ind90ly_lbl 761 `"Private households"', add
label define ind90ly_lbl 762 `"Hotels and motels"', add
label define ind90ly_lbl 770 `"Lodging places, except hotels and motels"', add
label define ind90ly_lbl 771 `"Laundry, cleaning, and garment services"', add
label define ind90ly_lbl 772 `"Beauty shops"', add
label define ind90ly_lbl 780 `"Barber shops"', add
label define ind90ly_lbl 781 `"Funeral service and crematories"', add
label define ind90ly_lbl 782 `"Shoe repair shops"', add
label define ind90ly_lbl 790 `"Dressmaking shops"', add
label define ind90ly_lbl 791 `"Miscellaneous personal services"', add
label define ind90ly_lbl 800 `"Theaters and motion pictures"', add
label define ind90ly_lbl 801 `"Video tape rental"', add
label define ind90ly_lbl 802 `"Bowling centers"', add
label define ind90ly_lbl 810 `"Miscellaneous entertainment and recreation services"', add
label define ind90ly_lbl 812 `"Offices and clinics of physicians"', add
label define ind90ly_lbl 820 `"Offices and clinics of dentists"', add
label define ind90ly_lbl 821 `"Offices and clinics of chiropractors"', add
label define ind90ly_lbl 822 `"Offices and clinics of optometrists"', add
label define ind90ly_lbl 830 `"Offices and clinics of health practitioners, n.e.c."', add
label define ind90ly_lbl 831 `"Hospitals"', add
label define ind90ly_lbl 832 `"Nursing and personal care facilities"', add
label define ind90ly_lbl 840 `"Health services, n.e.c."', add
label define ind90ly_lbl 841 `"Legal services"', add
label define ind90ly_lbl 842 `"Elementary and secondary schools"', add
label define ind90ly_lbl 850 `"Colleges and universities"', add
label define ind90ly_lbl 851 `"Vocational schools"', add
label define ind90ly_lbl 852 `"Libraries"', add
label define ind90ly_lbl 860 `"Educational services, n.e.c."', add
label define ind90ly_lbl 861 `"Job training and vocational rehabilitation services"', add
label define ind90ly_lbl 862 `"Child day care services"', add
label define ind90ly_lbl 863 `"Family child care homes"', add
label define ind90ly_lbl 870 `"Residential care facilities, without nursing"', add
label define ind90ly_lbl 871 `"Social services, n.e.c."', add
label define ind90ly_lbl 872 `"Museums, art galleries, and zoos"', add
label define ind90ly_lbl 873 `"Labor unions"', add
label define ind90ly_lbl 880 `"Religious organizations"', add
label define ind90ly_lbl 881 `"Membership organizations, n.e.c."', add
label define ind90ly_lbl 882 `"Engineering, architectural, and surveying services"', add
label define ind90ly_lbl 890 `"Accounting, auditing, and bookkeeping services"', add
label define ind90ly_lbl 891 `"Research, development, and testing services"', add
label define ind90ly_lbl 892 `"Management and public relations services"', add
label define ind90ly_lbl 893 `"Miscellaneous professional and related services"', add
label define ind90ly_lbl 900 `"Executive and legislative offices"', add
label define ind90ly_lbl 901 `"General government, n.e.c."', add
label define ind90ly_lbl 910 `"Justice, public order, and safety"', add
label define ind90ly_lbl 921 `"Public finance, taxation, and monetary policy"', add
label define ind90ly_lbl 922 `"Administration of human resources programs"', add
label define ind90ly_lbl 930 `"Administration of environmental quality and housing programs"', add
label define ind90ly_lbl 931 `"Administration of economic programs"', add
label define ind90ly_lbl 932 `"National security and international affairs"', add
label define ind90ly_lbl 940 `"Army"', add
label define ind90ly_lbl 941 `"Air Force"', add
label define ind90ly_lbl 942 `"Navy"', add
label define ind90ly_lbl 950 `"Marines"', add
label define ind90ly_lbl 951 `"Coast Guard"', add
label define ind90ly_lbl 952 `"Armed Forces, branch not specified"', add
label define ind90ly_lbl 960 `"Military Reserves or National Guard"', add
label define ind90ly_lbl 998 `"Unknown"', add
label values ind90ly ind90ly_lbl

label define wkswork2_lbl 0 `"NIU"'
label define wkswork2_lbl 1 `"1-13 weeks"', add
label define wkswork2_lbl 2 `"14-26 weeks"', add
label define wkswork2_lbl 3 `"27-39 weeks"', add
label define wkswork2_lbl 4 `"40-47 weeks"', add
label define wkswork2_lbl 5 `"48-49 weeks"', add
label define wkswork2_lbl 6 `"50-52 weeks"', add
label define wkswork2_lbl 9 `"Missing data"', add
label values wkswork2 wkswork2_lbl

forvalues i=1980(1)2017{
	preserve
	keep if year==`i'
	save "$raw_data/IPUMS_CPS/cps_sample_`i'", replace
	restore
}
