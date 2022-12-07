% Bayer patter plot
%
% usage:  bayerpattern(elements,mode,labels,color)
%
% where: 
%   elements: is the number of RGB sub-pixel to plot vector [m x n] or scalar [m x m]
%   mode: defines the RGB mode
%       - BGGR
%       - GBRG
%       - GRBG
%       - RGGB
%   labels: row and column numbers: 'on' or 'off' (default)
%   color: define own RGB colors, default = [1 0 0; 0 1 0; 0 0 1]
%
% Author: Frederic Rudawski
% Date: 03.12.2022
% See: https://www.frudawski.de/bayerpattern

function bayerpattern(elements,mode,labels,color)

cla
if isequal(numel(elements),1)
    elements = [elements elements];
end
if ~exist('mode','var')
    mode = 'BGGR';
end
if ~exist('labels','var')
    labels = 'off';
end

if ~exist('color','var')
    RGB = [1 0 0;0 1 0;0 0 1];
else
    RGB = color;
end

switch mode
    case 'BGGR'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(3,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(1,:);
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
            end
        end
    case 'GBRG'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(3,:);
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(1,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
            end
        end
    case 'GRBG'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(1,:);
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(3,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
            end
        end
    case 'RGGB'
        for r = 1:elements(1)
            for c = 1:elements(2)
                if isequal(mod(c,2),1) && isequal(mod(r,2),1)
                    col = RGB(1,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),1)
                    col = RGB(2,:);
                elseif isequal(mod(c,2),1) && isequal(mod(r,2),0)
                    col = RGB(2,:);
                elseif isequal(mod(c,2),0) && isequal(mod(r,2),0)
                    col = RGB(3,:);
                end
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
            end
        end
    case 'RGB'
        col = [1 0 0];
        for r = 1:elements(1)
            for c = 1:elements(2)
                patch([c c+1 c+1 c],[-r -r -r-1 -r-1],col)
            end
        end
        col = [0 1 0];
        for c = 1:elements(2)
            patch([c c+1 c+1 c]+1,[-1 -1 0 0],col)
        end
        for r = 1:elements(1)
            c = elements(2);
            patch([c c+1 c+1 c]+1,[-r -r -r-1 -r-1]+1,col)
        end
        col = [0 0 1];
        for c = 1:elements(2)
            patch([c c+1 c+1 c]+2,[-1 -1 0 0]+1,col)
        end
        for r = 1:elements(1)
            c = elements(2);
            patch([c c+1 c+1 c]+2,[-r -r -r-1 -r-1]+2,col)
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
        text(0,-n-0.5,num2str(n),'HorizontalAlignment','center')
    end
    for n = 1:elements(2)
        text(n+0.5,-elements(1)-1.5,num2str(n),'HorizontalAlignment','center')
    end
end

axis equal off
hold off

title([mode,' Bayer pattern'])
end