clc;
clear all;

% General model Exp2:
%      f(x) = a*exp(b*x) + c*exp(d*x)
% Coefficients (with 95% confidence bounds):
%        a =       422.1  (371.3, 472.8)
%        b =     -0.1601  (-0.2001, -0.1202)
%        c =       87.25  (35.55, 139)
%        d =  -0.0008244  (-0.01346, 0.01181)

% Optimal Mesh Size According to Variance and image size (im_size x im_size)

[result ]          = optimal_mesh_res( 15 , 480);


function [result ] = optimal_mesh_res( var , im_size)

% Constants
a =       422.1 ;
b =     -0.1601 ;
c =       87.25 ;
d =  -0.0008244 ;

% Optimal result according to obtained function
res1 = a * exp(b*var) + c*exp(d*var) ;
res1
% Find the closest common dividend of the image-size
common   = find_div(im_size,im_size) ;
[~,idx]  = min(round( abs( common-res1) ));
minVal   = common(idx(1));

result   = minVal(1);

end
function [common]  = find_div(row,col)
% Select the minimum div number as 10 and search the min of the row and
% col for max number

    if row < col
        lim = row;
    else
        lim = col;
    end

    i = 1;
    for x = 10:1:lim

        x_row = mod(row,x);
        x_col = mod(col,x);

        if  x_row == x_col & x_col == 0

            common(i) = x ;
            i=i+1;

        end
    end
    
end