function file = saveplot(name,varargin)
% Saves a hardcopy of the figure or axes and returns file location.
%
% The function creates a new invisible figure and copies all elements of
% the target figure/axes print it in the specified file format and closes
% the new figure.
%
% usage:
% saveplot('name','parameter','value',...)
% if empty call is used: saveplot(), the function uses the figure name or a
% default name: plot_figureNr. If no figure or axes hanlde is given the
% current figure will be used for saving.
%
% parameters:
%   'handle': figure or axes handle
%             default: current figure (gcf)
%   'fileformat': 'png','eps','pdf','svg','jpg','tiff','bmp','clipboard'
%                 default: 'png'
%   'resolution': print resolution for none vector grafics as: png, tiff, jpg, bmp
%   'papersize': [width height], set the papersize for printing the plot.
%   'popup': 'on','off' (default 'on')
%            when calling saveplot a uiputfile dialog will appear where you
%            can chose the folder and filename for saving. If you don't
%            want a popup, disable it and specify the folder with next two
%            parameters. 
%   'path': 'absolut','relative', specifies if the filename is relative or
%           absolut. If absolut is used, the folder must be provided, 
%           see 'folder' parameter. The relative folder starts in the current
%           working directory of Matlab (pwd).
%   'folder': 'absolut folder path', specifies folder in which plot will be saved.
%   'InvertHardcopy': 'on','off' (defaul: 'off')
%           save the actual background (and text color(s)) of the plot
%
%
% supported fileformats: 'pdf', 'eps', 'svg', 'png', 'jpg', 'tiff', 'bmp', 'clipboard'
% Standard fileformat is png
%
% Author: Frederic Rudawski
% Date: 20.02.2014 - last updated: 21.03.2022
% See: https://www.frudawski.de/saveplot

p = inputParser;
addOptional(p,'name',[],@(f) (isempty(f) || ischar(f)));
addParameter(p,'handle',gcf,@ishandle)
addParameter(p,'fileformat','png',@(f) ismember(f,{'png','pdf','bmp','tiff','jpg','svg','clipboard'}));
addParameter(p,'resolution',300,@isnumeric)
%addParameter(p,'linewidth',1,@isnumeric);
addParameter(p,'papersize',[],@isvector);
addParameter(p,'path','absolut',@(f) ismember(f,{'absolut','relative'}))
addParameter(p,'popup','on',@(f) ismember(f,{'on','off'}))
addParameter(p,'folder',pwd,@ischar)
%addParameter(p,'rotate',0,@isnumeric)
addParameter(p,'InvertHardcopy','off',@(f) ismember(f,{'on','off'}))
if exist('name','var')
    parse(p,name,varargin{:})
else
    parse(p,varargin{:})
end

% map input to function parameters
name = p.Results.name;
h1 = p.Results.handle;
fileformat = p.Results.fileformat;
resolution = p.Results.resolution;
%linewidth = p.Results.linewidth;
papersize = p.Results.papersize;
%rot = p.Results.rotate;

try
  col = get(gcf,'color');
catch
end


try
    % get Papersize and units
    ps = get(h1,'PaperSize');
    pos = get(h1,'PaperPosition');
    orientation = get(h1,'PaperOrientation');
    outpos = get(h1,'outerposition');
    clrmp = get(h1,'Colormap');
    unit = get(h1,'Units');
    
    % define new figure
    h2=figure;
    %h2.InvertHardcopy = 'off';
    set(h2,'PaperPositionMode','auto','visible','off','units',unit,'PaperPosition',pos,'outerposition', outpos,'PaperOrientation',orientation,'PaperSize',ps)
    %set(h2,'visible','on')
    catch
    h2 = figure;
    h2.InvertHardcopy = 'off';
    set(h2,'color','w');
    set(h2,'PaperPositionMode','auto','units','normalized','visible','off');
end

try
  set(gcf,'color',col);
catch
end

% copy figure for saving
try
    % figure
    copyobj(get(h1,'children'),h2);
catch
    % axes
    copyobj(h1,h2);
    h2.Units = h1.Units;
    h2.Children.Position = [0.15 0.15 0.7 0.7];
    try
        copyobj(h1.Children,h2.CurrentAxes.Children)
        %col = get(h1,'color');
    catch
    end
end

% copy colorbar
try
    copyobj(h1.Colorbar,h2.Children.Colorbar);
    if ~isempty(h1.Colorbar)
        c = colorbar;
        c.Label.String = h1.Colorbar.Label.String;
    end
