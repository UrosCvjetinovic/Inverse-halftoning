%% Testiranje slike pojedinacno
clc;
close all;

% -- Images for testing
%sive slike
Im1 = imread('slike/lena.tif');
%rgb slike
Im2 = imread('slike/wolfs.jfif');
Im3 = imread('slike/keanu reeves.jpg');
Im4 = imread('slike/logan.jpg');
Im5 = imread('slike/1369012.jpg');
Im6 = imread('slike/marlinmanro.jpeg');
Im7 = imread('slike/cat.jfif');
Im8 = imread('slike/tiger.jfif');
Im9 = imread('slike/balls.jfif');
Im10 = imread('slike/basketball.jpg');
Im11 = imread('slike/jingjang.jfif');

Images = { Im1,Im2,Im3,Im4,Im5,Im6,Im7,Im8,Im9,Im10,Im11};

for i = 1:length(Images)
    [rows,cols,channels]= size(Images{i});
    if(channels == 3)
        Images{i} = rgb2gray(Images{i});
    end
end

%% -- SINGLE IMAGE TESTING
% -- Select method and image
type = {'Floyd_Steinberg','Brukes','Stucki','Minimized average error','Atkinson'};
error_diffusion_type = type{5};
SELECT_IMAGE = 1;
template_size = '3x3';

%%
bin_coef = 0.5;

Img = cell2mat(Images(SELECT_IMAGE));
    figure(1); imshow(Img);
    set(gcf, 'Position', get(0, 'Screensize'));

% -Use function to create dither matrix
% dim_of_dither = 7;
% dit_type = 'circle';
% Im_dit = dither(dit_type,dim_of_dither);
%     figure(2); imshow(Im_dit);
%     set(gcf, 'Position', get(0, 'Screensize'));

% -Use premade dither matrix
% Im_dit = [0.5, 0.25, 0.5; 0.25, 0, 0.25; 0.5, 0.25, 0.5];
Im_dit = [0.75, 0.5, 0.75; 0.5, 0, 0.5; 0.75, 0.5, 0.75];
% Im_dit = [1, 0.75, 0.5, 0.75, 1; 0.75, 0.5, 0.25, 0.5, 0.75; 0.5, 0.25, 0, 0.25, 0.5; 0.75, 0.5, 0.25, 0.5, 0.75; 1, 0.75, 0.5, 0.75, 1;];

%%
%-----Halftoning
%-Pixel by pixel error_diffusion
% Img_halftoned = halftone(Img,error_diffusion_type,bin_coef);
%     figure(3); imshow(Img_halftoned);
%     title('Polutonirana slika poredjenjem sa skalarom');
%     set(gcf, 'Position', get(0, 'Screensize'));
% 
% %-Block by block error_diffusion
% Img_halftoned_dit = halftone_dit(Img,Im_dit,error_diffusion_type);
%     figure(4); imshow(Img_halftoned_dit);
%     title('Polutonirana slika koristeci diter matricu za uporedjivanje');
%     set(gcf, 'Position', get(0, 'Screensize'));
% 
% %-----Inverse halftoning
% %-Gaussian inverse halftoning
% Img_gaussian = gaussian_method(Img_halftoned_dit, '5x5');
%     figure(5); imshow(Img_gaussian);
%     title('Inverzno polutoniranje gausovim');
%     set(gcf, 'Position', get(0, 'Screensize')); 
%%
% -- Halftone all images
Imgs_original = Images;
Imgs_halftoned = cell(1,length(Images));
% Takes a long time if used max images
for k = 1:length(Images)
    Img_temp = halftone_dit(cell2mat(Images(k)),Im_dit,error_diffusion_type);
    Imgs_halftoned{k} =  Img_temp;
end
    figure(6); imshow(Imgs_halftoned{SELECT_IMAGE});
    title('Polutonirana slika poredjenjem sa skalarom');
    set(gcf, 'Position', get(0, 'Screensize'));

%%

% LUT or Gaussian
%-- Determin best of LUT to embed
[SI, Template] = LUT_or_Gaussian(Imgs_original,Imgs_halftoned, template_size);

% -- Demonstrate LUT and LIH

LUT = LutBuildUp(Imgs_original,Imgs_halftoned,template_size);   
% Img_LIH = LIH(cell2mat(Imgs_halftoned(SELECT_IMAGE)),LUT,template_size);
%     figure(7); imshow(Img_LIH);
%     title('Inverzno polutoniranje LUT');
%     set(gcf, 'Position', get(0, 'Screensize')); 

%%
%-- Find patterns pairs for embedding
[pairs, Embed_cap] = find_patterns(Imgs_halftoned{SELECT_IMAGE}, template_size);

SH_embedded = pairs; % ==[PH;PL]
LH_embedded = [Template; floor(255*(LUT(Template+1)))];
%%
%Embeding 
[Img_stego_halftoned] = embed(Imgs_halftoned{SELECT_IMAGE},LH_embedded,SH_embedded,Embed_cap,template_size);

    figure(8); imshow(Img_stego_halftoned);
    title('STEGO Halftone (embed)');
    set(gcf, 'Position', get(0, 'Screensize'));
    
%% 
%Extracting
[Img_extract_halftone,LH_extracted,SH_extracted,template_size_extracted] = extract(Img_stego_halftoned);

    figure(9); imshow(Img_extract_halftone);
    title('Extracted halftone');
    set(gcf, 'Position', get(0, 'Screensize'));
    %%
%Reconstruct
Img_inverse = reconstruct(Img_extract_halftone,LH_embedded,template_size_extracted);

    figure(10); imshow(Img_inverse);
    title('Dobijena slika opisanim postupkom (extract)');
    set(gcf, 'Position', get(0, 'Screensize'));









