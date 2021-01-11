function [trn_pat,trn_lab,tst_pat,tst_idx] = generation(im1,im2,im_lab,PatSize,SamSize,gen_sample_neg,Num)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
fprintf(' ... ... ... samples initializaton begin ... ... .....\n');
fprintf(' ... ... ... Patch Size : %d pixels ... ....\n', PatSize);


pos_idx = find(im_lab == 1);
neg_idx = find(im_lab == 0);
tst_idx = find(im_lab == 0.5);


rand('seed', 10);
pos_idx = pos_idx(randperm(numel(pos_idx)));
neg_idx = neg_idx(randperm(numel(neg_idx)));

[ylen, xlen] = size(im1);

% normalization
im1 = Normalized(im1,2);
im2 = Normalized(im2,2);


mag = (PatSize-1)/2;
imTmp = zeros(ylen+PatSize-1, xlen+PatSize-1);
imTmp((mag+1):end-mag,(mag+1):end-mag) = im1; 
im1 = im2col_general(imTmp, [PatSize, PatSize]);
imTmp((mag+1):end-mag,(mag+1):end-mag) = im2; 
im2 = im2col_general(imTmp, [PatSize, PatSize]);
clear imTmp mag;


im = zeros(SamSize, SamSize, ylen*xlen);

parfor idx = 1 : size(im1, 2)
    imtmp1 = reshape(im1(:, idx), [PatSize, PatSize]);
    imtmp2 = reshape(im2(:, idx), [PatSize, PatSize]);
    
    imtmp1 = imresize(imtmp1, [SamSize/2, SamSize], 'bilinear');
    imtmp2 = imresize(imtmp2, [SamSize/2, SamSize], 'bilinear');
    
    im(:,:,idx) = [imtmp1; imtmp2];
end
clear im1 im2 idx imtmp1 imtmp2;


sam_num = Num*2;
pos_num = Num;
neg_num = sam_num - pos_num;
realneg_num = length(neg_idx);

if realneg_num > (Num/2)
   realneg_num = Num/2;
end
fakeneg_num = neg_num - realneg_num;


%Sample classification and segmentation
for num_neg = 1:numel(neg_idx)
    neg_sample(:,:,num_neg) = im(:,:,neg_idx(num_neg));
end

for num_pos = 1:numel(pos_idx)
    pos_sample(:,:,num_pos) = im(:,:,pos_idx(num_pos));
end

% =================================
% --- prepare the traninng data ---
trn_pat = zeros(SamSize, SamSize, sam_num);
trn_lab = zeros(2, sam_num);
trn_lab(1, 1:neg_num) = 1;
trn_lab(2, 1+neg_num:sam_num) = 1;



for i = 1:realneg_num
    trn_pat(:,:,i) = neg_sample(:,:,i);    
end
for i = 1:fakeneg_num
    trn_pat(:,:,realneg_num+i) = gen_sample_neg(:,:,i);    
end


for i = 1:pos_num
    trn_pat(:,:,i+neg_num) = pos_sample(:,:,i);
end
clear idx1 idx2 i ratio;

% ==================================
% --- prepare the testing data -----
tst_pat = zeros(SamSize, SamSize, numel(tst_idx));
for i = 1 : numel(tst_idx)
  tst_pat(:,:,i) = im(:,:, tst_idx(i));
end

end

