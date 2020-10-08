function [Img_halftoned,LH,SH,template_size] = extract(Img_stego_halftoned)
%Extract Extracts LUT information in a stego halftone image, with hidden 
% headers SH and LH
%   [Img_halftoned,LH,SH,template_size] = extract(Img_stego_halftoned)
%       extracts SH and LH from stego halftone
%   Img_stego_halftoned is a halftoned image, created with embedding method
% 
%   LH is a hidden header that is made of 2 rows: TemplateID,
%       LUT(TemplateID). The TemplateID is generated from function
%       LUT_or_Gaussian
%   SH is a hidden header that contains PH and PL, templates that are
%       frequent PH and templates PL that dont exist in the embedding
%       halftone. PH and PL are paired to be similar to each other
%   Img_halftoned is the halftoned image with the hidden headers removed
%   LH is the hidden header from the Stego Halftone
%       (TemplateID;LUT(TemplateID))
%   SH is the hidden header from the Stego Halftone (PH;PL)
%   template_size is the size of the blocks used to generate the stego
%       halftone

Img_halftoned = Img_stego_halftoned;
[rows,cols] = size(Img_halftoned);

last = length(Img_halftoned(:));
t_s = Img_halftoned(last);

% uno = [];
% nuno = [];
%extract SH
switch t_s
    case 0 % '3x3'
        F_dim = 3;
        template_size = '3x3';
        TCb = Img_halftoned(last-1:-1:last-8);
        TC = bi2de(TCb);
        SHb = zeros(1,8+TC*18);
        SHb(1:8) = TCb;
        pair = zeros(2,TC);
        for i = 1:TC
            PHind = last-9-(i-1)*18:-1:last-17-(i-1)*18;
            PLind = last-18-(i-1)*18:-1:last-26-(i-1)*18;
            pair(1,i) = bi2de(Img_halftoned(PHind));
            pair(2,i) = bi2de(Img_halftoned(PLind));
            SHb(9+(i-1)*18:8+i*18) = [Img_halftoned(PHind), Img_halftoned(PLind)];
        end
    case 1  % '4x4'
        F_dim = 4;
        template_size = '4x4';
        TCb = Img_halftoned(last-1:-1:last-15);
        TC = bi2de(TCb);
        SHb = zeros(1,8+TC*18);
        SHb(1:15) = TCb;
        pair = zeros(2,TC);
        for i = 1:TC
            PHind = last-16-(i-1)*32:-1:last-31-(i-1)*32;
            PLind = last-32-(i-1)*32:-1:last-47-(i-1)*32;
            pair(1,i) = bi2de(Img_halftoned(PHind));
            pair(2,i) = bi2de(Img_halftoned(PLind));
            SHb(16+(i-1)*32:15+i*32) = [Img_halftoned(PHind), Img_halftoned(PLind)];
        end
    otherwise
        error('Template size is either string 3x3 or 4x4');
end

MAX_SIZEOFBITSFOR_LHlength = ceil(2*log2(min(size(Img_halftoned))/F_dim));
SH = [pair(1,:); pair(2,:)];
PH = SH(1,:);
PL = SH(2,:);

% extract bits (HLi)
Bit_stream = [];
for j = 1:F_dim:F_dim*floor(cols/F_dim)
    for i = 1:F_dim:F_dim*floor(rows/F_dim)
        I = 0;
        for ii = 1:F_dim
            for jj = 1:F_dim
                I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
            end
        end
        foundPH = find(PH == I);
        foundPL = find(PL == I);
        if(~isempty(foundPH))
            if (foundPH > 0)
                Bit_stream = [Bit_stream, 0];
%                 nuno = [nuno, [i; j]];
            end 
        elseif (~isempty(foundPL))
            if (foundPL > 0)
                embedding_pattern = de2bi(pair(1,foundPL),F_dim^2);
                embedding_pattern = [embedding_pattern(1:F_dim); embedding_pattern(F_dim+1:2*F_dim); embedding_pattern(2*F_dim+1:3*F_dim)];
                Img_halftoned(i:i+F_dim-1,j:j+F_dim-1) = embedding_pattern;
                Bit_stream = [Bit_stream, 1];
%                 uno = [uno, [i; j]];
            end
        end
        if(length(Bit_stream) >= length(SHb)+2)
            i_last = i;
            j_last = j;
            break;
        end
    end
    if(length(Bit_stream) >= length(SHb)+2)
        break;
    end
end

% Swap SH with found HL
HL = Bit_stream;
Img_halftoned(last:-1:last-length(SHb)-1) = HL;


Bit_stream = [];
% Extract bits for length (LH)
j = j_last;
for i = i_last+F_dim:F_dim:F_dim*floor(rows/F_dim)
        I = 0;
        for ii = 1:F_dim
            for jj = 1:F_dim
                I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
            end
        end
        foundPH = find(PH == I);
        foundPL = find(PL == I);
        if(~isempty(foundPH))
            if(foundPH > 0)
                Bit_stream = [Bit_stream, 0];
