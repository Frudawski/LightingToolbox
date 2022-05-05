% plotcolor:
% plots a set of colors given in a nx3 RGB matrix, next to each other.
%
% Same function as colorplot
% 
% usage: plotcolor(c)
%
% e.g.: c = colors(5)
%       plotcolor(c)
%
% Example uses the colors function, not included in Matlab.
% Color values must range between 0 and 1.
% 
% Author: Frederic Rudawski
% Date: 30.08.2019, last edited: 12.06.2020

function plotcolor(RGB)

if size(RGB,1) < 20
    for i = 1:size(RGB,1)
        h=fill([i-1 i-1 i i i-1],[0 1 1 0 0],'r');
        set(h,'Facecolor',RGB(i,:));
        text(0.5+i-1,-0.05,num2str(i),'HorizontalAlignment','Center')
        hold on
    end
else
    for i = 1:size(RGB,1)
        h=fill([i-1 i-1 i i i-1],[0 1 1 0 0],'r');
        set(h,'Facecolor',RGB(i,:),'EdgeColor','none');
        %text(0.5+i-1,-0.05,num2str(i),'HorizontalAlignment','Center')
        hold on
    end
end
axis off
hold off

