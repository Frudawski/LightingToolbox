% Test Lighting Toolbox function: fisheyeang
%
% Author: Frederic Rudawski
% Date: 30.09.2023 (Saturday)

%% Check for assumed correct values and result size

% definitions
dim = [11 11];

% test function
[theta, rho, omega] = fisheyeang(dim,76);

assert(isequal(size(theta),dim)) % test theta size
assert(isequal(size(rho),dim)) % test rho size
assert(isequal(size(omega),dim)) % test omega size
assert(isequal([theta(6,11) theta(11,6) theta(6,1) theta(1,6)],[0 90 180 270])) % test theta values
assert(isequal(rho(6,1),38)) % test rho value
assert(strcmp(rat(sum(omega(:))),'1 + 1/(18 + 1/(-15 + 1/(3)))')) % test omega value
