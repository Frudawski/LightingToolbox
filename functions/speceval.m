% The function speceva evaluates a given spectral power distribution
% (SPD) for all relevant parameters that are included in the Lighting
% Toolbox.
%
% usage: data = speceval(lam,spec)
%
% where: 
% - lam defines the wavelengths, vector
% - spec defines the SPD, vector or matrix, row-wise     
%
% Author: Frederic Rudawski
% Date: 26.10.2022
% see: https://www.frudawski.de/speceva


function data = speceval(lam,spec)

% derive data
[xyz,x,y,z,XYZ] = ciespec2xyz(lam,spec);
[xyz10,x10,y10,z10,XYZ10] = ciespec2xyz10(lam,spec);
[u,v] = ciexy2uv(x,y);
Tcp = ciespec2cct(lam,spec,'exact');
cri = ciecri(lam,spec);
cfi = ciecfi(lam,spec);
edq = cieedq(lam,spec,'aopic');
medi = ciemedi(lam,spec);
aopic = ciespec2aopic(lam,spec);
deltauv = duv(u,v,'exact');
lab = ciexyz2lab(xyz);
lch = cielab2lch(lab);

% save in struct
data.X = XYZ(:,1)';
data.Y = XYZ(:,2)';
data.Z = XYZ(:,3)';
data.SC = aopic(:,1)';
data.MC = aopic(:,2)';
data.LC = aopic(:,3)';
data.RH = aopic(:,4)';
data.MEL = aopic(:,5)';
data.sc_EDY = edq(:,1)';
data.mc_EDY = edq(:,2)';
data.lc_EDY = edq(:,3)';
data.rh_EDY = edq(:,4)';
data.MEDY = medi';
data.Tcp = Tcp';
data.x = x';
data.y = y';
data.z = z';
data.x10 = x10';
data.y10 = y10';
data.z10 = z10';
data.u = u';
data.v = v';
data.v_ = 1.5.*v';
data.L = lab(:,1)';
data.a = lab(:,2)';
data.b = lab(:,3)';
data.C = lch(:,2)';
data.h = lch(:,3)';
data.Ra = cri.Ra;
data.Rf = cfi.Rf;
data.duv = deltauv';
