% statistical plot of an arbitrary number of spectra
% 
%   usage: out = spectrum_range(wavelength,data,'parameter',value)
%
%   where out is an struct with the following elements:
%       - min
%       - max
%       - mean
%       - SD (standad deviation)
%
%   parameters: 
%       'Color':  single color vector (default: [0 0.4470 0.7410])
%       'ylabel': y-axis label
%       
% author: Frederic Rudawski
% date: 21.03.2018 - last updated: 26.07.2018


function varout = plotspecrange(lambda,data,varargin)

cla reset


p = inputParser;
addRequired(p,'lambda',@isvector);
addRequired(p,'data',@ismatrix);
addParameter(p,'Color',[0   0.4470   0.7410],@isvector)
addParameter(p,'ylabel','',@ischar)
addParameter(p,'max',[],@isnumeric)
addParameter(p,'legend','on',@ischar)
addParameter(p,'normalize','off',@ischar)
parse(p,lambda,data,varargin{:})

% y label
ylabeltext = p.Results.ylabel;
% title
titletext = '';

color = p.Results.Color;

% statistics
check = sum(data,2);
check = find(check == 0);
data(check,:) = [];
m = mean(data,1);
datamin = min(data,[],1);
datamax = max(data,[],1);
if strcmp(p.Results.normalize,'on')
    datamin = datamin-m;
    datamax = datamax-m;
    m = zeros(size(m));
end
var = sum(((data-mean(data,1)).^2),1)./(size(data,1)-1);
std = sqrt(var);

% color stuff
x = 1-(max(color));
c1 = color./1.25;
c2 = color./1.75;

% plot
p1 = patch([lambda fliplr(lambda)],[datamax fliplr(datamin)],color,'EdgeColor','none');
hold on
p2 = patch([lambda fliplr(lambda)],[m+std fliplr(m-std)],c1,'EdgeColor','none');
p3 = plot(lambda,m,'Color',c2);
if strcmp(p.Results.legend,'on')
  L = legend([p1 p2 p3],'min/max','standard deviation','mean');
end
%hline = plot(NaN,NaN,'Color',color);

if ~isempty(p.Results.max) && ~isequal(p.Results.max,0)
    ylim([lambda(1) lambda(end) 0 p.Results.max])
else
    axis([lambda(1) lambda(end) 0 inf])
end
grid on
set(gca, 'Layer', 'top')
xlabel('\lambda in nm')
ylabel(ylabeltext)

hold off

title(titletext)

% output
varout.min = datamin;
varout.max = datamax;
varout.mean = mean(data,1);
varout.SD = std;

