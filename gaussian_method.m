function Img_out = gaussian_method(Img_halftoned, template_size)



if(~strcmp(template_size,'3x3')) && (~strcmp(template_size,'5x5'))
    error('Template size is either string 3x3 or 5x5');
end

[rows,cols,channels] = size(Img_halftoned);
if(channels ~= 1)
    error('Funkcija prima samo sive slike');
end

Im_halftoned = Img_halftoned;
Img_out = zeros(rows,cols);

template3x3 = 1/16 .* [ 1,2,1; 2,4,2; 1,2,1];
template5x5 = 1/273 .* [1,4,7,4,1; 4,16,26,16,4; 7,26,41,26,7; 4,16,26,16,4; 1,4,7,4,1];

switch template_size
    case '3x3'
        F_dim = 3;
        Im_halftoned = padarray(Im_halftoned,[1 1],'symmetric');%'replicate'
        for i = 2: rows+1
            for j = 2:cols+1
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        Img_out(i-1,j-1) = Img_out(i-1,j-1) + Im_halftoned(i+ii-2,j+jj-2)*template3x3(ii,jj);
                    end
                end
            end
        end
    case '5x5'
        F_dim = 5;
        Im_halftoned = padarray(Im_halftoned,[2 2],'symmetric');
        for i = 3: rows+2
            for j = 3:cols+2
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        Img_out(i-2,j-2) = Img_out(i-2,j-2) + Im_halftoned(i+ii-3,j+jj-3)*template5x5(ii,jj);
                    end
                end
            end
        end
    otherwise
        error('Unknown template size.');
end




