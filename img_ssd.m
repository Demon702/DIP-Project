gi=imread('./stex-512-splitted/Bush.0013.15.pnm');
%gi=imread('chains.jpg');
[x,y,z]=size(gi);
s_x=4;
s_y=4;
block_x=x/8;
block_y=y/8;
ovlp_x=3;
ovlp_y=3;
fx=x*s_x;
fy=y*s_y;
output=uint8(zeros(fx,fy,z));
slct_x=1+floor((x-block_x)*rand(1,1));
slct_y=1+floor((y-block_y)*rand(1,1));
output(1:block_x,1:block_y,:)=gi(slct_x:slct_x+block_x-1,slct_y:slct_y+block_y-1,:);

for i=1:fx/block_x
    for j=1:fy/block_y
        if i==1 && j==1
            continue;
        end
        %overlap(patchsize_x,patchsize_y, im1, im2, ovlp_x,ovlp_y,place_x,place_y)
        [ox,oy]=overlap(block_x,block_y,output,gi,ovlp_x,ovlp_y,(i-1)*block_x+1-(i-1)*ovlp_x,(j-1)*block_y+1-(j-1)*ovlp_y);
        %disp(oy);
        output((i-1)*block_x+1-(i-1)*ovlp_x:i*block_x-(i-1)*ovlp_x,(j-1)*block_y+1-(j-1)*ovlp_y:j*block_y-(j-1)*ovlp_y,:)=gi(ox:ox+block_x-1,oy:oy+block_y-1,:);
    end
end