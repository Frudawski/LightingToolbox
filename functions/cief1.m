% cief1 function calculates the f1 error or more precisely the mismatch index
% to the V(λ) curve. Any errors in the data set or in results generated with
% the Lighting Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: f1 = cief1(lam,spec,reference)
%
% originally f1 error was only defined for V(lambda) reference, later
% f1 for x,y and z were defined.
%
% References:
%
% ISO/CIE 19476:2014(E): Characterization of the performance of illuminance 
% meters and luminance meters. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2014.
% https://cie.co.at/publications/characterization-performance-illuminance-meters-and-luminance-meters
%
% CIE 179:2007: Methods for Characterising Tristimulus Colorimeters for 
% Measuring the Colour of Light. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2007, ISBN: 978 3 901906 60 2.
% https://cie.co.at/publications/methods-characterising-tristimulus-colorimeters-measuring-colour-light
% 
% Author: Frederic Rudawski
% Date: 11.08.2021, last edited: 08.12.2021
% See: https://www.frudawski.de/cief1

function F1 = cief1(lam,spec,ref)

F1 = zeros(size(spec,1),1).*NaN;

% check reference input
if ~exist('ref','var')
   ref = 'VL'; 
end

% standard illuminant A
A = ciespec(lam,'A');
% get reference data, if neccessary
if ischar(ref)
   ref = ciespec(lam,ref); 
end
% f1 error calculation
for n = 1:size(spec,1)
    srel = spec(n,:).*trapz(ref.*A)./trapz(spec(n,:).*A);
    f1 = trapz(abs(srel-ref))./trapz(ref);
    F1(n) = ltfround(f1.*100,14);
end
