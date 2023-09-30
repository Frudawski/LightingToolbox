% specbar plots a colourbar with the spectral monochromatic colours beneath
% a plot.
%
% usage: specbar(a)
%
% where: a is the axis handle to add the specbar to. Default: current
% active axis plot
%
% References (by Steve Eddins):
% https://blogs.mathworks.com/steve/2020/04/27/making-color-spectrum-plots-part-1/
% https://blogs.mathworks.com/steve/2020/07/20/making-color-spectrum-plots-part-2/
% https://blogs.mathworks.com/steve/2020/08/18/making-color-spectrum-plots-part-3/
%
% MATLAB ONLY CURRENTLY
%
% Author: Frederic Rudawski
% Date: 26.08.2023


function specbar(ticks,a)
    if ~exist('a','var')
        drawnow
        a = gca;    
    end
    % define wavelengths
    lam = a.XLim(1):a.XLim(2);
    % define spectral colours for colourbar
    xyz = ciespec(lam,'xyz');
    srgb = xyz2srgb(xyz');
    % colourbar
    cb = colorbar;
    cb.Location = 'SouthOutside';
    % change colours
    a.Colormap = srgb;
    a.CLim = [a.XLim(1) a.XLim(2)];

    % https://blogs.mathworks.com/steve/2020/08/18/making-color-spectrum-plots-part-3/
    if ~exist('ticks','var')
        cb.Ticks = a.XTick;
    else
        cb.Ticks = ticks;
    end
    cb.Label.String = a.XLabel.String;
    cb.TickDirection = "out";
    a.XTickLabels = [];
    a.XLabel = [];
end