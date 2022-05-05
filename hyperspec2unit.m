% hyperspectral image to photometric unit
% 
% usage:   
% srgb = hyperspec2unit(I,lambda)
%
% Where:
% I is either a struct containing the image data I.image and the corresponding
% wavelength I.lambda, or I is a 3-dim matrix and lambda provides the
% corresponding wavelengths.
%
% Author: Frederic Rudawski
% Date: 25.22.2021
% See: https://www.frudawski.de/hyperspec2unit



function I = hyperspec2unit(IM,lambda,unit)

% check input
if isstruct(IM)
    unit = lambda;
    lambda = IM.lambda;
    IM = IM.image;
end

% arange image data
im = reshape(IM,size(IM,1)*size(IM,2),size(IM,3));
% transform hyperspec image to target quantity
q = ciespec2unit(lambda,im,unit);
% rearange image data
I = reshape(q,size(IM,1),size(IM,2),size(q,2));




