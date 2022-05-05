% The function south calculates the local time for TST 12:00 when the sun is at
% 180 degree azimuth (south).
%
% usage: t = south(day,coord,offset,mode)
%
% where:
% t:   Is the Coordinated Universal Time (UTC) at noon, when the sun is at 180° .
% day: Specifies the date in 'dd.mm.yyyy' format.
% coord: (optional)	Specifies the geographic coordinates as 1 x 2 vector. 
%        Default: [13.326 52.514] for Berlin, Germany.
% offset: (optional) Defines the offset for local time adjustment to UTC,
%         e.g. 2 for Central European Summer Time (CEST). Default: 0
% mode: (optional) Specifies the accuracy:
%       'sec' for second exaclty (default)
%       'min' for minute exactly (faster)
%
% Reference:
% DIN EN 17037:2019-03: Daylight in buildings. 2019.
% https://www.beuth.de/de/norm/din-en-17037/287576515
%
% Author: Frederic Rudawski
% Date: 10.02.2020
% See: https://www.frudawski.de/south

function t = south(day,coord,offset,mode)

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
    coord = [13.326 52.514];
else
    if isempty(coord)
        coord = [13.326 52.514];
    end
end
if ~exist('offset','var')
    offset = 0; 
end
if ~exist('mode','var')
    mode = 'sec'; 
end

geolen = coord(1);
geow = coord(2);

% time steps in s
switch mode
    case 'min'
        time_increasement = 60;
    case 'sec'
        time_increasement = 1;
    otherwise
        warning('Unknown time precission mode in "south" function, using default ''sec'' for seconds.');
end
% date: YYYY.MM.DD
datevar = [day(7:end),'.',day(4:5),'.',day(1:2)];

% time
starttime = '00:00:00';
endtime   = '23:59:00';


% start script
starttime = [datevar,'_',starttime];
endtime   = [datevar,'_',endtime];

day = starttime(1,9:10);
month = starttime(1,6:7);
year = starttime(1,1:4);

y = str2double(year);
m = str2double(month);
d = str2double(day);


% time UTC
time = starttime(1,12:19);
hrsUTC = str2double(time(1:2));
minUTC = str2double(time(4:5));
secUTC = str2double(time(7:8));

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

% SkyVector contains the angles of the 145 sky patches, first line
% almucantar, second line azimut, third the skypatch number.
skyvector = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 66 66 66 66 66 66 66 66 66 66 66 66 78 78 78 78 78 78 90;180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 NaN;1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145];

timeBegin = hrsUTC*10000+minUTC*100+secUTC;
timeEnd   = str2double(endtime(12:13))*10000 + str2double(endtime(15:16))*100 + str2double(endtime(18:19));
row = 1;


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


if DAY >= summerday && DAY < winterday
    if hrsUTC+2 >= 10
        localtime_hrs = num2str(hrsUTC+2);
    else
        localtime_hrs = ['0',num2str(hrsUTC+2)];
    end
else
    if hrsUTC+1 >= 10
        localtime_hrs = num2str(hrsUTC+1);
    else
        localtime_hrs = ['0',num2str(hrsUTC+1)];
    end
end

