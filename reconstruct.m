function Img_inverse = reconstruct(Img_halftoned,LH,template_size)
%RECONSTRUCT This function is used to inverse halftone an image with the 
% use of LUT and Guassian method
%   Img_inverse = reconstruct(Img_halftoned,LH,template_size)
%       reconstructs the original image used to generate the halftone image
%   Img_halftoned is a halftone image
%   LH is a table of TemplateID;LUT(Template(ID) used for LUT inverse 
%       halftoning
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   Img_inverse is the image gained from inverse halftoning the Stegohalfton

LH(2,:) = LH(2,:)/255;

Img_inverse = gaussian_method(Img_halftoned,'3x3');

[rows,cols] = size(Img_inverse);
Img_fromLUT = ones(rows,cols);

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
                indx = LH(1,:) == I;
                indx = find(indx,1,'first');
                if ~isempty(indx)
                    Img_inverse(i-1,j-1) = LH(2,indx);
                    Img_fromLUT(i-1,j-1) = LH(2,indx);
                end
            end
        end
    case '4x4'
        F_dim = 4;
        Im_halftoned = padarray(Img_halftoned,[2 2],'symmetric', 'pre');
        Im_halftoned = padarray(Im_halftoned,[1 1],'symmetric', 'post');
        for i = 3: rows+2
            for j = 3:cols+2
                I = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Im_halftoned(i+ii-3,j+jj-3);
                    end
                end
                indx = LH(1,:) == I;
                if ~isempty(LH(2,indx))
                    Img_inverse(i-2,j-2) = LH(2,indx);
                    Img_fromLUT(i-2,j-2) = LH(2,indx);
                end
            end
        end
    otherwise
        error('Unknown template size.');
end

    figure(7); imshow(Img_fromLUT);
    title('Pikseli cija boja je odredjena pomocu LIH');
    set(gcf, 'Position', get(0, 'Screensize'));