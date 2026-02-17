% streetegrid returns a mesurement grid according to DIN 13201-3 for street
% surfaces with the corresponding measurement points for a given measurement
% area.
%
% usage: [x,y,numx,numy] = streetegrid(distance,width)
%
% where: - x and y are the meshpoints coordinates matrices in m
%        - numx and numy are the number of points in x and y dimension
%        - distance is the distance between luminaires in m
%        - width is the width of the traffic lane in m
%
% Reference:
% EN 13201-3:2015 - Road lighting - Part 3: Calculation of performance
%
% Author: Frederic Rudawski
% Date: 13.10.2024
% See: https://www.frudawski.de/streetegrid

function [xq,yq,dn,bn] = streetegrid(s,w)

% number of points
if s<30
    dn = 10;
else
    dn = ceil(s/3);
end

% Längsrichtung
dw = s/dn;

% Querrichtung
bw = w/3;
bn = 3;

% grid determination
rgrid = linspace(dw/2,s-dw/2,dn);
zgrid = linspace(bw/2,w-bw/2,bn);

% meshgrid determination
[xq,yq] = meshgrid(rgrid,zgrid);

