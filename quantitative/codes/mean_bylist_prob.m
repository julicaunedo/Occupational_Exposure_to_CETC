function [ss_tp]=mean_bylist_prob(ss_tpx,list_s,ident_age,nn,occ_groups,group_id)

n_o=nn(1);occg=unique(occ_groups);

for i=1:max(numel(list_s),1)
    if isempty(list_s)==0
        if group_id==1
            aa=ident_age(i,:,:);
        elseif group_id==2
            aa=ident_age(:,i,:);
        elseif group_id==3
            aa=ident_age(:,:,i);
        end
    else
        aa=ident_age;
    end
    help1=reshape(aa,[1,numel(aa)]);
    help1_sel=ss_tpx(:,help1,:);
    help1_den=nansum(nansum(help1_sel,1),2);
    help1_den=permute(help1_den,[1,3,2]);
    if isempty(occ_groups)==1 
        ss_tp(:,:,i)=permute(nansum(help1_sel,2),[1,3,2]).*(repmat(help1_den,[n_o,1])).^(-1);
    else 
        for j=1:numel(occg)
            iik=find(occ_groups==j);
            ss_tp(j,:,i)=permute(nansum(nansum(help1_sel(iik,:,:,:),1),2),[1,3,2]).*help1_den.^(-1);
        end     
    end
end

