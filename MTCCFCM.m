clear all;
clc;
close all;

addpath('./Utils');
addpath('./cwnn');
addpath('./DI');
addpath('./Clustering');

PatSize = 7;
SamSize = 28;
f_size = 3;
w = 4;
b = 0;
bata = 0.5;

%% read image
fprintf(' ... ... read image file ... .. ... ....\n');
im1   = imread('1_1.tif');
im2   = imread('1_2.tif');
im_gt = imread('1_3.tif');
fprintf(' ... ... read image file finished !!! !!!\n\n');

im1 = double(im1(:,:,1));
im2 = double(im2(:,:,1));
im_gt = double(im_gt(:,:,1));
[ylen, xlen] = size(im1);

%% Compute the log-ratio difference image
fprintf('... ... compute the deep difference image ... ...\n');
im1 = WP(im1,f_size);
im2 = WP(im2,f_size);
DI =di_gen(im1,im2);   
SLRDI = Normalized(WP(DI,3),3); 

%% Compute the MSRDI
Parameters(1,1) = 100;
Parameters(2,1) = 500;
Parameters(3,1) = 1000;
Parameters(4,1) = 2000;
MSRDI = MSRDI(SLRDI,Parameters);
DIMAP = sigmoid(Normalized(MSRDI,10),w,b);
%% Gabor feature extraction
fprintf('... ... feature extraction... ...\n');
[f_all,fea] = Gabor_fea(DIMAP,6);
%% Clustering
[pre_center,U1,obj_fcn1] = prefcm(fea,DIMAP);
[im_lab,obj_fcn] = clf_FCMCC(fea,DIMAP,pre_center,bata);

nos_th = 30;
[res_lab,num] = bwlabel(~im_lab);
for i = 1:num
    idx = find(res_lab==i);
    if numel(idx) <= nos_th
        res_lab(idx)=0;
    end
end
res_lab = res_lab>0;

[res_lab,num] = bwlabel(im_lab);
for i = 1:num
    idx = find(res_lab==i);
    if numel(idx) <= nos_th
        res_lab(idx)=0;
    end
end

res_lab = res_lab>0;
lab_pre = res_lab > 0;
res = uint8(lab_pre)*255;
pic = res;

%% === output the results ==============
[TN,TP,FN,FP,FA,MD,OER,PCC,Kappa,F1] = PE(res,im_gt);
list = [TN,TP,FN,FP,FA,MD,OER,PCC,Kappa,F1];
imshow(pic);
% imwrite(pic, 'changemap.png');
% save('result.mat','list');
