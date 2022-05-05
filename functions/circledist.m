% Determines angular distance on circle:
%
% usage:  ang = circledist(a1,a2,mode)
%
% with: ang: return angel distande
%       a1: angle 1 on cirlce in °
%       a2: angle 2 on circle in °
%       mode: specifies return mode
%             'normal' = angular distance from a1 to a2
%             'abs' = absolute angular distance (positive)
%
% Author: Frederic Rudawski
% Date: 13.03.2021 - saturday

function ang = circledist(a1,a2,mode)

if ~exist('mode','var')
    mode = 'normal';
end

if strcmp(mode,'abs')
    while a1>360
        a1 = a1-360;
    end
    while a2>360
        a2 = a2-360;
    end
    while a1<0
        a1 = a1+360;
    end
    while a2<0
        a2 = a2+360;
    end
    
    ang = sort([a1 a2]);
    a = ang(2)-ang(1);
    b = ang(1)-ang(2)+360;
    ang = min(a,b);
    
elseif strcmp(mode,'normal')
    % with direction
    while a1>360
        a1 = a1-360;
    end
    while a2>360
        a2 = a2-360;
    end
    while a1<0
        a1 = a1+360;
    end
    while a2<0
        a2 = a2+360;
    end
    
    %ang = sort([a1 a2]);
    ang = [a1 a2];
    a = ang(2)-ang(1);
    b = ang(2)-ang(1)+360;
    c = ang(2)-ang(1)-360;
    v = [a b c];
    [~,idx] = min(abs(v));
    ang = v(idx);
end