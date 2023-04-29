% SPECPEAK returns the peak wavelength for any given spectral power
% distribution (SPD).
%
% usage: sp = specpeak(lam,spec)
%
% Author: Frederic Rudawski
% Date: 29.04.2023 (Saturday)

function sp = specpeak(lam,spec)

% find peak wavelengths
[~,idx] = max(spec,[],2);

% check lambda matrix size
if size(lam,1)==1 && size(spec,1)>1
    lam = repmat(lam,size(spec,1),1);
end

% return peak wavelengths
sp = NaN(size(spec,1),1);
for n = 1:size(spec,1)
    sp(n) = lam(n,idx(n));
end
