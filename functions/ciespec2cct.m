% Derive correlated colour temperature (CCT) from spectral power distribution
% as in CIE 15:2018.
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see licence.
%
% usage:
% [Tcp,x,y,u,v] = ciespec2cct(lam,spec,method)
%
% where: 
% Tcp:  Returns the Correlated Colour Temperature (CCT) Tcp ​in K
% x and y: CIE 1931 chromaticity coordinates
% u and v: CIE 1960 chromaticity coordinates 
% lam:  Is a vector containing the wavelengths: 380:780 in 5 nm steps.
% spec: Defines the spectral power distribution (SPD)
% method: Defines the CCT determination method
%         'Robertson' = Robertson algorythm
%         'exact' = shortest distance to planckian locus
%
% Reference:
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage 
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% author: Frederic Rudawski
% Date: 06.03.20
% See: https://www.frudawski.de/ciespec2cct

function [Tcp,x,y,u,v] = ciespec2cct(lambda,spectrum,method)

xyz = ciespec2xyz(lambda,spectrum);
x = xyz(:,1);
y = xyz(:,2);

uvw = ciespec2uvw(lambda,spectrum);
u = uvw(:,1);
v = uvw(:,2);

if ~exist('method','var')
    method = 'Robertson';
end

switch method
    case 'Robertson'
        Tcp = RobertsonCCT('x',x,'y',y);
    case 'Hernandez'
        Tcp = HernandezCCT('x',x,'y',y);
    case 'exact'
        Tcp = CCT('x',x,'y',y);
    otherwise
        error('Unknown CCT method!')
end

