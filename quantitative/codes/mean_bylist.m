function [ss_tp,ss_tp_1]=mean_bylist(ss_tpx,pi,list_s,ident_age,nn,group_id)

n_o=nn(1);n_y=nn(4);

for i=1:numel(list_s)
    if group_id==1
        aa=ident_age(i,:,:);
    elseif group_id==2
        aa=ident_age(:,i,:);
    elseif group_id==3
        aa=ident_age(:,:,i);
    end
    help1=reshape(aa,[1,numel(aa)]);
    if size(ss_tpx,3)==1 
        help1_sel=ss_tpx(help1,:);
        help1_w=pi(help1,:);
        ss_tp(i,:)=nanmean(help1_sel,1)';
        ss_tp_1(i,:)=nansum(help1_sel.*help1_w,1)'.*(nansum(help1_w,1)').^(-1);
    else
        help1_sel=ss_tpx(:,help1,:);
        help1_w=pi(:,help1,:);
        ss_tp(i,:)=reshape(nanmean(nanmean(help1_sel,1),2),1,n_y);
        help2=help1_sel.*help1_w.*(repmat(nansum(nansum(help1_w,1),2),[n_o,numel(help1),1])).^(-1);
        ss_tp_1(i,:)=reshape(nansum(nansum(help2,1),2),1,n_y);
    end
end

