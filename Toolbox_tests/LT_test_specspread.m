% Test Lighting Toolbox function: specspread
% Author: Frederic Rudawski
% Date: 28.09.2023

%% Check for assumed correct values

% definitions
lam = 380:5:780;
spec1 = zeros(size(lam));
spec1(40:41) = 1;
spec2 = spec1;
spec2(42) = 1;
spec3 = spec2;
spec3(43) = 1;

% test function
sp = specspread(lam,[spec1;spec2;spec3]);
assert(isequal(sp,2.5)) % specspread value test
