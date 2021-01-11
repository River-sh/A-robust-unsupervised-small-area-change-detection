function im_output = CWP(im_input,T)
% T is cumulative times
[x,y] = size(im_input);
add_im = ones(x,y);
if T == 1
    im_output = im_input;
else
    for i = 1:T-1
    im = WP(im_input,2*i+1);
    add_im = add_im + im;
    end
    im_output = add_im/T;
end
   
end

