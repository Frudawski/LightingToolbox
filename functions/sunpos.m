% sunpos function returns the sun position (azimuth and elevation angle)
% for a given date, UTC time and location according to DIN EN 17037.
%
% usage: [azimuth,elevation] = sunpos(datevar,utc,geolen,geow)
%
% default: 
%   date: current date in 'dd.mm.yyyy' format
%   utc: curent UTC time in 'hh:mm:ss' format
%   geolen: 13.326
%   geowidth: 52.514
%
% Reference:
% DIN EN 17037:2019-03: Daylight in buildings. 2019.
% https://www.beuth.de/de/norm/din-en-17037/287576515
%
% Author: Frederic Rudawski
% Date: 10.08.2021
% See: https://www.frudawski.de/sunpos

function [az,el]= sunpos(datevar,utc,geolen,geow)

if ~exist('datevar','var')
    datevar = date;
    datevar = datestr(datevar,'dd.mm.yyyy');
end
if ~exist('utc','var')
    if exist('OCTAVE_VERSION', 'builtin')
      d = strftime ("%H:%M:%S", gmtime(time()));
    else
      d = datetime('now','TimeZone','UTC','Format','hh:mm:ss');
    end
    utc = datestr(d);
    utc = utc(end-7:end);
end
if ~exist('geolen','var') && ~exist('geow','var')
    geolen = 13.326;
    geow   = 52.514;
end

[~,~,az,el] = TST(datevar,utc,geolen,geow);
