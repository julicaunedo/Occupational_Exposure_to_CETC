function [mm_xtilda]=corr_corner(mm_xtilda_in)

mm_xtilda=mm_xtilda_in;
mm_xtilda(mm_xtilda<0)=0;
mm_xtilda(mm_xtilda<0)=0;
mm_xtilda(imag(mm_xtilda) ~= 0) = 0;
