%% plot n spectra

function plotnspec(lam,spec,m)

s = size(spec,1);
if ~exist('m','var')
    m = [floor(sqrt(s)) ceil(sqrt(s))];
end
ind = 1;


for n = 1:size(spec,1)
    subplot(m(1),m(2),ind)
    ind = ind+1;
    plotspec(lam,spec(n,:));
end


