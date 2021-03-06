% The function south calculates the local time for TST 12:00 when the sun is at
% 180 degree azimuth (south).
%
% usage: [t,lct] = south(day,coord)
%
% where:
% t:   Is the Coordinated Universal Time (UTC) at noon, when the sun is at 180°.
% lct: Is the local time at noon, offset to UTC is specified in LT_location.mat
% day: Specifies the date in 'dd.mm.yyyy' format.
% coord: (optional)	Specifies the geographic coordinates as 1 x 2 vector.
%        Default: [13.326 52.514] for Berlin, Germany.
% offset: (optional) Defines the offset for local time adjustment to UTC,
%         e.g. 2 for Central European Summer Time (CEST). Default: 0
%
% Reference:
% DIN EN 17037:2019-03: Daylight in buildings. 2019.
% https://www.beuth.de/de/norm/din-en-17037/287576515
%
% Author: Frederic Rudawski
% Date: 10.02.2020
% See: https://www.frudawski.de/south

function [t,lct] = south(day,coord)

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

[t,lct] = suntime(day,coord,'azimuth',180);

if exist('OCTAVE_VERSION', 'builtin')
    warning ('on', 'Octave:data-file-in-path')
end


