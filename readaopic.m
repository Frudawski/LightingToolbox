% laod aopic image from αΩ-dosimeter
%
% usage: aopic = readaopic(filename,resolution)
% 
% Where: - aopic is the returned aopic image
%        - filename gives the absolute or relative file location
%        - resolution specifies the resolution and number of channels of the 
%          image, default: [160 120 6]
% 
% Author: Frederic Rudawski
% Date: 14.12.2021
% See: https://www.frudawski.de/readaopic

function [aopic,SC,MC,LC,RH,MEL,VL] = readaopic(filename,reso)

if ~exist('reso','var')
    reso = [160 120 6];
end

fileID = fopen(filename,'r');
im = fread(fileID,[1 reso(1)*reso(2)*reso(3)*4],'single');
fclose(fileID);

SC  = reshape(im(1:6:end),reso(1),reso(2))';
MC  = reshape(im(2:6:end),reso(1),reso(2))';
LC  = reshape(im(3:6:end),reso(1),reso(2))';
RH  = reshape(im(4:6:end),reso(1),reso(2))';
MEL = reshape(im(5:6:end),reso(1),reso(2))';
VL  = reshape(im(6:6:end),reso(1),reso(2))';

aopic(:,:,1) = SC;
aopic(:,:,2) = MC;
aopic(:,:,3) = LC;
aopic(:,:,4) = RH;
aopic(:,:,5) = MEL;
aopic(:,:,6) = VL;

