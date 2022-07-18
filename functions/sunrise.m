% The function sunset calculates the UTC and local time for sunset at
% -0.833 degree sun altitude.
%
% usage: [t,lct] = sunrise(day,coord)
%
% where:
% t:   Is the Coordinated Universal Time (UTC) at noon, when the sun is
%      specified position.
% localt: Is the local time, offset to UTC is specified in LT_location.mat
% day: Specifies the date in 'dd.mm.yyyy' format.
% coord: (optional)	Specifies the geographic coordinates as 1 x 2 vector.
%        Default is defined in LT_ocation.mat
%
% Reference:
% DIN EN 17037:2019-03: Daylight in buildings. 2019.
% https://www.beuth.de/de/norm/din-en-17037/287576515
%
% Author: Frederic Rudawski
% Date: 03.07.2020


function [t,lct] = sunrise(day,coord,offset)

if exist('OCTAVE_VERSION', 'builtin')
    warning ('off', 'Octave:data-file-in-path')
end

if ~exist('day','var')
    day = date;
    day = datestr(day,'dd.mm.yyyy');
else
    if isempty(day)
        day = date;
        day = datestr(day,'dd.mm.yyyy');
    end
end
if ~exist('coord','var')
    load('LT_location.mat','coord');
else
    if isempty(coord)
        load('LT_location.mat','coord');
    end
end

[t,lct] = suntime(day,coord,'gamma1');

if exist('OCTAVE_VERSION', 'builtin')
    warning ('on', 'Octave:data-file-in-path')
end
