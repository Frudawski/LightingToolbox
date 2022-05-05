% iso range plot
%
% usage: plotisorange(x,y,data,colorbarlabel,[min max])
%
% where:
% x and y are the coordinate vectors of the mesh grid
% data is the data to plot
% colorbarlabel is an optional input argument string for the colorbar label
% min and max sets the colorbar range
% 
% author: Frederic Rudawski
% date: 20.03.2018, last edited: 16.07.2020

function plotisorange(x,y,data,clabel,climits)

zaxistext =  '';
titletext = '';
if ~exist('clabel','var')
    clabel = '';
end


if exist('OCTAVE_VERSION', 'builtin')
  if max(data(:))>1
    mindat = floor(min(data(:)));
    maxdat = ceil(max(data(:)));
    datalabel = round(linspace(mindat,maxdat,11));
    [c,h] = contourf(x,y,data,datalabel,'ShowText','on','linecolor','k');
    ax = gca;
    set(ax,'Zlabel',zaxistext);
  else
    [c,h] = contourf(x,y,data,'ShowText','on','linecolor','k');
  end
  c = colorbar;
  L = get(c,'label');
  set(L,'string',clabel)
  if exist('climits','var')
     caxis(climits) 
  end
else
  s = contourf(x,y,data,'ShowText','on');
  xlabel('x');
  ylabel('y');
  view([0 90]);
  ax = gca;
  ax.ZLabel.String = zaxistext;
  c = colorbar;
  c.Label.String = clabel;
  if exist('climits','var')
     caxis(climits) 
  end
end

axis equal
title(titletext)
