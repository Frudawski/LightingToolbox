% Angular distance on hemisphere in degree
%
% usage:
% [X,idx] = hemdistd(az1,el1,az2,el2,n)
%
% with: X = angular distance
%
% Author: Frederic Rudawski
% Date: 18.06.2021, last update: 30.11.2021

function X = hemdistd(az1,el1,az2,el2,n)

%if ~exist('n','var')
%    n = max([numel(az1) numel(az2)]); 
%end

X = acosd(sind(el1).*sind(el2)+cosd(el1).*cosd(el2).*cosd(az2-az1));
%X = ltfround(X,4);

% min distance and according patches
%[mind,ind] = sort(X);

% return values
%p = ind(1:n)';
%d = mind(1:n)';

%p(d==0) = [];
%d(d==0) = [];

end