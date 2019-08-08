function [seam_arr] = horizontalseamhelper(ov_patch_1, ov_patch_2)
[ovlp_x,block_y,~] = size(ov_patch_1);
enrgy_ind =zeros(ovlp_x,block_y);
energy_mat = sum((double(ov_patch_1) - double(ov_patch_2)).^2,3);
    for i=2:block_y
        for j=1:ovlp_x
            %display(i)
            %display(j)
            left=max(1,j-1);
            right=min(ovlp_x,j+1);
            [sml , enrgy_ind(j,i)]=min(energy_mat(left:right,i-1));
            %display(enrgy_ind(i,j));
            %display(left);
            enrgy_ind(j,i)=left-1+enrgy_ind(j,i);
            energy_mat(j,i)=energy_mat(j,i)+sml;
        end
    end
    [~, last_ind]=min(energy_mat(:,block_y));
seam_arr=zeros(block_y,1);
seam_arr(block_y)=last_ind;
for i=block_y-1:-1:1
    %disp(seam_arr(i+1));
    %disp(enrgy_ind(seam_arr(i+1),i+1));
    seam_arr(i)=enrgy_ind(seam_arr(i+1),i+1);
end
end