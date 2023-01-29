function [mm_Th,mm_lambda_o,mm_z]=main_calibration(pi_oj_gh,pi_h,nn,bb,alpha_mat,mm_lambda_j,elast_s,elast_s_lev,wa_h,para,ii_cd,...
                                                        pw_k)
n_o=nn(1);n_g=nn(3);n_y=nn(4);
o_b=bb(1);g_b=bb(3);
theta_w=para(1);

%%Frechet scale parameters: absolute advantage
pi_ojh=pi_oj_gh.*repmat(permute(pi_h,[3,1,2]),[n_o,1,1]);
pi_o=permute(nansum(pi_ojh,2),[1,3,2]); 
factor1=permute((alpha_mat(:,1,:).*(1-alpha_mat(:,1,:)).^(-1).*mm_lambda_j(:,1,:).^(-1)).^elast_s_lev(:,1,:),[1,3,2]);
help1=wa_h.*(repmat(wa_h(g_b,:),[n_g,1])).^(-1);
help2=permute(nansum(pi_oj_gh.*repmat(pi_oj_gh(o_b,:,:),[n_o,1,1]).^(-1),1),[2,3,1]);
mm_Th=help1.^theta_w.*repmat(help2(g_b,:),[n_g,1]).*help2.^(-1);
D=nansum(pi_ojh.*(repmat(permute(mm_Th,[3,1,2]),[n_o,1,1])).^(1/theta_w).*(repmat(pi_oj_gh(o_b,:,:),[n_o,1,1])).^(-1/theta_w),2); 
if numel(ii_cd)==n_o
    mm_xtilda_transf=ones(1,n_y);
    mm_xtilda_b=ones(1,n_y);
else
    aa1=help2(g_b,:).^(-1/theta_w);
    aa2=wa_h(g_b,:).*permute(pw_k(o_b,:,:),[1,3,2]).^(-1);
    aa3=1;
    aa4=factor1(o_b,:);
    aa5=permute(D(o_b,:,:),[1,3,2]);
    aa6=pi_o(o_b,:).^(-1);
    mm_xtilda_transf=(aa1.*aa2.*aa3.*aa4.*aa5.*aa6);
    mm_xtilda_b=mm_xtilda_transf.^((1-permute(elast_s_lev(o_b,1,:),[1,3,2])).^(-1));
end
aa1=wa_h(g_b,:).^(theta_w);
aa2=help2(g_b,:).^(-1);
aa3=mm_xtilda_b.^(-theta_w);
aa4=(gamma(1-1/theta_w)).^(-theta_w);
T_lev=aa1.*aa2.*aa3.*aa4;
mm_Th=mm_Th.*T_lev;
%%wage per efficiency units of labor
aa1=factor1.^(-1).*repmat(factor1(o_b,:),[n_o,1]);
aa2=permute(D.^(-1).*repmat(D(o_b,:,:),[n_o,1]),[1,3,2]);
aa3=permute(pw_k,[1,3,2]).*repmat(permute(pw_k(o_b,:,:),[1,3,2]),[n_o,1]).^(-1);
aa4=pi_o.*repmat(pi_o(o_b,:),[n_o,1]).^(-1);
mm_xtilda=(aa1.*aa2.*aa3.*aa4.*repmat(mm_xtilda_transf,[n_o,1]).^(-1)).^((permute(elast_s_lev(:,1,:),[1,3,2])-1).^(-1));
norm_xtilda_cd=0;
if norm_xtilda_cd==0
    mm_xtilda(ii_cd,:)=pi_o(ii_cd,:).^(1/theta_w).*repmat(mm_xtilda_b,[numel(ii_cd,1),1]);
elseif norm_xtilda_cd==1
    mm_xtilda(ii_cd,:)=1;
end
%%occupational price
aa1=(alpha_mat.*(1-alpha_mat).^(-1)).^((1-elast_s).^(-1)).*repmat(mm_lambda_j,[1,n_g,1]).^((elast_s).*((elast_s-1)).^(-1));
aa2=repmat(permute(mm_xtilda,[1,3,2]),[1,n_g,1]).^(1-elast_s_lev(:,1,:));
aa3=(1-alpha_mat).^(elast_s_lev);
mm_lambda_o=((aa2+aa1).*aa3).^((1-elast_s_lev).^(-1));
alpha_bar=(1-alpha_mat).*alpha_mat.^(alpha_mat.*(1-alpha_mat).^(-1));
aa1=repmat(mm_lambda_j,[1,n_g,1]).^((-alpha_mat).*(1-alpha_mat).^(-1));
aa2=repmat(permute(mm_xtilda,[1,3,2]),[1,n_g,1]);
aa3=alpha_bar.^(-1);
mm_xtilda_cd=(aa1.^(-1).*aa2.*aa3).^(1-alpha_mat);
mm_lambda_o(ii_cd,:,:)=mm_xtilda_cd(ii_cd,:,:);
mm_lambda_o=mm_lambda_o(:,1,:);
mm_xtilda=repmat(permute(mm_xtilda,[1,3,2]),[1,n_g,1]);
%%Frechet scale parameters: comparative advantage
mm_z=((pi_oj_gh).*...
    (repmat(pi_oj_gh(o_b,:,:),[n_o,1,1])).^(-1)).^(1/theta_w).*...
    repmat(mm_xtilda(o_b,:,:),[n_o,1,1]).*mm_xtilda.^(-1);
