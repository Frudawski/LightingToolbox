% Test Lighting Toolbox function: colors
%
% Author: Frederic Rudawski
% Date: 28.09.2023

%% Check for unique colors and correct matrix size


c = colours(5);
assert(isequal(size(c),[5 3]))
assert(isequal(size(unique(c,'rows')),[5 3]))


