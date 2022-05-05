% spectrogram plot
%
% usage: h = plotspecslice(wavelength,data,'colorbarlabel',maxY);
%
% where: h is the return handle of the axes
%        wavelength is a vector containing the n wavelentgh steps
%        data is a mxn matrix containing the m spectra
%        label is the label string of the colorbar
%        maxY is a scalar setting the maximum z value 
%
% author: Frederic Rudawski
% date: 20.03.2018,
% updated: 19.07.2018, 04.222021

function plotspecslice(lambda,data,label,maxY)
cla reset
zlabeltext =  '';
if ~exist('label','var')
    clabel = 'spectral intensity';
else
    clabel = label;
end

if ~exist('maxY','var')
    maxY = inf;
end
    
imagesc(data);
title('')
xlabel('\lambda in nm');
ylabel('number');
view([0 90]);

ax = gca;
%ax.ZLabel.String = zlabeltext;
c = colorbar;
if exist('OCTAVE_VERSION', 'builtin')
    L = get(c,'label');
    set(L,'string',clabel)
else
    c.Label.String = clabel;
end
if ~isinf(maxY)
    caxis([0 maxY])
end
if size(data,1)<20
    yticks([1:size(data,1)])
end

hold on
slice = 1:size(data,1);
if numel(slice)>50
  for s = 2:numel(slice)
    plot([0 numel(lambda)],[slice(s)-0.5 slice(s)-0.5],'w','Linewidth',1)
  end
else
  for s = 2:numel(slice)
    plot([0 numel(lambda)],[slice(s)-0.5 slice(s)-0.5],'w','Linewidth',2)
  end
end

x = 1:numel(lambda)-1;
x = x(~(rem(numel(lambda)-1, x)));
n = (numel(lambda)-1)./x;
[~,ind] = find(n<=8 & n>=4);
try
    ind = ind(1);
catch
end
if isempty(ind)
    inc = round(numel(lambda)/8);
else
    inc = x(ind);
end
xt = [1:inc:numel(lambda)];

xticks(xt)
xticklabels(lambda(xt))
hold off
