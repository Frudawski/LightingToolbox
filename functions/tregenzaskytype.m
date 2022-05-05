% tregenzaskytype determines the best fitting CIE Standard General Sky as
% described in ISO 15469 / CIE S 011 by means of the RootMean-Square Error.
%
% usage:  [sky, rms] = tregenzaskytype(L,sunaz,sunel,mode)
%
% where: 
%   - sky: is the best fitting CIE Standard General Sky (1-16)
%   - rms: gives the correspondig root-mean-square error
%   - L: is the luminance of the tregenza hemispehre with  145 patches 
%        as in "Subdivision of the sky hemisphere for luminance
%        measurements" (Tregenza 1987)
%   - sunaz: is the sun azimuth angle in °
%   - sunel: is the sun elevation angle in °
%   - mode: describes the luminance determinatoin of the refence CIE skies.
%           'center' = luminance is detmerined for the patch center angels
%           'mean' = luminance is determined as mean luminance of the four
%                    patch corners, as decribed in (Tregenza 2004)
%
% References:
% ISO 15469:2004(E)/CIE S 011/E:2003: Spatial Distribution of Daylight
% - CIE Standard General Sky. Commission Internationale de l'Eclairage (CIE),
% Vienna Austria, 2004.
% https://cie.co.at/publications/spatial-distribution-daylight-cie-standard-general-sky
%
% Peter Roy Tregenza: Analysing sky luminance scans to obtain frequency 
% distributions of CIE Standard General Skies. In: Lighting Research and 
% Technology, vol. 36, no. 4, pp. pp. 271–281, 2004, (DOI: 10.1191/1477153504li117oa).
% https://journals.sagepub.com/doi/abs/10.1191/1477153504li117oa?journalCode=lrtd
%
% Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103)
% https://journals.sagepub.com/doi/10.1177/096032718701900103
%
% Function author: Frederic Rudawski
% Date: 11.03.2021
% see: https://www.frudawski.de/tregenzaskytype

function [sky,rms] = tregenzaskytype(lum,sunaz,sunel,mode)

if ~exist('mode','var')
    mode = 'center';
end
try
    L = zeros(145,16);
    for n = 1:16
        L(:,n) = ciesky(n,sunaz,sunel,'mode',mode);
    end
    % check for low values (measurements)
    if isequal(sum(lum(~isnan(lum))),0)
      ind = isequal(lum,0);
      lum(ind) = min(lum)./1000;
    end
    Y = lum./lum(145);
    Y(isnan(Y)) = 0;
    L(isnan(Y),:) = 0;
    
    RMS = sqrt(sum((L-Y).^2)./sum(~isnan(lum)));
    [rms,sky] = min(RMS);
    rms = ltfround(rms,15);
catch
    rms = NaN; 
    sky = NaN;
end

