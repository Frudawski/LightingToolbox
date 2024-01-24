% SPECBANDWIDTH determines the spectral bandwidth for narrowband spectral
% power distributions (SPDs). The function performs spline interpolation to
% determine the wavelengths where the SPD has the specified threshold
% level.
%
% usage: sbw = specbandwidth(lam,spec,threshold)
%
% Author: Frederic Rudawski
% Date: 29.04.2023


function [sbw,lambda1,lambda2] = specbandwidth(lam,spec,threshold,method)

% check for threshold level
if ~exist('threshold','var')
    threshold = 50;
end

% check for interpolation method
if ~exist('method','var')
    method = 'linear';
end

% check lam size
if size(lam,1) == 1 && size(spec,1) ~= 1
    lam = repmat(lam,size(spec,1),1);
end

% normalize spectrum/spectra in %
SPEC = spec./max(spec,[],2).*100;

% get spectra peak index
[~,idx] = max(SPEC,[],2);

% loop over spectra
lambda1 = NaN(1,size(spec,1));
lambda2 = NaN(1,size(spec,1));
for n = 1:size(SPEC,1)
    try
        % interpolate wavelength left from peak at threshold level
        [v,ind] = unique(SPEC(n,1:idx(n)),'last');
        w = lam(n,1:idx(n));
        lambda1(n) = interp1(v,w(ind),threshold,method);
        % interpolate wavelength right from peak at threshold level
        [v,ind] = unique(SPEC(n,idx(n):end),'first');
        w = lam(n,idx(n):end);
        lambda2(n) = interp1(v,w(ind),threshold,method);
    catch
        lambda1(n) = NaN;
        lambda2(n) = NaN;
    end
end
sbw = lambda2-lambda1;

