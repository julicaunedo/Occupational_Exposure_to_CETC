%% Loading
if yby==0
    load data_main.mat
    load data_info.mat

elseif yby==1
    load data_main_yby.mat
    load data_info_yby.mat
end
load baseo.mat
n_o=numel(list_o); %%number of occupations
n_g=size(pi_o_gh,2); %%total number of demographic groups

%% Expenditure share
alpha=0.24; %%as in Burstein et al. (2019), see online appendix
dd_wa_h_help=permute(wa_h,[3,1,2]); 
dd_pi_h_help=permute(pi_h.*repmat(tot_n,[n_g,1]),[3,1,2]); 
dd_yo=nansum(pi_o_gh.*repmat(dd_wa_h_help.*dd_pi_h_help,[n_o,1,1]),2);
wage_pay_lev=permute(dd_yo,[1,3,2]);
capital_pay_lev=data_stock_occ.*data_usercost_occ;
dd_exps=capital_pay_lev.*(wage_pay_lev).^(-1);
dd_rescale=nanmean(dd_exps(:)).^(-1).*alpha.*(1-alpha).^(-1);
dd_rescale_saved=dd_rescale;
dd_exps=dd_rescale.*dd_exps;
dd_alpha_o=dd_exps.*(dd_exps+1).^(-1);
capital_pay_lev_s=capital_pay_lev.*dd_rescale_saved;

%% Number of workers
dd_pi_h_help=permute(pi_h.*repmat(tot_n,[n_g,1]),[3,1,2]); %%number of workers of a given group
tot_n_in=pi_o_gh.*repmat(dd_pi_h_help,[n_o,1,1]);
pi_oj_gh=pi_o_gh; %%relabelling

%% Variation in the usercost of capital over time
%%usercost by occupation
dd_lambda_j_occ_s=data_usercost_occ;
%%usercost by equipment (model with mulitple capital goods)
pk_k_oj=repmat(permute(data_pi_s,[3,1,2]),[n_o,1,1]);
%%select the baseline capital good in the multiple capital goods model
tot_k_oj=permute(nansum(tot_k_ohj,2),[1,3,4,2]);
aa=nansum((tot_k_oj==0),[1,3]);
n_j_opt=find(aa==0);

%% Elasticity of substitution between capital and labor
load elast_for_model.mat
ii_cd=find(elast_s_in==1); %%index for Cobb-Douglas

%% Save
save stats_data_for_model.mat dd_lambda_j_occ_s dd_alpha_o dd_exps dd_rescale_saved capital_pay_lev_s tot_k_oj pk_k_oj ...
    data_stock_occ tot_n_in elast_s_in ii_cd pi_oj_gh n_j_opt