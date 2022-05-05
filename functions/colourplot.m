% colorplot:
% plots a set of colors given in a nx3 RGB matrix, next to each other.
%
% usage: colorplot(c)
%
% e.g.: c = colors(5)
%       colorplot(c)
%
% Example uses the colors function, not included in Matlab.
% Color values must range between 0 and 1.
% 
% Author: Frederic Rudawski
% Date: 30.08.2019
% See: https://www.frudawski.de/colourplot

function colourplot(RGB)

for i = 1:size(RGB,1)
    h=fill([i-1 i-1 i i i-1],[0 1 1 0 0],'r');
    set(h,'Facecolor',RGB(i,:));
    text(0.5+i-1,-0.05,num2str(i),'HorizontalAlignment','Center')
    hold on
end
axis off
hold off