%                 nuno = [nuno, [i; j]];
            end
        elseif(~isempty(foundPL))
            if (foundPL > 0)
                embedding_pattern = de2bi(pair(1,foundPL),F_dim^2);
                embedding_pattern = [embedding_pattern(1:F_dim); embedding_pattern(F_dim+1:2*F_dim); embedding_pattern(2*F_dim+1:3*F_dim)];
                Img_halftoned(i:i+F_dim-1,j:j+F_dim-1) = embedding_pattern;
                Bit_stream = [Bit_stream, 1];
%                 uno = [uno, [i; j]];
            end
        end
        if(length(Bit_stream) >= MAX_SIZEOFBITSFOR_LHlength)
            break;
        end
end
for j = j_last+F_dim:F_dim:F_dim*floor(cols/F_dim)
    if(length(Bit_stream) >= MAX_SIZEOFBITSFOR_LHlength)
        break;
    end
    for i = 1:F_dim:F_dim*floor(rows/F_dim)
        I = 0;
        for ii = 1:F_dim
            for jj = 1:F_dim
                I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
            end
        end
        foundPH = find(PH == I);
        foundPL = find(PL == I);
        if ( ~isempty(foundPH))
            if(foundPH > 0)
                Bit_stream = [Bit_stream, 0];
%                 nuno = [nuno, [i; j]];
            end
        elseif (~isempty(foundPL))
            if( foundPL > 0)
                embedding_pattern = de2bi(pair(1,foundPL),F_dim^2);
                embedding_pattern = [embedding_pattern(1:F_dim); embedding_pattern(F_dim+1:2*F_dim); embedding_pattern(2*F_dim+1:3*F_dim)];
                Img_halftoned(i:i+F_dim-1,j:j+F_dim-1) = embedding_pattern;
                Bit_stream = [Bit_stream, 1];
%                 uno = [uno, [i; j]];
            end
        end
        if(length(Bit_stream) >= MAX_SIZEOFBITSFOR_LHlength)
            i_last = i;
            j_last = j;
            break;
        end
    end
end

LHb_length = bi2de(Bit_stream);

% Extract bits (LH)
Bit_stream = [];
j = j_last;
for i = i_last+F_dim:F_dim:F_dim*floor(rows/F_dim)
        I = 0;
        for ii = 1:F_dim
            for jj = 1:F_dim
                I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
            end
        end
        foundPH = find(PH == I);
        foundPL = find(PL == I);
        if(~isempty(foundPH))
            if(foundPH > 0)
                Bit_stream = [Bit_stream, 0];
%                 nuno = [nuno, [i; j]];
            end
        elseif(~isempty(foundPL))
            if (foundPL > 0)
                embedding_pattern = de2bi(pair(1,foundPL),F_dim^2);
                embedding_pattern = [embedding_pattern(1:F_dim); embedding_pattern(F_dim+1:2*F_dim); embedding_pattern(2*F_dim+1:3*F_dim)];
                Img_halftoned(i:i+F_dim-1,j:j+F_dim-1) = embedding_pattern;
                Bit_stream = [Bit_stream, 1];
%                 uno = [uno, [i; j]];
            end
        end
        if(length(Bit_stream) >= LHb_length)
            break;
        end
end
for j = j_last+F_dim:F_dim:F_dim*floor(cols/F_dim)
    for i = 1:F_dim:F_dim*floor(rows/F_dim)
        I = 0;
        for ii = 1:F_dim
            for jj = 1:F_dim
                I = I + 2^((ii-1)*F_dim+jj-1)*Img_halftoned(i+ii-1,j+jj-1);
            end
        end
        foundPH = find(PH == I);
        foundPL = find(PL == I);
        if(~isempty(foundPH))
            if(foundPH > 0)
                Bit_stream = [Bit_stream, 0];
%                 nuno = [nuno, [i; j]];
            end
        elseif(~isempty(foundPL))
            if (foundPL > 0)
                embedding_pattern = de2bi(pair(1,foundPL),F_dim^2);
                embedding_pattern = [embedding_pattern(1:F_dim); embedding_pattern(F_dim+1:2*F_dim); embedding_pattern(2*F_dim+1:3*F_dim)];
                Img_halftoned(i:i+F_dim-1,j:j+F_dim-1) = embedding_pattern;
                Bit_stream = [Bit_stream, 1];
%                 uno = [uno, [i; j]];
            end
        end
        if(length(Bit_stream) >= LHb_length)
            break;
        end
    end
    if(length(Bit_stream) >= LHb_length)
        break;
    end
end

% LHb to LH
LHb = Bit_stream;
temp = F_dim^2+8;
length_lh = floor(length(LHb)/temp);
LH = zeros(2,length_lh);
for i = 1:length_lh
    LH(1,i) = bi2de(LHb(1+(i-1)*temp:F_dim^2+(i-1)*temp));
    LH(2,i) = bi2de(LHb(F_dim^2+1+(i-1)*temp:i*temp));
end
