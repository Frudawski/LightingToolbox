% Blue Light Harzard
% As in IEC 62471:2006/CIE S 009:2002
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see license.
%
% usage: BLH = cieblh(lam,spec,t)
%
% with: lam = wavelength steps
%       spec = spectral radiance
%       t = exposure time in s
%
% the function reurns the struct BLH with the following elements:
%       BLH = Blue Light Hazard value
%       hazard = 'yes','no', signals if exposure is hazardous
%       tmax = maximum permissible exposure time in s for L > 100 W m-^2 sr-^1
%              NaN if L < 100 W m-^2 sr-^1
%
% for t <= 10^4 s, BLH should not exceed 10^6 J m^-2 sr^-1
% for t >  10^4 s, BLH should not exceed 100  W m^-2 sr^-1
%
% Reference:
% IEC 62471:2006/CIE S 009:2002: Photobiological safety of lamps and lamp systems
%  / Sécurité photobiologique des lampes et des appareils utilisant des lampes 
% (bilingual edition). Commission Internationale de l'Eclairage (CIE), 
% Vienna Austria, 2002.
% https://cie.co.at/publications/photobiological-safety-lamps-and-lamp-systems-s-curit-photobiologique-des-lampes-et-des
%
% Author: Frederic Rudawski
% Date: 29.05.2021, last update: 21.07.2023
% See: https://www.frudawski.de/cieblh

function blh = cieblh(lam,Le,t)

% initialize tmax
tmax = zeros(1,size(Le,1)).*NaN;

% BLH determination depending on exposure time
if t <= 1e4
    b = [ciespec2unit(lam,Le,'BLH',1).*t]';
    T = t;
    for n = 1:length(b)
        if b(n) > 1e6
            hazard{n} = 'yes';
        else
            hazard{n} = 'no';
        end
    end
else
    T = ones(size(t));
    b = ciespec2unit(lam,Le,'BLH',1)';
    for n = 1:length(b)
        if b(n) > 1e2
            hazard{n} = 'yes';
        else
            hazard{n} = 'no';
        end
    end
end

% maximum permissible exposure time
for n = 1:size(Le,1) 
    if sum(Le(n,:)) > 100
        tmax(n) = 1e6./b(n)*T(n);
    end
end

% return struct
blh.BLH = b;
blh.hazard = hazard;
blh.tmax = tmax;

end
