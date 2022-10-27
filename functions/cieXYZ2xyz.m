% Returns the normalized tristimulus values xyz from XYZ:
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage xyz = cieXYZ2xyz(XYZ)
%
% Reference:
% ISO/CIE 12664-3:2019(E): Colorimetry - Part 3: CIE tristimulus values.
% Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-3-cie-tristimulus-values-2
%
% Author: Frederic Rudawski
% Date: 24.11.2019 (Sunday)
% See: https://www.frudawski.de/cieXYZ2xyz


function [xyz,x,y,z] = cieXYZ2xyz(XYZ)

x = XYZ(:,1)./sum(XYZ,2);
y = XYZ(:,2)./sum(XYZ,2);
z = XYZ(:,3)./sum(XYZ,2);

xyz = [x y z];

