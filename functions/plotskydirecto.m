% Tregenza hemisphere directogram plot
%
% usage: Tregenza_directogram(data,color,viewpoint)
%
% data: vector with 145 elements
% color: optional - vector with 145x3 color entries. If not provided gray
%        scales with max = white is used.
% viewpoint: optional - set plot azimuth and elevation viewing direction
%
% author: Frederic Rudawski
% date: 20.03.2018 - updated: 19.07.2018, 15.12.2021


function plotskydirecto(data,clr,clabel,viewpoint,flip,mode)

if ~exist('viewpoint','var')
    viewpoint = [-40 33];
end

if ~isequal(size(data,1),145)
    data = data';  
end
if isequal(size(data,2),2)
    data1 = data(:,1);
    data2 = data(:,2);
else
    data1 = data;
    data2 = data;
end

cla reset

Y = data1;
if size(Y,2) > size(Y,1)
    Y = Y';
end

if ~exist('clr','var')
    CLR = data2;
    c = colorbar;
else
    if (isempty(clr)) | (isnan(clr))
        CLR = data2;
        c = colorbar;
    else
        if strcmp(clr,'w')
            CLR = ones(145,3);
        elseif strcmp(clr,'gray')
            CLR = data2;
            colormap(gray)
            c = colorbar;
        elseif strcmp(clr,'clr')
            CLR = data2;    
            if exist('OCTAVE_VERSION', 'builtin')
                colormap(viridis)
            else
                colormap(parula)
            end
            c = colorbar;
        else
            if ismatrix(clr)
                if size(clr,1) == 1
                    CLR = repmat(clr,145,1);
                else
                    CLR = clr;
                end
            else
                CLR = data2; 
                c = colorbar;
            end
        end
    end
end
CLR(isnan(CLR)) = 0;

if ~exist('flip','var')
    flip = 0;
end

if ~exist('mode','var')
    mode = 'sky';
end

if ~exist('clabel','var')
    clabel = '';
end

try
    if exist('OCTAVE_VERSION', 'builtin')
        L = get(c,'label');
        set(L,'string',clabel)
    else
        c.Label.String = clabel;
    end
catch
end

% Tregenza table
tt = [1 30 6 12; 2 30 18 12; 3 24 30 15; 4 24 42 15; 5 18 54 20; 6 12 66 30; 7 6 78 60; 8 1 90 0];
% patch numbers and angles
% line 1: almucantars
% line 2: azimuths
% line 3: Patchnumber
pnt = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 66 66 66 66 66 66 66 66 66 66 66 66 78 78 78 78 78 78 90;180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 NaN;1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145];

hold on

%    hold on
width = 5;
width = 90-width;
axis([0 1 0 1 0 1])
% normalize L
f = Y./max(Y);
r = 1;
els = 6;
hold on


for al = 1:size(tt,1)-1
    % plot almucantar
    ps = 0;
    for patchn = 1:tt(al,2)
        az = -deg2rad(ps-90);
        el = deg2rad(els);
        
        % patchnumber
        pp = find(pnt(1,:)==tt(al,3));
        p  = find(pnt(2,pp)==ps);
        patchn = pnt(3,pp(p));
        [x,y,z] = sph2cart(az,el,f(patchn));
        
        if flip
            line = plot3([0 x],[0 -y],[0 z],'-','Color',[0.35 0.35 0.35],'LineWidth',0.5);
        else
            line = plot3([0 x],[0 y],[0 z],'-','Color',[0.35 0.35 0.35],'LineWidth',0.5);
        end
        
        phi = deg2rad(linspace(0,360,101));
        theta = deg2rad(ones(1,101).*width);
        [x,y,z] = sph2cart(phi,theta,f(patchn));
        face = patch(x,y,z,CLR(patchn,:));
        set(face,'EdgeColor',[0.35 0.35 0.35])
        rotate(face,[0 1 0],90-rad2deg(el),[0 0 0]);
        if flip
            rotate(face,[0 0 1],rad2deg(-az),[0 0 0]);
        else
            rotate(face,[0 0 1],rad2deg(az),[0 0 0]);
        end
        
        ps = ps+tt(al,4);
    end
    els = els + 12;
