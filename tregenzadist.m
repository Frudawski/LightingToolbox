% Nearest Tregenza patch & Tregenza patch distance in degree
%
% usage:
%
%   [p,d] = tregenzadist(patch,n,not)
%
%   where: p = nearest patch in ascending order
%          d = angular distance of patch p to input patch
%          patch = Tregenza input patch number, from 1 to 145. For more 
%                  than one input patch d and p are returned column-wise.
%          n = number of return patches, max: 144
%          not = vector or scalar with Tregenza patches not to consider
%
% Reference:
% Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103)
% https://journals.sagepub.com/doi/10.1177/096032718701900103
%
% Author: Frederic Rudawski
% Date: 18.06.2021
% See: https://www.frudawski.de/tregenzadist

function [p,d] = tregenzadist(patch,n,not)

% initialization
p = [];
d = [];

if ~exist('not','var')
    not = [];
end

% Tregenza patch angles
TRaz = [180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 0];
TRel = [ones(1,30).*6 ones(1,30).*18 ones(1,24).*30 ones(1,24).*42 ones(1,18).*54 ones(1,12).*66 ones(1,6).*78 90];

for m = 1:length(patch)
    % patch angles
    az = TRaz(patch(m));
    el = TRel(patch(m));
    
    % check input vector orientation
    if size(az,2) > size(az,1)
        az = az';
    end
    if size(el,2) > size(el,1)
        el = el';
    end
    
    % same size matrices
    az = repmat(az,1,145);
    el = repmat(el,1,145);
    
    traz = repmat(TRaz,size(az,1),1);
    trel = repmat(TRel,size(el,1),1);
    
    % angular distance on hemisphere
    dist = ltfround(hemdistd(az,el,traz,trel),4);
    
    % min distance and according patches
    [mind,ind] = sort(dist);
    
    % exclude input patches
    NOT = [not patch(m)];
    idx = ismember(ind,NOT);
    mind(idx) = [];
    ind(idx)  = [];
    
    if ~exist('n','var')
        n = length(ind);
    end
    
    % return values
    p(:,m) = ind(1:n)';
    d(:,m) = mind(1:n)';
end

% end of function
end
