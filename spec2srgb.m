% spec2srgb as specified in IEC 61966-2-1:1999
%
% usage: srgb = spec2srgb(lam,spec,mode,wp)
%
% where:
% srgb is the returned color matrix
% lam defines the wavelengts
% spec defines the spectral power distribution
% mode defines a rough white balancing
% wp defines an optional whitepoint
%
% The function includes gamma correction based on the Y values of the spectra.
%
% Transformation as described at:
% https://www.color.org/sRGB.pdf
%
% Chromatic adaptation method:
% http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
%
% Reference:
% IEC 61966-2-1:1999, Multimedia systems and equipment - Colour measurement
% and management - Part 2-1: Colour management - Default RGB colour space - 
% sRGB. Genf, Switzerland: International Electrotechnical Commission (IEC), 1999.
% https://webstore.iec.ch/publication/6168
%
% Author: Frederic Rudawski
% Date: 30.11.2021
% See: https://www.frudawski.de/spec2srgb

function srgb = spec2srgb(lam,spec,mode,wp,L)
  
% check for whitepoint
if ~exist('wp','var')
    wp = 'D65';
end
if isempty(wp)
  wp = 'D65';
end
if ~exist('mode','var')
  mode = 'none';
end

% transform spec2xyz2srgb
xyz = ciespec2xyz(lam,spec);
srgb = xyz2srgb(xyz,wp);

if ~strcmp(mode,'none')
% get luminance L from spectra
if ~exist('L','var')
    L = ciespec2Y(lam,spec);
end
% gamma correctiom
fa = (L./max(L(:))).*100;
fa(fa>(24/116)^3) = (fa(fa>(24/116)^3)).^(1/3);
fa(fa<=(24/116)^3) = (fa(fa<=(24/116)^3)).*841./108 + 16/116;
L = 116.*fa-16;
L = real((L./max(L(:))).^(1/2));

% rough white balancing
switch mode
    case 'min'
        wb = min(L(:));
    case 'mean'
        wb = mean(L(:));
    case 'obj'
        wb = max(L(:));
    case 'lum'
        wb = 1;
        L = 1;
        for n = 1:size(srgb,1)
           srgb(n,:) = srgb(n,:)./max(srgb(n,:)); 
        end
end
% apply corrections to image
srgb = (srgb.*L.*wb);
end

% ensure displayable color values
srgb(srgb<0) = 0;
srgb(srgb>1) = 1;

end
  
  
  