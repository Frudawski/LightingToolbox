% roadegrid returns a mesurement grid according to DIN 13201-3 for street
% surfaces with the corresponding measurement points for a given measurement
% area.
%
% usage: [x,y,numx,numy] = roadegrid(distance,width)
%
% where: - x and y are the meshpoints coordinates matrices in m
%        - numx and numy are the number of points in x and y dimension
%        - distance is the distance between luminaires in m
%        - width is the width of the traffic lane in m
%
% Reference:
% DIN 13201-3:2015: Berechnung der Gütemerkmale
% https://www.dinmedia.de/de/norm/din-en-13201-3/225893470
%
% Author: Frederic Rudawski
% Date: 13.10.2024
% See: https://www.frudawski.de/streetegrid

function [xq,yq,dn,bn] = roadegrid(s,w)

% call alternatively named function
 [xq,yq,dn,bn] = streetegrid(s,w);