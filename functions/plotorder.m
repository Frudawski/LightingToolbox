% Plots figures with specified colour order, line style and marker.
%
% usage: h = plotorder(x,y,colours,'parameter','value')
%
% where colours is a nx3 matrix and h the return handle(s) of the line plots. 
%
% Optional parameters:
% 'LineStyle' : standard Matlab linestyle parameters
%               '-' solid line (default)
%               ':' dotted line
%               '.-' dashed-dotted line
%               '--' dashed line
% 'Marker' : standard Matlab markers
%               '*' star
%               '.' point
%               '+' plus
%               'o' circle
%               'x' cross
%               's' square
%               'd' diamond
%               '^' upward traingle
%               'v' downward triangle
%               '<' triangle left
%               '>' triangle right
% 
% example: c = [1 0 0;0 1 0;0 0 1]; 
%          plotc(1:10,rand(3,10),c,'Marker',{'+','o','d'});
%
%
% Author: Frederic Rudawski
% Date: 25.06.2019
% last updated: 28.09.2019
% see: https//www.frudawski.de/plotorder

function h = plotorder(x,y,c,varargin)


p = inputParser;
addRequired(p,'x', @ismatrix);
addRequired(p,'y', @ismatrix);
addRequired(p,'c', @ismatrix);
addParameter(p,'LineStyle',repmat({'-'},1,size(y,1)),@iscell)
addParameter(p,'Marker',repmat({'none'},1,size(y,1)),@iscell)
addParameter(p,'LineWidth',1)
parse(p,x,y,c,varargin{:})

ls = p.Results.LineStyle;
mk = p.Results.Marker;
lw = p.Results.LineWidth;
if isscalar(lw)
    lw = repmat(lw,size(y,1));
end

h(1) = plot(x,y(1,:),'Color',c(1,:),'LineStyle',ls{1},'Marker',mk{1},'LineWidth',lw(1));
hold on
for i = 2:size(y,1)
    h(i) = plot(x,y(i,:),'Color',c(i,:),'LineStyle',ls{i},'Marker',mk{i},'LineWidth',lw(i));
end
hold off
end


