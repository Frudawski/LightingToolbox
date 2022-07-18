% The function suntime calculates the UTC and local time for a specific
% sun position.
%
% usage: [t,lct] = sunset(day,coord,target,value)
%
% where:
% t:   Is the Coordinated Universal Time (UTC) at noon, when the sun is
%      specified position.
% lct: Is the local time, offset to UTC is specified in LT_location.mat
% day: Specifies the date in 'dd.mm.yyyy' format.
% coord: (optional)	Specifies the geographic coordinates as 1 x 2 vector.
%        Default: [13.326 52.514] for Berlin, Germany.
% target: specifies the target value:
%          - 'sunrise' for sunrise
%          - 'sunset' for sunset
%          - 'gamma1' for the time the elevation angle value is reached the
%                     first time, default g = -0.833 (sunrise)
%          - 'gamma2' for the time the elevation angle value is reached the
%                     second time, default g = -0.833 (sunset)
%          - 'azimuth' for the azimuth angle value, default az = 180 (noon)
%
% Reference:
% DIN EN 17037:2019-03: Daylight in buildings. 2019.
% https://www.beuth.de/de/norm/din-en-17037/287576515
%
% Author: Frederic Rudawski
% Date: 03.07.2022


function [t,lct] = suntime(day,coord,target,value,offset)

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
if ~exist('target','var')
    target = 'gamma'; % sun elevation
end


geolen = coord(1);
geow = coord(2);

% get sun azimuth angle for every hour
hrs = cell(1,24);
v = NaN(1,24);

switch target
    case 'gamma1'
        if ~exist('value','var')
            value = -0.833; % sunset
        end
        for n = 0:23
            [~,hrs{n+1},~,v(n+1)] = TST(day,[num2str(n,'%02d'),':00:00'],geolen,geow,'off');
        end
        v(13:24) = inf;
        n1 = 0;
        n2 = 1;

    case 'gamma2'
        if ~exist('value','var')
            value = -0.833; % sunset
        end
        for n = 0:23
            [~,hrs{n+1},~,v(n+1)] = TST(day,[num2str(n,'%02d'),':00:00'],geolen,geow,'off');
        end
        v(1:12) = inf;
        n1 = 1;
        n2 = 0;

    case 'sunset'
        if ~exist('value','var')
            value = -0.833; % sunset
        end
        for n = 13:23
            [~,hrs{n+1},~,v(n+1)] = TST(day,[num2str(n,'%02d'),':00:00'],geolen,geow,'off');
        end
        v(1:12) = inf;
        n1 = 1;
        n2 = 0;

    case 'sunrise'
        if ~exist('value','var')
            value = -0.833; % sunset
        end
        for n = 0:12
            [~,hrs{n+1},~,v(n+1)] = TST(day,[num2str(n,'%02d'),':00:00'],geolen,geow,'off');
        end
        v(13:23) = inf;
        n1 = 0;
        n2 = 1;

    case 'azimuth'
        if ~exist('value','var')
            value = 180; % noon
        end
        for n = 0:23
            [~,hrs{n+1},v(n+1)] = TST(day,[num2str(n,'%02d'),':00:00'],geolen,geow,'off');
        end
        n1 = 0;
        n2 = 1;
    otherwise
        error('Unsupported target in sumtime function.')
end


% find the two hours around target value
[~,ind] = min(abs(v-value));

if v(ind) < value
    h = ind-n1-1;
elseif v(ind) > value
    h = ind-n2-1;
elseif isequal(v(ind),value)
    % already found correct time
    t = [num2str(ind,'%02d'),'00:00'];
    return
end

% get local time offset to UTC
if ~exist('offset','var')
  [~,~,~,~,offset] = TST(day);
end

% get sun azimuth angle for every minute between range
v = NaN(1,59);
mins = cell(1,59);
switch target
    case 'azimuth'
        for n = 1:59
            [~,mins{n},v(n)] = TST(day,[num2str(h,'%02d'),':',num2str(n,'%02d'),':00'],geolen,geow,'off');
        end
    otherwise
        for n = 1:59
            [~,mins{n},~,v(n)] = TST(day,[num2str(h,'%02d'),':',num2str(n,'%02d'),':00'],geolen,geow,'off');
        end
end


% find the two minutes around target value
[~,ind] = min(abs(v-value));

if v(ind) < value
    m = ind-n1;
elseif v(ind) > value
    m = ind-n2;
elseif isequal(v(ind),value)
    % already found correct time
    t = [num2str(h,'%02d'),':',num2str(ind,'%02d'),':00'];
    return
end

% find the second that is closest to target value
v = NaN(1,59);
sec = cell(1,59);
switch target
    case 'azimuth'
        for n = 1:59
            [~,sec{n},v(n)] = TST(day,[num2str(h,'%02d'),':',num2str(m,'%02d'),':',num2str(n,'%02d')],geolen,geow,'off');
        end
    otherwise
        for n = 1:59
            [~,sec{n},~,v(n)] = TST(day,[num2str(h,'%02d'),':',num2str(m,'%02d'),':',num2str(n,'%02d')],geolen,geow,'off');
        end
end


% find the two minutes around target value
[~,ind] = min(abs(v-value));

t = sec{ind};
h = str2double(sec{ind}(1:2))+offset;
lct = [num2str(h,'%02d'),sec{ind}(3:end)];

if exist('OCTAVE_VERSION', 'builtin')
    warning ('on', 'Octave:data-file-in-path')
end
