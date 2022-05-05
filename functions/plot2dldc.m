% plot 2D luminous intensity distribution curve - LDC 
%
% usage: plot2dldc(ldc)
%
% Author: Frederic Rudawski
% Date: 15.06.2020, edited: 02.12.2021
% See: https://www.frudawski.de/plot2dldc

function plot2dldc(ldc)

% gamma angles
g = ldc.anglesG;
data = ldc.I;
g = (g*pi/180)-pi/2;

% C angles
[~,c0]   = find(ldc.anglesC == 0);
[~,c180] = find(ldc.anglesC == 180);
[~,c90]  = find(ldc.anglesC == 90);
[~,c270] = find(ldc.anglesC == 270);

% plot
if exist('OCTAVE_VERSION', 'builtin')
  p1 = polar([g(:,c270);flipud(-g(:,c0))], [data(:,c180);flipud(-data(:,c0))]);
  hold on
  p2 = polar([g(:,c180);flipud(-g(:,c90))], [data(:,c270);flipud(-data(:,c90))]);
  hold off
else
  p1 = polarplot([g(:,c270);flipud(-g(:,c0))], [data(:,c180);flipud(-data(:,c0))]);
  hold on
  p2 = polarplot([g(:,c180);flipud(-g(:,c90))], [data(:,c270);flipud(-data(:,c90))]);
  hold off
end

% set colors right for legend
c = colors(5);
set(p1,'Color',c(1,:));
set(p2,'Color',c(3,:));

% correct plot tick labels
pax = gca;
if exist('OCTAVE_VERSION', 'builtin')
  newlabel = {'120','150','180','150','120','90','60','30','0','30','60','90'};
  newlabel = {'60','30','0','30','60','90','120','150','180','150','120','90'};
  labels = findall(gca, 'type', 'text');
  distances = cellfun(@(x)norm(x(1:2)), get(labels, 'Position'));
  % Figure out the most common
  [~, ~, b] = unique(round(distances * 100));
  h = hist(b, 1:max(b));
  labels = labels(b == find(h == max(h)));
  % set new label string
  for k = 1:numel(labels)
    set(labels(k), 'String', newlabel(k));
  end
else
  newlabel = {'90','120','150','180','150','120','90','60','30','0','30','60'};
  pax.ThetaTickLabel = newlabel;
end
phi = ldc2Phi(ldc);
% title and legend
try
    title([ldc.name,' - ',num2str(ltfround(phi,1)),' lm'])
catch
    title([ldc.header.filename,' - ',num2str(ltfround(phi,1)),' lm'])
end
legend([p1(1) p2(1)],{'C0-180','C90-270'},'Location','northoutside');

