% The function ciespec2uvw returns the colorimetric normalized standard
% colour values uvw (CIE 1960) for a given spectral power distribution.
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: uvw = ciespec2uvw(lambda,spectrum)
%
% where: lambda is a wavelength vector, spectrum is a vector or row-wise
% matrix of several spectra.
%
% to get u and v as seperate scalars or vectors:
% 
%       [uvw,u,v,w] = ciespec2uvw(lambda,spectrum)
%
%       The following function call returns only u's and v's as vectors.
%       [~,u,v] = ciespec2uvw(lambda,spectrum)
%
% References:
% David Lewis MacAdam: Projective Transformations of I. C. I. Color Specifications. 
% In: Journal of the Optical Society of America, vol. 27, no. 8, pp. 294-299, 1937, 
% DOI: 10.1364/JOSA.27.000294
% https://opg.optica.org/josa/abstract.cfm?uri=josa-27-8-294
%
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% Author: Frederic Rudawski
% Date: 20.11.2019
% See: https://www.frudawski.de/ciespec2uvw

function [uvw,u,v,w] = ciespec2uvw(lambda,spec)

% xyz normalized standard colour values
xyz = ciespec2xyz(lambda,spec);
% transformation xy to uv
[u,v] = ciexy2uv(xyz(:,1),xyz(:,2));
w = 1-u-v;

% CIE 1960 uvw colour coordinates
uvw = [u v w];

end