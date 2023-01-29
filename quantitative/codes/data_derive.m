
for j=1:size(c_years,2)
    %%number of individuals
    aa=rdata_census_age.(y_list{j})(:,:,30); 
    tot_n(j)=nansum(aa(:));
    %%occupational distribution
    ss_h=nansum(rdata_census_age.(y_list{j})(:,:,30),1);
    ss_o=nansum(rdata_census_age.(y_list{j})(:,:,30),2);    
    pi_o_gh(:,:,j)=rdata_census_age.(y_list{j})(:,:,30).*(repmat(ss_h,[numel(list_o),1])).^(-1); 
    pi_h_go(:,:,j)=rdata_census_age.(y_list{j})(:,:,30).*(repmat(ss_o,[1,numel(ss_h)])).^(-1);     
    pi_h(:,j)=ss_h'.*(sum(ss_h)).^(-1);
    pi_j(:,j)=ss_o.*(sum(ss_o)).^(-1);    
    ss_w=rdata_census_age.(y_list{j})(:,:,30);
    tot_w_ohj(:,:,:,j)=ss_w;
    ss_k=rdata_census_age.(y_list{j})(:,:,31:54); 
    ss_k_go=repmat(nansum(ss_k,3),[1,1,size(ss_k,3)]);
    pj_goh(:,:,:,j)=ss_k.*ss_k_go.^(-1);
    pi_oj_gh(:,:,:,j)=permute(pj_goh(:,:,:,j),[1,3,2]).*permute(pi_o_gh(:,:,j),[1,3,2]);
    %%capital
    tot_k_ohj(:,:,:,j)=rdata_census_age.(y_list{j})(:,:,31:54);
    tot_k_h(:,j)=nansum(nansum(tot_k_ohj(:,:,:,j),1),3)';
    tot_k_o(:,j)=nansum(nansum(tot_k_ohj(:,:,:,j),2),3);
    %%wages
    wa_oh(:,:,j)=rdata_census_age.(y_list{j})(:,:,29);
    wa_o(:,j)=nansum(wa_oh(:,:,j).*pi_h_go(:,:,j),2);
    wa_h(:,j)=nansum(wa_oh(:,:,j).*pi_o_gh(:,:,j),1);
end




