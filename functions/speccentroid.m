% SPECCENTROID calculates the spectral centroid for given spectral power
% distributions (SPD). The spectral centroid gives the "center of mass" of
% a SPD.
%
% usage: sc = specentroid(lam,spec)
%
% Author: Frederic Rudawski
% Date: 29.04.2023


function sc = speccentroid(lambda,spec)

% get delta lambda
[dlambda,lam] = dlam(lambda);

% power
SPECP = sum(spec.*dlambda,2);
% normalize
NSPEC = spec./SPECP;

% specetral centroid
sc = sum(lam.*NSPEC,2)./sum(NSPEC,2);

[lambda,idx] = sort(lambda);
