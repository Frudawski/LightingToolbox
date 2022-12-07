% plotcfibar plots the Colour Fidelity Index
%
% usage: plotcribar(CRI)
%
% where: CRI is a single Colour Rendering Index struct, see ciecri function.
% 
% Author: Frederic Rudawski
% Date: 30.11.2021
% see: https://www.frudawski.de/plotcribar

function plotcribar(CRI)

% CRI colours
lam = 380:780;
spec = ciespec(lam,'CRI');
D65 = ciespec(lam,'D65'); % srgb whitepoint
RGB = spec2srgb(lam,spec.*D65,'obj');

% plot CFI bars
for n = 1:size(RGB,1)
    h=fill([n-1 n-1 n n n-1],[0 CRI.Ri(n) CRI.Ri(n) 0 0],'r');
    set(h,'Facecolor',RGB(n,:));
    set(h,'Edgecolor',[1 1 1]);
    text(0.5+n-1,7*sign(CRI.Ri(n)),num2str(CRI.Ri(n)),'HorizontalAlignment','Center')
    hold on
end
if min(CRI.Ri)<0
    axis([0 14 min(CRI.Ri) 100])
else
    axis([0 14 0 100])
end
grid on
hold off
title(['Special Colour Rendering Index, R_a = ',num2str(CRI.Ra)])
ylabel('Rendering Index by sample')
xticks(0.5:1:14)
xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14'})
