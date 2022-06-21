% The function south calculates the local time for TST 12:00 when the sun is at
% 180 degree azimuth (south).
%
% usage: t = south(day,coord,offset)
%
% where:
% t:   Is the Coordinated Universal Time (UTC) at noon, when the sun is at 180° .
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

geolen = coord(1);
geow = coord(2);

% get sun azimuth angle for every hour
hrs = cell(1,24);
az = NaN(1,24);
for n = 0:23
   [~,hrs{n+1},az(n+1)] = TST(day,[num2str(n,'%02d'),':00:00'],geolen,geow,'off');
end

% find the two hours around noon
[~,ind] = min(abs(az-180));

if az(ind)<180
    h = ind-1;
elseif az(ind)>180
    h = ind-2;
elseif isequal(az(ind),180)
    % already found correct time
    t = [num2str(ind-1,'%02d'),'00:00'];
    return
end

% get sun azimuth angle for every minute between range
az = NaN(1,60);
mins = cell(1,60);
for n = 0:59
   [~,mins{n+1},az(n+1)] = TST(day,[num2str(h,'%02d'),':',num2str(n,'%02d'),':00'],geolen,geow,'off');
end

% find the two minutes around noon
[~,ind] = min(abs(az-180));

if az(ind)<180
    m = ind-1;
elseif az(ind)>180
    m = ind-2;
elseif isequal(az(ind),180)
    % already found correct time
    t = [num2str(h,'%02d'),':',num2str(ind-1,'%02d'),':00'];
    return
end

% find the second that is closest to 180 degree sun azimuth
az = NaN(1,60);
sec = cell(1,60);
for n = 0:59
   [~,sec{n+1},az(n+1)] = TST(day,[num2str(h,'%02d'),':',num2str(m,'%02d'),':',num2str(n,'%02d')],geolen,geow,'off');
end


% find the two minutes around noon
[~,ind] = min(abs(az-180));

% set times
t = [num2str(h,'%02d'),':',num2str(m,'%02d'),':',num2str(ind-1,'%02d')];
% get local time offset to UTC
[~,~,~,~,offset] = TST;
lct = [num2str(h+offset,'%02d'),':',num2str(m,'%02d'),':',num2str(ind-1,'%02d')];


