% aopicroi returns mean values of the region of interest (ROI) defined with
% a binary mask. The averaging of the radiance values require the solid
% angle information per pixel, provided with the omega file.
%
% usage: mean_roi = aopicroi(aopic,mask,omega)
%
% Where: aopic is the aopic image data input
%        mask is the binary image mask input specifying the region of interest
%        omega is the solid angle image data input      
%
% Author: Frederic Rudawski
% Date: 10.02.2024

function roi = aopicroi(aopic,mask,omega)

% initialize return value
roi = NaN(1,6);
% apply mask data to omega calibration data
angles = omega.*mask;
% loop over channel
for channel = 1:6
    % apply mask data to aopic image
    values = aopic(:,:,channel).*mask;
    % evaluate region of interest (ROI)
    roi(channel) = sum(values(:))./sum(angles(:));
end

