function [center,U,obj_fcn] = prefcm(data_vector,im_di)
%PREFCM 此处显示有关此函数的摘要
%   此处显示详细说明
k = 1;
[x,y] = size(im_di);

options = [2.0; 100; 1e-6; 0];

for i = 1:x
    for j = 1:y
        imdi_vector(k,1) = im_di(i,j);
        k = k+1;
    end
end
[vector_value,vector_index] = sort(imdi_vector,1,'descend');
for i = 1:x*y
    new_vector(i,:) = data_vector(vector_index(i,1),:);
end
    change_point = new_vector(1:200,:);
    unchange_point = new_vector((x*y)-199:(x*y),:);
    for i = 1:200
        new_data(i,:) =  change_point(i,:);
        new_data(200+i,:) = unchange_point(i,:);
    end
    
    [center,U,obj_fcn] = fcm(new_data,2, options);
    
end

