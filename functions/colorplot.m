% colourplot plots a set of colors given in a nx3 RGB matrix, next to each other.
%
% usage: colourplot(c) or colorplot(c)
%
% e.g.: c = colours(5)
%       colourplot(c)
% 
% Author: Frederic Rudawski
% Date: 30.08.2019
% See: https://www.frudawski.de/colourplot

function colorplot(RGB)

for i = 1:size(RGB,1)
    h=fill([i-1 i-1 i i i-1],[0 1 1 0 0],'r');
    set(h,'Facecolor',RGB(i,:));
    text(0.5+i-1,-0.05,num2str(i),'HorizontalAlignment','Center')
    hold on
end
axis off
hold off