catch    
end

% copy colormap
try
    % axes
    cm = h1.Parent.Colormap;
    colormap(cm)
catch
    % figure
    try
        h2.Colormap = clrmp;
    catch   
    end
end

% copy legend
try
    if ~isempty(h1.Legend)
        L = legend(h1.Legend.String);
        L.Location = h1.Legend.Location;
        L.Orientation = h1.Legend.Orientation;
        L.Box = h1.Legend.Box;
        L.Visible = h1.Legend.Visible;
    end
catch
end
% make sure legend is not in background
LE = findobj(gcf,'Type','axes','Tag','legend');
try
  uistack(LE,'top');
catch
end
% check papersize argument
if ~isempty(papersize)
    set(h2,'Papersize',papersize)
end
% check filename
if isempty(name)
    try
        % try figure name
        name = get(h1,'Name');
        % use figure number
        if isempty(name)
            name = ['plot ',num2str(h1.Number)];
        end
    catch
        % no figure
        name = 'plot';
    end
end
% check for fileformat
if exist('fileformat','var') == 0
    fileformat = 'png';
end
% check resolution
if exist('resolution','var') == 0
    resolution = '-r300';
else
    resolution = ['-r',num2str(resolution)];
end
% check line width
if exist('linewidth','var') == 0
    linewidth = 1;
end
% change plot linewidth
linesource = findobj(h1,'Type','line');
markersource = findobj(h1,'Type','marker');

lineplot = findobj(h2,'Type','line');
try
for n = 1:length(linesource)
    set(lineplot(n),'LineWidth',get(linesource(n),'LineWidth'));
end
catch
end
markerplot = findobj(h2,'Type','marker');
try
for n = length(markersource)
    set(markerplot(n),'LineWidth',get(markersource(n),'LineWidth'));
    set(markerplot(n),'MarkerSize',get(markersource(n),'MarkerSize'));
end
catch
end
%set(lineplot,'Linewidth',linewidth);
%set(markerplot,'Linewidth',linewidth);

% OS Dependend folder seperator
if ismac || isunix
    sep = '/';
else
    sep = '\';
end

try
    h2.Colormap = h1.Colormap;
catch
end

% folder
if strcmp(p.Results.popup,'on')
    % select save path
    [IMAGEFILE,Save] = uiputfile(['*.',fileformat],'Save as...',name);
    if Save == 0
        file = 'Aborted by user.';
        return;
    end
else
    if strcmp(p.Results.path,'relative')
        Save = [pwd sep];
        IMAGEFILE = [name '.' fileformat];
    else
        if strcmp(p.Results.folder(end),sep)
            Save = p.Results.folder;
        else
            Save = [p.Results.folder sep];
        end
        IMAGEFILE = [name '.' fileformat];
    end
end
SaveTo = [Save, IMAGEFILE];

% save plot
if strcmp(p.Results.InvertHardcopy,'off')
    set(h2,'InvertHardcopy','off');
    %set(h2,'Color','w')
end

try
    h2.Children.Colormap = h1.Children.Colormap;
    cm = colormap;
    colormap(h1.Children.Colormap);
catch
end

switch fileformat
    case 'pdf'
       print(h2,'-dpdf', SaveTo,'-fillpage');
    case 'eps'
        print(h2,'-depsc',resolution, SaveTo,'-fillpage');
    case 'svg'
        print(h2, '-dsvg',resolution, SaveTo);
    case 'png'
        print(h2,'-dpng',resolution, SaveTo);
            % rotate image
            %B = imrotate(I,rot);
            %imwrite(B,SaveTo)
    case 'jpg'
        print(h2,'-djpeg',resolution, SaveTo);
            % rotate image
            %B = imrotate(I,rot);
            %imwrite(B,SaveTo)
    case 'tiff'
        print(h2,'-dtiffn',resolution, SaveTo);
            % rotate image
            %B = imrotate(I,rot);
            %imwrite(B,SaveTo)
    case 'bmp'
        print(h2,'-dbmp',resolution, SaveTo);
            % rotate image
            %B = imrotate(I,rot);
            %imwrite(B,SaveTo)
    case 'clipboard'
        %print(h2,'-clipboard',resolution,'-dbitmap');
        hgexport(h2,'-clipboard')
    otherwise
        warning('Unexpected file format in saveplot.')
end
% close printed copied figure h2
close(h2);

try
   colormap(cm); 
catch
end

file = SaveTo;
% done saving



