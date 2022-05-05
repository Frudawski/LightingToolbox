% CIE α-opic Equivalent Daylight D65 Quantity - EDQ
%
% usage: edq = cieedq(lam,spec,reference)
%
% with:  lam = wavelength steps
%        spec = spectral quantity
%        reference = α-opic reference:
%                    'sc' : s-cone-opic
%                    'mc' : m-cone-opic
%                    'lc' : l-cone-opic
%                    'rh' : rhodopic or scotopic
%                    'mel': melanopic
%                    'a-opic' : sc,mc,lc,rh,mel
%
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for 
% ipRGC-Influenced Responses to Light. Commission Internationale de l'Eclairage,
% Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
%
% Author: Frederic Rudawski
% Date: 29.05.2021 (Sunday)
% See: https://www.frudawski.de/cieedq


function EDQ = cieedq(lam,spec,reference)

% a-opic efficacy
S = ciespec(380:780,'D65');
k = ciek(380:780,S,reference);

% Equivalent Daylight (D65) Quantity
EDQ = ciespec2unit(lam,spec,reference)./k;

end


