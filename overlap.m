function [ans_x, ans_y] = overlap(patchsize_x,patchsize_y, im1, im2, ovlp_x,ovlp_y,place_x,place_y)

%% Definitions
% im1 : old patch (already placed in bigger frame)
% im2 : sample texture available
% ovlp : no. of rows/columns to be overlapped
% vert : = 1 if overlap is vertical, 0 if horizontal
% cutoff : error cutoff
% patchsize : size of patch to be taken from im2

 %patchsize_x = 3;
 %patchsize_y = 3;
 %ovlp_x = 2;
 %ovlp_y = 2;
 %cutoff = 0.5;
 %vert = 1;
 %place_x = 10;
 %place_y = 10;

 %im1 = [9 2 3;13 6 7; 8 10 11];
 %im2 = [1 2 3 4; 5 6 7 8; 9 10 11 12];

[im1_x, im1_y,~] = size(im1);
[im2_x, im2_y,~] = size(im2);

%display(im1_x);
%disp(im1_y);
%disp(patchsize_x);
%disp(patchsize_y);
%disp('oola');
 total_possible_patch_coord = floor(0.1*(im2_x-patchsize_x+1)*(im2_y-patchsize_y+1));
%disp(total_possible_patch_coord);
 ssdarray =  zeros(2,total_possible_patch_coord);

 rand_x = 1+floor((im2_x-patchsize_x)*rand(1,total_possible_patch_coord));
 rand_y = 1+floor((im2_y-patchsize_y)*rand(1,total_possible_patch_coord));

pov_x=max(1,place_x-ovlp_x);
pov_y=max(1,place_y-ovlp_y);

if place_x == 1
    ov_patch_1 = im1(1:patchsize_x,pov_y:place_y-1,:);

    for i = 1:total_possible_patch_coord

    pi=im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:);

    ov_patch_2 = pi(1:patchsize_x,1:ovlp_y,:);

    diff = ov_patch_1 - ov_patch_2;

    ssdarray(1,i) = sum(sum(sum(diff.^2)));
    ssdarray(2,i) = i;
    end



elseif place_y == 1

   ov_patch_1 = im1(pov_x:place_x-1,1:patchsize_y, :);

    for i = 1:total_possible_patch_coord

    pi=im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:);

    ov_patch_2 = pi(1:ovlp_x,1:patchsize_y,:);

    diff = ov_patch_1 - ov_patch_2;

    ssdarray(1,i) = sum(sum(sum((diff.^2))));
    ssdarray(2,i) = i;

    end



else

    ov_patch_1x = im1(pov_x:patchsize_x+pov_x-1,pov_y:place_y-1,:);
    ov_patch_1y = im1(pov_x:place_x-1,place_y:patchsize_y+pov_y-1,:);

    for i = 1:total_possible_patch_coord

    pi=im2(rand_x(i):rand_x(i)+patchsize_x-1,rand_y(i):rand_y(i)+patchsize_y-1,:);

    ov_patch_2x = pi(1:patchsize_x,1:ovlp_y,:);
    ov_patch_2y = pi(1:ovlp_x, ovlp_y+1:patchsize_y,:);

    diff_x = (ov_patch_1x - ov_patch_2x);
    diff_y = (ov_patch_1y - ov_patch_2y);
    ssdarray(1,i) = sum(sum(sum(diff_x.^2))) + sum(sum(sum(diff_y.^2)));
    ssdarray(2,i) = i;

    end

end

[min_val,~]=min(ssdarray(1,:));
kmin_vals=find(ssdarray(1,:)<1.1*min_val);
%[~,ind]=mink(ssdarray,round(0.1*total_possible_patch_coord));
[s,~]=size(kmin_vals);
%r_ind=ind(1+floor(rand(1,1)*round(0.1*total_possible_patch_coord-1)));
r_ind=kmin_vals(1+floor(rand(1,1)*(s-1)));
ans_x=rand_x(r_ind);
ans_y=rand_y(r_ind);
end