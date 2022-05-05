% function plotcieuv
%
% plot u,v coordinates in CIE 1960 u,v or CIE 1976 u',v' Chromaticty diagram.
%
% NOTE: for use in Octave the image package is recommended
%
% usage: cieplotuv(x,y,parameter,value)
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see license.
%
% NOTE: for use in octave the image package is recommended.
%
% parameters:
% input: 'uv','xy' (default: 'uv')
%       input data for plot. x,y coordinates will be automaticly transformed to
%       u,v coordinates. 
% Planck: 'on','off'
%       plot planckian locus (default: 'off')
% CCT: 'value','range','off'
%       plots isotemperature lines over the planckian locus
%       'value': plots for each given value an isotemperature line
%       'range': plots only the min and max isotemperature line
%       'off': plot no isotemperature line (default)
% CCTMethod: 'Robertson','Hernandez','exact'
%       define CCT calculation method:
%       'Robertson': Robertson CCT algrithm (fast and good approximation)
%       'Hernandez': Hernandez-Andres CCT calculation (fastest and good enough approximation)
%       'exact': find minimum distance in uv (CIE1960) diagram to planckian locus (slow but exact calculation)
% IsoTempLines: [CCT1 CCT2 ...]
%       plot additional isotemperature lines in Kelvin, default: []
% DaylightLocus: 'on','off'
%        plot the daylight locus (default: 'off')
% WhitePoints: plots white points:
%               e.g.: 'A','B','C','D50','D55','D65','D75','D93'
%               'E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'
% Color: 'on','off'
%       plot the cie1931 diagram in color or grayscale (default: 'on')
% Background: 'white','black'
%       'white': white background (default)
%       'black': black background
% Marker: '+','o','*','.','x','s','d','^','v','>','<','p','h','square','diamond','pentagram','hexagram'
%       marker for the x,y plot
%       all Matlab standard plot markers are useable (see list above)
% MarkerColor: [r g b]
%       color of the plot marker
%       [] = matlab colormap order (default)
%       [r g b] = uniform rgb color for the plot marker(s)
%       [r1 g1 b1 ; r2 b2 g2 ; ... ] = colormap used for plot marker(s)
% MarkerSize: numeric
%       plot marker size, default: 10
% LegendMode: 'on','off','extended'
%       'off': no legend
%       'on': show plot legend with x and y value
%       'extended': show legend with x, y and CCT value
% Grid: 'on','off'
%       plot grid lines (default: 'on')
% FontSize: numeric
%       Fontsize of text
% zoom: numerical vector [x1 x2 y1 y2]
%       Zooms in specified region (default: [0.0  0.8  0.0  0.9])
% Author: Frederic Rudawski
% Date: 05.05.2016, last updated: 27.11.2021
% See: https://www.frudawski.de/plotcieuv


function plotcieuv(u,v,varargin)

% caller function to cie1960 for better function name and at the same time
% backwards code compability with own projects.
%
% Author: Frederic Rudawski
% Date: 27.11.2021

if~exist('u','var')
  cie1960
else
  if isempty(varargin)
     cie1960(u,v)
  else
     cie1960(u,v,varargin{:})
  end
end

end