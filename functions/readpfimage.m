% read Technoteam LMK pf image file
%
% usage: [im,header] = readpfimage(file)
%
% Author: Frederic Rudawski
% Date: 06.12.2021
% See: https://www.frudawski.de/readpfimage

function [IM,header] = readpfimage(file)

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
fseek(fid, -r*c*4, 'eof');
IM = fread(fid,r*c,'single');
IM = reshape(IM,c,r)';

% close file
fclose(fid);


