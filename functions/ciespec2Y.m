% The function ciespec2Y returns the photometric value for a given spectral
% power distribution.
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: Y = ciespec2Y(lambda,spectrum,k)
%
% where: lambda is a wavelength vector and spectrum a vector or row-wise
% matrix of one or more spectra. k is the spectral luminous effiviency and
% optional. Standard value: k = 683.002 lm/W.
%
% Reference:
% ISO/CIE 11664-1:2019(E): Colorimetry - Part 1: CIE standard colorimetric 
% observers. Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-1-cie-standard-colorimetric-observers-0
%
% Author: Frederic Rudawski
% Date: 22.08.2017 - last edited: 24.11.2019
% See: https://www.frudawski.de/ciespec2Y

function Y = ciespec2Y(lambda,spec,k)

if ~exist('k','var')
    k = 683.002;
end

% Y determination
Y = ciespec2unit(lambda,spec,'y',k);

end