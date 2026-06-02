% aopicroi returns mean values of the region of interest (ROI) defined with
% a binary mask. The averaging of the radiance values require the solid
% angle information per pixel, provided with the omega angle file.
%
% usage: roi = lightroi(im,mask,omega)
%
% Where: im is the radiometric, alpha-opic or luminance image data input
%        mask is the binary image mask input specifying the region of interest
%        omega is the solid angle image data input      
%
% Author: Frederic Rudawski
% Date: 02.06.2026
% See: https://frudawski.de/en/aometerroi

function roi = lightroi(im,mask,omega)

% number of channels
n = size(im,3);

% initialize return value
roi = NaN(1,n);
% apply mask data to omega calibration data
angles = omega.*mask;
E = im.*omega.*mask;
% loop over channel
for channel = 1:n
    % apply mask data to aopic image
    values = E(:,:,channel);
    % evaluate region of interest (ROI)
    roi(channel) = sum(values(:))./sum(angles(:));
end

