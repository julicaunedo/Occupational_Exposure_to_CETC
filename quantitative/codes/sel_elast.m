load sigma.mat 
temph=numel(est_iv);
if ii_cdsd==0
    elast_s_in=est_iv;    
elseif ii_cdsd==1
    elast_s_in=aggregate_elast*ones(temph,1); 
end
save elast_for_model.mat elast_s_in 