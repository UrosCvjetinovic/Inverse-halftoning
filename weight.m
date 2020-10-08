function out = weight(PH,PL,template_size)
%WEIGHT This function is used to add to the diffrence of patterns that seem
%   similar to the computer, but not to a human eye
%   out = weight(PH,PL,template_size)
%       If PH and PL are a certain way the output is 1
%   Valid values for template_size are:
%       '3x3' uses 3x3 blocks to calculate templates
%       '4x4' uses 4x4 blocks to calculate templates
% 
%   out is the output that adds weight for finding patterns for embedding

out = 0;

switch template_size
    case '3x3'
        F_dim = 3;
    case '4x4'
        F_dim = 4;
    otherwise
        error('Template size is either string 3x3 or 4x4');
end
PHb = de2bi(PH,F_dim^2);
PLb = de2bi(PL,F_dim^2);
PHb = [PHb(1:3); PHb(4:6); PHb(7:9)];
PLb = [PLb(1:3); PLb(4:6); PLb(7:9)];


if( (PHb(1,1) == 1) && (PHb(1,2) == 0) &&(PHb(2,1) == 0) && (PL(1,1) == 0))
    out = 1;
end


switch template_size
    case '3x3'
        
        a = [0,0,0];
        b = [0;0;0];
        if((PH == 146) && isequal(PLb(:,2),b))
            out = 1;
        end
        if((PH == 56) && isequal(PLb(2,:),a))
            out = 1;
        end
        if( (PHb(1,3) == 1) && (PHb(1,2) == 0) &&(PHb(2,3) == 0) && (PLb(1,3) == 0))
            out = 1;
        end
        if( (PHb(3,1) == 1) && (PHb(2,1) == 0) &&(PHb(3,2) == 0) && (PLb(3,1) == 0))
            out = 1;
        end
        if( (PHb(3,3) == 1) && (PHb(2,3) == 0) &&(PHb(3,2) == 0) && (PLb(3,3) == 0))
            out = 1;
        end
    case '4x4'
        a = [0,0,0,0];
        b = [0;0;0;0];
        if((PH == 26214) && isequal(PLb(:,2:3),b))
            out = 1;
        end
        if((PH == 4080) && isequal(PLb(2:3,:),a))
            out = 1;
        end
        if( (PHb(1,4) == 1) && (PHb(1,3) == 0) &&(PHb(2,4) == 0) && (PLb(1,4) == 0))
            out = 1;
        end
        if( (PHb(4,1) == 1) && (PHb(3,1) == 0) &&(PHb(4,2) == 0) && (PLb(4,1) == 0))
            out = 1;
        end
        if( (PHb(4,4) == 1) && (PHb(3,4) == 0) &&(PHb(4,3) == 0) && (PLb(4,4) == 0))
            out = 1;
        end
    otherwise
        error('Template size is either string 3x3 or 4x4');
end
