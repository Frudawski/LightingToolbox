% CIE L*a*b* to CIE xyz
%
% The function cielab2xyz returns the colorimetric normalized standard
% colour values xyz (CIE 1931) for a given set of L*a*b* chromaticity coordinates.
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: xyz = cielab2xyz(lab,'wp','system')
%
% where:
% xyz:	Are the resulting CIE 1931 xyz chromaticity coordinates.
% lab:	Are the given CIE L∗a∗b∗ chromaticity coordinates.
% 'wp': (optional)Specifies the reference whitepoint, see list or use a vector 
%       triplet [x y z]. Default: ‘D65’
% 'system': (optional) CIE xyz observer:
%           'xyz' = 2° observer (default)
%           'xyz10' = 10° observer
%
% Reference:
%
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic Rudawski
% Date: 25.06.2018, updated 24.10.2021 (sunday)
% See: https://www.frudawski.de/cielab2xyz

function [xyz,x,y,z] = cielab2xyz(lab,wp,system)
 
L = lab(:,1);
a = lab(:,2);
b = lab(:,3);

if~exist('system','var')
    system = 'xyz';
end

% get whitepoint
if ~exist('wp','var')
    wp = ciewhitepoint('D65',system).*100;
else
    if ischar(wp)
        wp = ciewhitepoint(wp,system).*100;
    end
end

% treshold
eps = 24/116;

% initialize
xr = ones(size(L)).*NaN;
yr = ones(size(a)).*NaN;
zr = ones(size(b)).*NaN;

fy = (L+16)./116;
fx = a./500+fy;
fz = fy-b./200;

indx = fx>eps;
indy = L>8;
indz = fz>eps;

xr(indx)  = fx(indx).^3;
xr(~indx) = (fx(~indx)-16./116).*(108./841);
yr(indy)  = fy(indy).^3;
yr(~indy) = (fy(~indy)-16./116).*(108./841);
zr(indz)  = fz(indz).^3;
zr(~indz) = (fz(~indz)-16./116).*(108./841);

x = xr.*wp(1)./100;
y = yr.*wp(2)./100;
z = zr.*wp(3)./100;

xyz = [x y z];

end