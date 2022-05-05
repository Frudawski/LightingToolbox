% pseudo color plot function
%
% usage: plotpseudocolor(data,colorbarlabel,[min max])
%
% where:
% data is the data to plot
% colorbarlabel is an optional input argument string for the colorbar label
% min and max sets the colorbar range
% 
% author: Frederic Rudawski
% date: 20.03.2018, edited 24.10.2021, 14.12.2021

function plotpseudocolors(data,clabel,climits)

%zaxistext =  '';
titletext = 'pseudo colour plot';
if ~exist('colorbarlabel','var')
    clabel = '';
end

%data = [data data(:,end)];
%data = [data; data(end,:)];
%x = 0:size(data,2)-1;
%y = 0:size(data,1)-1;

%s = surf(x,y,data,'EdgeColor','none');
imagesc(data);
xlabel('x');
ylabel('y');

axis equal
%view([0 90]);

%ax = gca;
%ax.ZLabel.String = zaxistext;
c = colorbar;
c.Label.String = clabel;
if exist('climits','var')
   caxis(climits) 
end
title(titletext)
