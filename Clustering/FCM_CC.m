function [center,U,obj_fcn] = FCM_CC(data,cluster_n,options,pre_center,bata)
%FCM_SH �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%
% �÷���
%   1.  [center,U,obj_fcn] = FCMClust(Data,N_cluster,options);
%   2.  [center,U,obj_fcn] = FCMClust(Data,N_cluster);
%  
% ���룺
%   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ
%   N_cluster   ---- ����,��ʾ�ۺ�������Ŀ,�������
%   options     ---- 4x1��������
%       options(1):  �����Ⱦ���U��ָ����>1                  (ȱʡֵ: 2.0)
%       options(2):  ����������                           (ȱʡֵ: 100)
%       options(3):  ��������С�仯��,������ֹ����           (ȱʡֵ: 1e-5)
%       options(4):  ÿ�ε����Ƿ������Ϣ��־                (ȱʡֵ: 1)
% �����
%   center      ---- ��������
%   U           ---- �����Ⱦ���
%   obj_fcn     ---- Ŀ�꺯��ֵ
%   Example:
%       data = rand(100,2);
%       [center,U,obj_fcn] = FCMClust(data,2);
%       plot(data(:,1), data(:,2),'o');
%       hold on;
%       maxU = max(U);
%       index1 = find(U(1,:) == maxU);
%       index2 = find(U(2,:) == maxU);
%       line(data(index1,1),data(index1,2),'marker','*','color','g');
%       line(data(index2,1),data(index2,2),'marker','*','color','r');
%       plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
%       hold off;

global plot_center1;

if nargin ~= 2 & nargin ~= 3 & nargin ~= 4 & nargin ~= 5 & nargin ~= 6   %�ж������������ֻ����2����3��
error('Too many or too few input arguments!');
end
default_options = [2.0; 200; 0.00001; 0];
data_n = size(data, 1); % ���data�ĵ�һά(rows)��,����������
in_n = size(data, 2);   % ���data�ĵڶ�ά(columns)����������ֵ����
if nargin == 2
    options = default_options;
else       %������options������ʱ������
 % ���������������Ƕ���ô�͵���Ĭ�ϵ�option;
    if length(options) < 4 %����û�����opition������4����ô������Ĭ��ֵ;
        tmp = default_options;
        tmp(1:length(options)) = options;
        options = tmp;
    end
    % ����options��������ֵΪ0(��NaN),������ʱΪ1
    nan_index = find(isnan(options)==1);
    %��denfault_options�ж�Ӧλ�õĲ�����ֵ��options�в�������λ��.
    options(nan_index) = default_options(nan_index);
    if options(1) <= 1 %���ģ�������ָ��С�ڵ���1
    error('The exponent should be greater than 1!');
    end
end
%��options �еķ����ֱ�ֵ���ĸ�����;
expo = options(1);          % �����Ⱦ���U��ָ��
max_iter = options(2);  % ����������
min_impro = options(3);  % ��������С�仯��,������ֹ����
display = options(4);  % ÿ�ε����Ƿ������Ϣ��־

obj_fcn = zeros(max_iter, 1); % ��ʼ���������obj_fcn

U = initimfcm(pre_center,data);     % ��ʼ��ģ���������,ʹU�����������Ϊ1,
% Main loop  ��Ҫѭ��
for i = 1:max_iter
    %�ڵ�k��ѭ���иı��������ceneter,�ͷ��亯��U��������ֵ;
    [U, center, obj_fcn(i)] = stepimfcm(data, U, cluster_n, expo,pre_center,bata);
    if display
        fprintf('FCM:Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
    end
    % ��ֹ�����б�
%     plot_center1(:,:,i) = center;
    if i > 1
        if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro,
                break;
        end
    end
end

iter_n = i; % ʵ�ʵ�������
obj_fcn(iter_n+1:max_iter) = [];
end

