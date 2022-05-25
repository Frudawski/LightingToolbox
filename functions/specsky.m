% Spectral sky data for CIE sky types 3 (overcast) and 12 (clear sky) for a
% Tregenza hemisphere with 145 patches.
% 
% usage: [spec,lam,L,CCT,x,y,rgb] = specsky(type,sunaz,sunel,'target',value,'mode',value)
%
% with:
% - spec: spectral power distribution
% - lam: wavelengths in nm (lambda)
% - L: Tregenza luminance distribution, columnwise
% - CCT: Correlated Colour Temperature
% - type: cie sky type (1-15), multiple sky types as vector
% - sun_azimuth: sun azimuth angle in °. The azimuth angle starts in north
%   and goes clockwise.
% - sun_elevation: sun eleavation angle in °
% - target (optional): valid values:
%                      - target unit, zenith luminance 'Lz' or
%                      - horizontal illuminance 'Eh'
% - mode (otional): valid values:
%                   - 'center' uses patch center for luminance determination
%                   - 'mean' uses mean of patchcorner luminances as suggestes
%                      by Tregenza in Tregenza, P. R. (2004). "Analysing sky 
%                      luminance scans to obtain frequency distributions of CIE
%                      Standard General Skies"
%
%
% References:
%
% Chain C, Dumortier D, Fontoynont M. A
% comprehensive model of luminance, correlated
% colour temperature and spectral distribution of
% skylight: comparison with experimental data.
% Solar Energy 1999; 65: 285–295.
%
% ISO 15469:2004(E)/CIE S 011/E:2003: Spatial Distribution of Daylight - 
% CIE Standard General Sky. Commission Internationale de l'Éclairage (CIE),
% Vienna Austria, 2004.
% https://cie.co.at/publications/spatial-distribution-daylight-cie-standard-general-sky
%
% Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103).
% https://journals.sagepub.com/doi/10.1177/096032718701900103
% 
% Author: Frederic Rudawski
% Date: 18.05.2022

function [spec,lam,L,Tcp,x,y,rgb] = specsky(type,sunaz,sunel,varargin)

p = inputParser;
validVar = @(f) isnumeric(f) || isvector(f);
addRequired(p,'type',validVar);
addRequired(p,'sunaz',@isnumeric);
addRequired(p,'sunel',@isnumeric);
addParameter(p,'Lz',1,@isnumeric)
addParameter(p,'Eh',-1,@isnumeric)
addParameter(p,'mode','center')
parse(p,type,sunaz,sunel,varargin{:})

type = p.Results.type;
sunaz = p.Results.sunaz;
sunel = p.Results.sunel;
Lz = p.Results.Lz;
Eh = p.Results.Eh;

if ~isequal(Lz,1)
    sky_mode = 'Lz';
    sky_value = Lz;
elseif ~isequal(Eh,-1)
    sky_mode = 'Eh';
    sky_value = Eh;
end
if ~exist('sky_mode','var')
    sky_mode = 'Eh';
    sky_value = 1e4;
end

% get luminance distribution from ciesky function
L = ciesky(type,sunaz,sunel,sky_mode,sky_value);

% approximate CCT from luminance distribution:
switch type
    case 3
        Tcp = ones(145,1).*6415;
    case 12
        Tcp = 1e6./(-132.1+59.77.*log10(L));
    otherwise
        error('Sky types supported: 3 and 12')
end

% Determine spectral power distribution for daylight from CCT
[spec,lam,x,y] = ciecct2spec(Tcp);

% calculate luminance of CCT spectrum
Y = ciespec2Y(lam,spec);

% weight radiance distribution with luminance data
spec = spec.*L./Y;

% determine srgb patch colours
rgb = xyz2srgb([x y 1-x-y]);



