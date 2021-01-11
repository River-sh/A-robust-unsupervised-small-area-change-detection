function result = parallelclustering(pixel_vector1,X1,pre_center1,pixel_vector2,X2,pre_center2,bata)

[ylen, xlen] = size(X1);
options = [2.0; 200; 0.000001; 0];

[center1,U1,obj_fcn] = FCM_CC(pixel_vector1,2,options,pre_center1,bata);

flag1 = sum(sum(center1(1,:)));
flag2 = sum(sum(center1(2,:)));

if flag1 >= flag2
    U(1,:) = U1(2,:);
    U(2,:) = U1(1,:);
else
    U = U1;
end

[x,y]=size(pixel_vector1);
im1 = zeros(x,1);
im2 = zeros(x,1);
for i = 1:x
    if U(1,i)>U(2,i)
       im1(i,1) = 0;
    elseif U(1,i)<=U(2,i)
       im1(i,1) = 1;
    end
end
    im1 = reshape(im1,ylen,xlen);
    im_clust1 = im1';

clear flag1;
clear flag2;
clear U;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[center2,U2,obj_fcn] = FCM_CC(pixel_vector2,2,options,pre_center2,bata);

flag1 = sum(sum(center2(1,:)));
flag2 = sum(sum(center2(2,:)));

if flag1 >= flag2
    U(1,:) = U2(2,:);
    U(2,:) = U2(1,:);
else
    U = U2;
end
for i = 1:x
    if U(1,i)>U(2,i)
       im2(i,1) = 0;
    elseif U(1,i)<=U(2,i)
       im2(i,1) = 1;
    end
end
    im2 = reshape(im2,ylen,xlen);
    im_clust2 = im2';

% Get pseudo-labels by mean encoding    
    im_f = im_clust1+im_clust2;
    for i = 1:xlen
        for j = 1:ylen
            if im_f(i,j)==0
                result(i,j) = 0;
            elseif im_f(i,j)==1
                result(i,j) = 0.5;
            else
                result(i,j) = 1;
            end
        end
    end
end

















