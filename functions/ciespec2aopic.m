% α-opic values from spectral power distribution (SPD).
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage:
%
%   aopic = ciespec2aopic(lam,spec)
%
% Reference
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for ipRGC-
% Influenced Responses to Light. Commission Internationale de l'Eclairage,
% Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
%
% Autohr: Frederic Rudawski
% Date: 22.06.2021
% See: https://www.frudawski.de/ciespec2aopic

function a = ciespec2aopic(lam,spec)

a = ciespec2unit(lam,spec,'a-opic');

end