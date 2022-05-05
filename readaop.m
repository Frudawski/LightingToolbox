% laod aopic image from allpha_Omega-dosimeter
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


function aopic = readaop(varargin)

aopic = readaopic(varargin{:});

