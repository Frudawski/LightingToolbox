% polar plot for CCT compass direction from x,y,Y input for 145 Tregenza
% patches. The Tregenza hemisphere is treated as if it does not cover the 
% whole hemisphere using the round patches form. The function uses the normal
% plot (cartesian coordinates) in order to avoid axes handle problems appearing
% in combination with polarplot in GUIs. polarplot deletes the axes and creates
% a new polarplot axes and therefor does not work properly in GUIs.
%
% usage: [h_int,v_int] = plotpolarcct(x,y,Y,direction,'parameter',value)
%
% where: h_int is the resulting horizontal integral and v_int contains the 
%        resulting vertical globus direction N,E,S,W. see polardataCCT
%        function
%
% parameters:
%        'Background' : 'black' or 'white' (default 'white') 
%        'D65' : 'on' or 'off' (default 'on') - draws an additional
%                 D65 circle in figure
%        'info' : info string
%        'FontSize' : Fontsize 
%        'solidangle': solid angle, default 0.022 for TU Berlin spec. sky
%                      scanner
%
% Author: Frederic Rudawski
% Date: 26.07.2018, last edited 12.03.2021

function [h,v] = plotpolarCCT(x,y,L,direction,varargin)


if ~exist('direction','var')
    direction = 1:360;
end
direction(direction==0) = 360;

cla reset
hold off

p = inputParser;
addRequired(p,'x',@isvector);
addRequired(p,'y',@isvector);
addRequired(p,'L',@isvector);
addParameter(p,'Background','white',@(f) ismember(f,{'black','white'}))
addParameter(p,'D65','on',@(f) ismember(f,{'on','off'}))
addParameter(p,'info','')
addParameter(p,'max',[],@isnumeric)
addParameter(p,'FontSize',8,@isnumeric)
addParameter(p,'solidangle',0.022,@isnumeric)
parse(p,x,y,L,varargin{:})

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

% black background ?
if strcmp(p.Results.Background,'black')
    black_background = 1;
else
    black_background = 0;
end

legend_horizontal = 'horizontal';
legend_vertical = 'vertical';
legend_6500 = '6500 K';

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

% angles
solid_angle = ones(size(pnt(1,:))).*p.Results.solidangle;

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
    y = vY./(vX+vY+vZ);
    y(isnan(y)) = 0;
    
    vertical_integral{i} = RobertsonCCT('x',x,'y',y,'warning','off');
    
end

% legend dummy plots
if black_background
    plot(NaN,NaN,'--w')
    hold on
    plot(NaN,NaN,'-w')
    plot(NaN,NaN,'-.w')
else
    plot(NaN,NaN,'--k')
    hold on
    plot(NaN,NaN,'-k')
    plot(NaN,NaN,'-.k')
end
% plot
theta = -linspace(0,2*pi,360)+pi/2;
rho1 = h'.*ones(size(vertical_integral{1}));
rho2 = vertical_integral{1};
rho3 = 6500.*ones(size(vi,1),1);

% background & outer grid
range = max([6500 h max(cell2mat(vertical_integral))]);
limit = ceil(range/10^(size(num2str(range),2)-1))*10^(size(num2str(range),2)-1);
if ~isempty(p.Results.max) && ~isequal(p.Results.max,0)
   limit = p.Results.max; 
