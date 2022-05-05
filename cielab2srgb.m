% CIE L*a*b* to srgb
%
% Author: Frederic Rudawski
% Date: 21.11.2019

function [srgb,r,g,b] = cielab2srgb(lab,wp)


% transformation
try
    xyz = cielab2xyz(lab,wp);
    [srgb,r,g,b] = xyz2srgb(xyz,wp);
catch
    xyz = cielab2xyz(lab);
    [srgb,r,g,b] = xyz2srgb(xyz);
end
