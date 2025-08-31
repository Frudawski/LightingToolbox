% plot circle
%
% usage: plotcircle(x,y,r,mode)
%
% where:
% x & y are the circle center coordinates
% r is the circles radius
% mode specifies the plot mode, e.g. 'g--'
%
% Author: Frederic Rudawski
% Date: 01.03.2022

% circle plot function
function plotcircle(x,y,r,mode,varargin)

p = inputParser;
validVar = @(f) isnumeric(f) || isvector(f);
addRequired(p,'x',validVar);
addRequired(p,'y',validVar);
addRequired(p,'r',validVar);
addRequired(p,'mode',validVar);
addParameter(p,'LineWidth',1)
parse(p,x,y,r,mode,varargin{:})

t = linspace(0,360,1000);
xc = r*cosd(t)+x;
yc = r*sind(t)+y;
plot(xc,yc,mode,'LineWidth',p.Results.LineWidth)