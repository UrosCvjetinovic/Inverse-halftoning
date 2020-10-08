function [Img_stego_halftoned, Img_inverse] = proposed_method(Imgs_in, Imgs_halftoned, Select_image, template_size)
%PROPOSED_METHOD This function is used to demonstrate the emebedding and
% extracting algorithm of inverse halftoning
%   [Img_stego_halftoned, Img_inverse] = proposed_method(Imgs_in, ...
%       Imgs_halftoned, Select_image, template_size) = ...
%       embed(Img_halftoned,LH,SH,Embed_cap,template_size) 
%       creates a Stego Halftone and a inverse halftone from it
%   Imgs_in is a set of images used to generate a LUT 
%   Imgs_halftoned is a set of halftoned Imgs_in used for generating LUT
%   Select_image is the index of the image to be embedded and then
%       extracted from
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   Img_stego_halftone is the halftoned image with hidden headers in it
%   Img_invers is the image gained from inverse halftoning the Stegohalfton


switch template_size
    case '3x3'
        F_dim = 3;
    case '4x4'
        F_dim = 4;
    otherwise
        error('Template size is either string 3x3 or 4x4');
end


Img_halftoned = cell2mat(Imgs_halftoned(Select_image));

%step 1
[~,num_of_images] = size(Imgs_in);
[~,num_of_halftones] = size(Imgs_halftoned);

%-- LUT BUILDUP
LUT = LutBuildUp(Imgs_in, Imgs_halftoned, template_size);

%-- Determin best of LUT to embed
[SI, Template] = LUT_or_Gaussian(Imgs_in,Imgs_halftoned, template_size);

%-- Find patterns pairs for embedding
[pairs, Embed_cap] = find_patterns(Img_halftoned, template_size);

SH_embedded = pairs; % ==[PH;PL]
LH_embedded = [Template; floor(255*(LUT(Template+1)))];

%Embeding 
Img_stego_halftoned = embed(Img_halftoned,LH_embedded,SH_embedded,Embed_cap,template_size);

%Extracting
[Img_extract_halftone,LH_extracted,~,template_size] = extract(Img_stego_halftoned);

%Reconstruct
Img_inverse = reconstruct(Img_extract_halftone,LH_extracted,template_size);







