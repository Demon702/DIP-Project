gi=imread('fabric.jpeg');
%gi=imread('chains.jpg');
targetimage = imread('girl.jpg');
[x,y,z]=size(gi);
[target_x,target_y,~]=size(targetimage);


fx=target_x;
fy=target_y;
block_x=floor(x/4);
block_y=floor(y/4);
ovlp_x=ceil(block_x/6);
ovlp_y=ceil(block_y/6);
iterations = 5;
output=uint8(zeros(fx,fy,z));
previousimage = zeros(2*fx,2*fy,z);
slct_x=1+floor((x-block_x)*rand(1,1));
slct_y=1+floor((y-block_y)*rand(1,1));
firstrun = 0;
output(1:block_x,1:block_y,:)=gi(slct_x:slct_x+block_x-1,slct_y:slct_y+block_y-1,:);
for k = 1 : iterations
    alpha = 0.8*(k-1)/(iterations - 1)+0.1;
    if k==1
        firstrun= 0;
    else
        firstrun = 1;
    end
for i=1:(fx + block_x - 2*ovlp_x)/(block_x - ovlp_x)
    place_x=(i-1)*block_x+1-max((i-2),0)*ovlp_x;
    pov_x=max(1,place_x-ovlp_x);
    block_x1 = min(block_x, fx - pov_x +1);
    for j=1:(fy+ block_y - 2*ovlp_y)/(block_y -ovlp_y)
        if i==1 && j==1
           [ox,oy]=firstfinder(alpha,firstrun,block_x,block_y,gi,previousimage, targetimage); 
            output(1:block_x,1:block_y,:) = gi(ox:ox+block_x-1,oy:oy+block_y-1,:);
            continue;
        end
        
        
        place_y=(j-1)*block_y+1-max((j-2),0)*ovlp_y;
        pov_y=max(1,place_y-ovlp_y);
        block_y1 = min(block_y, fy - pov_y +1);
        %overlap(patchsize_x,patchsize_y, im1, im2, ovlp_x,ovlp_y,place_x,place_y)
        [ox,oy]=overlaptransfer(firstrun,alpha,block_x1,block_y1,output,gi,previousimage, targetimage, ovlp_x,ovlp_y,place_x,place_y);
        im2=gi(ox:ox+block_x1-1,oy:oy+block_y1-1,:);
        [seam_arr1, seam_arr2]=make_seam(block_x1,block_y1,output,im2,ovlp_x,ovlp_y,place_x,place_y);
        [a,~]=size(seam_arr1);
        [b,~]= size(seam_arr2);
        if a~=0
            seam_arr1_real=seam_arr1+pov_x-1;
            for l = 1:block_y1
                im2(1:seam_arr1(l),l,:)=output(pov_x:seam_arr1_real(l), pov_y+ l- 1,:);
            end
        end
        
        if b~=0
            seam_arr2_real = seam_arr2 + pov_y - 1;
            for l = 1:block_x1
                im2(l,1: seam_arr2(l),:)=output(pov_x + l- 1,pov_y: seam_arr2_real(l),:);
            end
        end
        output(pov_x : pov_x + block_x1 -1 ,pov_y : pov_y + block_y1 - 1,:) = im2;
%         output=permute(output,[2 1 3 ]);
%         im2=permute(im2,[ 2 1 3]);
%         [seam_arr]=make_seam(block_x,output,im2,ovlp_y,ovlp_x,place_y,place_x);
%         [a,b]=size(seam_arr);
%         if a~=0
%             seam_arr_real=seam_arr+pov_y-1;
%             for l = 1:block_y
%                 output(seam_arr_real(l):pov_y+block_y-1,pov_x + l -1,:)=im2(seam_arr(l):block_y, l,:);
%             end
%         end
%         output=permute(output,[2 1 3]);
    end
    
end
block_x = floor(block_x/2);
block_y = floor(block_y/2);
ovlp_x = ceil(block_x/6);
ovlp_y = ceil(block_y/6);

previousimage = output;
end