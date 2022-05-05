% The function ciespec2xyz returns the colorimetric normalized standard
% color values xyz (CIE 1931) for a given radiometric spectrum.
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: xyz = ciespec2xyz(lambda,spectrum)
%
% where: lambda is a wavelength vector, spectrum is a vector or row-wise
% matrix of several spectra.
%
% You can get also return values as vectors:
% 
%       [xyz,x,y,z,XYZ] = ciespec2xyz(lambda,spectrum)
%
%       The following function call returns only x's and y's as vectors.
%       [~,x,y] = ciespec2xyz(lambda,spectrum)
%
%
% Reference:
% ISO/CIE 11664-1:2019(E): Colorimetry - Part 1: CIE standard colorimetric 
% observers. Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-1-cie-standard-colorimetric-observers-0
%
% Author: Frederic Rudawski
% Date: 22.08.2019- last edited 20.11.2019
% see: https://www.frudawski.de/ciespec2xyz

function [xyz,x,y,z,XYZ] = ciespec2xyz(lambda,spec)

% XYZ standard Tristimulus values
XYZ = ciespec2unit(lambda,spec,'xyz');
x = XYZ(:,1)./sum(XYZ,2);
y = XYZ(:,2)./sum(XYZ,2);
z = XYZ(:,3)./sum(XYZ,2);

% CIE 1931 xyz normalised colour coordinates
xyz = [x y z];

end