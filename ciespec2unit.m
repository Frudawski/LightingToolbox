% ciespec2unit weight a given spectrum by a certain weighting
% function and returns the integrated value(s).
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see licence.
%
% usage: m = ciespec2unit(lambda,spec,'reference',k)
% where: m are the return values e.g. XYZ
%        spec is the given spectral distribution to be weighted
%        'reference' specifies the weighting function
%         k is the luminous efficacy factor, for photopic vision 683 lm/W
%
%        references:
%        'x'   = 2 degree tristimulus function x bar
%        'y'   = 2 degree tristimulus function y bar equals V(lambda) 'VL'
%        'z'   = 2 degree tristimulus function z bar
%        'xyz' = 2 degree tristimulus funciots x bar, y bar and z bar
%        'x10' = 10 degree tristimuls function x10 bar
%        'y10' = 10 degree tristimulus funtcion y10 bar
%        'z10' = 10 degree tristimulus function z10 bar
%        'xyz10' = 10 degree tristimulus funciots x10 bar, y10 barand z10 bar
%        'r'   = CIE r bar function - note: source only 380:5:780 nm
%        'g'   = CIE g bar function - note: source only 380:5:780 nm
%        'b'   = CIE b bar function - note: source only 380:5:780 nm
%        'rgb' = CIE rgb bar function - note: source only 380:5:780
%        'VL'  = V(lambda) and tristimulus function ybar 'y'
%        'V-L' = V'(lambda) equals rhodopic/scotopic 'rh'
%        'sc'  = retinal ganglion cells: s-cone-opic or cyanopic
%        'mc'  = retinal ganglion cells: m-cone-opic or chloropic
%        'lc'  = retinal ganglion cells: l-cone-opic or erythropic
%        'rh'  = retinal ganglion cells: rhodopic or scotopic equals V'(lmabda) 'V-L'
%        'mel' = retinal ganglion cells: melanopic
%        'a-opic' = retinal ganglion cells: s,m,l-cone, rh and mel
%
% References:
%
% ISO/CIE 11664-1:2019(E): Colorimetry - Part 1: CIE standard colorimetric observers.
% Commission International de l’Éclairage (CIE), Vienna Austria, 2019.
% https://cie.co.at/publications/colorimetry-part-1-cie-standard-colorimetric-observers-0
%
% CIE 15:2018: Colorimetry, 4th Edition. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-editionv
%
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for ipRGC-
% Influenced Responses to Light. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
%
% IEC 62471:2006/CIE S 009:2002: Photobiological safety of lamps and lamp systems /
% Sécurité photobiologique des lampes et des appareils utilisant des lampes 
% (bilingual edition). Commission Internationale de l'Éclairage (CIE), 
% Vienna Austria, 2002.
% https://cie.co.at/publications/photobiological-safety-lamps-and-lamp-systems-s-curit-photobiologique-des-lampes-et-des
%
% Author: Frederic Rudawski
% Date: 17.11.2019 (Sunday) - last edited: 22.06.2021
% See: https://www.frudawski.de/ciespec2unit

function m = ciespec2unit(lambda,spec,reference,K,maxdlam)

if size(lambda,1) > size(lambda,2)
    lambda = lambda';
    spec = spec';
end

try
    ref = whos('reference','var');
    if strcmp(ref.class,'char')
        reference = {reference};
    end
    if strcmp(ref.class,'double')
        W = reference;
        reference = {'weightingfunction'};
    end
catch
end

if ~exist('maxdlam','var')
    maxdlam = 100;
end

lam = lambda;
[lambda,idx] = sort(lambda);

% spectral range
range(1) = lambda(1);
range(2) = lambda(end);

% lambda range indices
[~,First] = min(abs(lambda(1,:)-range(1)));
[~,Last]  = min(abs(lambda(1,:)-range(2)));

% lamba step width
wave = lambda(lambda~=0);

if ~isempty(wave)
    if wave(1) >= range(1)
        leftstep = zeros(size(lambda));
        leftstep(1) = (lambda(1,2)-lambda(1,1))/2;
        leftstep(end) = (lambda(1,end)-lambda(1,end-1))/2;
        leftstep(2:end-1) = (lambda(1,First+1:Last-1) - lambda(1,First:Last-2))./2;
    else
        leftstep  = (lambda(1,First:Last) - lambda(1,First-1:Last-1))./2;
    end
    if wave(end) <= range(2)
        rightstep = zeros(size(lambda));
        rightstep(1) = (lambda(1,2)-lambda(1,1))/2;
        rightstep(end) = (lambda(1,end)-lambda(1,end-1))/2;
        rightstep(2:end-1) = (lambda(1,First+2:Last) - lambda(1,First+1:Last-1))./2;
    else
        rightstep = (lambda(1,First+1:Last+1) - lambda(1,First:Last))./2;
    end
    lam = leftstep+rightstep;
else
    lam = ones(size(lambda)).*NaN;
end

lam(lam>maxdlam) = maxdlam;

wf = zeros(size(lambda));
m = [];

for c = 1:size(reference,2)
    
    % luminous efficacy factor
    if ~exist('K','var')
        switch reference{c}
            case 'V-L'
                k = 1700.05; % lm/W
            case {'sc','mc','lc','rh','mel','a-opic','aopic'}
                k = 1;
            case 'weightingfunction'
                k = 1;
            otherwise
                k = 683.002; % lm/W
        end
    else
        k = K;
    end
    
    % weighting function(s)
    if isequal(strcmp(reference{c},'weightingfunction'),1)
        wf = W;
    else
        eval(['wf = ciespec(lambda,''',reference{c},''');']);
    end
    
    % actual calculation
    M = ((lam.*spec(:,idx))*wf').*k;
    m = [m M];
    
end


