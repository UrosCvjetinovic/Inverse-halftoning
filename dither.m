function Im_out = dither(type, size)
%HALFTONE Computes dither matrix for halftoning
%   Im_out = dither(type, size) creates a matrix/image that is used
%   in block halftoning of various shapes.
%   Valid values for type are:
%
%   'circle'     Dither is a circle shape
%
%   'diamond'    Dither is a diamond shape
%
%   'square'     Dither is a square shape
% 
% If size is even, it will be shortened by one

    if nargin == 1
        size = 31;
    end
    if (mod(size,2) == 0)
        size = size - 1;
    end

    Im_out = ones(size,size);
    radius = floor(size/2);
    xc = ceil(size/2);
    yc = ceil(size/2);
    switch type
        case 'circle'
           for ii = xc - int16(radius):xc+(int16(radius))
               for jj = yc - int16(radius):yc+(int16(radius))
                   tempR = sqrt((double(ii) - double(xc)).^2 + (double(jj) -double(yc)).^2);
                   if(tempR <= double(int16(radius)))
                       Im_out(ii,jj) = double(tempR/double(int16(radius)));
                   end
               end
           end
        case 'diamond'
           for ii = xc - int16(radius):xc+(int16(radius))
               for jj = yc - int16(radius):yc+(int16(radius))
                   tempR = abs(double(ii) - double(xc)) + abs(double(jj) -double(yc));
                   Im_out(ii,jj) = tempR / (size-1);
               end
           end
        case 'square'
            Im_out(xc,yc) = 0;
            for i = 1 : radius
                for ii = xc - i: xc + i
                    for jj = yc - i: yc+i
                        Im_out(ii,yc-i) = i/radius;
                        Im_out(ii,yc+i) = i/radius;
                        Im_out(xc-i,jj) = i/radius;
                        Im_out(xc+i,jj) = i/radius;
                    end
                end
           end
        otherwise
           error('Unknown shape.')
    end

