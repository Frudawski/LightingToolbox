% CIE melanopic equivalent daylight (D65) illuminance
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: medi = ciemedi(lam,spec)
%
% Reference
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for
% ipRGC-Influenced Responses to Light. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
%
% Author: Frederic Rudawski
% Date: 08.12.2021
% See: https://www.frudawski.de/ciemedi

function medi = ciemedi(lam,spec)

medi = cieedq(lam,spec,'mel');

