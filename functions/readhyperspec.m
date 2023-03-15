% read hyperspectral fisheye image created with LUMOS
%
% usage: IM = readhyperspec(file);
%
% where:
% IM is the return struct comtaining the wavelengths and the image matrix
%   - IM.lambda contains teh wavelengths 1xn vector
%   - IM.image cntains the image matrx 500x500xn
% file specifies the filename
% 
% reference: 
% Rudawski, Frederic, The spectral radiosity simulation program LUMOS,
% 2022, DOI: 10.5281/zenodo.7275807, URL: https://github.com/Frudawski/LUMOS
%
% Author: Frederic Rudawski
% Date: 15.03.2023

function IM = readhyperspec(file)

% open file in mat format
load(file,'-mat','hyperspec');
IM = hyperspec;

