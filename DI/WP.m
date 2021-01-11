function pic = WP(data,k_size)

[l_pic,h_pic] = size(data);
% Initialization
Pooling_window = ones(k_size,k_size);
w = ones(k_size,k_size);

% Calculate the weighted pooling kernel w
w_kc = ((k_size-1)/2)+1;
 for i = 1:k_size
     for j = 1:k_size
         d = sqrt((w_kc-i)^2+(w_kc-j)^2);
         w(i,j) = 1/d;
     end
 end
 w(w_kc,w_kc) = 2;
 w_mean = mean(mean(w));
 
% padding 0
for i = 1:l_pic+k_size-1
    for j = 1:h_pic+k_size-1
        if i <= (k_size-1)/2 || j <= (k_size-1)/2
            new_pic(i,j) = 0;
        elseif i >= l_pic+(k_size-1)/2 || j > h_pic+(k_size-1)/2
            new_pic(i,j) = 0;
        else
            new_pic(i,j) = data(i-(k_size-1)/2,j-(k_size-1)/2);
        end
    end
end

% Pooling
for i = 1:l_pic
    for j = 1:h_pic
        Pooling_window = new_pic(i:i+k_size-1,j:j+k_size-1); 
        pic(i,j) = mean(mean(w.*Pooling_window))/w_mean;
    end
end
end

