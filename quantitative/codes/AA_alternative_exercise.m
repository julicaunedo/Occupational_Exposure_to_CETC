%%% This code runs the alternative exercises labelled "identical 
%%% elasticity" and "identical CETC" in the paper. It also produces all the 
%%% table entries that relate to these exercises.

%% Alternative exercise: identical elasticity
%%select the elasticity of subtitution between capital and labor
clear all
close all
clc
ii_cdsd=1; %%=0 occupational elasticities, =1 aggregate elasticity
run sel_elast.m
%%prepare the data for calibration
clear all
close all
clc
yby=0; %%=0 decennial data, =1 yearly data
run data_for_model.m
%%run the calibration
clc
clear all
close all
same_pk=0; %%=0 occupational usercosts, =1 aggregate usercost   
yby=0; %%=0 decennial data, =1 yearly data
model_me=0; %%=0 baseline model, ==1 model with multiple capital goods
run model_solve.m
%%decomposition of the scale parameters of the Frechet distribution of 
%%efficiency units of labor for the counterfactuals
clear all
clc
run z_decomposition.m
%%run the counterfactual
clc
clear all
maxiter_in=10^4; %%maximum number of iterations in the computation of the equilibrium
c_ysel=1; %%year of the counterfactual, =1 1984, =2 1989, =3 1999, =4 2009, =5 2015
altx=1; %%=0 baseline, =1 is alternative exercise
model_me=0; %%=0 baseline, =1 model with multiple capital goods
run main_counterfactuals.m
%%run tables and figures on the counterfactual outcome
clear all
clc
filename_mult='../results/tables_paper.xlsx'; %%output file
sheet_name_mult='ae_elast'; %%output sheet
altx=1; %%=0 baseline, =1 is alternative exercise
model_me=0; %%=0 baseline, =1 model with multiple capital goods
run counterfactual_stats.m

%% Alternative exercise: identical CETC
%%select the elasticity of subtitution between capital and labor
clear all
close all
clc
ii_cdsd=0; %%=0 occupational elasticities, =1 aggregate elasticity
run sel_elast.m
%%prepare the data for the calibration
clear all
close all
clc
yby=0; %%=0 decennial data, =1 yearly data
run data_for_model.m
%%run the calibration
clc
clear all
close all
same_pk=1; %%=0 occupational usercosts, =1 aggregate usercost   
yby=0; %%=0 decennial data, =1 yearly data
model_me=0; %%=0 baseline model, ==1 model with multiple capital goods
run model_solve.m
%%decomposition of the scale parameters of the Frechet distribution of 
%%efficiency units of labor for the counterfactuals
clear all
clc
run z_decomposition.m
%%run the counterfactual
clc
clear all
maxiter_in=10^4; %%maximum number of iterations in the computation of the equilibrium
c_ysel=1; %%year of the counterfactual, =1 1984, =2 1989, =3 1999, =4 2009, =5 2015
altx=1; %%=0 baseline, =1 is alternative exercise
model_me=0; %%=0 baseline, =1 model with multiple capital goods
run main_counterfactuals.m
%%run the tables on the counterfactual outcome
clear all
clc
filename_mult='../results/tables_paper.xlsx'; %%output file
sheet_name_mult='ae_pk'; %%output sheet
altx=1; %%=0 baseline, =1 is alternative exercise
model_me=0; %%=0 baseline, =1 model with multiple capital goods
run counterfactual_stats.m