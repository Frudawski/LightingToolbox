% create n colours
% see: https://wisotop.de/hsl-to-rgb.php
%
% usage: c = colors(n,parameter)
%
% parameters: S = [0..100] 1 x n vector
%             L = [0..100] 1 x n vector
%             H = [0..360] 1 x 2 vector
%
% S = satturation
% L = brightness
% H = hue
% 
% Atuhor: Frederic Rudawski
% Date: 30.08.2019
% last updated: 10.09.2019
% See: https://www.frudawski.de/colours

function RGB = colors(n,varargin)


p = inputParser;
%ValidInput = @(f) (max(size(f)) == sum(isnumeric(f) & (f>=0) & (f<=1)));
addRequired(p,'n',@isscalar)
addParameter(p,'S',[],@isvector)
addParameter(p,'L',[],@isvector)
addParameter(p,'H',[-120 360-120],@isvector)
parse(p,n,varargin{:})


H = linspace(p.Results.H(1),p.Results.H(2),n+1);
H(end) = [];
if isempty(p.Results.S)
    S = ones(1,n).*200/3;
else
    S = p.Results.S;
end
%S = linspace(10,90,n);
if isempty(p.Results.L)
    L = linspace(20,90,n+1);
    L = L(1:end-1);
else
    L = p.Results.L;
end
%L = ones(size(S)).*50;

if size(S,1) > size(S,2)
    S = S';
end
if size(L,1) > size(L,2)
    L = L';
end

% HSL to rgb

% tempory variables
ind = L<50;
t1 = zeros(size(L));
t1(ind) = L(ind)./100.*(1+S(ind)./100);
t1(~ind) = L(~ind)./100 + S(~ind)./100 - (L(~ind)./100 .* S(~ind)./100);

t2 = 2.*L./100 - t1;

% temporary color variables
tR = H./360 + 1/3;
tR(tR<0) = tR(tR<0)+1;
tR(tR>1) = tR(tR>1)-1;
tG = H./360;
tG(tG<0) = tG(tG<0)+1;
tG(tG>1) = tG(tG>1)-1;
tB = H./360 - 1/3;
tB(tB<0) = tB(tB<0)+1;
tB(tB>1) = tB(tB>1)-1;

% color R
R = zeros(size(tR));
ind0 = zeros(size(tR));
ind = 6.*tR < 1;
ind0(ind) = 1;
R(ind) = t2(ind)+(t1(ind)-t2(ind)).*6.*tR(ind);
ind = 2.*tR < 1 & ind0 == 0;
ind0(ind) = 1;
R(ind) = t1(ind);
ind = 3.*tR < 2 & ind0 == 0;
ind0(ind) = 1;
R(ind) = t2(ind)+(t1(ind)-t2(ind)).*(0.666-tR(ind)).*6;
ind = 3.*tR >= 2 & ind0 == 0;
R(ind) = t2(ind);

% color G
G = zeros(size(tG));
ind0 = zeros(size(tG));
ind = 6.*tG < 1;
ind0(ind) = 1;
G(ind) = t2(ind)+(t1(ind)-t2(ind)).*6.*tG(ind);
ind = 2.*tG < 1 & ind0 == 0;
G(ind) = t1(ind);
ind0(ind) = 1;
ind = 3.*tG < 2 & ind0 == 0;
G(ind) = t2(ind)+(t1(ind)-t2(ind)).*(0.666-tG(ind)).*6;
ind = 3.*tG >= 2 & ind0 == 0;
G(ind) = t2(ind);

% color B
B = zeros(size(tB));
ind0 = zeros(size(tG));
ind = 6.*tB < 1;
ind0(ind) = 1;
B(ind) = t2(ind)+(t1(ind)-t2(ind)).*6.*tB(ind);
ind = 2.*tB < 1 & ind0 == 0;
ind0(ind) = 1;
B(ind) = t1(ind);
ind = 3.*tB < 2 & ind0 == 0;
ind0(ind) = 1;
B(ind) = t2(ind)+(t1(ind)-t2(ind)).*(0.666-tB(ind)).*6;
ind = 3.*tB >= 2 & ind0 == 0;
B(ind) = t2(ind);

RGB = [R' G' B'];

end

