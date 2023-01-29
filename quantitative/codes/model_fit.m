%% Loading
load model_calib.mat
load data_main.mat
load data_info.mat
filename_in='../results/tables_paper.xlsx';
sheet_name='model_fit';
load baseo.mat
n_o=numel(list_o);
n_g=size(pi_o_gh,2); 

%% Capital share 
%%%data
alpha=0.24; 
pi_o=permute(nansum(pi_o_gh.*(permute(pi_h,[3,1,2])),2),[1,3,2]);
wage_pay=pi_o.*wa_o.*repmat(tot_n,[n_o,1]);
capital_pay=data_stock_occ.*data_usercost_occ;
dd_exps=capital_pay.*(wage_pay).^(-1);
dd_rescale=nanmean(dd_exps(:)).^(-1).*alpha.*(1-alpha).^(-1);
dd_exps=dd_rescale.*dd_exps;
dd_alpha_o=dd_exps.*(dd_exps+1).^(-1);    
T=table([dd_alpha_o(:,1),dd_alpha_o(:,5)-dd_alpha_o(:,1)]);
writetable(T,filename_in,'Sheet',sheet_name,'Range','b19','WriteVariableNames',false)
%%model
alpha=0.24; 
dd_wa_h_help=permute(wa_h,[3,1,2]); 
dd_pi_h_help=permute(dd_pi_h.*repmat(tot_n,[n_g,1]),[3,1,2]); 
dd_yo=nansum(pi_o_gh.*repmat(dd_wa_h_help.*dd_pi_h_help,[n_o,1,1]),2);
wage_pay=permute(dd_yo,[1,3,2]);wage_pay_lev=wage_pay;
dd_exps=capital_pay.*(wage_pay).^(-1);
dd_rescale=nanmean(dd_exps(:)).^(-1).*alpha.*(1-alpha).^(-1);
dd_exps=dd_rescale.*dd_exps;
dd_alpha_o_m=dd_exps.*(dd_exps+1).^(-1);
T=table([dd_alpha_o_m(:,1),dd_alpha_o_m(:,5)-dd_alpha_o_m(:,1)]);
writetable(T,filename_in,'Sheet',sheet_name,'Range','f19','WriteVariableNames',false)

%% Wages by occupation 
n_o=size(pi_oj_gh,1);n_j=size(pi_oj_gh,2);n_g=size(pi_oj_gh,3);n_y=size(pi_oj_gh,4);
nn=[n_o,n_j,n_g,n_y];
%%data
T=table([wa_o(:,1),((wa_o(:,5).*wa_o(:,1).^(-1)).^(1/30)-1)*100]);
writetable(T,filename_in,'Sheet',sheet_name,'Range','b4','WriteVariableNames',false)
%%model
mm_pi_oj=mm_pi_oj_gh.*repmat(permute(dd_pi_h,[3,1,2]),[n_o,1,1]);
ss_tpx=mm_pi_oj;ss_tpy=mm_wh_p; group_id=1; %%edu
[mm_wa_o]=mean_wageo_bylist(ss_tpx,ss_tpy,[],ident,nn,group_id);
T=table([mm_wa_o(:,1),((mm_wa_o(:,5).*mm_wa_o(:,1).^(-1)).^(1/30)-1)*100]);
writetable(T,filename_in,'Sheet',sheet_name,'Range','f4','WriteVariableNames',false)
