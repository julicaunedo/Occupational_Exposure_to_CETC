%% Loading
load data_main_yby.mat
load model_calib.mat

%% Model variables in the regression
o_b=bb(1);n_o=nn(1);n_y=nn(4);
mm_lambda_o=permute(mm_lambda_o,[1,3,2]);
mm_lambda_o_r=mm_lambda_o.*(repmat(mm_lambda_o(o_b,:),[n_o,1])).^(-1);
mm_yo_val=permute(mm_yo_val,[1,3,2]);
mm_yo_val_r=mm_yo_val.*(repmat(mm_yo_val(o_b,:),[n_o,1])).^(-1);
dd_lambda_j_occ_s_t=instrument_lev;
dd_lambda_j_occ_s_t=dd_lambda_j_occ_s_t.*(repmat(dd_lambda_j_occ_s_t(o_b,:,:),[n_o,1,1])).^(-1);
n_o=n_o-1;
%%Instrument
est_rel_p=log(mm_lambda_o_r);est_rel_p(o_b,:)=[];
est_rel_y=log(mm_yo_val_r);est_rel_y(o_b,:)=[];
inst_pk_1980=log(dd_lambda_j_occ_s_t);inst_pk_1980(o_b,:,:)=[];
%%Dummies
occ_index=[1:1:n_o]';
y_index=[1:1:n_y];
y_dummy=repmat(y_index,[n_o,1])+1984;
aa=dummyvar(occ_index);
for i=1:n_o
    comb_dummy(:,:,i)=repmat(aa(:,i),[1,n_y]).*y_dummy;
end
%%Reshape the regression variables
est_rel_p_in=reshape(est_rel_p,[numel(est_rel_p),1]);
est_rel_y_in=reshape(est_rel_y,[numel(est_rel_y),1]);
inst_pk_1980_in=reshape(inst_pk_1980,[numel(inst_pk_1980),1]);
for i=1:n_o
    temp=comb_dummy(:,:,i);
    temp_in=reshape(temp,[numel(temp),1]);
    comb_dummy_in(:,i)=temp_in;
end

%% Estimation
%%OLS
i=1;
xx_in=[est_rel_p_in,ones(size(est_rel_p_in,1),1),comb_dummy_in];yy_in=est_rel_y_in;
A=[xx_in];B=yy_in;w=ones(size(A,1),1);
[temp,temp_stdx,mse,S] = lscov(A,B);
est(1,i)=temp(1);est_se(1,i)=temp_stdx(1);
rho_est(1,i)=1-est(i);
%%IV
i=i+1;
%first stage
xx_in=[inst_pk_1980_in,ones(size(est_rel_p_in,1),1),comb_dummy_in];yy_in=est_rel_p_in;
A=[xx_in];B=yy_in;w=ones(size(A,1),1);
mdl = fitlm(A,B,'Intercept',false);
ypred = predict(mdl,A);
FS_rs(1,i)=mdl.Rsquared.Adjusted;
FS_est_se(1,i)=mdl.Coefficients.pValue(1);
FS_est(1,i)=mdl.Coefficients.Estimate(1);
%second stage
xx_in=[ypred,comb_dummy_in,ones(size(est_rel_p_in))];yy_in=est_rel_y_in;
A=[xx_in];B=yy_in;w=ones(size(A,1),1);
[temp,temp_stdx] = lscov(A,B);
est(1,i)=temp(1);est_se(1,i)=temp_stdx(1);
rho_est(1,i)=1-est(i);

%% Outcome
disp('********* Estimation of rho: *****************')
disp(strcat('OLS: ',num2str(rho_est(1)),' ','(',num2str(est_se(1)),')')   )
disp(strcat('IV: ',num2str(rho_est(2)),' ','(',num2str(est_se(2)),')')   )



