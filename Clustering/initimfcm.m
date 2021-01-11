function U = initimfcm(pre_center,data)
%INITFCM 此处显示有关此函数的摘要
%   此处显示详细说明
% 初始化fcm的隶属度函数矩阵
% 输入:
%   cluster_n   ---- 聚类中心个数
%   data_n      ---- 样本点数
% 输出：
%   U           ---- 初始化的隶属度矩阵
k1 = 1;
k2 = 1;
[x,y] = size(data)
U = zeros(2,x);
for i = 1:x
    point = data(i,:);
    d1 = sqrt(sum(sum((point-pre_center(1,:)).^2)));
    d2 = sqrt(sum(sum((point-pre_center(2,:)).^2)));
    if d1<d2
        U(1,i) = d2/(d1+d2);
        U(2,i) = d1/(d1+d2);
        k1 = k1 + 1;
    elseif d2<=d1
        U(1,i) = d2/(d1+d2);
        U(2,i) = d1/(d1+d2);
        k2 = k2 + 1;
    end
end

end