while timeBegin <= timeEnd
    
    % time equation
    time_equation = 0.0066 + (7.3525*cos(Jt+deg2rad(85.9))) + (9.9359*cos(2*Jt+deg2rad(108.9))) + (0.3387*cos(3*Jt+deg2rad(105.2)));
    
    % deklination
    dek = 0.3948-23.2559*cos(Jt+deg2rad(9.1))-0.3915*cos(2*Jt+deg2rad(5.4))-0.1764*cos(3*Jt+deg2rad(26.0));
    
    % time
    LST = hrsUTC + minUTC/60 + secUTC/3600 + 1 -(4*(15-geolen)/60) + (time_equation/60);
    
    hourangle = ((LST-12)*15);
   
    % = 180+hourangle;
    hrs = floor(LST);
    minu = floor((LST - hrs)*60);
    sec = round((((LST - hrs)*60)-minu)*60);
    
    
    SEC = num2str(sec);
    if sec < 10
        SEC = ['0',SEC];
    end
    if sec == 60
        SEC = '00';
        minu = minu+1;
    end
    
    MIN = num2str(minu);
    if minu < 10
        MIN = ['0',MIN];
    end
    if minu == 60
        MIN = '00';
        hrs = hrs + 1;
    end

    HRS = num2str(hrs);
    if hrs < 10
        HRS = ['0',HRS];
    end


    
    % True Solar Time
    TST = [HRS,':',MIN,':',SEC];
    
    % Sun elevation angle
    elevation = rad2deg(asin(cos(deg2rad(hourangle))*cos(deg2rad(geow))*cos(deg2rad(dek)) + sin(deg2rad(geow))*sin(deg2rad(dek))));
    
    % sun azimuth
    toggle = hrs*10000 +  minu*100 + sec;
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
    UTC = [t1,':',t2,':',t3];
    localtime_min = t2;
    localtime_sec = t3;
    localtime = [localtime_hrs,':',localtime_min,':',localtime_sec];
    
    % patch almucantar & Azimuth
    if elevation >= 0 && elevation < 12 
        almucantar = 6;
        azimuthPatch = round(azimuth/12)*12;
    elseif elevation >= 12 && elevation < 24 
        almucantar = 18;
        azimuthPatch = round(azimuth/12)*12;
    elseif elevation >= 24 && elevation < 36
        almucantar = 30;
        azimuthPatch = round(azimuth/15)*15;
    elseif elevation >= 36 && elevation < 48
        almucantar = 42;
        azimuthPatch = round(azimuth/15)*15;
    elseif elevation >= 48 && elevation < 60
        almucantar = 54;
        azimuthPatch = round(azimuth/20)*20;
    elseif elevation >= 60 && elevation < 72
        almucantar = 66;
        azimuthPatch = round(azimuth/30)*30;
    elseif elevation >= 72 && elevation < 84
        almucantar = 78;
        azimuthPatch = round(azimuth/60)*60;
    elseif elevation >= 84
        almucantar = 90;
        azimuthPatch = NaN;
    else
        almucantar = NaN;
        azimuthPatch = NaN;
    end
    

    AlmucantarMatch = skyvector(1,:)-almucantar==0;
    AzimuthMatch = skyvector(2,:)-azimuthPatch==0;
    Match = (AlmucantarMatch+AzimuthMatch) == 2;
    Patch = skyvector(3,Match);
    if isempty(Patch) == 1
        Patch = NaN;
    end
    
    % data table / Matrix
    M2(row,:) = {localtime UTC TST azimuth elevation almucantar azimuthPatch Patch};
    row = row + 1;
    
    % Time increasing
    secUTC = secUTC + time_increasement;
    while secUTC >= 60
        secUTC = secUTC - 60;
        minUTC = minUTC + 1;
    end
    if minUTC >= 60
        hrsUTC = hrsUTC + 1;
        minUTC = minUTC-60;
    end
    timeBegin = hrsUTC*10000+minUTC*100+secUTC;
    
    % end while
end

% show True Solar time 12:00:00
try
    %[~,ind] = ismember('12:00:00',M2(:,3));
    [~,ind] = min(abs(str2num(cell2mat(strrep(M2(:,3),':','')))-120000));
    %t = M2{ind,1};
    t = M2{ind,2};
    if str2double(t(1:2))+offset < 10
        t(1:2) = ['0',num2str(str2double(t(1:2))+offset)];
    else
        t(1:2) = num2str(str2double(t(1:2))+offset);
    end
    disp([datevar,': TST 12:00:00 at ',M2{ind,2},' UTC.'])
catch
end

%{
if strcmp(save,'yes') == 1
    % filename for saving
    filename =  [strrep(starttime(1:10),'.','_'),'.xlsx'];
    % if aborted
    path = (uigetdir('','Save excel file to:'));
    if path == 0
        return
    end
    % save excel file
    M1 = {'local time' 'UTC' 'TST' 'sun_azimuth' 'sun_elevation' 'patch_almucantar' 'patch_azimuth' 'patch_number'};
    M = cell2table(M2,'VariableNames',{'local_time', 'UTC', 'TST', 'azimuth', 'elevation', 'patch_almucantar', 'patch_azimuth', 'patch_number'});
    writetable(M,[path,'\',filename])
end
%}