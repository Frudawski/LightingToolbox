% Bayer patter plot
%
% usage:  bayerpattern(elements,'parameter','value')
%
% where: 
%   elements: is the number of RGB sub-pixel to plot vector [m x n] or scalar [m x m]
%   parameter:
%   'Labels': row and column numbers: 'on' or 'off' (default)
%   'Color': define own RGB colors, default = [1 0 0; 0 1 0; 0 0 1]
%   'Mode': 'BGGR','GRGB','GBRG','RGGB','RGB'
%   'PixelText': Text information for R, G and B pixel
%   'FontSize': fontsize of PxielText, numeric
%
% Author: Frederic Rudawski
% Date: 03.12.2022 - updated: 21.12.2023
% See: https://www.frudawski.de/bayerpattern

function bayerpattern(elements,varargin)

% input parser
p = inputParser;
validVar = @(f) isnumeric(f) || isvector(f);
addRequired(p,'elements',validVar);
addParameter(p,'Mode','BGGR');
addParameter(p,'Labels','off',@ischar)
addParameter(p,'Color',[1 0.4 0.4;0.4 1 0.4;0.4 0.4 1],@ismatrix)
addParameter(p,'PixelText',cell(1,3),@iscell)
addParameter(p,'FontSize',14,@isscalar)
parse(p,elements,varargin{:})

color = p.Results.Color;
RGB = color;
labels = p.Results.Labels;
textstr = p.Results.PixelText;
FS = p.Results.FontSize;
mode = p.Results.Mode;

cla
if isequal(numel(elements),1)
    elements = [elements elements];
end

switch mode
    case 'BGGR'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(3,:);
                    t = textstr{3};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                    t = textstr{2};
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                    t = textstr{2};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(1,:);
                    t = textstr{1};
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
                if ~isempty(t)
                    text(c+0.5,-r-0.5,t,'HorizontalAlignment','center','FontSize',FS)
                end
            end
        end
    case 'GBRG'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                    t = textstr{2};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(3,:);
                    t = textstr{3};
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(1,:);
                    t = textstr{1};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                    t = textstr{2};
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
                if ~isempty(t)
                    text(c+0.5,-r-0.5,t,'HorizontalAlignment','center','FontSize',FS)
                end
            end
        end
    case 'GRBG'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                    t = textstr{2};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(1,:);
                    t = textstr{1};
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(3,:);
                    t = textstr{3};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                    t = textstr{2};
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
                if ~isempty(t)
                    text(c+0.5,-r-0.5,t,'HorizontalAlignment','center','FontSize',FS)
                end
            end
        end
    case 'RGGB'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(1,:);
                    t = textstr{1};
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                    t = textstr{2};
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                   t = textstr{2}; 
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(3,:);
                    t = textstr{3};
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
                if ~isempty(t)
                    text(c+0.5,-r-0.5,t,'HorizontalAlignment','center','FontSize',FS)
                end
            end
        end
    case 'RGB'
        col = RGB(3,:);
        for r = 1:elements(1)
            for c = 1:elements(2)
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
            end
        end
        col = RGB(2,:);
        for r = 1:elements(1)
            for c = 1:elements(2)
                patch([c c+1 c+1 c]-0.5,[-r -r -r-1 -r-1]-0.5,col)
            end
        end
        col = RGB(1,:);
        for r = 1:elements(1)
            for c = 1:elements(2)
                patch([c c+1 c+1 c]-1,[-r -r -r-1 -r-1]-1,col)
            end
        end
        title(mode)
        axis equal off
        hold off
        return
    otherwise
        error('Unsupported Bayer-pattern.')
end


if isequal(strcmp(labels,'on'),1)
    for n = 1:elements(1)
        text(0,-n-0.5,num2str(n),'HorizontalAlignment','center','FontSize',FS)
    end
    for n = 1:elements(2)
        text(n+0.5,-elements(1)-1.5,num2str(n),'HorizontalAlignment','center','FontSize',FS)
    end
end

axis equal off
hold off

title([mode,' Bayer pattern'])
end