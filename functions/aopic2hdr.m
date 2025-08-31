% AOPIC2HDR reconstructs the RGB HDR image from an aopic
% image (alphaOmega-meter).
%
% usage: [RGB,R,G,B] = aopic2rgb(aopic,relative,absolute)
%
% where: - RGB is the reconstructed 3-channel RGB image
%        - aopic is the 6-channel aopic image from an alphaOmeger-meter
%        - relative is the a vector containing the relative calibration factors
%        - absolute is the a vector containing the absolute calibration factors
%
% Author: Frederic Rudawski
% Date: 16.04.2023 (sunday)

function [RGB,R,G,B] = aopic2hdr(aopic,r,a)

% aopic channels
sc = aopic(:,:,1)./a(1);
mc = aopic(:,:,2)./a(2);
lc = aopic(:,:,3)./a(3);

% reconstruction of RGB
detA = r(1).*(r(5).*r(9)-r(6).*r(8)) - r(2).*(r(4).*r(9) - r(6).*r(7)) + r(3).*(r(4).*r(8) - r(5).*r(7));
R = ( (r(5).*r(9) - r(6).*r(8)).*sc + (-r(2).*r(9) + r(3).*r(8)).*mc + (r(2).*r(6) - r(3).*r(5)).*lc ) ./ detA;
G = ( (r(6).*r(7) - r(4).*r(9)).*sc + ( r(1).*r(9) - r(3).*r(7)).*mc + (r(3).*r(4) - r(1).*r(6)).*lc ) ./ detA;
B = ( (r(4).*r(8) - r(5).*r(7)).*sc + ( r(2).*r(7) - r(1).*r(8)).*mc + (r(1).*r(5) - r(2).*r(4)).*lc ) ./ detA;

% concatenate RGB
RGB = cat(3,R,G,B);

