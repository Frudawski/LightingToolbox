% Horizontal and vertical illumance E from Tregenza sky luminance or radiance
% data. The Tregenza hemisphere is treated as if it covers the whole hemisphere
% with rectangle patches.
% 
% usage: [h,v] = polardataE(Y,direction)
%
% where: 
%   - h: is the horizontal illuminance
%   - v: is the vertical illuminance in compass directions specified by direction
%   - Y: is the luminance of the Tregenza hemisphere with 145 patches
%   - direction: specifies the compas direction of vertical illuminaces
%                default 1-360 in 1° steps
%                for north, east, sout, west use: [0 90 180 270]
%
% Author: Frederic Rudawski
% Date: 18.12.2019, updated: 12.03.2021, 13.01.2022
% See: https://www.frudawski.de/polardataE

function [h,v] = polardataE(Y,direction)


if ~exist('direction','var')
    direction = 1:360;
end

direction(direction==0) = 360;

if size(Y,1)~=145
    Y = Y';
    if size(Y,1)~=145
       error('Data size incorrect.')
    end
end
Y(isnan(Y)) = 0;

% reset parameters
vertical_integral = cell(1,360);

% patch numbers and angles in pnt
% line 1: patch center elevation
% line 2: patch center azimuth
% line 3: azimuth increment
% line 4: elevation increment
% line 5: Patchnumber
azinc = [ones(60,1).*12;ones(48,1).*15;ones(18,1).*24;ones(12,1).*30;ones(6,1).*60;360];
elinc = [ones(144,1).*12; 6];
pnt = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 66 66 66 66 66 66 66 66 66 66 66 66 78 78 78 78 78 78 87;...
    180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 0;...
    azinc';...
    elinc';...
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145;...
    ];

% horizontal illuminance
solid_anglehp = 1./4.*(cosd(2.*[(pnt(1,1:end-1)'-6);84]) - cosd(2.*[(pnt(1,1:end-1)'+6);90])).*azinc.*pi./180;
h = sum(solid_anglehp' .* Y(1:145,:)',2)';

% vertical illuminance for all 360 directions
%for i = 1:size(Y,2)
   
    input = Y;
    vi = zeros(360,size(input,2));
    for azimuth = 1:1:360
        for patch = 1:size(pnt,2)
            
            el1 = pnt(1,patch)-6;
            el2 = pnt(1,patch)+6;
            az2 = circledist(pnt(2,patch)-pnt(3,patch)/2,azimuth);
            az1 = az2+pnt(3,patch);
            if az1>90
                az1 = 90;
            end
            if az2>90
                az2 = 90;
            end
            if az1<-90
                az1 = -90;
            end
            if az2<-90
                az2 = -90;
            end
            az = [az1 az2];
            
            % E_v = int_{g_1}^{g_2} int_{a_1}^{a_2} L * sin(pi/2-g)* cos(g) * cos(a)  da dg
            % g = gamma: sun elevation angle
            % a = alpha: sun azimuth angle
            solid_anglevp = 1./4.*((sind(az(2)))-(sind(az(1)))).*(2*deg2rad(el1)-2*deg2rad(el2)+sind(2*el1)-sind(2*el2));
            vi(azimuth,:) = vi(azimuth,:) + input(patch,:).*solid_anglevp;
           
        end
    end
    %vertical_integral{i} = vi;
%end

v = vi(direction,:);