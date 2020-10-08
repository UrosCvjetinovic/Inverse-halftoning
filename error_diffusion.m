function Im_out = error_diffusion(Img_in, dif_error, row, col, error_diffusion_type)
%ERROR DIFFUSION Spreads the error to the neighboring pixels of the parsed
%                   pixel
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
% 
% Im_in = im2double(Img_in);
% [rows,cols] = size(Im_in);
% 
% switch error_diffusion_type
%     case 'Floyd_Steinberg'
%         Im_out = padarray(Im_in,[1,1]);
%         trow = row + 1;
%         tcol = col + 1;
%         div = 7;
%         Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 7/div;
%         
%         Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 1/div;
%         Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 5/div;
%         Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 3/div;
%         Im_out = Im_out(2:rows+1, 2:cols+1);
%     case 'Brukes'
%         Im_out = padarray(Im_in,[1,2]);
%         trow = row + 1;
%         tcol = col + 2;
%         div = 32;
%         Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 8/div;
%         Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 4/div;
%         
%         Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol)   + dif_error * 2/div;
%         Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 4/div;
%         Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 8/div;
%         Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 4/div;
%         Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + dif_error * 2/div;
%         
%         Im_out = Im_out(2:rows+1, 3:cols+2);
%         
%     case 'Stucki'
%         Im_out = padarray(Im_in,[2,2]);
%         trow = row + 1;
%         tcol = col + 2;
%         div = 42;
%         Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 8/div;
%         Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 4/div;
%         
%         Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol)   + dif_error * 2/div;
%         Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 4/div;
%         Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 8/div;
%         Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 4/div;
%         Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + dif_error * 2/div;
%         
%         Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol)   + dif_error * 1/div;
%         Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + dif_error * 2/div;
%         Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 4/div;
%         Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + dif_error * 2/div;
%         Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + dif_error * 1/div;
%         
%         Im_out = Im_out(3:rows+2, 3:cols+2);
%         
%     case {'Jarvis' , 'Judice', 'Ninke'}
%         Im_out = padarray(Im_in,[2,2]);
%         trow = row + 1;
%         tcol = col + 2;
%         div = 46;
%         Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 7/div;
%         Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 5/div;
%         
%         Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol)   + dif_error * 3/div;
%         Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 5/div;
%         Im_out(trow+1,tcol)     = Im_out(trow+1,tcol)   + dif_error * 7/div;
%         Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 5/div;
%         Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + dif_error * 3/div;
%         
%         %Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol)   + error * 0/div;
%         Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + dif_error * 3/div;
%         Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 5/div;
%         Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + dif_error * 3/div;
%         %Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + error * 0/div;
%         
%         Im_out = Im_out(3:rows+2, 3:cols+2);
%         
%     case {'Atkinson'}
%         Im_out = padarray(Im_in,[2,2]);
%         trow = row + 1;
%         tcol = col + 2;
%         div = 8;
%         Im_out(trow,tcol+1)     = Im_out(trow,tcol+1) + dif_error * 1/div;
%         Im_out(trow,tcol+2)     = Im_out(trow,tcol+2) + dif_error * 1/div;
%         
%         %Im_out(trow+1,tcol-2)   = Im_out(trow+1,tcol)   + error * 0/div;
%         Im_out(trow+1,tcol-1)   = Im_out(trow+1,tcol-1) + dif_error * 1/div;
%         Im_out(trow+1,tcol)     = Im_out(trow+1,tcol) 	+ dif_error * 1/div;
%         Im_out(trow+1,tcol+1)   = Im_out(trow+1,tcol+1) + dif_error * 1/div;
%         %Im_out(trow+1,tcol+2)   = Im_out(trow+1,tcol+2) + error * 0/div;
%         
%         %Im_out(trow+2,tcol-2)   = Im_out(trow+2,tcol)   + error * 0/div;
%         %Im_out(trow+2,tcol-1)   = Im_out(trow+2,tcol-1) + error * 0/div;
%         Im_out(trow+2,tcol)     = Im_out(trow+2,tcol)   + dif_error * 1/div;
%         %Im_out(trow+2,tcol+1)   = Im_out(trow+2,tcol+1) + error * 0/div;
%         %Im_out(trow+2,tcol+2)   = Im_out(trow+2,tcol+2) + error * 0/div;
%         
%         Im_out = Im_out(3:rows+2, 3:cols+2);
%         
%     otherwise
%         error('Unknown function type.');
% end