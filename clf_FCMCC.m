function [im_lab,obj_fcn] = clf_FCMCC(fea,DIMAP,pre_center,bata)
options = [2.0; 100; 0.00001; 0];
[ylen, xlen] = size(DIMAP);
[center1,U1,obj_fcn] = FCM_CC(fea,2,options,pre_center,bata);
flag1 = sum(sum(center1(1,:)));
flag2 = sum(sum(center1(2,:)));

if flag1 >= flag2
    U(1,:) = U1(2,:);
    U(2,:) = U1(1,:);
else
    U = U1;
end

[x,y]=size(fea);
im1 = zeros(x,1);
for i = 1:x
    if U(1,i)>U(2,i)
       im1(i,1) = 0;
    elseif U(1,i)<=U(2,i)
       im1(i,1) = 1;
    end
end
    im1 = reshape(im1,ylen,xlen);
    im_lab = im1';
end

