% read Technoteam LMK pcf colour image file
%
% usage: [im,header] = readpcfimage(file)
%
% Author: Frederic Rudawski
% Date: 07.12.2021
% See: https://www.frudawski.de/readpcfimage

function [XYZ,header] = readpcfimage(file)

% open file
fid = fopen(file,'r');
if isequal(fid, -1)
    % error
    error(['Could not read file: ',file])
end

% read header
header = textscan(fid,'%s',78,'delimiter','\n');
header = header{1};

% image size
r = str2double(header{2}(7:end));
c = str2double(header{3}(9:end));

% read image and resize
fseek(fid, -r*c*4*3, 'eof');
IM = fread(fid,r*c*3,'single');

% create color image matrix
RGB = zeros(c,r,3);
RGB(:,:,3) = reshape(IM(1:3:end),c,r);
RGB(:,:,2) = reshape(IM(2:3:end),c,r);
RGB(:,:,1) = reshape(IM(3:3:end),c,r);

% RGB to XYZ transformation
% from: Colorimetry - fundamentals and applications, authors: Robertson and Ohta on page 70
XYZ = zeros(c,r,3);
XYZ(:,:,1) = 2.7689.*RGB(:,:,1) + 1.7517.*RGB(:,:,2) + 1.1302.*RGB(:,:,3);
XYZ(:,:,2) = 1.0000.*RGB(:,:,1) + 4.5907.*RGB(:,:,2) + 0.0601.*RGB(:,:,3); % luminance matrix
XYZ(:,:,3) = 0.0000.*RGB(:,:,1) + 0.0565.*RGB(:,:,2) + 5.5943.*RGB(:,:,3);

% rotate image
XYZ = flipud(rot90(XYZ));

% close file
fclose(fid);


