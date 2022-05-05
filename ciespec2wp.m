% CIE whitepoint from spectral power distribution.
% Y equals 1 for XYZ system.
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
% 
% usage: [XYZ,xyz] = ciespec2wp(lam,spec,observer)
%
% Where:
% XYZ:	Are the retuned tristimulus values of the standard illuminant, scaled so that Y=1.
% xyz:	Are the returned normalized tristimulus values, scaled so that x+y+z=1.
% lam:	Defines the wavelengths, vector
% spec:	Defines the spectral power distribution(s), vector or matrix
% observer: Specifies the standard observer:
%           'xyz' = standard 2° observer (default)
%           'xyz10' = standard 10° observer
%
% References:
% ISO/CIE 11664-1:2019(E): Colorimetry - Part 1: CIE standard colorimetric 
% observers. Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-1-cie-standard-colorimetric-observers-0
%
% CIE 15:2018: Colorimetry, 4th Edition. Commission International de l’Éclairage 
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic  Rudawski
% Date: 22.11.2019
% See: https://www.frudawski.de/ciespec2wp

function [wp,abc] = ciespec2wp(lambda,spec,sys)

% set colour system
if ~exist('sys','var')
    sys = 'xyz';
end

ABC = ciespec2unit(lambda,spec,sys);
wp = ABC./ABC(:,2);
abc = wp./sum(wp,2);
