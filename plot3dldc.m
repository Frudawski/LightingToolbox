% plot 3D light intensity distribution curve (LDC)
%
% usage: h = plot3dldc(ldc,'parameter','value')
%
% where: 
%   ldt is a ldt-struct, see read_ldt
% parameters:
%    clr: is 3x1 colour vector - default: orange = [0.8594 0.5153 0]
%    mode: specifies different plot modi:
%       - '3D': 3D plot with light (default)
%       - 'wire': 3D wireframe
%       - 'norm': normalized 3D wireframe
%   origin: defines the origin of the LDC as 1x3 or 3x1 vector
%   rotation: defines the rotation matrix of the LDC as 3x3 matrix
%
% Author: Frederic Rudawski
% Date: 03.06.2020, edited 03.12.2021
% See: https://www.frudawski.de/plot3dldc

function h = plot3dldc(ldt,varargin)

% input parser
p = inputParser;
addRequired(p,'ldt',@isstruct);
addParameter(p,'clr',[0.8594 0.5153 0],@isvector)
addParameter(p,'mode','3D',@ischar)
addParameter(p,'origin',[0 0 0],@isvector)
addParameter(p,'rotation',eye(3),@ismatrix)
parse(p,ldt,varargin{:})

clr = p.Results.clr;
mode = p.Results.mode;
origin = p.Results.origin;
rotation = p.Results.rotation;

angleC = ldt.anglesC;
gamma = ldt.anglesG;
I = ldt.I;

[X, Y, Z] = s2c(angleC, gamma, I);
c = [X(:) Y(:) -Z(:)];
c = c*rotation;
X = reshape(c(:,1),size(angleC));
Y = reshape(c(:,2),size(angleC));
Z = reshape(c(:,3),size(angleC));
idx = angleC==0;
C0 = angleC(idx);
G0 = gamma(idx);
I0 = I(idx);
[X0, Y0, Z0] = s2c(C0, G0, I0);
c = [X0(:) Y0(:) -Z0(:)];
c = c*rotation;
X0 = reshape(c(:,1),size(C0));
Y0 = reshape(c(:,2),size(C0));
Z0 = reshape(c(:,3),size(C0));
if strcmp(mode,'norm')
    m = max(max(abs([X(:) Y(:) Z(:)])));
    X = X./m;
    Y = Y./m;
    Z = Z./m;
    %m = max(max([X0(:) Y0(:) Z0(:)]));
    X0 = X0./m;
    Y0 = Y0./m;
    Z0 = Z0./m;
end
X=[X X(:,1)]+origin(1);
Y=[Y Y(:,1)]+origin(2);
Z=[Z Z(:,1)];
X0 = X0+origin(1);
Y0 = Y0+origin(2);
rnan = isnan(X);
X(rnan) = 0;
rnan = isnan(Y);
Y(rnan) = 0;
rnan = isnan(X0);
X0(rnan) = 0;
rnan = isnan(Y0);
Y0(rnan) = 0;
switch mode
    case '3D'
        h = surf(X,Y,Z+origin(3),'facecolor',clr,'edgecolor','none');
        hold on
        camlight left
        try
          lighting phong
        catch
          lighting gouraud
        end
    case 'wire'
        h = surf(X,Y,Z+origin(3),'EdgeColor',clr,'Facecolor','none');
        hold on
        plot3(X0,Y0,Z0+origin(3),'Color',1-clr)
        %hold off
    case 'norm'
        h = surf(X,Y,Z+origin(3),'EdgeColor',clr,'Facecolor','none');
        hold on
        plot3(X0,Y0,Z0+origin(3),'Color',1-clr)
        %hold off
end
axis equal
box off
hold off


function [X, Y, Z] = s2c(angleC, gamma, I)

h = sind(gamma)  .* I;
X = cosd(angleC) .* h;
Y = sind(angleC) .* h;
Z = cosd(gamma)  .* I;
