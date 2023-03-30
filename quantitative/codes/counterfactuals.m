%% Loading
load model_calib.mat
load data_info.mat
load mm_z_dec.mat
y_sel=5;
maxiter=maxiter_in;

%% Run the counterfactuals
n_o=nn(1);n_g=nn(3);
for pp=1:5
    cc_lambda_j=cc_lambda_j_sel(:,:,:,pp);
    cc_z_o_in=cc_z_o_in_sel(:,:,:,pp);
    cc_z_g_in=cc_z_g_in_sel(:,:,:,pp);
    cc_z_resi=cc_z_resi_sel(:,:,:,pp);
    cc_Th=cc_Th_sel(:,:,:,pp);
    cc_omegas=cc_omegas_sel(:,:,:,pp);
    cc_pi_h=cc_pi_h_sel(:,:,:,pp);
    cc_z=cc_z_resi.*...
    repmat(permute(cc_z_o_in,[1,3,2]),[1,n_g,1]).*...
    repmat(permute(cc_z_g_in,[3,1,2]),[n_o,1,1]);
    %%%outcomes
    eval([strcat('cc_pi_oj_gh_',num2str(pp)),'=zeros(n_o,n_g,n_y);'])
    eval([strcat('cc_xtilda_',num2str(pp)),'=zeros(n_o,n_g,n_y);'])
    eval([strcat('cc_wh_p_',num2str(pp)),'=zeros(n_g,n_y);'])
    %%run the counterfactual
    [cc_pi_oj_gh_j,cc_xtilda_j,cc_wh_p_j,temp2]=counter_help(pp,alpha_mat,elast_s,ii_cd,mm_lambda_o,alpha_bar,...
        cc_lambda_j,cc_z,cc_Th,cc_omegas,cc_pi_h,nn,bb,maxiter,para,c_ysel,y_sel,altx);
    %%save
    eval([strcat('cc_pi_oj_gh_',num2str(pp)),'=cc_pi_oj_gh_j;'])
    eval([strcat('cc_xtilda_',num2str(pp)),'=cc_xtilda_j;'])
    eval([strcat('cc_wh_p_',num2str(pp)),'=cc_wh_p_j;'])
    eval([strcat('cc_ddist_',num2str(pp)),'=temp2;'])
end
c_ysel_counter=c_ysel;
save temp_counter.mat  c_ysel_counter ...
    cc_pi_oj_gh_1 cc_xtilda_1 cc_wh_p_1 cc_ddist_1 ...
    cc_pi_oj_gh_2 cc_xtilda_2 cc_wh_p_2 cc_ddist_2 ...
    cc_pi_oj_gh_3 cc_xtilda_3 cc_wh_p_3 cc_ddist_3 ...
    cc_pi_oj_gh_4 cc_xtilda_4 cc_wh_p_4 cc_ddist_4 ...
    cc_pi_oj_gh_5 cc_xtilda_5 cc_wh_p_5 cc_ddist_5;
