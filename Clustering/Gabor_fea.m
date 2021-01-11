function [pixel_vector_1,pixel_vector_2] = Gabor_fea(im_di,scale)

% initialization
HW = 21;
GaborH = HW;
GaborW = HW;
sigma = 2.8*pi;
Kmax = 2.0*pi;
f = sqrt(2);
flag = 1;
orientation = 12;
V = 0:1:(scale-1);
U = 0:1:(orientation-1);

[Ylen,Xlen] = size(im_di);
% the total number of pixels for the difference image
pixel_sum = Ylen*Xlen;
% the total number of self-similar Gabor filters
subgraph_sum = scale*orientation;

% Initialization
GaImout_MAGNITUDE = cell(scale,orientation);          % magnitude

% Gabor wavelet transform
for s = 1:scale
    for n = 1:orientation
        GaImout_MAGNITUDE{s,n} = zeros(Ylen,Xlen);
        [Gr,Gi] = GaborKernelWave(GaborH, GaborW, U(n), V(s), Kmax, f, sigma, orientation, flag);
        % Gr: The real part of the Gabor kernels
        % Gi: The imaginary part of the Gabor kernels
        Regabout = conv2(im_di,double(Gr),'same');
        Imgabout = conv2(im_di,double(Gi),'same');
        % Magnitude
        GaImout_MAGNITUDE{s,n} = sqrt(Imgabout.*Imgabout + Regabout.*Regabout);  
    end
end

clear GaborH GaborW sigma;
clear Gi Gr HW Kmax;
clear Imgabout Regabout;
clear U V f flag;

% acquire the feature vector of each pixel for the difference image
% 1): all amplitudes at different scales and orientations
pixel_vector_1 = zeros(pixel_sum,subgraph_sum);
k = 1;
for s = 1:scale
    for n = 1:orientation
        temp_gaimout_1 = zeros(Ylen,Xlen);
        temp_gaimout_1 = GaImout_MAGNITUDE{s,n};
        pixel_vector_1(:,k) = reshape(temp_gaimout_1',pixel_sum,1);
        k = k + 1;
    end
end

% clear k n s GaImout_MAGNITUDE subgraph_sum;

% 2): maximum amplitudes for all orientations at different scales
% pixel_vectorr_2 = zeros(pixel_sum,scale);
for s = 1:scale
    temp_gaimout_2 = zeros(pixel_sum,orientation);
    temp_gaimout_2 = pixel_vector_1(:,(s-1)*orientation+1:s*orientation);
    pixel_vector_2(:,s) = max(temp_gaimout_2,[],2);
end

end

