% plotgrid plots a illuminance distribution for a given meshgrid given by
% the egrid function. The plot functions also extrapolates data outside the
% mesh points.
%
% usage: plotgrid(x,y,data,extrap,mode,clabel,climits)
%
% where:
% x and y are the coordinate matrices of the mesh grid
% data is the data to plot
% mode sets the plot mode: 'clr' or 'lines'
% clabel is an optional input argument string for the colorbar label
% climits sets the colorbar range
% 
% author: Frederic Rudawski
% date: 12.12.2021

function plotgrid(x,y,Y,mode,clabel,climits)

if ~exist('clabel','var')
    clabel = '';
end
if ~exist('climits','var')
    climits = [0 max(Y(:))];
end

% check for grid or vector input
if isequal(size(y,1),1)
   y = y';
end
if isequal(size(x,1),1) && isequal(size(y,2),1)
    [x,y]= meshgrid(x,y);
end

% extract area coordinates from grid
dx = (x(1,2)-x(1,1))/2;
dy = (y(2,1)-y(1,1))/2;
ax = [x(:,1)-dx x x(:,end)+dx];
ax = [ax(1,:); ax; ax(end,:)];
ay = [y(1,:)-dy; y; y(end,:)+dy];
ay = [ay(:,1) ay ay(:,end)];

% extrapolate borders
data = interp2(x,y,Y,ax,ay,'spline');

% call plot function depending on plot mode
switch mode
    case 'isocolor'
        if ~exist('climits','var')
            plotisorange(ax,ay,data,clabel)
        else
            plotisorange(ax,ay,data,clabel,climits)
        end
    case 'lines'
        plotisolines(ax,ay,data)
    case 'falsecolor'
        plotfalsecolours(x,y,Y,'lin',clabel,climits);
    otherwise
        error(['Undefined plot mode "',mode,'" in plotgrid funciton']) 
end


