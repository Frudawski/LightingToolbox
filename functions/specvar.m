% spectral variance of an arbitrary number of spectra
% 
%   usage: out = specvar(lambda,data)
%
%   where out is an struct with the following elements:
%       - min
%       - max
%       - mean
%       - SD (standad deviation)
%       
% author: Frederic Rudawski
% date: 25.01.2023 

function varout = specvar(lambda,data,varargin)

p = inputParser;
addRequired(p,'lambda',@isvector);
addRequired(p,'data',@ismatrix);
parse(p,lambda,data,varargin{:})

% statistics
check = sum(data,2);
check = find(check == 0);
data(check,:) = [];
datamin = min(data,[],1);
datamax = max(data,[],1);
var = sum(((data-mean(data,1)).^2),1)./(size(data,1)-1);
std = sqrt(var);

% output
varout.min = datamin;
varout.max = datamax;
varout.mean = mean(data,1);
varout.SD = std;

