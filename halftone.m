function Im_out = halftone(Img_in, error_diffusion_type, bin_coef)
%HALFTONE Computes halftone of an image using error diffusion methods
%   H = HALFTONE(Im_in, error_diffusion_type) creates a halftoned image
%    of an image using error difusion and binar function.
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

if nargin == 2
    bin_coef = 0.5;
end
Im_in = im2double(Img_in);
[rows,cols,channels] = size(Im_in);


if(channels ~= 1)
    error('Funkcija prima samo sive slike');
end

switch error_diffusion_type
    case 'Floyd_Steinberg'
        Im_out = padarray(Im_in,[1,1]);
        div = 7;
    case 'Brukes'
        Im_out = padarray(Im_in,[1,2]);
        div = 32;
    case 'Stucki'
        Im_out = padarray(Im_in,[2,2]);
        div = 42;
    case 'Minimized average error'
        Im_out = padarray(Im_in,[2,2]);
        div = 46;
    case 'Atkinson'
        Im_out = padarray(Im_in,[2,2]);
        div = 8;
    otherwise
        error('Unknown function type.');
end


for i= 1:rows
    for j= 1:cols
        row = i;
        col = j;
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
        dif_error = Im_out(trow,tcol) - bin_coef;
        if(Im_out(trow,tcol) > bin_coef)
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
                Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 1./div;
                Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 1./div;
                
                %Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol-2)   + error * 0/div;
                Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 1./div;
                Im_out(trow+1,tcol)     = Im_out(trow+1,tcol) 	+ dif_error * 1./div;
                Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 1./div;
                %Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + error * 0/div;
                
                %Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol-2)   + error * 0/div;
                %Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + error * 0/div;
                Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 1./div;
                %Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + error * 0/div;
                %Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + error * 0/div;
                
            otherwise
                error('Unknown function type.');
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