end
% zenith
az = deg2rad(0);
el = deg2rad(90);
[x,y,z] = sph2cart(az,el,f(145));
line = plot3([0 x],[0 y],[0 z],'Color',[0.35 0.35 0.35]);

phi = deg2rad(linspace(0,360,101));
theta = deg2rad(ones(1,101).*width);
[x,y,z] = sph2cart(phi,theta,f(145));
face = patch(x,y,z,CLR(145,:));
set(face,'EdgeColor',[0.35 0.35 0.35])
title('')
axis  auto


% GLOBUS

% circle
a = axis;
c = 10/1.5;

width = max([abs(a(2)) abs(a(3))])*1.45/10;
phi = deg2rad(linspace(0,360,101));
theta = deg2rad(ones(1,101).*width);
[x,y,z] = sph2cart(phi,theta,width);

g1 = plot3(x,y,z,'Color',[0.55 0.55 0.55],'LineWidth',0.5);
g2 = plot3(x,y,z,'Color',[0.55 0.55 0.55],'LineWidth',0.5);
g3 = plot3(x,y,z,'Color',[0.55 0.55 0.55],'LineWidth',0.5);
rotate(g2,[0 1 0],90,[0 0 0]);
rotate(g3,[1 0 0],90,[0 0 0]);
x1 = get(g1,'XData');
set(g1,'XData',x1+width*c);
x2 = get(g2,'XData');
set(g2,'XData',x2+width*c);
x3 = get(g3,'XData');
set(g3,'XData',x3+width*c);
y1 = get(g1,'YData');
set(g1,'YData',y1-width*c);
y2 = get(g2,'YData');
set(g2,'YData',y2-width*c);
y3 = get(g3,'YData');
set(g3,'YData',y3-width*c);
[x,y,z] = sphere(50);
C(:,:,1) = ones(51).*0.85; % red
C(:,:,2) = ones(51).*0.85; % green
C(:,:,3) = ones(51).*0.85; % blue
globus = surf(x.*width+width*c, y.*width-width*c, z.*width,C);
set(globus,'EdgeColor','none');
%colormap(gray)
%shading interp

% Nord arrow
f = 2;
plot3([0 0]+width*c,[-f*width f*width]-width*c,[0 0],'Color',[0.55 0.55 0.55],'LineWidth',0.5)
plot3([0 0]+width*c,[0 0]-width*c,[-f*width f*width],'Color',[0.55 0.55 0.55],'LineWidth',0.5)
plot3([-f*width f*width]+width*c,[0 0]-width*c,[0 0],'Color',[0.55 0.55 0.55],'LineWidth',0.5)

switch mode
    case 'sky'
        text(width*c,-width*c+1.25*f.*width,0,'N','HorizontalAlignment','Center','VerticalAlignment','middle','Color',[0 0 0])
        text(width*c,-width*c,1.25*f.*width,'Z','HorizontalAlignment','Center','VerticalAlignment','middle','Color',[0 0 0])
        text(width*c,-width*c-1.25*f.*width,0,'S','HorizontalAlignment','Center','VerticalAlignment','middle','Color',[0 0 0])
    case 'view'
        text(width*c,-width*c+1.25*f.*width,0,'DOWN','HorizontalAlignment','Center','VerticalAlignment','middle','Color',[0 0 0])
        text(width*c,-width*c,1.25*f.*width,'VIEW','HorizontalAlignment','Center','VerticalAlignment','middle','Color',[0 0 0])
        text(width*c,-width*c-1.25*f.*width,0,'UP','HorizontalAlignment','Center','VerticalAlignment','middle','Color',[0 0 0])

end
view(viewpoint)

hold off
axis equal
grid on
axis off