end
rho0  = limit.*ones(size(vi,1),1);
[xs0,ys0] = pol2cart(theta,rho0');
if black_background
    fill(xs0,ys0,[0 0 0],'EdgeColor',[0.15 0.15 0.15])
    plot([min(xs0) max(xs0)],[mean(ys0) mean(ys0)],'Color',[0.15 0.15 0.15])
    plot([mean(xs0) mean(xs0)],[min(ys0) max(ys0)],'Color',[0.15 0.15 0.15])
    text(max(xs0)*1.1,mean(ys0),'E','Color',[1 1 1],'HorizontalAlignment','center','VerticalAlignment','middle')
    text(min(xs0)*1.1,mean(ys0),'W','Color',[1 1 1],'HorizontalAlignment','center','VerticalAlignment','middle')
    text(mean(xs0),max(ys0)*1.1,'N','Color',[1 1 1],'HorizontalAlignment','center','VerticalAlignment','middle')
    text(mean(xs0),min(ys0)*1.1,'S','Color',[1 1 1],'HorizontalAlignment','center','VerticalAlignment','middle')
else
    fill(xs0,ys0,[1 1 1],'EdgeColor',[0.85 0.85 0.85])
    plot([min(xs0) max(xs0)],[mean(ys0) mean(ys0)],'Color',[0.85 0.85 0.85])
    plot([mean(xs0) mean(xs0)],[min(ys0) max(ys0)],'Color',[0.85 0.85 0.85])
    text(max(xs0)*1.1,mean(ys0),'E','Color',[0 0 0],'HorizontalAlignment','center','VerticalAlignment','middle')
    text(min(xs0)*1.1,mean(ys0),'W','Color',[0 0 0],'HorizontalAlignment','center','VerticalAlignment','middle')
    text(mean(xs0),max(ys0)*1.1,'N','Color',[0 0 0],'HorizontalAlignment','center','VerticalAlignment','middle')
    text(mean(xs0),min(ys0)*1.1,'S','Color',[0 0 0],'HorizontalAlignment','center','VerticalAlignment','middle')
end

% outer grid text
text(xs0(45)*1.05,ys0(45)*1.05,[num2str(limit),' K'],'FontSize',p.Results.FontSize)
% grid
num = ceil(range/10^(size(num2str(range),2)-1));
if mod(num,2) % odd limit number
    steps = [1 3 5];
    [~,ind]= find(mod(num,steps)==0);
    steps = steps(max(ind));
    if isequal(steps,1)
        gridlines = num/2.*10^(size(num2str(range),2)-1);
    else
        gridlines = [steps:steps:num-steps].*10^(size(num2str(range),2)-1);
        if isempty(gridlines)
            gridlines = num/2.*10^(size(num2str(range),2)-1);
        end
    end
else% even number limit
    steps = [2 5];
    [~,ind]= find(mod(num,steps)==0);
    steps = steps(max(ind));
    if isequal(steps,1)
        gridlines = num/2.*10^(size(num2str(range),2)-1);
    else
        gridlines = [steps:steps:num-steps].*10^(size(num2str(range),2)-1);
        if isempty(gridlines)
            gridlines = num/2.*10^(size(num2str(range),2)-1);
        end
    end
end


for i = 1:size(gridlines,2)
    % plot grid line and text
    [xsgrid,ysgrid] = pol2cart(theta,[gridlines(i).*ones(size(vi,1),1)]');
    if black_background
        plot(xsgrid,ysgrid,'Color',[0.15 0.15 0.15])
    else
        plot(xsgrid,ysgrid,'Color',[0.85 0.85 0.85])
    end
    if isequal(i,1)
        text(xsgrid(45)+xs0(45)*0.05,ysgrid(45)+ys0(45)*0.05,[num2str(gridlines(i)),' K'],'FontSize',p.Results.FontSize)
    end
end

[xs1,ys1] = pol2cart(theta,rho1');
[xs2,ys2] = pol2cart(theta,rho2');
[xs3,ys3] = pol2cart(theta,rho3');
if black_background
    if strcmp(p.Results.D65,'on')
        pol = plot(xs1,ys1,'w--',xs2,ys2,'w-',xs3,ys3,'w-.');
    else
        pol = plot(xs1,ys1,'w--',xs2,ys2,'w-');
    end
else
    if strcmp(p.Results.D65,'on')
        pol = plot(xs1,ys1,'k--',xs2,ys2,'k-',xs3,ys3,'k-.');
    else
        pol = plot(xs1,ys1,'k--',xs2,ys2,'k-');
    end
end
hold on
ax = gca;

if black_background
    if strcmp(p.Results.D65,'on')
        LE=legend(['\color[rgb]{1 1 1}',legend_horizontal],['\color[rgb]{1 1 1}',legend_vertical],['\color[rgb]{1 1 1}',legend_6500]);
    else
        LE=legend(['\color[rgb]{1 1 1}',legend_horizontal],['\color[rgb]{1 1 1}',legend_vertical]);
    end
    LE.Color = [0 0 0];
    LE.EdgeColor = [1 1 1];
else
    if strcmp(p.Results.D65,'on')
        LE = legend(legend_horizontal,legend_vertical,legend_6500);
    else
        LE = legend(legend_horizontal,legend_vertical);
    end
end

% Legend
if exist('OCTAVE_VERSION', 'builtin')
  set(LE,'Location','SouthOutside');
  set(LE,'Orientation','Horizontal');
else
  LE.Location = 'SouthOutside';
  LE.Orientation = 'Horizontal';
end

% black background ?
if black_background
    
    fig = gcf;
    set(ax,'color',[0 0 0])
    set(fig,'color',[0 0 0])
    ax.GridColor = [1 1 1];
    ax.GridAlpha = 0.5;
    set(ax,'GridColorMode','auto')
    ax.LineWidth = 1;
    grid on
    fig.InvertHardcopy = 'off';
else
    fig = gcf;
    set(ax,'color',[1 1 1])
    set(fig,'color',[0.95 0.95 0.95])
    set(ax,'GridColorMode','auto')
    set(ax,'LineWidth',1);
    grid on
end

title(['CCT distribution in K',10])

%a = axis;
axis equal
axis off

text(-limit*1.2,-limit*1.2,p.Results.info,'HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',p.Results.FontSize)

v = cell2mat(vertical_integral);
v = v(direction);