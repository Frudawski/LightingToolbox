% texify changes the text interpreter of all elements in a figure to Latex.
%
% usage: texify(graphicshandle)
%
% where: graphicshandle is an optional handle for any figure or axis
%
% Author: Frederic Rudawski
% Date: 30.10.2022
% see: https://www.frudawski.de/texify


function texify(handle,mode)

if ~exist('handel','var')
    handle = gca;
end
if isempty(handle)
    handle = gca;
end
if ~exist('mode','var')
    mode = 'none';
end

% OCTAVE
if exist('OCTAVE_VERSION', 'builtin')

    str = findall(handle,'Type','Text');
    for n = 1:numel(str)
        try
            if strcmp(mode,'change')
                newstr = correctstr(get(str(n),'String'));
                set(str(n),'String',newstr);
            end
            set(str(n),'Interpreter','Latex');
        catch

        end
        % title settings
        h = get(handle,'Title');
        set(h,'fontsize',16);
        set(h,'fontweight','bold');
    end

else
    % MATLAB


    % change axis labels
    try
        % normal plot
        ax = gca;
        if strcmp(mode,'change')
            nxlabels = correctstr(xticklabels);
            xticklabels(nxlabels);
            nylabels = correctstr(yticklabels);
            yticklabels(nylabels);
        end
        % change tick labels
        set(handle,'TickLabelInterpreter','latex')
        % change labels
        if strcmp(mode,'change')
            newx = correctstr(handle.XLabel.String);
            xlabel(newx)
            newy = correctstr(handle.YLabel.String);
            ylabel(newy)
        end
        set(handle.XLabel,'Interpreter','Latex')
        set(handle.YLabel,'Interpreter','Latex')
    catch
        % polarplot
        if strcmp(mode,'change')
            nthetalabels = correctstr(thetaticklabels);
            thetaticklabels(nthetalabels);
            nrlabels = correctstr(rticklabels);
            rticklabels(nrlabels);
        end
        % change tick labels
        set(handle,'TickLabelInterpreter','latex')
        % change labels
        if strcmp(mode,'change')
            newtheta = correctstr(handle.ThetaTickLabel);
            handle.ThetaTickLabel = newtheta;
            newr = correctstr(handle.RTickLabel);
            handle.RTickLabel = newr;
        end
        %set(handle.ThetaTickLabel,'Interpreter','Latex')
        %set(handle.RTickLabel,'Interpreter','Latex')
    end




    % change title
    if strcmp(mode,'change')
        t = correctstr(handle.Title.String);
        title(t)
    end
    set(handle.Title,'Interpreter','Latex','FontSize',14)

    % change legend
    try
        if strcmp(mode,'change')
            handle.Legend.String = correctstr(handle.Legend.String);
        end
        set(handle.Legend,'Interpreter','Latex')
    catch
        % polar plot ...
    end

    % change text
    str = findall(handle.Children,'Type','Text');
    for n = 1:numel(str)
        if strcmp(mode,'change')
            str(n).String = correctstr(str(n).String);
        end
        set(str(n),'Interpreter','Latex')
    end

end

end




% correct string function for Latex interpreter
function newstr = correctstr(str)

% char array
if ischar(str) && size(str,1)>1
    for n = 1:size(str,1)
        newstr{n} = correctstr(str(n,:));
    end
    newstr = correctstr(newstr);
    return
end

% cell array
if iscell(str)
    newstr = str;
    for n = 1:numel(str)
        newstr{n} = correctstr(str{n});
    end
    return
end

% reset \degree fix
str = strrep(str,'^{\circ}','\degree');
% find commands
ind = strfind(str,'\');
spaces = strfind(str,' ');
newstr = str;
idx = 1;

% enclose commands in $ $ environment
if ~isempty(ind)
    if ind(idx) == 1
        if isempty(spaces)
            newstr = (['$',str,'$']);
            return
        end
        newstr = ['$',str(1:spaces(1)-1),'$',str(spaces(1):end)];
        idx = idx+1;
        ind(idx:end) = ind(idx:end)+2;
    end
    for n = idx:numel(ind)
        spaces = strfind(newstr,' ');
        sp = spaces>ind(idx);
        spaces = spaces(sp);
        if ~isempty(spaces)
            newstr = [newstr(1:ind(idx)-1),'$',newstr(ind(idx):spaces(1)-1),'$',newstr(spaces(1):end)];
        else
            newstr = [newstr(1:ind(idx)-1),'$',newstr(ind(idx):end),'$'];
        end
        idx = idx+1;
        ind(idx:end) = ind(idx:end)+2;
    end

end

% replace double $$
newstr = strrep(newstr,'$$','$');
% replace not working \degree
newstr = strrep(newstr,'\degree','^{\circ}');
newstr = strrep(newstr,'°','$^{\circ}$');
% replace errorneous degree correction
newstr = strrep(newstr,'$^{$\circ}$','^{$\circ}$');

end
