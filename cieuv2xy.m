% CIE 1960 u,v to CIE 1931 x,y transformation.
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: [x,y] = cieuv2xy(u,v)
%
% Reference:
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic Rudawski
% Date: 26.06.2018
% See: https://www.frudawski.de/cieuv2xy

function [x,y] = cieuv2xy(u,v)

% transformation
x = 3.*u ./ (2.*u-8.*v+4);
y = 2.*v ./ (2.*u-8.*v+4);

end
