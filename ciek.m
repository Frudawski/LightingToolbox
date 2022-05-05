% ciek returns the luminous (or blue light hazard) efficacy/efficacies according to 
% CIE S026 sec. 3.4. (α-opic) and CIE TN 002 sec. 2.1. (blue light hazard).
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: k = ciek(lambda,spec,'reference')
%
% where: k is/are the return value/s (e.g. K_mel,v) in W/lm
%        lambda is vector containing the corresponding wavelengths
%        spec is/are the given spectral distribution/s
%        'reference' specifies the a-opic weighting function
%
%        references:
%        'sc'  = retinal ganglion cells: s-cone-opic or cyanopic
%        'mc'  = retinal ganglion cells: m-cone-opic or chloropic
%        'lc'  = retinal ganglion cells: l-cone-opic or erythropic
%        'rh'  = retinal ganglion cells: rhodopic or scotopic
%        'mel' = retinal ganglion cells: melanopic
%        'a-opic' = retinal ganglion cells: sc, mc, lc, rh and mel
%        'BLH' = Blue Light Hazard
%
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for 
% ipRGC-Influenced Responses to Light. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
% 
% CIE TN 002:2014: Relating Photochemical and Photobiological Quantities to 
% Photometric Quantities. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2014.
% https://cie.co.at/publications/relating-photochemical-and-photobiological-quantities-photometric-quantities
% 
% Author: Frederic Rudawski
% Date: 10.12.2020, last edited 06.06.2021 sunday
% See: https://www.frudawski.de/ciek


function k = ciek(lambda,spec,reference)
%{
p = inputParser;
addRequired(p,'lambda',@isvector);
addRequired(p,'spec',@isvector || @ismatrix);
addRequired(p,'reference',@ischar || @iscell);
parse(p,lambda,spec,reference)
%}

Phi_v = ciespec2Y(lambda,spec);
Phi_a = ciespec2unit(lambda,spec,reference,1);
if strcmp(reference,'BLH')
    k = Phi_a./Phi_v./683.002;
else
    k = Phi_a./Phi_v;
end

