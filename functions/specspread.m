% SPECSPREAD determines the spectral spread of a series of spectral power
% distributions (SPDs). The spectral spread equals the standard deviation 
% (SD) of a series of spectral centroids.
%
% usage: sp = specspread(lam,spec)
%
% Author: Frederic Rudawski
% Date: 29.04.2023

function sp = specspread(lam,spec)

% get spectral centroids
sc = speccentroid(lam,spec);

% determine spectral spread
sp = std(sc);
