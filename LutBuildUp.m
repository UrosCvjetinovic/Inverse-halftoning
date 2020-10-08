function LUT = LutBuildUp(Imgs_in, Imgs_halftoned, template_size)
% indeks LUT elementa je sablon-1 kom ogovara vrednost piksela sive slike


if(~strcmp(template_size,'3x3')) && (~strcmp(template_size,'4x4'))
    error('Template size is either string 3x3 or 4x4');
end
switch template_size
    case '3x3'
        F_dim = 3;
        numOfPatterns = 512;
    case '4x4'
        F_dim = 4;
        numOfPatterns = 65536;
    otherwise
        error('Unknown template size.');
end
%step 1 -initial values
LUT = zeros(1,numOfPatterns);
N = zeros(1,numOfPatterns);

%step 2 -select a pair (img,img_halftone)
[~,num_of_images] = size(Imgs_in);
[~,num_of_halftones] = size(Imgs_halftoned);

if (num_of_images ~= num_of_halftones)
    error('Images and their halftones dont match');
end
for k = 1:num_of_images
    if  (length(Imgs_in{k}) ~= length(Imgs_halftoned{k}))
        error('Images and their halftones dont match');
    end
end

switch (template_size)
    case '3x3'
        F_dim = 3;
        for k = 1:num_of_images
            Img_org = cell2mat(Imgs_in(k));
            Img_org = im2double(Img_org);
            Img_halftoned = cell2mat(Imgs_halftoned(k));
            [rows,cols] = size(Img_halftoned);
            Im_halftoned = padarray(Img_halftoned,[1 1],'symmetric');%'replicate'
            for i = 2: rows+1
                for j = 2:cols+1
                    I = 0;
                    for ii = 1:F_dim
                        for jj = 1:F_dim
                            I = I + 2^((ii-1)*F_dim+jj-1)*Im_halftoned(i+ii-2,j+jj-2);
                        end
                    end
                    N(I+1) = N(I+1)+1;
                    LUT(I+1) = LUT(I+1)+ Img_org(i-1,j-1);
                end
            end
        end
    case '4x4'
        F_dim = 4;
        for k = 1:num_of_images
            Img_org = cell2mat(Imgs_in(k));
            Img_org = im2double(Img_org);
            Img_halftoned = cell2mat(Imgs_halftoned(k));
            [rows,cols] = size(Img_halftoned);
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
                    N(I+1) = N(I+1)+1;
                    LUT(I+1) = LUT(I+1)+ Img_org(i-1,j-1);
                end
            end
        end
    otherwise
        error('Unknown template size.');
end


for I = 1:numOfPatterns
    LUT(I) = LUT(I)/N(I);
end



