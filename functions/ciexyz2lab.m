% CIE xyz to CIE lab
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: lab = ciexyz2lab(xyz,wp,observer)
%
% Where:
% lab: Are the given CIE L∗a∗b chromaticity coordinates.
% xyz:Are the resulting CIE 1931 xyz chromaticity coordinates.
% 'wp': (optional) Specifies the reference whitepoint, see list (online) or 
%       use a vector triplet [x y z]. Default: ‘D65’
% observer: (optional)	CIE xyz observer:
%           'xyz' = 2° observer (default)
%           'xyz10' = 10° observer
% 
% Reference:
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic Rudawski
% Date: 25.06.2018, updated 24.10.2021 (sunday)
% See: https://www.frudawski.de/ciexyz2lab

function [lab,l,a,b] = ciexyz2lab(xyz,wp,system)
 
x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

if ~exist('system','var')
    system = 'xyz';
end

% get whitepoint
if ~exist('wp','var')
    WP = ciewhitepoint('D65',system);
else
    if ischar(wp)
        WP = ciewhitepoint(wp,system);
    end
end

% reference white
xr = xyz(:,1)./WP(1);
yr = xyz(:,2)./WP(2);
zr = xyz(:,3)./WP(3);

% treshold
eps = (24/116)^3;

% initialize
fx = ones(size(x)).*NaN;
fy = ones(size(y)).*NaN;
fz = ones(size(z)).*NaN;

indx = xr>eps;
indy = yr>eps;
indz = zr>eps;

fx(indx)  = nthroot(xr(indx),3);
fx(~indx) = (814./108).*(xr(~indx))+16./116;
fy(indy)  = nthroot(yr(indy),3);
fy(~indy) = (814./108).*(yr(~indx))+16./116;
fz(indz)  = nthroot(zr(indz),3);
fz(~indz) = (814./108).*(zr(~indx))+16./116;

L = 116.*fy-16;
a = 500.*(fx-fy);
b = 200.*(fy-fz);

lab = [L a b];

end