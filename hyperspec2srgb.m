% Trasnforms a hyperspectral image to srgb image including gamma correction
% and rough white balancing.
% 
% usage:   
% srgb = hyperspec2srgb(im,lambda)
%
% Where:
% im is either a struct containing the image data im.image and the corresponding
% wavelength im.lambda, or im is a 3-dim matrix and lambda provides the
% corresponding wavelengths.
%
% Author: Frederic Rudawski
% Date: 25.22.2021
% See: https://www.frudwaski.de/hyperspec2srgb


function srgbI = hyperspec2srgb(IM,lambda)

% check input
if isstruct(IM)
    lambda = IM.lambda;
    IM = IM.image;
end

% transform hyperspec image to CIE xyz values to srgb values
IMM = reshape(IM,size(IM,1)*size(IM,2),size(IM,3));
%xyz = ciespec2xyz(lambda,IMM);
%srgb = xyz2srgb(xyz);
srgb = spec2srgb(lambda,IMM);
I = reshape(srgb,size(IM,1),size(IM,2),3);

% get luminance L from spectra
L = reshape(ciespec2unit(lambda,reshape(IM,size(IM,1)*size(IM,2),size(IM,3)),'VL'),size(IM,1),size(IM,2));
% gamma correctiom
fa = (L./max(L(:))).*100;
fa(fa>(24/116)^3) = (fa(fa>(24/116)^3)).^(1/3);
fa(fa<=(24/116)^3) = (fa(fa<=(24/116)^3)).*841./108 + 16/116;
L = 116.*fa-16;
L = real((L./max(L(:))).^(1/2));
% rough white balancing
I(isnan(I)) = 0;
wb = max(L(:))/max(mean(I(I~=0)));
% apply corrections to image
srgbI = (I.*L.*wb);
% ensure displayable color values
srgbI(srgbI<0) = 0;
srgbI(srgbI>1) = 1;



