function out = distfcm(center, data)
%DISTFCM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% �������������������ĵľ���
% ���룺
%   center     ---- ��������
%   data       ---- ������
% �����
%   out        ---- ����
out = zeros(size(center, 1), size(data, 1));
for k = 1:size(center, 1), % ��ÿһ����������
    % ÿһ��ѭ��������������㵽һ���������ĵľ���
    out(k, :) = sqrt(sum(((data-ones(size(data,1),1)*center(k,:)).^2)',1));
end

