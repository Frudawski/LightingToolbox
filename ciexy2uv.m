% CIE 1931 x,y to CIE 1960 u,v transformation:
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: [u,v] = ciexy2uv(x,y)
%
% Reference:
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic Rudawski
% Date: 26.06.2018
% See: https://www.frudawski.de/ciexy2uv

function [u,v] = ciexy2uv(x,y)

% transformation
u = 4.*x ./ (-2.*x + 12.*y + 3);
v = 6.*y ./ (-2.*x + 12.*y + 3);

end
