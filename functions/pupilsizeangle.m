% pupilsizeangle returns the angle dependend apparent pupil size.
%
% usage: A = pupilsizeangle(tilt_angle,interp_method)
%
% where: A: is the return matrix containing the relative weigthing factors
%        tilt_angle: is the pixel-wise tilt angle matrix to the optical axis
%
%
% Reference:
% Wyszecki & Stiles 2000, Color science: "Concepts and methods, quantitative
% data and formulas". 2nd edition. New York, John Wiley & Sons.
% ISBN: 978-0-471-39918-6
%
% Author: Frederic Rudawski
% Date: 24.02.2024

function A = pupilsizeangle(rho,method)

if ~exist('method','var')
   method = 'linear';
end

% apparant pupil size (PS)
PS = [47.3 44.4 43.1 35.9 28.3 20.9 12.0 4.53 1.46];
PS = PS./max(PS);
% corresponding angles (AN)
AN = [0 20 25 55 70 80 90 100 105];
% interpolate appearant pupil size effect
A = interp1(AN,PS,rho,method);

