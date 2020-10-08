function [Img_stego_halftone] = embed(Img_halftoned,LH,SH,Embed_cap,template_size)
%EMBED Embeds LUT information in a halftone image, with hidden headers SH
%and LH
%   [Img_stego_halftone] = embed(Img_halftoned,LH,SH,Embed_cap,template_size) 
%       creates a halftoned image with hidden headers SH and LH in it
%   Img_halftoned is a halftoned image, created with error_diffusion
%   LH is a hidden header that is made of 2 rows: TemplateID,
%       LUT(TemplateID). The TemplateID is generated from function
%       LUT_or_Gaussian
%   SH is a hidden header that contains PH and PL, templates that are
%       frequent PH and templates PL that dont exist in the embedding
%       halftone. PH and PL are paired to be similar to each other
%   Embed_cap is the number of bits that can be hidden in the image. (PHs)
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   Img_stego_halftone is the halftoned image with hidden headers in it

Img_stego_halftone = Img_halftoned;
[rows,cols] = size(Img_stego_halftone);
[~, TC] = size(SH);

PH = SH(1,:);
PL = SH(2,:);

% uno = [];
% nuno = [];
switch template_size
    case '3x3'
        t_s = 0;
        F_dim = 3;
    case '4x4'
        t_s = 1;
        F_dim = 4;
    otherwise
        error('Template size is either string 3x3 or 4x4');
end
MAX_SIZEOFBITSFOR_LHlength = ceil(2*log2(min(size(Img_halftoned))/F_dim));

%--SH in bits
SHb = zeros(1,F_dim^2-1+TC*2*F_dim^2);
SHb(1:F_dim^2-1) = de2bi(TC,F_dim^2-1);
for i = 1:TC
    SHb(F_dim^2+(i-1)*2*F_dim^2:F_dim^2-1+i*2*F_dim^2) = [de2bi(SH(1,i),F_dim^2), de2bi(SH(2,i),F_dim^2)];
end
SHb = [t_s, SHb]; %template_size

if (Embed_cap < length(SHb) + MAX_SIZEOFBITSFOR_LHlength)
    error('Not enough patterns for embedding');
end

%--LH in bits (pixel is 8bits)
LHb_LENGTH = Embed_cap - length(SHb) - MAX_SIZEOFBITSFOR_LHlength;
temp = F_dim^2+8;
length_lh = floor(LHb_LENGTH/temp);
length_lh = min(length(LH(:)), length_lh);
LH = LH(:)';
LHb = zeros(1,ceil(length_lh/2*temp));
for i = 0:length_lh/2 - 1
    LHb(1+i*temp:(i+1)*temp) = [de2bi(LH(2*i+1),F_dim^2), de2bi(LH(2*i+2),8)];
end
length_lhb = de2bi(length(LHb),MAX_SIZEOFBITSFOR_LHlength);
LHb = [ length_lhb, LHb];

last = length(Img_stego_halftone(:));
HL = Img_stego_halftone(last:-1:last-length(SHb));

%--Embed data
Bit_stream = [HL, LHb];
temp_BitStream = Bit_stream;
for j = 1:F_dim:F_dim*floor(cols/F_dim)
    for i = 1:F_dim:F_dim*floor(rows/F_dim)
        I = 0;
        for ii = 1:F_dim
            for jj = 1:F_dim
                I = I + 2^((ii-1)*F_dim+jj-1)*Img_stego_halftone(i+ii-1,j+jj-1);
            end
        end
        found = find(PH == I);
        if(~isempty(found))
            if(found > 0)
                if(temp_BitStream(1))
                    embedding_pattern = de2bi(PL(found),F_dim^2);
                    embedding_pattern = [embedding_pattern(1:F_dim); embedding_pattern(F_dim+1:2*F_dim); embedding_pattern(2*F_dim+1:3*F_dim)];
                    Img_stego_halftone(i:i+F_dim-1,j:j+F_dim-1) = embedding_pattern;
%                     uno = [uno, [i; j]];
                else 
%                     nuno = [nuno, [i; j]];
                end
                temp_BitStream(1) = [];
            end
        end
        if (isempty(temp_BitStream))
            break;
        end
    end
    if (isempty(temp_BitStream))
        break;
    end
end

Img_stego_halftone(last:-1:last-length(SHb)+1) = SHb;
