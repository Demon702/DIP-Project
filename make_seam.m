
function [seam_arr1, seam_arr2]=make_seam(block_x,block_y,im1,im2,ovlp_x,ovlp_y,place_x,place_y)
pov_x=max(1,place_x-ovlp_x);
pov_y=max(1,place_y-ovlp_y);
if place_y == 1 && place_x == 1
    seam_arr1 = [];
    seam_arr2 = [];
elseif place_y==1 && place_x~=1
    ov_patch_1 = im1(pov_x:place_x-1,1:block_y,:);
    ov_patch_2 = im2(1:ovlp_x ,1:block_y,:);
    seam_arr1 = horizontalseamhelper(ov_patch_1, ov_patch_2);
    seam_arr2 = [];
elseif place_y~=1 && place_x==1 
    ov_patch_3 = im1(1:block_x,pov_y:place_y - 1,:);
    ov_patch_4 = im2(1:block_x ,1:ovlp_y,:);
    seam_arr1 = [];
    seam_arr2 = verticalseamhelper(ov_patch_3, ov_patch_4);
else 
    ov_patch_1 = im1(pov_x:place_x-1,pov_y:pov_y + block_y - 1,:);
    ov_patch_2 = im2(1:ovlp_x,1 : block_y,:);
    ov_patch_3 = im1(pov_x:pov_x + block_x - 1,pov_y:place_y - 1,:);
    ov_patch_4 = im2(1:block_x ,1:ovlp_y,:);
    seam_arr1 = horizontalseamhelper(ov_patch_1, ov_patch_2);
    seam_arr2 = verticalseamhelper(ov_patch_3, ov_patch_4);

end

end
    