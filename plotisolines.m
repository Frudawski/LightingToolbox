% iso line plot
%
% usage: plotisolines(x,y,data)
%
% where:
% x and y are the coordinate vectors of the mesh grid
% data represents the data to plot
% 
% author: Frederic Rudawski
% date: 16.07.2020, edited: 11.12.2021

function plotisolines(x,y,data)

zaxistext =  '';
titletext = '';

if exist('OCTAVE_VERSION', 'builtin')
  if max(data(:))>1
    mindat = floor(min(data(:)));
    maxdat = ceil(max(data(:)));
    datalabel = round(linspace(mindat,maxdat,11));
    [c,h] = contour(x,y,data,datalabel,'ShowText','on','linecolor','k');
    ax = gca;
    set(ax,'Zlabel',zaxistext);
  else
    [c,h] = contour(x,y,data,'ShowText','on','linecolor','k');
  end
else
    s = contour(x,y,data,'ShowText','on','Color','k');
    ax = gca;
	  ax.ZLabel.String = zaxistext;
end
xlabel('x');
ylabel('y');
axis equal
view([0 90]);

title(titletext)
