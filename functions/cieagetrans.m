% Age dependent spectral lens tranmittance, according to CIE 203
%
% usage: t = cieagetrans(lam,age)
%
% where: 
% lam is a vector containing the reference wavelengths
% age defines the transission age, scalar or vector 
%
% Reference:
% CIE 203:2012 (incl. Erratum), A COMPUTERIZED APPROACH TO TRANSMISSION AND ABSORPTION CHARACTERISTICS OF THE HUMAN EYE, Commission Internationale de l'Eclairage (CIE), Vienna Austria, ISBN: 978-3-902842-43-5.
% https://cie.co.at/publications/computerized-approach-transmission-and-absorption-characteristics-human-eye
% 
% Author: Frederic Rudawski
% Date: 28.09.2023

function [t,lam] = cieagetrans(a,lam)

if ~exist('lam','var')
    lam = 300:5:700;
end

% check vector orientation
if isrow(a)
    a = a';
end

% ocular density 
Dt = (0.15 + 0.000031.*a.^2).*(400./lam).^4 ...
     + 14.19.*10.68.*exp(-((0.057.*(lam-273)).^2)) ...
     + (1.05-0.000063.*a.^2).*2.13.*exp(-((0.029.*(lam-370)).^2)) ...
     + (0.059+0.000186.*a.^2).*11.95.*exp(-((0.021.*(lam-325)).^2)) ...
     +(0.016+0.000132.*a.^2).*1.43.*exp(-((0.008.*(lam-325)).^2))+0.06;

t = 10.^(-Dt);

end