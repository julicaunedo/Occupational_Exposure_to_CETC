%% Loading
load model_calib.mat
load data_main.mat
load data_info.mat

%% Regression inputs
%%change the shape of z
mm_z=permute(mm_z,[1,4,2,3]);
o_b=bb(1);
n_o=nn(1);n_j=nn(2);n_g=nn(3);n_y=nn(4);
%%dummies
occ_index=[1:1:n_o]';
o_dummy=repmat(occ_index,[1,n_j,n_g]);
j_index=[1:1:n_j];
j_dummy=repmat(j_index,[n_o,1,n_g]);
g_index=[1:1:n_g]';g_index=permute(g_index,[3,2,1]);
g_dummy=repmat(g_index,[n_o,n_j,1]);
o_d=reshape(o_dummy,[numel(o_dummy),1]);
o_j=reshape(j_dummy,[numel(o_dummy),1]);
o_g=reshape(g_dummy,[numel(o_dummy),1]);
int=ones(numel(o_d),1);
o_d_in=dummyvar(o_d);
o_j_in=dummyvar(o_j);
o_g_in=dummyvar(o_g);
pi_ojh=mm_pi_oj_gh.*repmat(permute(pi_h,[3,1,2]),[n_o,1,1]); %%number of workers in the model
ii_indexocc=[[1:o_b-1],[o_b+1:n_o]];

%% Year by year regression
for t=1:n_y
    mm_z_in=reshape(mm_z(:,:,:,t),[numel(mm_z(:,:,:,t)),1]);
    mm_z_in(mm_z_in==0)=nan;    
    ww_in=reshape(pi_ojh(:,:,t),[numel(pi_ojh(:,:,t)),1]);
    y=log(mm_z_in);
    X=[int,o_d_in(:,ii_indexocc),o_j_in(:,2:size(o_j_in,2)),o_g_in(:,2:size(o_g_in,2))];
    xx_in=X;yy_in=y;w=ww_in;
    A=[xx_in];B=yy_in;w=ww_in;
    mdl = fitlm(A,B,'Intercept',false,'Weights',w);
    temp=mdl.Coefficients.Estimate;
    res_alt=mdl.Residuals.Raw;
    temp(temp==0)=nan;         
    z_o(:,t)=[temp(2:o_b);0;temp(o_b+1:n_o)];
    z_j(:,t)=[0;temp(n_o+1:n_o+n_j-1)];
    z_g(:,t)=temp(1)+[0;temp(n_o+n_j:n_o+n_j+n_g-2)];
    z_resi(:,:,:,t)=reshape(res_alt,[n_o,n_j,n_g,1]);
end

%% Outcomes
z_o=exp(1).^(z_o);
z_j=exp(1).^(z_j);
z_g=exp(1).^(z_g);
z_resi=exp(1).^(z_resi);
z_resi=permute(z_resi,[1,3,4,2]);
save mm_z_dec.mat z_resi z_o z_g
