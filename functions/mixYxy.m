% mixYxy mixes an arbitray number of colour light sets.
%
% usage: [xmix,ymix] = mixYxy(Y,x,y)
%
% where: 
% output xmix and ymix are vectors containing the resulting chromacitiy coordinates
% Y is a vector with the corresponding photometric values
% input x and y are vectors containing the chromacitiy coordinates
% 
% Author: Frederic Rudawski
% Date: 03.06.2022

function [xmix,ymix] = mixYxy(Y,x,y)

xmix = sum(x./y.*Y)/sum(Y./y);
ymix = sum(Y)/sum(Y./y);