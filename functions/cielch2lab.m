% CIE LCh to  l*a*b* transformation.
%
% usage: lab = cielch2lab(lch)
%
% Reference:
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% Author: Frederic Rudawski
% Date: 21.02.2022
% see: https://www.frudawski.de/cielab2lch

function lab = cielch2lab(lch)

% seperate LCh coordinates
L = lch(:,1);
C = lch(:,2);
h = lch(:,3);

% transform C & h to a* and b*
a = C.*cosd(h);
b = C.*sind(h);

% combine to L*a*b*
lab = [L a b];



