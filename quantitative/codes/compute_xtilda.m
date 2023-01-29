function mm_xtilda=compute_xtilda(mm_lambda_o,mm_lambda_j,alpha_mat,elast_s,nn,alpha_bar)

n_g=nn(3);ii_cd=find(elast_s(:,1,1)==0);

aa1=(alpha_mat.*(1-alpha_mat).^(-1)).^((1-elast_s).^(-1)).*repmat(mm_lambda_j,[1,n_g,1]).^((elast_s).*((elast_s-1)).^(-1));
aa2=(1-alpha_mat).^((elast_s-1).^(-1)).*repmat(mm_lambda_o,[1,n_g,1]).^((elast_s).*((elast_s-1)).^(-1));
x_tilda=(aa2-aa1).^((elast_s-1).*((elast_s)).^(-1));
mm_xtilda=x_tilda;
aa1=repmat(mm_lambda_j,[1,n_g,1]).^((-alpha_mat).*(1-alpha_mat).^(-1));
aa2=repmat(mm_lambda_o,[1,n_g,1]).^((1).*((1-alpha_mat)).^(-1));
mm_xtilda_cd=alpha_bar.*aa1.*aa2;
mm_xtilda(ii_cd,:,:)=mm_xtilda_cd(ii_cd,:,:);

