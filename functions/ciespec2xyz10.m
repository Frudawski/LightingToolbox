% The function ciespec2xyz10 returns the colorimetric normalized standard
% color values xyz (CIE 1931) for the standard 10 degree observer (1964)
% for a given radiometric spectrum.
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: xyz = ciespec2xyz(lam,spec
% where: lambda is a wavelength vector, spectrum is a vector or row-wise
% matrix of several spectra.
%
% You can get also return values as vectors:
% 
%       [xyz10,x10,y10,z10,XYZ10] = ciespec2xyz10(lam,spec)
%
%       The following function call returns only x's and y's as vectors.
%       [~,x10,y10] = ciespec2xyz10(lam,spec)
%
%
% Reference:
% ISO/CIE 11664-1:2019(E): Colorimetry - Part 1: CIE standard colorimetric 
% observers. Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-1-cie-standard-colorimetric-observers-0
%
% Author: Frederic Rudawski
% Date: 26.10.2022
% see: https://www.frudawski.de/ciespec2xyz10


function [xyz10,x10,y10,z10,XYZ10] = ciespec2xyz10(lam,spec)

XYZ10 = ciespec2unit(lam,spec,'xyz10');
[xyz10,x10,y10,z10] = cieXYZ2xyz(XYZ10);
