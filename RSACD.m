
clear;
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
Num = 2000;
bata = 0.5;

%%        read images
fprintf(' ... ... read image file ... .. ... ....\n');
im1   = imread('1_1.tif');
im2   = imread('1_2.tif');
im_gt = imread('1_3.tif');
sam_neg = load('Data_DCGAN.mat');
gen_sample_neg = sam_neg.I;
fprintf(' ... ... read image file finished !!! !!!\n\n');
im1 = double(im1(:,:,1));
im2 = double(im2(:,:,1));
im_gt = double(im_gt(:,:,1));
[ylen, xlen] = size(im1);

%% Compute the log-ratio image
fprintf('... ... compute the deep difference image ... ...\n');
im1 = WP(im1,f_size);
im2 = WP(im2,f_size);
LRDI = di_gen(im1,im2); 

%% Compute the filtered log-ratio image
SLRDI = Normalized(WP(LRDI,3),3);  

%% Compute the MSRDI
Parameters(1,1) = 100;
Parameters(2,1) = 500;
Parameters(3,1) = 1000;
Parameters(4,1) = 2000;
MSRDI = MSRDI(SLRDI,Parameters);
%% Computing mapped MSRDI
[DDIMAP1,DDIMAP2]=DDIMAP(MSRDI,w,b);    
%% Gabor feature extraction
fprintf('... ... feature extraction... ...\n');
[f1_all,fea_1] = Gabor_fea(DDIMAP1,6);
[f2_all,fea_2] = Gabor_fea(DDIMAP2,6);
%% Parallel TCCFCM clustering
fprintf('... ... parallelclustering begin ... ...\n');
[pre_center1,U1,obj_fcn1] = prefcm(fea_1,DDIMAP1);
[pre_center2,U2,obj_fcn2] = prefcm(fea_2,DDIMAP2);
im_lab = parallelclustering(fea_1,DDIMAP1,pre_center1,fea_2,DDIMAP2,pre_center2,bata);
clear f1_all fea_1 f2_all fea_2;
% Clustering results are saved in im_lab
% Changed pixels as 1
% Unchanged pixels is marked as 0
fprintf('@@@ @@@ clustering finished @@@@\n');
im_lab = 1-im_lab;
clear pixel_vector im_di;

%% generating samples
[trn_pat,trn_lab,tst_pat,tst_idx] = generation(im1,im2,im_lab,PatSize,SamSize,gen_sample_neg, Num);
%% CWNN
rand('seed', 10);

cwnn.layers = {
    struct('type', 'i') 
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) 
    struct('type', 's', 'scale', 2)
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) 
    struct('type', 's', 'scale', 2) 
    struct('type', 'c', 'outputmaps', 96, 'kernelsize', 4)
};

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 25;

fprintf(' ... ... ... CWNN SETUP ... ... ...\n');
cwnn = cnnsetup(cwnn, trn_pat, trn_lab);
fprintf(' ... ... ... CWNN TRAIN ... ... ...\n');
cwnn = cnntrain(cwnn, trn_pat, trn_lab, opts);


fprintf('\n ... ... ... CWNN TEST  ... ... ...\n');
cwnn = cnnff(cwnn, tst_pat);

% === prepare the testing result =====
res_lab = im_lab;
tst_res = zeros(numel(tst_idx), 1);
for i = 1: numel(tst_idx)
  if cwnn.o(1,i) > cwnn.o(2,i)
    tst_res(i) = 0;
  else
    tst_res(i) = 1;
  end
end
% ====================================

res_lab(tst_idx) = tst_res';

% === refine the results =============
nos_th = 30;
[res_lab,num] = bwlabel(res_lab);
for i = 1:num
    idx = find(res_lab==i);
    if numel(idx) <= nos_th
        res_lab(idx)=0;
    end
end
res_lab = res_lab>0;

[res_lab,num] = bwlabel(~res_lab);
for i = 1:num
    idx = find(res_lab==i);
    if numel(idx) <= nos_th
        res_lab(idx)=0;
    end
end
res_lab = res_lab>0;

%% === output the results ==============
lab_pre = res_lab > 0;
res = uint8(lab_pre)*255;
pic = res;
[TN,TP,FN,FP,FA,MD,OER,PCC,Kappa,F1] = PE(res,im_gt);
list = [TN,TP,FN,FP,FA,MD,OER,PCC,Kappa,F1];
imwrite(pic, 'changemap.png');
save('result.mat','list');





