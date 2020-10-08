function Img_out = LIH(Img_halftoned, LUT, template_size)
%LIH This function is used inverse halftone a halftoned image using the LUT
%   method
%   Img_out = LIH(Img_halftoned, LUT, template_size)
%       inverse halftones using LUT
%   Img_halftoned is a halftoned image
%   LUT is a table of patterns and value of pixels it coresponds to
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   Img_out is a inverse halftone of the input image using LUT method



if(~strcmp(template_size,'3x3')) && (~strcmp(template_size,'4x4'))
    error('Template size is either string 3x3 or 4x4');
end

[rows,cols] = size(Img_halftoned);
Img_out = zeros(rows,cols);

switch template_size
    case '3x3'
        F_dim = 3;
        Im_halftoned = padarray(Img_halftoned,[1 1],'symmetric');%'replicate'
        for i = 2: rows+1
            for j = 2:cols+1
                I = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Im_halftoned(i+ii-2,j+jj-2);
                    end
                end
                Img_out(i-1,j-1) = LUT(I+1);
            end
        end
    case '4x4'
        F_dim = 4;
        Im_halftoned = padarray(Imgs_halftoned,[2 2],'symmetric', 'pre');
        Im_halftoned = padarray(Im_halftoned,[1 1],'symmetric', 'post');
        for i = 3: rows+2
            for j = 3:cols+2
                I = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Im_halftoned(i+ii-3,j+jj-3);
                    end
                end
                Img_out(i-2,j-2) = LUT(I+1);
            end
        end
    otherwise
        error('Unknown template size.');
end






