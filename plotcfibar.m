% plotcfibar
% plots the Colour Fidelity Index
%
% usage: plotcfibar(CFI)
%
% where: CFI is a single Colour Fidelity Index struct, see ciecfi function
% 
% References: 
% CIE 224:2017: CIE 2017 Colour Fidelity Index for accurate scientific use. 
% Commission International d'Eclairage (CIE), Vienna Austria, 2017, ISBN: 978-3-902842-61-9.
% URL: https://cie.co.at/publications/cie-2017-colour-fidelity-index-accurate-scientific-use
%
% Reference colour source:
% ANSI/IES TM30-20: IES Method for Evaluating Light Source Color Rendition,
% The Illuminating Engineering Society, New York USA, 2020, ISBN: 978-0-87995-379-9 
% URL: https://store.ies.org/product/tm-30-20-ies-method-for-evaluating-light-source-color-rendition/
%
% Author: Frederic Rudawski
% Date: 30.11.2021
% See: https://www.frudawski.de/plotcfibar

function plotcfibar(CFI)

% CFI colours
%lam = 380:780;
%S = ciespec(lam,'D50');
%spec = ciespec(lam,'CFI');
%RGB = spec2srgb(lam,spec.*S,'obj','D65');

% source: IES TM.30-18 advanced calculation Tool v2.01
RGB = [250 188 192;208 100 122;91 61 62;211 134 136;178 68 81;151 95 92;152 58 62;145 61 63;71 63 60;255 128 104;201 88 65;226 97 70;135 78 56;195 165 148;202 151 127;147 88 58;150 93 60;159 114 85;219 142 81;217 124 42;255 180 91;250 157 67;253 218 176;255 207 124;218 145 31;255 203 98;190 167 119;106 91 54;247 202 91;166 143 92;249 209 96;207 170 50;243 216 144;162 138 44;103 94 57;203 190 162;116 107 57;222 210 147;82 80 62;115 115 77;222 216 181;149 170 57;156 182 59;67 64 59;113 145 70;141 163 102;156 169 124;157 198 130;82 115 67;97 135 99;111 144 111;56 106 70;0 135 92;192 221 198;175 213 191;79 191 160;0 156 128;0 146 124;190 221 203;215 218 206;162 190 179;151 157 149;78 78 74;0 156 156;57 99 99;0 118 126;0 127 138;109 158 166;110 124 127;122 181 205;36 87 108;177 182 182;52 145 183;65 64 63;43 81 106;52 115 171;76 104 136;56 104 160;164 173 200;149 149 187;98 93 147;220 209 215;177 166 190;67 62 67;99 89 104;163 141 186;104 77 122;170 125 170;108 71 107;126 79 123;204 188 182;151 116 135;180 144 158;121 69 98;197 147 164;222 169 184;160 92 119;211 110 141;178 80 113]./255;

% plot CFI bars
for n = 1:size(RGB,1)
    h = fill([n-1 n-1 n n n-1],[0 CFI.Rfi(n) CFI.Rfi(n) 0 0],'r');
    set(h,'Facecolor',RGB(n,:));
    set(h,'Edgecolor',[1 1 1]);
    text(0.5+n-1,-3,num2str(n),'HorizontalAlignment','Center','Rotation',90,'Fontsize',6)
    text(0.5+n-1,3,num2str(ltfround(CFI.Rfi(n),1),'%2.1f'),'HorizontalAlignment','Center','Rotation',90,'Fontsize',6) 
    hold on
end
axis([-1 100 0 100])
xticklabels([])
grid on
hold off
title(['Special Colour Fidelity Index, R_f = ',num2str(ltfround(CFI.Rf,1))])
ylabel('Fidelity Index by sample')
