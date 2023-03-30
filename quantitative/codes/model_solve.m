%% Loading
if yby==0
    load data_main.mat
else
    load data_main_yby.mat
end
load stats_data_for_model.mat
g_b=7;%%baseline demographic group
load baseo.mat
load rho.mat
load theta_w.mat
load gamma.mat

%% Data
n_o=numel(list_o); %%number of occupations
n_s=numel(list_s); %%number of educational groups
n_a=numel(list_a); %number of age groups
n_j=1; %number of capital goods by occupation
n_g=size(pi_o_gh,2); %%total number of demographic groups
n_y=numel(c_years);
j_b=o_b;
bb=[o_b,j_b,g_b];nn=[n_o,n_j,n_g,n_y];
%%%%%%%Occupational capital
%%rescaling the levels of capital expenses 
if model_me==0
    tot_k_in=data_stock_occ.*dd_rescale_saved;  
elseif  model_me==1
    tot_k_in=permute(nansum(tot_k_ohj,2),[1,3,4,2]).*dd_rescale_saved; 
end
dd_wa_h_help=permute(wa_h,[3,1,2]); 
wage_pay_lev=permute(nansum(tot_n_in.*repmat(dd_wa_h_help,[n_o,1,1]),2),[1,3,2]);
if model_me==0
    capital_pay_lev=tot_k_in.*data_usercost_occ;
    tot_k_in=tot_k_in.*nanmean(nanmean(capital_pay_lev.^(-1).*capital_pay_lev_s,1),2); 
    tot_k_in=permute(tot_k_in,[1,3,2]);
elseif  model_me==1
    capital_pay_lev=permute(nansum(pk_k_oj.*tot_k_in,2),[1,3,2]);
    tot_k_in=tot_k_in.*nanmean(nanmean(capital_pay_lev.^(-1).*capital_pay_lev_s,1),2); 
end
dd_yo_val=capital_pay_lev+wage_pay_lev;
wage_pay_lev_pw=wage_pay_lev.*repmat(tot_n,[n_o,1]).^(-1);
capital_pay_lev_pw=capital_pay_lev.*repmat(tot_n,[n_o,1]).^(-1);
dd_yo_val_pw=capital_pay_lev_pw+wage_pay_lev_pw;
%%expenditure shares in aggregate capital (only for the model with multiple capital goods)
if model_me==0
    sh_oj=nan;
elseif model_me==1
    tot_k_occ_in=permute(data_stock_occ.*dd_rescale_saved,[1,3,2]); 
    n_jt=numel(list_k);
    j_b=n_j_opt(2);
    sh_oj=tot_k_in.*repmat(tot_k_in(:,j_b,:),[1,n_jt,1]).^(-1).*...
        (pk_k_oj.*repmat(pk_k_oj(:,j_b,:),[1,n_jt,1]).^(-1)).^gamma_1;
    sh_oj(isnan(sh_oj)==1)=0;
    tot_k_in_o=nansum(sh_oj.^(1/gamma_1).*tot_k_in.^((gamma_1-1)/gamma_1),2).^(gamma_1/(gamma_1-1));
    rescale_sh=(tot_k_occ_in.*(tot_k_in_o).^(-1)).^(gamma_1-1);
    sh_oj=sh_oj.*repmat(rescale_sh,[1,n_jt,1]);
end
%%capital per worker
if model_me==0
    pw_k=tot_k_in.*nansum(tot_n_in,2).^(-1);
elseif model_me==1
    tot_k_in_o=nansum(sh_oj.^(1/gamma_1).*tot_k_in.^((gamma_1-1)/gamma_1),2).^(gamma_1/(gamma_1-1));
    if gamma_1==1
        tot_k_in_temp=tot_k_in;tot_k_in_temp(sh_oj==0)=1;
        tot_k_in_o_cd=prod(tot_k_in_temp.^(sh_oj),2);
        tot_k_in_o=tot_k_in_o_cd;
    end
    pw_k=tot_k_in_o.*nansum(tot_n_in,2).^(-1);
end

%% Parameters
alpha=0.24; %%as in Burstein et al. (2019), see online appendix
para=[theta_w,rho,alpha,gamma_1];
%%elasticity
elast_temp=(elast_s_in-1).*elast_s_in.^(-1);
elast_s=repmat(elast_temp,[1,n_g,n_y]);
elast_s_lev=repmat(elast_s_in,[1,n_g,n_y]);
%%capital shares
iihelp=[1:1:n_o];iihelp(ii_cd)=[];
dd_alpha_o(iihelp,:)=alpha;
alpha_mat=repmat(permute(dd_alpha_o,[1,3,2]),[1,n_g,1]);
%%expenditure shares
dd_exps=permute(dd_exps,[1,3,2]);
%%%%usercost of capital
mm_lambda_j=permute(dd_lambda_j_occ_s(:,:,1),[1,3,2]); 
if same_pk==1
    mm_lambda_j=repmat(nanmean(mm_lambda_j,1),[n_o,1,1]);
