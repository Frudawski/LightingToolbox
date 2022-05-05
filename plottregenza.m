% Plot Tregenza hemisphere (flat) with 145 sky patches.
%
% usage: Tregenza_plot(values,color,info,fontsize,[sun_az sun_el],gradation_patches,indicatrix_patches)
% 
% e.g. Tregenza_plot(1:145',repmat(rand(145,1),3),{'ID','date','time'},8,[148 23],[55 65 104 112 136 140 144 128 124 88 81 35 26],[57 65 82 33])
%
% Only values are mandatory.
%
% The info cell struct can contain up to 20 entries. It will be distibuted
% around the plot in blocks of 5, starting in the left top -> right top -> left bottom -> right bottom.
%
% Reference:
% Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103)
% https://journals.sagepub.com/doi/10.1177/096032718701900103
%
% Author: Frederic Rudawski
% Date: 19.06.2018, edited 16.12.2021
% see: https://www.frudawski.de/plottregenza

function plottregenza(values,clr,clabel,information,fontsize,sun,grad,ind,direction)

cla reset
plot(NaN,NaN)

if size(values,2) > 2
  values = values';
end

if isequal(size(values,2),2)
    data1 = values(:,1);
    data2 = values(:,2);
    cmapon = 1;
else
    data1 = values;
    data2 = values;
    cmapon = 0;
end

lim = 1.5;
lim2 = max(data2)/2;


if ~exist('clr','var')
    clr = data2;
    lim = lim2;
    colormap(gray)
else
    if (isempty(clr)) | (isnan(clr))
        clr = data2;
        lim = lim2;
    else
        if strcmp(clr,'w')
            clr = ones(145,3);
        elseif strcmp(clr,'gray')
            clr = data2;
            colormap(gray)
            lim = lim2;
        elseif strcmp(clr,'clr')
            clr = data2;    
            if exist('OCTAVE_VERSION', 'builtin')
                colormap(viridis)
            else
                colormap(parula)
            end
            lim = lim2;
        else
            if ismatrix(clr)
                if size(clr,1) == 1
                    clr = repmat(clr,145,1);
                    lim = lim2;
                else

                end
            else
                clr = data2; 
                lim = lim2;
            end
        end
    end
end
clr(isnan(clr)) = 0;

values = ltfround(data1,1);



if ~exist('fontsize','var')
    fontsize = 8;
end
if isempty(fontsize)
    fontsize = 8;
end
    
% NaN color red
try
    [nanind,~] = find(isnan(clr));
    nanind = unique(nanind,'rows');
catch
end

if ~exist('direction','var')
    direction = 1;
end

% Tregenza table
%tt = [1 30 6 12; 2 30 18 12; 3 24 30 15; 4 24 42 15; 5 18 54 20; 6 12 66 30; 7 6 78 60; 8 1 90 0];
azinc = [ones(1,60).*12 ones(1,48).*15 ones(1,18).*20 ones(1,12).*30 ones(1,6).*60 360];
% patch numbers and angles
% line 1: almucantars
% line 2: azimuths
% line 3: Patchnumber
% line 4: elevation start
% line 5: elevation stop
% line 6: azimuth start
% line 7: azimuth stop
pnt = zeros(7,145);
pnt(1:3,:) = [ones(1,30).*6 ones(1,30).*18 ones(1,24).*30 ones(1,24).*42 ones(1,18).*54 ones(1,12).*66 ones(1,6).*78 90;180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 NaN;1:145;];
pnt(4,:) = pnt(1,:)-6;
pnt(5,:) = pnt(1,:)+6;
pnt(5,end) = 90;
pnt(6,:) = pnt(2,:)-azinc./2;
pnt(7,:) = pnt(2,:)+azinc./2;
pnt(6,end) = 0;
pnt(7,end) = 360;
rhos = 1.4-pnt(1,:)./60;

% clear axes
cla reset
set(gca,'box','off');
set(gca,'visible','off');
hold on
circle = 0:0.01:2*pi;
zenit = ones(size(circle)).*0.1;
%polarplot(0,0)
view([90 -90])
axis equal;

% set North South West East Markers
if direction
    text(0,1.65,'E','HorizontalAlignment','center','FontSize',12)
    text(0,-1.65,'W','HorizontalAlignment','center','FontSize',12)
    text(1.65,0,'N','HorizontalAlignment','center','FontSize',12)
    text(-1.65,0,'S','HorizontalAlignment','center','FontSize',12)
end

% Initialize patches
patchn(1:145) = NaN;

% Zenit
[X,Y] = pol2cart(circle,zenit);
patchn(145) = fill(X,Y,clr(145,:));

try
    if ~isnan(values(145))
        if sum(clr(end,:),2) >= lim
            t(145) = text(0,0,num2str(values(145)),'HorizontalAlignment','center','Color','k');
        else
            t(145) = text(0,0,num2str(values(145)),'HorizontalAlignment','center','Color','w');
        end
        t(145).FontSize = fontsize;
        t(145).VerticalAlignment = 'middle';
    end
