% SPECPEAK returns the peak wavelength for any given spectral power
% distribution (SPD).
%
% usage: sp = specpeak(lam,spec)
%
% Author: Frederic Rudawski
% Date: 29.04.2023 (Saturday)
% last updated: 30.09.2023

function sp = specpeak(lam,spec)

sp = NaN(size(spec,1),1);

% check lambda matrix size
if size(lam,1)==1 && size(spec,1)>1
    lam = repmat(lam,size(spec,1),1);
end

for n = 1:size(spec,1)
    % find peak wavelengths
    v = max(spec(n,:),[],2);
    idx = spec(n,:)==v; % allows for multiple idx with same value, [v,idx] = max() don't

    % return peak wavelengths
    sp(n) = mean(lam(n,idx));
end