end

%%  Calibration
pi_ojh=pi_oj_gh.*repmat(permute(pi_h,[3,1,2]),[n_o,1,1]); 
[mm_Th,mm_lambda_o,mm_z]=main_calibration(pi_oj_gh,pi_h,nn,bb,alpha_mat,mm_lambda_j,elast_s,elast_s_lev,wa_h,para,ii_cd,...
    pw_k);
norm_lambdao=mm_lambda_o(o_b,:,:);

%% Model stats
%%wage per efficiency unit of labor
alpha_bar=(1-alpha_mat).*alpha_mat.^(alpha_mat.*(1-alpha_mat).^(-1));
aa1=(alpha_mat.*(1-alpha_mat).^(-1)).^((1-elast_s).^(-1)).*repmat(mm_lambda_j,[1,n_g,1]).^((elast_s).*((elast_s-1)).^(-1));
aa2=(1-alpha_mat).^((elast_s-1).^(-1)).*repmat(mm_lambda_o,[1,n_g,1]).^((elast_s).*((elast_s-1)).^(-1));
x_tilda=(aa2-aa1).^((elast_s-1).*((elast_s)).^(-1));
mm_xtilda=x_tilda;
aa1=repmat(mm_lambda_j,[1,n_g,1]).^((-alpha_mat).*(1-alpha_mat).^(-1));
aa2=repmat(mm_lambda_o,[1,n_g,1]).^((1).*((1-alpha_mat)).^(-1));
mm_xtilda_cd=alpha_bar.*aa1.*aa2;
mm_xtilda(ii_cd,:,:)=mm_xtilda_cd(ii_cd,:,:);
%%average wages
T_h_st=repmat(permute(mm_Th,[3,1,2]),[n_o,1,1]);
mm_wh_p=(nansum(T_h_st.*mm_z.^(theta_w).*(mm_xtilda).^(theta_w),1)).^(1/theta_w).*gamma(1-1/theta_w);
mm_wh_p=permute(mm_wh_p,[2,3,1]);
%%occupational choice
num=(mm_z.*mm_xtilda).^theta_w;
den=repmat(nansum(num,1),[n_o,1,1]);
mm_pi_oj_gh=num.*(den).^(-1);
aa=mm_pi_oj_gh-pi_oj_gh;
error_1=nansum(nansum(abs(aa),1),2); %%fit on the occupational choice
%%capital stock
mm_pi_ojh=mm_pi_oj_gh.*permute(pi_h,[3,1,2]); 
dd_pi_h=permute(pi_h,[3,1,2]); 
eff_byt=(T_h_st).^(1/theta_w).*gamma(1-1/theta_w).*mm_pi_oj_gh.^(-1/theta_w+1);
mm_eeff=eff_byt.*repmat(dd_pi_h,[n_o,1,1]);
mm_k=mm_eeff.*mm_z.*(alpha_mat.*(1-alpha_mat).^(-1).*mm_xtilda.*repmat(mm_lambda_j,[1,n_g,1]).^(-1)).^(elast_s_lev);
mm_k(mm_z==0)=nan;
mm_ko=permute(nansum(mm_k,2),[1,3,2]).*permute(nansum(mm_pi_ojh,2),[1,3,2]).^(-1);
dd_ko=permute(pw_k,[1,3,2]);
modelin=mm_ko;
datain=dd_ko;
modelin(ii_cd,:)=nan;datain(ii_cd,:)=nan;
error_2=nansum(abs(modelin-datain),1); %%fit on the capital stock
%%omega 
[mm_omegas,mm_yo_val]=solve_occprodshares(pi_h,para,mm_pi_oj_gh,mm_Th,mm_z,mm_lambda_o,mm_lambda_j,mm_xtilda,elast_s,alpha_mat,ii_cd,bb,nn);
%%output
[mm_y]=compute_output(pi_h,para,mm_pi_oj_gh,mm_Th,mm_z,mm_lambda_o,mm_omegas,mm_lambda_j,mm_xtilda,elast_s,alpha_mat,ii_cd,bb,nn);

%% Save
dd_pi_oj_gh=pi_oj_gh;dd_wa_h=wa_h;dd_pi_h=pi_h;
save model_calib.mat mm_z mm_wh_p mm_lambda_o mm_lambda_j mm_xtilda mm_Th mm_omegas ...
    mm_pi_oj_gh mm_yo_val mm_ko mm_y ...
    para c_years elast_s alpha_mat ii_cd elast_s_in elast_s_lev alpha_bar nn bb ...
    pk_k_oj sh_oj dd_pi_h dd_pi_oj_gh dd_wa_h