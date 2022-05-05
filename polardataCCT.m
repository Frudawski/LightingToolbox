% CCT data from x,y,Y input for 145 Tregenza patches. The Tregenza
% hemisphere is treated as if it does not cover the whole hemisphere with 
% as in Tregenza's paper: Subdivision of the sky hemisphere for luminance
% measurements.
%
% usage: [h,v] = polardataCCT(x,y,Y,direction,solidangle,method)
%
% where: - h: is the resulting horizontal integral CCT
%        - v: contains the resulting vertical compas directions in 360
%          degrees: N,E,S,W specified by direction
%        - Y: is the luminance of the tregenza hemisphere with 145 patches
%        - x and y: are the chromaticity coordinates (CIE 1931) for each patch
%        - direction: specifies the cpmpas direction default: 1-360 in 1° steps
%          for north, east, sout, west use: [0 90 180 270]
%        - solidangle: defines the solid angle of the patches in sr
%          default value: 0.022 sr
%        - method: defines the CCT determination method: 'Robertson', 'exact', 'Herandez'
%
% Reference:
% % Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103)
% https://journals.sagepub.com/doi/10.1177/096032718701900103
%
% Author: Frederic Rudawski
% Date: 18.12.2019, last edited 12.03.2021
% see: https://www.frudawski.de/polardataCCT

function [h,v] = polardataCCT(x,y,L,direction,solid,method)


if ~exist('direction','var')
    direction = 1:360;
end
if ~exist('solid','var')
    solid = 0.022;
end
if ~exist('method','var')
    method = 'Robertson';
end

direction(direction==0) = 360;

p = inputParser;
addRequired(p,'x',@isvector);
addRequired(p,'y',@isvector);
addRequired(p,'L',@isvector);
parse(p,x,y,L)

x = p.Results.x;
y = p.Results.y;
Y = p.Results.L;

if size(x,2) > size(x,1)
    x = x';
end
if size(y,2) > size(y,1)
    y = y';
end
if size(Y,2) > size(Y,1)
    Y = Y';
end

% reset parameters
vertical_integral = cell(1,360);

% patch numbers and angles in pnt
% line 1: patch center elevation
% line 2: patch center azimuth
% line 3: azimuth increment
% line 4: elevation increment
% line 5: Patchnumber
azinc = [ones(60,1).*12;ones(48,1).*15;ones(18,1).*24;ones(12,1).*30;ones(6,1).*60;360];
elinc = ones(145,1).*12;
pnt = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 66 66 66 66 66 66 66 66 66 66 66 66 78 78 78 78 78 78 90;...
    180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 NaN;...
    azinc';...
    elinc';...
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145;...
    ];

solid_angle = ones(size(pnt(1,:))).*solid;

X = Y./y.*x;
Z = Y./y.*(1-x-y);
input = [X Y Z];
input(isnan(input)) = 0;
if size(input,1)>145
    input = input(1:145,:);
end
% integrating over hemisphere
hX = sum( sind(pnt(1,:)) .* solid_angle .* input(:,1)');
hY = sum( sind(pnt(1,:)) .* solid_angle .* input(:,2)');
hZ = sum( sind(pnt(1,:)) .* solid_angle .* input(:,3)');
h = RobertsonCCT('x',(hX./(hX+hY+hZ)),'y',hY./(hX+hY+hZ),'warning','off');
 
for i = 1:size(Y,2)
 
    vi = zeros(360,size(input,2));
    for azimuth = 1:1:360
        
        
        if azimuth >= 0 && azimuth < 90
            %disp('0 - 90')
            from = azimuth-90;
            to   = azimuth+90;
            from = 360 + from;
            for patch = 1:size(pnt,2)
                if pnt(2,patch) > from || pnt(2,patch) < to
                    vi(azimuth,:) = vi(azimuth,:) + cosd(pnt(1,patch)).*cosd(abs(azimuth-pnt(2,patch))).*input(patch,:).*solid_angle(patch);
                end
            end
            
        elseif azimuth >= 90 && azimuth <= 270
            %disp('90 - 270')
            from = azimuth-90;
            to   = azimuth+90;
            for patch = 1:size(pnt,2)
                if pnt(2,patch) > from && pnt(2,patch) < to
                    %cosd(abs(azimuth-pnt(2,patch)))
                    vi(azimuth,:) = vi(azimuth,:) + cosd(pnt(1,patch)).*cosd(abs(azimuth-pnt(2,patch))).*input(patch,:).*solid_angle(patch);
                end
            end
            
        elseif azimuth > 270
            %disp('270 - 360')
            from = azimuth-90;
            to   = azimuth+90;
            to = to - 360;
            for patch = 1:size(pnt,2)
                if pnt(2,patch) > from || pnt(2,patch) < to
                    %cosd(abs(azimuth-pnt(2,patch)))
                    vi(azimuth,:) = vi(azimuth,:) + cosd(pnt(1,patch)).*cosd(abs(azimuth-pnt(2,patch))).*input(patch,:).*solid_angle(patch);
                end
            end
            
        end
    end
    
    vX = vi(:,1);
    vY = vi(:,2);
    vZ = vi(:,3);
    
    x = vX./(vX+vY+vZ);
    x(isnan(x)) = 0;
    polarx(1:360,i) = x;
    y = vY./(vX+vY+vZ);
    y(isnan(y)) = 0;
    polary(1:360,i) = y;
    
    switch method
      case 'Robertson'
        vertical_integral{i} = RobertsonCCT('x',x,'y',y,'warning','off');
      case 'exact'
        vertical_integral{i} = CCT('x',x,'y',y,'warning','off');
      case 'Hernandez'
        vertical_integral{i} = ciexy2cct(x,y,'Hernandez');
      end
    
end

v = cell2mat(vertical_integral);
v = v(direction);