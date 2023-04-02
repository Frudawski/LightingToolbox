% pseudo color plot function
%
% usage: plotfalsecolours(x,y,data,mode,clabel,climits)
%
% where:
% x and y define the axis positions (optional)
% data is the data to plot
% mode: 'lin' or 'log'
% clabel is an optional input argument string for the colorbar label
% climits sets the colorbar range
% 
% author: Frederic Rudawski
% date: 20.03.2018, edited 24.10.2021, 14.12.2021, 04.01.2022

function plotfalsecolours(x,y,data,mode,clabel,climits)
  
axoff = 0;
  
if ~exist('data','var')
   data = [];
end
  
% check for image input without x and y input
if (size(x,1)>1) && (size(x,2)>1) && (size(data,1)<2 || size(data,2)<2)
  try
    axoff = 1;
    try
      climits = mode;
    catch
    end
    try
      clabel = data;
    catch
    end 
    mode = y;
  catch
  end
  data = x;
  x = 1:size(data,1);
  y = 1:size(data,2);
end

titletext = '';
if ~exist('clabel','var')
    %warning('No label provided for colorbar.')
    clabel = '';
end

if size(x,1) > 1 && size(x,2) > 1
    x = x(1,:);
end
if size(y,2) > 1 && size(y,1) > 1
    y = y(:,1)';
end

if ~exist('mode','var')
  mode = 'lin';
else
  switch mode
    case 'lin'
      % do nothing
    case 'log'
      % do nothing
    otherwise
     try
       climits = clabel;
     catch
     end
     try
       clabel = mode;
     catch
     end
  end
end

switch mode
  case 'lin'
   imagesc(data);
  case 'log'
   if exist('OCTAVE_VERSION', 'builtin')
     imagesc(real(log10(data)))
     
     idx = data~=0;
     c1 = min(data(idx));
     c2 = max(max(data));
     ex1 = 0;
     while abs(c1)*10^(ex1)<1
        ex1 = ex1+1;
     end
     ex1 = ex1-1;
     ex2 = 0;
     while abs(c2)/10^(ex2)>1
        ex2 = ex2+1;
     end
     %ex2 = ex2+1;
     
     ex = 10.^(-ex1:ex2);
     num_of_ticks = numel(ex);
     Ticks = log10(ex);
     TickLabels = ex;

    else
      imagesc(data);
      set(gca,'ColorScale','log')
   end
  otherwise
   imagesc(data);
end
c = colorbar;
if exist('OCTAVE_VERSION', 'builtin')
  if strcmp(mode,'log')
    set(c,'ytick',Ticks)
    set(c,'yticklabel',TickLabels)
    caxis([Ticks(1) Ticks(end)])
    try
      L = get(c,'label');
      set(L,'string',clabel)
    catch
    end
  else
    L = get(c,'label');
    set(L,'string',clabel)
  end
else
    c.Label.String = clabel;
end

if exist('climits','var')
  switch mode
    case 'lin'
      caxis(climits)
    case 'log'
      %caxis(log10(climits));
      caxis(climits)
    end
end
title(titletext)
axis equal
axis([0.5 size(data,2)+0.5 0.5 size(data,1)+0.5])

if exist('OCTAVE_VERSION', 'builtin')
    if (~isempty(y)) && (~isnan(y))
        yticklabels(ltfround(fliplr(y),1));
        ylabel('y');
    else
        yticklabels([]);
    end
    if (~isempty(x)) && (~isnan(x))
        xticklabels(ltfround(x,1));
        xlabel('x');
    else
        xticklabels([]);
    end
else
    if (~isempty(y)) & (~isnan(y))
        yticklabels(ltfround(fliplr(y),1));
        ylabel('y');
    else
        yticklabels([]);
    end
    if (~isempty(x)) & (~isnan(x))
        xticklabels(ltfround(x,1));
        xlabel('x');
    else
        xticklabels([]);
    end
end
    
if axoff
  axis off
  ylabel('');
  xlabel('');
end

