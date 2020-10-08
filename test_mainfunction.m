%% Testiranje glavne funkcije
clc;
clear all;
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

%% -- Halftoning images
% -- Select method and image
type = {'Floyd_Steinberg','Brukes','Stucki','Minimized average error','Atkinson'};
error_diffusion_type = type{5};

bin_coef = 0.5;
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


Imgs_original = Images;
Imgs_halftoned = cell(1,length(Images));
% Takes a long time if used max images
for k = 1:length(Images)
    Img_temp = halftone_dit(cell2mat(Images(k)),Im_dit,error_diffusion_type);
    Imgs_halftoned{k} =  Img_temp;
end
%%

SELECT_IMAGE = 1;

    figure(1); imshow(Images{SELECT_IMAGE});
    set(gcf, 'Position', get(0, 'Screensize'));

    figure(2); imshow(Imgs_halftoned{SELECT_IMAGE});
    title('Polutonirana slika');
    set(gcf, 'Position', get(0, 'Screensize'));

[Img_stego_halftoned, Img_inverse] = proposed_method(Imgs_original, Imgs_halftoned, SELECT_IMAGE, '3x3');

    figure(3); imshow(Img_stego_halftoned);
    title('STEGO Halftone (embed)');
    set(gcf, 'Position', get(0, 'Screensize'));
    
    figure(4); imshow(Img_inverse);
    title('Dobijena slika opisanim postupkom (extract)');
    set(gcf, 'Position', get(0, 'Screensize'));
