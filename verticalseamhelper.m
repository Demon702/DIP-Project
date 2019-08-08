function [seam_arr] = verticalseamhelper(ov_patch_1, ov_patch_2)
[x,y,~] = size(ov_patch_1);
enrgy_ind =zeros(x,y);
energy_mat = sum((double(ov_patch_1) - double(ov_patch_2)).^2,3);
for i = 2:x
    for j = 1:y
        left=max(1,j-1);
        right=min(y,j+1);
        [sml , enrgy_ind(i,j)]=min(energy_mat(i-1,left:right));
        enrgy_ind(i,j)=left-1+enrgy_ind(i,j);
        energy_mat(i,j)=energy_mat(i,j)+sml;
        
    end
end

[~, last_ind]=min(energy_mat(x,:));
seam_arr=zeros(x,1);
seam_arr(x)=last_ind;
for i=x-1:-1:1
    %disp(seam_arr(i+1));
    %disp(enrgy_ind(seam_arr(i+1),i+1));
    seam_arr(i)=enrgy_ind(i+1,seam_arr(i+1));
end
end