% Test Lighting Toolbox function: fieldofview
%
% Author: Frederic Rudawski
% Date: 30.09.2023 (Saturday)

%% Check for assumed correct values and result size

% test function
IM = readhyperspec('hyperspec.mat'); % calling readhyperspec
assert(isequal(size(IM.image),[500 500 9])) % test reference image size
assert(isequal(IM.lambda,380:50:780)) % test reference lambda values
assert(isa(IM.image,'single')) % test reference image data type
