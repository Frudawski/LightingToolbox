% iso-colour
%
% usage: plotisocolours(x,y,data,colorbarlabel,[min max])
%
% where:
% x and y are the coordinate vectors of the mesh grid
% data is the data to plot
% colorbarlabel is an optional input argument string for the colorbar label
% min and max sets the colorbar range
% 
% author: Frederic Rudawski
% date: 20.03.2018, last edited: 16.07.2020

function plotisocolours(varargin)
% call function
plotisorange(varargin{:})