catch
end

% gradation boxes
a = 0.07; % vertical radius Gradation
b = 0.15; % horizontal radius Gradation
c = -pi:0.01:pi;
% indicatrix boxes
boxix = [-0.07 -0.07 -0.03 0.03 0.07 0.07 0.03 -0.03 -0.07];
boxiy = [-0.05 0.05 0.15 0.15 0.05 -0.05 -0.15 -0.15 -0.05];


% patch loop
for p = 1:144
    theta = deg2rad([linspace(pnt(6,p),pnt(7,p),10) linspace(pnt(7,p),pnt(6,p),10) pnt(6,p)]);
    rho(1:21) = rhos(p);
    rho(11:20) = rhos(p)+0.2;
    % plot patch
    [X,Y] = pol2cart(theta,rho);
    patchn(p) = patch(X,Y,clr(p,:));

    % patch value text coordinates
    [x,y] = pol2cart(deg2rad(pnt(2,p)),mean(rho(1:20)));

    try
        if ~isnan(values(p))
            if sum(clr(p,:),2) >= lim
                t(p) = text(x,y,num2str(values(p)),'HorizontalAlignment','center','VerticalAlignment','middle','Color','k');
            else
                t(p) = text(x,y,num2str(values(p)),'HorizontalAlignment','center','VerticalAlignment','middle','Color','w');
            end
            t(p).FontSize = fontsize;
            t(p).VerticalAlignment = 'middle';
        else
            t(p) = text(x,y,''); 
        end
    catch
        
    end
end

try 
    sun_el = 1.5-sun(2)./60;
    sun_az = deg2rad(sun(1));
    % define Sun
    [SUNX,SUNY] = pol2cart(sun_az,sun_el);
    rho = 1.5;
    mer = [sun_az, sun_az + pi];
    [X,Y] = pol2cart(mer,rho);
    
    SUN = plot(SUNX,SUNY,'*','MarkerSize',10,'Color',[1 0.9 0],'LineWidth',1.5); %
    plot(X,Y,'color', [1 0.9 0],'LineWidth',1.5);
    %uistack(t(:), 'top')
catch
    %catcher(me)
end


% gradation & indicatrix highlight
try
    if ~isempty(grad) || ~isempty(ind)
        for p = 1:145
            try
                % plot gradation highlight
                theta = deg2rad([linspace(pnt(6,p),pnt(7,p),10) linspace(pnt(7,p),pnt(6,p),10) pnt(6,p)]);
                rho(1:21) = rhos(p);
                rho(11:20) = rhos(p)+0.2;
                [X,Y] = pol2cart(theta,rho);
                if ismember(p,grad)
                    xx = mean(X)+a*cos(c);
                    yy = mean(Y)+b*sin(c);
                    plot(xx,yy,'Color', [0.5 0.9 0.7]);
                end
                % plot indicatrix highlight
                if ismember(p,ind)
                    x = mean(X)+boxix;%X(1)+A*cos(t);
                    y = mean(Y)+boxiy;%Y(1)+B*sin(t);
                    plot(x,y,'Color', [0.9 0.5 0.5])
                end
            catch
            end
        end
    end
catch
end

% print info
try
    % first block
    ty =  1.7;
    tx = -1.7;
    for i = 1:5
       try
          tinfo = text(ty,tx,information{i});
          set(tinfo,'FontSize',fontsize+2);
          ty = ty-0.125;
       catch
       end
    end
    % second block
    ty = 1.7;
    tx = 1.7;
    for i = 6:10
       try
          tinfo = text(ty,tx,information{i},'HorizontalAlignment','right');
          set(tinfo,'FontSize',fontsize+2);
          ty = ty-0.125;
       catch
       end
    end
    % third block
    ty = -1.7;
    tx = -1.7;
    for i = 11:15
       try
          tinfo = text(ty,tx,information{i});
          set(tinfo,'FontSize',fontsize+2);
          ty = ty+0.125;
       catch
       end
    end
    % fourth block
    ty = -1.7;
    tx =  1.7;
    for i = 16:21
       try
          tinfo = text(ty,tx,information{i},'HorizontalAlignment','right');
          set(tinfo,'FontSize',fontsize+2);
          ty = ty+0.125;
       catch
       end
    end
catch   
end

try
    uistack(t(:), 'top')
catch
end
axis([-1.5 1.5 -1.5 1.5])

try
  if isequal(cmapon,1)
   c = colorbar;
   if exist('OCTAVE_VERSION', 'builtin')
      L = get(c,'label');
      set(L,'string',clabel)
    else
      c.Label.String = clabel;
    end
  end
      caxis([0 max(clr)]);
catch
end

% end of function
end


