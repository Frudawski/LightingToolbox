% Test Lighting Toolbox function: speccentroid
%
% Author: Frederic Rudawski
% Date: 28.09.2023

%% Check for assumed correct values

% definitions
lam = 380:5:780;
spec = zeros(size(lam));
spec(40:41) = 1;

% test single spectrum
sc = speccentroid(lam,spec);
assert(isequal(sc,577.5)) % speccentroid value test

% test multiple spectra
sc = speccentroid(lam,[spec;spec;spec]);
assert(isequal(size(sc),[3 1])) % multi spectrum speccentroid size test
