% CIE l*a*b* to LCh transformation.
%
% usage: lch = cielab2lch(lab)
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
% Date: 21.02.2022, updated: 04.03.2022
% see: https://www.frudawski.de/cielab2lch

function lch = cielab2lch(lab)

% seperate lab coordinates
L = lab(:,1);
a = lab(:,2);
b = lab(:,3);

% transform a & b  to c & h
c = (a.^2+b.^2).^(1/2);
for n = 1:length(a)
    if a(n)>=0 & b(n)>=0
        h(n) = atand(b(n)./a(n));
    elseif a(n)<0 & b(n)>=0
        h(n) = atand(b(n)./a(n))+180;
    elseif a(n)<0 & b(n)<0
        h(n) = atand(b(n)./a(n))+180;
    elseif a(n)>=0 & b(n)<0
        h(n) = atand(b(n)./a(n))+360;
    end
end

% combine to LCh
lch = [L c h'];



