% Age dependent spectral lens tranmittance correction for 32 year old 
% reference observer, according to CIE 203 & CIE S026.
%
% usage: c = ciespecagecorr(age,lam)
%
% where: 
% age defines the transission age, scalar or vector. 
% lam is a vector containing the reference wavelengths (optional), default: 300:5:700 
%
% References:
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for ipRGC-Influenced Responses to Light. Commission Internationale de l'Eclairage, Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
%
% CIE 203:2012 (incl. Erratum), A COMPUTERIZED APPROACH TO TRANSMISSION AND ABSORPTION CHARACTERISTICS OF THE HUMAN EYE, Commission Internationale de l'Eclairage (CIE), Vienna Austria, ISBN: 978-3-902842-43-5.
% https://cie.co.at/publications/computerized-approach-transmission-and-absorption-characteristics-human-eye
% 
% Author: Frederic Rudawski
% Date: 26.11.2023 (Sunday)



function [corr,lam] = ciespecagecorr(age,lam)

if ~exist('lam','var')
    lam = 300:5:700;
end

% check vector orientation
if isrow(age)
    age = age';
end

% 32 year old reference transmission
ref32 = ciespecagetrans(32,lam);

% age transmission according to CIE 203
trans = ciespecagetrans(age,lam);

% Age transmission correction according to CIE S026
corr = trans./ref32;

