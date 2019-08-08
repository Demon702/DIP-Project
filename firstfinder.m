function [ans_x, ans_y] = firstfinder(alpha,firstrun,patchsize_x,patchsize_y, im2,previousimage,targetimage)
[im2_x, im2_y,~] = size(im2);
total_possible_patch_coord = floor((im2_x-patchsize_x+1)*(im2_y-patchsize_y+1));
ssdarray =  zeros(total_possible_patch_coord,1);
rand_x = 1+floor((im2_x-patchsize_x)*rand(1,total_possible_patch_coord));
rand_y = 1+floor((im2_y-patchsize_y)*rand(1,total_possible_patch_coord));

prev_patch = double(previousimage(1:patchsize_x ,1:patchsize_y,:));
target_patch = double(targetimage(1:patchsize_x,1:patchsize_y,:));

for i = 1:total_possible_patch_coord

    pi=double(im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:));

    diff2 = prev_patch - pi;
    diff3 = target_patch - pi;

    ssdarray(i) = alpha*firstrun*sum(sum(sum(diff2.^2))) + (1 - alpha)*sum(sum(sum(diff3.^2)));
end

[min_val,k]=min(ssdarray);
% kmin_vals=find(ssdarray<1.05*min_val);
% %[~,ind]=mink(ssdarray,round(0.1*total_possible_patch_coord));
% [s,~]=size(kmin_vals);
% %r_ind=ind(1+floor(rand(1,1)*round(0.1*total_possible_patch_coord-1)));
% r_ind=1+floor(rand(1,1)*(s-1));
ans_x=rand_x(k);
ans_y=rand_y(k);
end
% [im1_x, im1_y,~] = size(im1);