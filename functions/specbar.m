% specbar adds a colorbar with the spectral colours beneath a figure.
%
% usage: specbar(ticks,a)
%
% where:
% ticks defines the xlabel ticks, vector (optional).
% a is the axis handle (optional), default: current active axis (gca)
%
% References (by Steve Eddins):
% https://blogs.mathworks.com/steve/2020/04/27/making-color-spectrum-plots-part-1/
% https://blogs.mathworks.com/steve/2020/07/20/making-color-spectrum-plots-part-2/
% https://blogs.mathworks.com/steve/2020/08/18/making-color-spectrum-plots-part-3/
%
% Author: Frederic Rudawski
% Date: 26.08.2023


function specbar(ticks,a)

    if ~exist('a','var')
        drawnow
        a = gca;
    else
        axis(a);
    end

    if exist('OCTAVE_VERSION', 'builtin')
      % OCTAVE

      if exist('ticks','var')
        xticks = ticks;
        set(gca,'xtick',ticks);
      end

      % define wavelengths
      x = get(gca,'XLim');
      lam = x(1):x(2);
      % define spectral colours for colourbar
      xyz = ciespec(lam,'xyz');
      srgb = xyz2srgb(xyz');

      % colorbar
      cb = colorbar('Location','SouthOutside');
      ind = round(linspace(1,size(srgb,1),64));
      set(cb,'Colormap',srgb(ind,:))
      set(gca,'clim',[x(1) x(2)])
      cbl = get(cb,'Label');
      xl = get(gca,'xlabel');
      set(cbl,'string',get(xl,'string'));
      set(gca,'xlabel','');

      % xticks and xlabel
      xtl = get(gca,'xticklabel');
      set(gca,'xticklabel',[]);
      set(cb,'zticklabel',xtl);

      if exist('ticks','var')
        set(cb,'xtick',ticks)
      end

    else
      % MATLAB

      if exist('ticks','var')
        a = gca;
        a.XTick = ticks;
      end

      % define wavelengths
      lam = a.XLim(1):a.XLim(2);
      % define spectral colours for colourbar
      xyz = ciespec(lam,'xyz');
      srgb = xyz2srgb(xyz');

      % colorbar
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
end
