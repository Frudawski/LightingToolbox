% Test Lighting Toolbox function: specbandwidth
%
% Author: Frederic Rudawski
% Date: 28.09.2023

%% Check for assumed correct values and result size

% definitions
lam = 380:5:780;
spec = zeros(size(lam));
spec(40) = 1;

% test single spectrum
[bw,lam1,lam2] = specbandwidth(lam,spec,75,'linear');
assert(isequal(bw,2.5)) % bandwidth value test
assert(isequal(lam1,573.75)) % wavelength 1 test
assert(isequal(lam2,576.25)) % wavelength 2 test

% test multiple spectra
[bw,lam1,lam2] = specbandwidth(lam,[spec;spec;spec]);
assert(isequal(size(bw),[1 3])) % multi spectrum bandwith size test
assert(isequal(size(lam1),[1 3])) % multi spectrum wavelength 1 size test
assert(isequal(size(lam2),[1 3])) % multi spectrum wavelength 2 size test
