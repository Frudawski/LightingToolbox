% Test Lighting Toolbox function: fisheyeang
%
% Author: Frederic Rudawski
% Date: 30.09.2023 (Saturday)

%% Check for assumed correct values and result size

% test function
[theta, rho, omega] = fisheyeang([11 11]); % calling fisheyeang
binocular = fieldofview(theta,rho,'binocular'); % calling fieldofview
assert(isequal(sum(binocular,1),[1 4 6 6 7 7 7 6 6 4 1])) % test mask row sum
assert(isequal(sum(binocular,2),[0 0 3 7 9 11 9 9 7 0 0]')) % test mask column sum
