% reference illuminants whitepoints:
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: wp = ciewhitepoint(reference,obs)
%
%   where: reference is the whitepoint reference:
%          'A','C','D50','D55','D65','D75','FL1',...
%          obs represents the observer used:
%          'xyz' (default, 2 degree), 'xyz10', 'rgb'
%
% References:
%
% ISO/CIE 11664-1:2019(E): Colorimetry - Part 1: CIE standard colorimetric
% observers. Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-1-cie-standard-colorimetric-observers-0
%
% ISO 11664-2:2007(E)/CIE S 014-2/E:2006: Colorimetry - Part 2: CIE standard
% illuminants. Commission International de l’Éclairage (CIE), Vienna Austria, 2007.
% https://cie.co.at/publications/colorimetry-part-2-cie-standard-illuminants-0
%
% CIE 15:2018: Colorimetry, 4th Edition. Commission International de l’Éclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic  Rudawski
% Date: 22.11.2019
% updated: 24.11.2019 (Sunday), 04.11.2021
% See: https://www.frudawski.de/ciewhitepoint

function [wp,abc] = ciewhitepoint(reference,obs)

% set observer
if ~exist('sys','var')
    obs = 'xyz';
end

% get whitepoint
lambda = 300:830;
spec = ciespec(lambda,reference);
[wp,abc] = ciespec2wp(lambda,spec,obs);
