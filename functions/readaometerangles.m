% readaometerangle
%
% Author: Frederic Rudawski
% Date: 07.02.2024

function [im,reso] = readaometerangles(filename)

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
  file_information = dir(filename);
  byte_size = file_information.bytes;
end

% read file
im = fread(fileID,[1 byte_size],'single');
% close file
fclose(fileID);

% select correct resolution
switch byte_size
    case 160*120*4
        reso = [160 120];
    case 320*240*4
        reso = [320 240];
    case 640*480*4
        reso = [640 480];
    case 1024*768*4
        reso = [1024 768];
    otherwise
        error('Unsupproted resolution for ao-meter, use valid caibration: 160x120, 320x240, 640x480, 1024x768.')
end

% arrange image matrix
im = reshape(im,reso(2),reso(1));

