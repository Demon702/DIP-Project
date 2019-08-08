function [ans_x, ans_y] = parallel_overlap(alpha,firstrun,patchsize_x,patchsize_y, im1, im2,previousimage,targetimage,ovlp_x,ovlp_y,place_x,place_y)
% [im1_x, im1_y,~] = size(im1);
[im2_x, im2_y,~] = size(im2);

%display(im1_x);
%disp(im1_y);
%disp(patchsize_x);
%disp(patchsize_y);
%disp('oola');
 total_possible_patch_coord = floor(0.1*(im2_x-patchsize_x+1)*(im2_y-patchsize_y+1));
%disp(total_possible_patch_coord);
 ssdarray =  zeros(total_possible_patch_coord,1);



 rand_xy = 1+floor(([im2_x-patchsize_x;im2_y-patchsize_y].*rand(2,total_possible_patch_coord));

pov_x=max(1,place_x-ovlp_x);
pov_y=max(1,place_y-ovlp_y);
prev_patch = double(previousimage(pov_x:pov_x + patchsize_x - 1,pov_y:pov_y+patchsize_y-1,:));
target_patch = double(targetimage(pov_x:pov_x + patchsize_x - 1,pov_y:pov_y+patchsize_y-1,:));
allpatches = zeros(patchsize_x,patchsize_y, 3,total_possible_patch_coord);

if place_x == 1
    ov_patch_1 = double(im1(1:patchsize_x,pov_y:place_y-1,:));

    for i = 1:total_possible_patch_coord

    % pi=double(im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:));

    % ov_patch_2 = double(pi(1:patchsize_x,1:ovlp_y,:));

    % diff1 = ov_patch_1 - ov_patch_2;
    % diff2 = prev_patch - pi;
    % diff3 = double(target_patch) - double(pi);

    % ssdarray(i) = alpha*(sum(sum(sum(diff1.^2))) + firstrun*sum(sum(sum(diff2.^2)))) + (1 - alpha)*sum(sum(sum(diff3.^2)));
    allpatches(:,:,:,i) = im2(rand_xy(1,i):rand_xy(1,i) + patchsize_x - 1, rand_xy(2,i):rand_xy(2,i) + patchsize_y - 1,: );

    end



elseif place_y == 1

   ov_patch_1 = double(im1(pov_x:place_x-1,1:patchsize_y, :));

    for i = 1:total_possible_patch_coord

    pi=double(im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:));

    ov_patch_2 = double(pi(1:ovlp_x,1:patchsize_y,:));

    diff1 = ov_patch_1 - ov_patch_2;
    diff2 = prev_patch - pi;
    diff3 = double(target_patch) - double(pi);

    ssdarray(i) = alpha*(sum(sum(sum(diff1.^2))) + firstrun*sum(sum(sum(diff2.^2)))) + (1 - alpha)*sum(sum(sum(diff3.^2)));

    end



else

    ov_patch_1x = double(im1(pov_x:patchsize_x+pov_x-1,pov_y:place_y-1,:));
    %prev_patch_x = previousimage(pov_x:patchsize_x+pov_x-1,pov_y:place_y-1,:);
    %target_patch_x = targetimage(pov_x:patchsize_x+pov_x-1,pov_y:place_y-1,:);


    ov_patch_1y = double(im1(pov_x:place_x-1,place_y:patchsize_y+pov_y-1,:));
    %prev_patch_y = previousimage(pov_x:place_x-1,place_y:patchsize_y+pov_y-1,:);
    %target_patch_y = targetimage(pov_x:place_x-1,place_y:patchsize_y+pov_y-1,:);

    for i = 1:total_possible_patch_coord

    pi=double(im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:));

    ov_patch_2x = double(pi(1:patchsize_x,1:ovlp_y,:));
    ov_patch_2y = double(pi(1:ovlp_x, ovlp_y+1:patchsize_y,:));

    diff1_x = (ov_patch_1x - ov_patch_2x);
    diff1_y = (ov_patch_1y - ov_patch_2y);

    diff2 = (prev_patch - pi);
    diff3 = (double(target_patch) - double(pi));

    ssdarray(i) = alpha*(sum(sum(sum(diff1_x.^2))) + sum(sum(sum(diff1_y.^2))) + firstrun*sum(sum(sum(diff2.^2)))) + (1 - alpha)*sum(sum(sum(diff3.^2)));

    end

end
[min_val,~]=min(ssdarray);
kmin_vals=find(ssdarray<=1.1*min_val);
%[~,ind]=mink(ssdarray,round(0.1*total_possible_patch_coord));
[s,~]=size(kmin_vals);
%r_ind=ind(1+floor(rand(1,1)*round(0.1*total_possible_patch_coord-1)));
r_ind=kmin_vals(1+floor(rand1(,1)*(s-1)));
ans_x=rand_x(r_ind);
ans_y=rand_y(r_ind);
end



