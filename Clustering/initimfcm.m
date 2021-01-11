function U = initimfcm(pre_center,data)
%INITFCM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ��ʼ��fcm�������Ⱥ�������
% ����:
%   cluster_n   ---- �������ĸ���
%   data_n      ---- ��������
% �����
%   U           ---- ��ʼ���������Ⱦ���
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

