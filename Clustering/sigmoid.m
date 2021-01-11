function output = sigmoid(input,w,b)
%SIGMOID 此处显示有关此函数的摘要
%   此处显示详细说明
[r,c] = size(input);
for i = 1:r
    for j = 1:c
        new_input = w*(input-0.5)-b*w;
        x = new_input(i,j);
        y = 1 / (1 + exp(-x));
        output(i,j) = y;
    end
end
% imshow(output);
end

