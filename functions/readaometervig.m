% readaometervig
%
% [im,reso] = readaometervig(filename)
%
% Author: Frederic Rudawski
% Date: 07.02.2024 - updated 07.03.2026
% See: www.frudawski.de/en/readaometervig

function [im,reso] = readaometervig(filename)

% initialize empty image
im = [];

% check for input file - if not: popup menu
if ~exist('filename','var')
    [file, path] = uigetfile('*.cal');
    if file==0
        return
    end
    filename = [path file];
end

% open file
fileID = fopen(filename,'r');
% get size information
if exist('OCTAVE_VERSION', 'builtin')
  try
    file_information = dir(filename);
    byte_size = file_information.bytes;
  catch
    filename = file_in_loadpath(filename);
    file_information = dir(filename);
    byte_size = file_information.bytes;
  end
else
  try
    file_information = dir(filename);
    byte_size = file_information.bytes;
  catch
    filename = which(filename);
    file_information = dir(filename);
    byte_size = file_information.bytes;
  end
end
% read file
im = fread(fileID,[1 byte_size],'single');
% close file
fclose(fileID);

% select correct resolution
switch byte_size
    case 160*120*4*3
        reso = [160 120];
    case 320*240*4*3
        reso = [320 240];
    case 640*480*4*3
        reso = [640 480];
    case 1024*768*4*3
        reso = [1024 768];
    otherwise
        error('Unsupproted resolution for ao-meter, use valid calibration: 160x120, 320x240, 640x480, 1024x768.')
end

% arrange image matrix
R = reshape(im(1:3:end),reso(1),reso(2))';
G = reshape(im(2:3:end),reso(1),reso(2))';
B = reshape(im(3:3:end),reso(1),reso(2))';
im = cat(3,R,G,B);

