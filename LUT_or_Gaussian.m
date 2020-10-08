function  [SI, Template] = LUT_or_Gaussian(Imgs_original,Imgs_halftoned, template_size)
%LUT_OR_GAUSSIAN This function is used to determin what patterns are best
%   to use LUT inverse halftoning, which to use Gaussian
%   [SI, Template] = LUT_or_Gaussian(Imgs_original,Imgs_halftoned, template_size)
%       finds the patterns to which LUT inverse halftoning would give
%       better results
%   Imgs_in is a set of images used to generate a LUT 
%   Imgs_halftoned is a set of halftoned Imgs_in used for generating LUT
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   SI is the value that represents the quality of LUT inverse halftoning
%       on that pattern
%   Template is the TemplateID of the patterns which LUT inverse halftoning
%       would give better results than the Gaussian method



switch template_size
    case '3x3'
        numOfPatterns = 512;
        F_dim = 3;
        B = zeros(numOfPatterns);
        
        LUT = LutBuildUp(Imgs_original,Imgs_halftoned,'3x3');
        for selectImage = 1:size(Imgs_original)
            Img_halftoned = cell2mat(Imgs_halftoned(selectImage));
            [rows,cols] = size(Img_halftoned);
            D = zeros(rows,cols);   
            Img_LIH = LIH(Img_halftoned,LUT,'3x3');
            Img_Gaussian = gaussian_method(Img_halftoned,'3x3');
            for i = 1:rows
                for j = 1:cols
                    D(i,j) = abs(Img_halftoned(i,j) - Img_LIH(i,j)) - abs(Img_halftoned(i,j) - Img_Gaussian(i,j));
                end
            end
        end
        
        for i = 1:F_dim:F_dim*floor(rows/F_dim)-1
            for j = 1:F_dim:F_dim*floor(cols/F_dim)-1
                I = 0;
                d = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
                        d = d + D(i+ii-1,j+jj-1);
                    end
                end
                B(I+1) = B(I+1) + d;
            end
        end
        
    case '4x4'
        F_dim = 4;
        numOfPatterns = 65536;
        B = zeros(numOfPatterns);
        
        LUT = LutBuildUp(Imgs_original,Imgs_halftoned,'3x3');
        for selectImage = 1:size(Imgs_original)
            Img_halftoned = cell2mat(Imgs_halftoned(selectImage));
            [rows,cols] = size(Img_halftoned);
            D = zeros(rows,cols);   
            Img_LIH = LIH(Img_halftoned,LUT,'3x3');
            Img_Gaussian = gaussian_method(Img_halftoned,'3x3');
            for i = 1:rows
                for j = 1:cols
                    D(i,j) = abs(Img_halftoned(i,j) - Img_LIH(i,j)) - abs(Img_halftoned(i,j) - Img_Gaussian(i,j));
                end
            end
        end
        
        for i = 1:F_dim:F_dim*floor(rows/F_dim)-1
            for j = 1:F_dim:F_dim*floor(cols/F_dim)-1
                I = 0;
                d = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
                        d = d + D(i+ii-1,j+jj-1);
                    end
                end
                B(I+1) = B(I+1) + d;
            end
        end
    otherwise
        error('Invalid template size');
end

[SI, Template] = sort(B, 'descend');
zero_indx = find(SI==0, 1, 'first');
SI = SI(1:zero_indx-1);
Template = Template(1:zero_indx-1)-1;



    
    