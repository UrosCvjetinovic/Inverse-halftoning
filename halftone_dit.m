function Im_out = halftone_dit(Img_in,Img_dither, error_diffusion_type)
%HALFTONE Computes halftone of an image using error diffusion methods
%   H = HALFTONE(Im_in, error_diffusion_type) creates a halftoned image
%    of an image using error difusion and binar function with a dit matrix
%   Valid values for error_diffusion_type are:
%
%   'Floyd_Steinberg' only diffuses the error to neighboring pixels.
%                       This results in very fine-grained dithering.
%
%   'Brukes'     is a simplified form of Stucki dithering that is faster,
%                   but is less clean than Stucki dithering.
%
%   'Stucki'     is based on the above, but is slightly faster. Its output
%                   tends to be clean and sharp.
%
%   'Minimized average error'     by Jarvis, Judice, and Ninke diffuses the
%               error also to pixels one step further away. The dithering
%               is coarser, but has fewer visual artifacts. However, it is
%               slower than Floyd–Steinberg dithering, because it
%               distributes errors among 12 nearby pixels instead of 4
%               nearby pixels for Floyd–Steinberg.
%
%   'Atkinson'  was developed by Apple programmer Bill Atkinson, and
%           resembles Jarvis dithering and Sierra dithering, but it's
%           faster. Another difference is that it doesn't diffuse the
%           entire quantization error, but only three quarters. It tends to
%           preserve detail well, but very light and dark areas may appear
%           blown out.
%
%

Im_in = im2double(Img_in);
Im_dither = im2double(Img_dither);
[rows,cols,channels] = size(Im_in);
[rows_d,cols_d] = size(Im_dither);

if(channels ~= 1)
    error('Funkcija prima samo sive slike');
end

switch error_diffusion_type
    case 'Floyd_Steinberg'
        Im_out = padarray(Im_in,[1,1]);
        div = 7.;
    case 'Brukes'
        Im_out = padarray(Im_in,[1,2]);
        div = 32.;
    case 'Stucki'
        Im_out = padarray(Im_in,[2,2]);
        div = 42.;
    case 'Minimized average error'
        Im_out = padarray(Im_in,[2,2]);
        div = 46.;
    case 'Atkinson'
        Im_out = padarray(Im_in,[2,2]);
        div = 8.;
    otherwise
        error('Unknown function type.');
end


for i= 1:rows_d:floor(rows/rows_d)*rows_d
    for j= 1:cols_d:floor(cols/cols_d)*cols_d
        for ii= 1:rows_d
            for jj= 1:cols_d
                row = i+ii-1;
                col = j+jj-1;
                switch error_diffusion_type
                    case 'Floyd_Steinberg'
                        trow = row + 1;
                        tcol = col + 1;
                    case 'Brukes'
                        trow = row + 1;
                        tcol = col + 2;
                    case 'Stucki'
                        trow = row + 2;
                        tcol = col + 2;
                    case 'Minimized average error'
                        trow = row + 2;
                        tcol = col + 2;
                    case 'Atkinson'
                        trow = row + 2;
                        tcol = col + 2;
                    otherwise
                        error('Unknown function type.');
                end
                dif_error = Im_out(trow,tcol) - Im_dither(ii,jj);
                if(Im_out(trow,tcol) > Im_dither(ii,jj))
                    Im_out(trow,tcol) = 1;
                else
                    Im_out(trow,tcol) = 0;
                end
                switch error_diffusion_type
                    case 'Floyd_Steinberg'
                        Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 7./div;
                        
                        Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 3./div;
                        Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 5./div;
                        Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 1./div;
                    case 'Brukes'
                        Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 8./div;
                        Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 4./div;
                        
                        Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol-2)   + dif_error * 2./div;
                        Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 4./div;
                        Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 8./div;
                        Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 4./div;
                        Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + dif_error * 2./div;
                        
                    case 'Stucki'
                        Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 8./div;
                        Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 4./div;
                        
                        Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol-2)   + dif_error * 2./div;
                        Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 4./div;
                        Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 8./div;
                        Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 4./div;
                        Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + dif_error * 2./div;
                        
                        Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol-2)   + dif_error * 1./div;
                        Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + dif_error * 2./div;
                        Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 4./div;
                        Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + dif_error * 2./div;
                        Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + dif_error * 1./div;
                        
                    case 'Minimized average error'
                        Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 7./div;
                        Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 5./div;
                        
                        Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol-2)   + dif_error * 3./div;
                        Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 5./div;
                        Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 7./div;
                        Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 5./div;
                        Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + dif_error * 3./div;
                        
                        %Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol-2)   + error * 0/div;
                        Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + dif_error * 3./div;
                        Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 5./div;
                        Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + dif_error * 3./div;
                        %Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + error * 0/div;
                        
                    case 'Atkinson'
                        Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 1/div;
                        Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 1/div;
                        
                        %Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol-2)   + error * 0/div;
                        Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 1/div;
                        Im_out(trow+1,tcol)     = Im_out(trow+1,tcol) 	+ dif_error * 1/div;
                        Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 1/div;
                        %Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + error * 0/div;
                        
                        %Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol-2)   + error * 0/div;
                        %Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + error * 0/div;
                        Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 1/div;
                        %Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + error * 0/div;
                        %Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + error * 0/div;
                        
                    otherwise
                        error('Unknown function type.');
                end
            end
        end
    end
end

switch error_diffusion_type
    case 'Floyd_Steinberg'
        Im_out = Im_out(2:rows+1, 2:cols+1);
    case 'Brukes'
        Im_out = Im_out(2:rows+1, 3:cols+2);
        
    case 'Stucki'
        Im_out = Im_out(3:rows+2, 3:cols+2);
        
    case 'Minimized average error'
        Im_out = Im_out(3:rows+2, 3:cols+2);
        
    case 'Atkinson'
        Im_out = Im_out(3:rows+2, 3:cols+2);
    otherwise
        error('Unknown error diffusion type.');
end

%Zbog dither matric, odredjeni pikseli koji su vec odradjeni menjaju
%vrednost, ovim ih vracamo u zasicenje
Im_out = im2bw(Im_out,0.5);

