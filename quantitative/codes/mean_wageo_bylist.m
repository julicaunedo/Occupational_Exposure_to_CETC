function [mm_wo_out]=mean_wageo_bylist(ss_tpx,ss_tpy,list_s,ident_age,nn,group_id)

n_o=nn(1);

if numel(list_s)>0
    for i=1:numel(list_s)
        if group_id==1
            aa=ident_age(i,:,:);
        elseif group_id==2
            aa=ident_age(:,i,:);
        elseif group_id==3
            aa=ident_age(:,:,i);
        end
        help1=reshape(aa,[1,numel(aa)]);
        ss_tpy_sel=ss_tpy(help1,:);
        ss_tpx_sel=ss_tpx(:,help1,:);
        den=nansum(ss_tpx_sel,2);
        num=ss_tpx_sel.*repmat(permute(ss_tpy_sel,[3,1,2]),[n_o,1,1]);
        num=nansum(num,2);
        mm_wo=num.*den.^(-1);
        mm_wo_out(:,:,i)=permute(mm_wo,[1,3,2]);
    end
else
    den=nansum(ss_tpx,2);
    num=ss_tpx.*repmat(permute(ss_tpy,[3,1,2]),[n_o,1,1]);
    num=nansum(num,2);mm_wo=num.*den.^(-1);
    mm_wo_out=permute(mm_wo,[1,3,2]);

end

