%%% This code calibrates the model, runs the main counterfactual described
%%% in the second paragraph of section 5, and runs the prediction exercise
%%% described in section 6.1. It produces all tables and figures in the
%%% paper that relate to these exercies.

%% Calibration and counterfactuals 
%%% runs the calbration and the main counterfactual using decennial data
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
same_pk=0; %%=0 occupational usercosts, =1 aggregate usercost   
yby=0; %%=0 decennial data, =1 yearly data
model_me=0; %%=0 baseline model, ==1 model with multiple capital goods
run model_solve.m
%%model fit
clear all
clc
run model_fit.m
%%decomposition of the scale parameters of the Frechet distribution of 
%%efficiency units of labor for the counterfactuals
clear all
clc
run z_decomposition.m
%%run the counterfactual
clc
clear all
maxiter_in=10^6; %%maximum number of iterations in the computation of the equilibrium
c_ysel=1; %%year of the counterfactual, =1 1984, =2 1989, =3 1999, =4 2009, =5 2015
altx=0; %%=0 baseline, =1 is alternative exercise
model_me=0; %%=0 baseline, =1 model with multiple capital goods
run main_counterfactuals.m
%%run tables and figures on the counterfactual outcome
clear all
clc
filename_mult='../results/tables_paper.xlsx'; %%output file
sheet_name_mult='baseline'; %%output sheet
altx=0; %%=0 baseline, =1 is alternative exercise
model_me=0; %%=0 baseline, =1 model with multiple capital goods
run counterfactual_stats.m
clear all
run counterfactual_figures.m

%% Prediction
%%% runs the prediction exercise useing annual data
%%prepare the data for the calibration
clear all
close all
clc
yby=1; %%=0 decennial data, =1 yearly data
run data_for_model.m
%%run the calibration
clc
clear all
close all
same_pk=0; %%=0 occupational usercosts, =1 aggregate usercost   
yby=1; %%=0 decennial data, =1 yearly data
model_me=0; %%=0 baseline model, ==1 model with multiple capital goods
run model_solve.m
%%run the prediction
clear all
close all
clc
run prediction.m