% Calculates the True Solar Time (TST) from Coordinated Universal Time (UTC)
% in europe.
%
% Usage: [tst,localtime_germany,azimuth,elevation] = TST('dd.mm.yyyy','hh:mm:ss',geolength,geowidth,offset)
%
% default: geolen = 13.326, geowidth = 52.514
%
% Reference:
% DIN EN 17037:2019-03: Daylight in buildings. 2019.
% https://www.beuth.de/de/norm/din-en-17037/287576515
%
% Author Frederic Rudawski
% Date: 22.11.2017
% See: https://www.frudawski.de/TST

function [TST,localtime,azimuth,elevation,offset] = TST(datevar,utc,geolen,geow,offset)

if ~exist('datevar','var')
    datevar = date;
    datevar = datestr(datevar,'dd.mm.yyyy');
end
if ~exist('utc','var')
    if exist('OCTAVE_VERSION', 'builtin')
      t = time();
      d = ctime(t);
      utc = d(end-13:end-6);
    else
      d = datetime('now','TimeZone','UTC','Format','hh:mm:ss');
      utc = datestr(d);
      utc = utc(end-7:end);
    end
end
if ~exist('geolen','var') && ~exist('geow','var')
    load('LT_location.mat','coord');
    geolen = coord(1);
    geow   = coord(2);
end
if ~exist('offset','var')
    load('LT_location.mat','summeroffset','winteroffset');
    offset = 0;
else
    summeroffset = offset;
    winteroffset = offset;
end


for i = 1:size(datevar,1)

    day = datevar(i,1:2);
    month = datevar(i,4:5);
    year = datevar(i,7:10);

    y = str2double(year);
    m = str2double(month);
    d = str2double(day);

    % time UTC
    try
        hrsUTC = str2double(utc(i,1:2));
        minUTC = str2double(utc(i,4:5));
        try
            secUTC = str2double(utc(i,7:8));
        catch
            secUTC = 0;
        end
    catch
        hrsUTC = str2double(utc{i,:}(1:2));
        minUTC = str2double(utc{i,:}(4:5));
        try
            secUTC = str2double(utc{i,:}(7:8));
        catch
            secUTC = 0;
        end
    end

    days = [31 28 31 30 31 30 31 31 30 31 30 31];
    % Schaltjahr
    if mod(y-2000,4) == 0
        %disp('Schaltjahr')
        days(2) = 29;
    end

    % J for time equation
    if m == 1
        J = d;
    elseif m == 2
        J = days(1)+d;
    else
        J = sum(days(1:m-1))+d;
    end
    Jt = 360*J/365;
    if mod(y,4) == 0
        Jt = 360*J/366;
    end
    Jt = deg2rad(Jt);

    % time equation
    time_equation = 0.0066 + (7.3525*cos(Jt+deg2rad(85.9))) + (9.9359*cos(2*Jt+deg2rad(108.9))) + (0.3387*cos(3*Jt+deg2rad(105.2)));

    % deklination
    dek = 0.3948-23.2559*cos(Jt+deg2rad(9.1))-0.3915*cos(2*Jt+deg2rad(5.4))-0.1764*cos(3*Jt+deg2rad(26.0));


    % find last Sunday in March and October for Summertime - start with 01.01.2000
    summerday = 26;
    winterday = 29;
    for YY=2001:y
        summerday=summerday-1;
        winterday=winterday-1;
        if summerday <= 24
            summerday=summerday+7;
        end
        if winterday <= 24
            winterday=winterday+7;
        end
        if mod(YY,4)==0
            summerday=summerday-1;
            winterday=winterday-1;
        end
        if summerday <= 24
            summerday=summerday+7;
        end
        if winterday <= 24
            winterday=winterday+7;
        end
    end

    % days when summertime is changing
    summerday = sum(days(1:2))+summerday+1;
    winterday = sum(days(1:9))+winterday+1;


    DAY = d+sum(days(1:m-1));

    if strcmp(offset,'off')
        localtime_hrs = num2str(hrsUTC);
        offset = 0;
    else
        if DAY >= summerday && DAY < winterday
            localtime_hrs = num2str(hrsUTC+summeroffset,'%02d');
            offset = summeroffset;
        else
            localtime_hrs = num2str(hrsUTC+winteroffset,'%02d');
            offset = winteroffset;
        end
    end

    LST = hrsUTC + minUTC/60 + secUTC/3600 + 1 -(4*(15-geolen)/60) + (time_equation/60);

    hourangle = ((LST-12)*15);

    % = 180+hourangle;
    hrs = floor(LST);
    min = floor((LST - hrs)*60);
    sec = round((((LST - hrs)*60)-min)*60);


    SEC = num2str(sec);
    if sec < 10
        SEC = ['0',SEC];
    end
    if sec == 60
        SEC = '00';
        min = min+1;
    end

    MIN = num2str(min);
    if min < 10
        MIN = ['0',MIN];
    end
    if min == 60
        MIN = '00';
        hrs = hrs + 1;
    end

    HRS = num2str(hrs);
    if hrs < 10
        HRS = ['0',HRS];
    end

    % True Solar Time
    TST(i,:) = [HRS,':',MIN,':',SEC];

    % Sun elevation angle
    elevation = rad2deg(asin(cos(deg2rad(hourangle))*cos(deg2rad(geow))*cos(deg2rad(dek)) + sin(deg2rad(geow))*sin(deg2rad(dek))));

    % sun azimuth
    toggle = hrs*10000 +  min*100 + sec;
    if toggle <= 120000
        azimuth = rad2deg(deg2rad(180) - acos((sin(deg2rad(elevation)) * sin(deg2rad(geow)) - sin(deg2rad(dek))) / cos(deg2rad(elevation)) / cos(deg2rad(geow)) ));
    elseif toggle > 120000
        azimuth = rad2deg(deg2rad(180) + acos((sin(deg2rad(elevation)) * sin(deg2rad(geow)) - sin(deg2rad(dek))) / cos(deg2rad(elevation)) / cos(deg2rad(geow)) ));
    end

    % UTC time
    if hrsUTC < 10
        t1 = ['0',num2str(hrsUTC)];
    else
        t1 = num2str(hrsUTC);
    end
    if minUTC < 10
        t2 = ['0',num2str(minUTC)];
    else
        t2 = num2str(minUTC);
    end
    if secUTC < 10
        t3 = ['0',num2str(secUTC)];
    else
        t3 = num2str(secUTC);
    end

    utc(i,:) = [t1,':',t2,':',t3];

    localtime_min = t2;
    localtime_sec = t3;
    localtime(i,:) = [t1,':',t2,':',t3];


end
