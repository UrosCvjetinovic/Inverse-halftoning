function [pairs, Embed_cap] = find_patterns(Im_halftoned, template_size)
%FIND_PATTERNS This function is used to find patterns that dont exist in the
%   halftone image and their similar patterns that are frequent in the image
%   [pairs, Embed_cap] = find_patterns(Im_halftoned, template_size)
%       finds the pairs and calculates the amount of bits that can be
%       embedded
%   Img_halftoned is a halftone image
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   pairs is a table (PH,PL) of frequent patterns and similar ones that
%       dont exist in the halftone image
%   Embed_cap is the number of bits that can be embedded



[rows,cols] = size(Im_halftoned);

switch template_size
    case '3x3'
        F_dim = 3;
        numOfPatterns = 512;
        N = zeros(1,numOfPatterns);
        for i = 1:F_dim:F_dim*floor(rows/F_dim)
            for j = 1:F_dim:F_dim*floor(cols/F_dim)
                I = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Im_halftoned(i+ii-1,j+jj-1);
                    end
                end
                N(I+1) = N(I+1)+1;
            end
        end
        
    case '4x4'
        F_dim = 4;
        numOfPatterns = 65536;
        N = zeros(1,numOfPatterns);
        for i = 1:F_dim:F_dim*floor(rows/F_dim)
            for j = 1:F_dim:F_dim*floor(cols/F_dim)
                I = 0;
                for ii = 1:F_dim
                    for jj = 1:F_dim
                        I = I + 2^((ii-1)*F_dim+jj-1)*Im_halftoned(i+ii-1,j+jj-1);
                    end
                end
                N(I+1) = N(I+1)+1;
            end
        end
    otherwise
        error('Template size is either string 3x3 or 4x4');
end

[freq_PH, PH] = sort(N, 'descend');
% After halftoning we find the PH patterns

% Select PL patterns
numOfUsed = numOfPatterns;
j = 1;
i = 1;
PL = zeros(1,sum(freq_PH(:) == 0));
freq_PL = zeros(1,length(PL(:)));
while(i <= numOfUsed)
    if (freq_PH(i) == 0)
        PL(j) = PH(i);
        freq_PL(j) = freq_PH(i);
        j = j+1;
        PH(i) = [];
        freq_PH(i) = [];
        i = i - 1;
        numOfUsed = numOfUsed - 1;
    end
    i = i + 1;
end
numOfUnused = j - 1;
TC = numOfUnused;

% select pairs PH,PL

if numOfUnused > numOfUsed
    
    embed_freq = freq_PH;
    temp_PL = PL;
    pairs = zeros(2,numOfUsed);
    pairs(1,:) = PH;
    for i = 1:numOfUsed
        j = 1;
        distanceb = zeros(F_dim^2,numOfUnused);
        distance = zeros(1,numOfUnused);
        while( j <= numOfUnused)
            distanceb(:,j) = xor(de2bi(PH(i)-1,F_dim^2),de2bi(temp_PL(j)-1,F_dim^2));
            error_vector = distanceb(:,j);
            distance(j) = sum(error_vector(:)==1);
            distance(j) = distance(j) + weight(PH(i)-1,temp_PL(j)-1,template_size);
            j = j + 1;
        end
        globaMinIndexes = find(distance == min(distance));
        indx =  min(globaMinIndexes);
        pairs(2,i) = temp_PL(indx);
        temp_PL(indx) = [];
        numOfUnused = numOfUnused - 1;
    end
else
    embed_freq = zeros(1,numOfUnused);
    temp_freq = freq_PH;
    temp_PH = PH;
    pairs = zeros(2,numOfUnused);
    pairs(2,:) = PL;
    for i = 1:numOfUnused
        j = 1;
        distance = zeros(1,numOfUsed);
        while( j <= numOfUsed)
            distance(j) = xor(de2bi(temp_PH(j)-1,F_dim^2),de2bi(PL(i)-1,F_dim^2));
            error_vector = distance(j);
            transitions = find(diff([0; error_vector(:); 0]));
            distance(j) = transitions(2:2:end) - transitions(1:2:end);
            distance(j) = distance(j) + weight(temp_PH(j)-1,PL(i)-1,template_size);
            j = j + 1;
        end
        globaMinIndexes = find(distance == min(distance));
        indx =  min(globaMinIndexes);
        pairs(1,i) = temp_PH(indx);
        embed_freq(i) = temp_freq(indx);
        temp_freq(indx) = [];
        temp_PH(indx) = [];
        numOfUsed = numOfUsed - 1;
    end
end

pairs = pairs - 1;

% Check if we can embed data
Embed_cap = 0;
for i = 1:size(embed_freq)
    Embed_cap = Embed_cap + embed_freq(i);
end
