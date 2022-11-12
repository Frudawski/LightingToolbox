% huecon returns the a connection to a hue bridge containing:
% ip
% user
% bridge id
%
% The function creates a new user if neccessary.
%
% usage: huecon() or huecon(ip)
%
% where: ip contains the ip-address as char or string (optional)
%
% Author: Frederic Rudawski
% Date: 28.02.2022


function connection = huecon(bridgenr)

try
    % look for huecon.mat file
    load(which('huecon.mat'),'connection');

catch

    % find hue bridge ip
    if ~exist('ip','var')
        ip = hueip;
    end
    % create new user
    connection = huenew(ip);
end

if exist('bridgenr','var')
    connection = connection(bridgenr);
end

