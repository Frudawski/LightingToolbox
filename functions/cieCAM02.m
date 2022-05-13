% CIE CAM02 forward
%
% Author: Frederic Rudawski
% Date: 04.03.2022


function [cam02,parameter] = cieCAM02(XYZ,wp,cond,La,Yb)

% check input
if ~exist('cond','var')
    cond = 'ave';
end
if ~exist('wp','var')
    wp = ciewhitepoint('E').*100;
end
w = whos('wp','var');
if strcmp(w.class,'char')
    wp = ciewhitepoint(wp).*100;
end
if ~exist('La','var')
    La = XYZ(2)./5;
end
if ~exist('Yb','var')
    Yb = wp(2)./5;
end

% viewing condition surround
switch cond
    case 'ave' % average
        c = 0.69;
        Nc = 1;
        F = 1;
    case 'dim'
        c = 0.59;
        Nc = 0.9;
        F = 0.9;
    case 'dark'
        c = 0.525;
        Nc = 0.8;
        F = 0.8;
end

% CIE CAT02 transformation matrix
Mcat = [0.7328 0.4296 -0.1624;-0.7036 1.6975 0.0061;0.003 0.0136 0.9834];

% CIE CAT02 inverse matrix
Mcatinv = [1.096124 -0.278869 0.182745;0.454369 0.473533 0.072098;-0.009628 -0.005698 1.015326];

% Hunt-Pointer-Estevez sapce trasformation matrix
Mhpe = [0.38971 0.68898 -0.07868;-0.22981 1.1834 0.04641;0 0 1];

% transform XYZ to RGB
RGB = Mcat*XYZ';

% factor D
D = F.*(1-(1./3.6).*exp(-(La+42)./92));

% Whitepoint RGB
RGBw = Mcat*wp';
Rc = (wp(2).*D./RGBw(1)+(1-D)).*RGB(1,:);
Gc = (wp(2).*D./RGBw(2)+(1-D)).*RGB(2,:);
Bc = (wp(2).*D./RGBw(3)+(1-D)).*RGB(3,:);

Rw = (wp(2).*D./RGBw(1)+(1-D)).*RGBw(1,:);
Gw = (wp(2).*D./RGBw(2)+(1-D)).*RGBw(2,:);
Bw = (wp(2).*D./RGBw(3)+(1-D)).*RGBw(3,:);

% constants
k =  1./(5.*La+1);
FL = 0.2.*k.^4.*(5.*La)+0.1.*(1-k.^4).^2.*(5.*La).^(1/3);
n = Yb./wp(2);
Nbb = 0.725.*(1./n).^(0.2);
z = 1.48+sqrt(n);

% convert test source to Hunt-Pointer-Estevez space
RGB_ = Mhpe*Mcatinv*[Rc' Gc' Bc']';

% apply post-adaption non-linear compression to test source
indR = RGB_(1,:)<0;
Ra(indR)  = -(400.*(FL.*abs(RGB_(1,indR))./100).^0.42)./(27.13+(FL.*abs(RGB_(1,indR))./100).^0.42)+0.1;
Ra(~indR) = (400.*(FL.*RGB_(1,~indR)./100).^0.42)./(27.13+(FL.*RGB_(1,~indR)./100).^0.42)+0.1;

indG = RGB_(2,:)<0;
Ga(indG)  = -(400.*(FL.*abs(RGB_(1,indG))./100).^0.42)./(27.13+(FL.*abs(RGB_(1,indG))./100).^0.42)+0.1;
Ga(~indG) = (400.*(FL.*RGB_(2,~indG)./100).^0.42)./(27.13+(FL.*RGB_(2,~indG)./100).^0.42)+0.1;

indB = RGB_(3,:)<0;
Ba(indB)  = -(400.*(FL.*abs(RGB_(1,indB))./100).^0.42)./(27.13+(FL.*abs(RGB_(1,indB))./100).^0.42)+0.1;
Ba(~indB) = (400.*(FL.*RGB_(3,~indB)./100).^0.42)./(27.13+(FL.*RGB_(3,~indB)./100).^0.42)+0.1;

% convert whitepoint to Hunt-Pointer-Estevez space 
RGBw_ = Mhpe*Mcatinv*[Rw Gw Bw]';

% apply post-adaption non-linear compression to whitepoint
indR = RGBw_(1,:)<0;
Rw(indR)  = -(400.*(FL.*abs(RGBw_(1,indR))./100).^0.42)./(27.13+(FL.*abs(RGBw_(1,indR))./100).^0.42)+0.1;
Rw(~indR) = (400.*(FL.*RGBw_(1,~indR)./100).^0.42)./(27.13+(FL.*RGBw_(1,~indR)./100).^0.42)+0.1;

indG = RGBw_(2,:)<0;
Gw(indG)  = -(400.*(FL.*abs(RGBw_(1,indG))./100).^0.42)./(27.13+(FL.*abs(RGBw_(1,indG))./100).^0.42)+0.1;
Gw(~indG) = (400.*(FL.*RGBw_(2,~indG)./100).^0.42)./(27.13+(FL.*RGBw_(2,~indG)./100).^0.42)+0.1;

indB = RGBw_(3,:)<0;
Bw(indB)  = -(400.*(FL.*abs(RGBw_(1,indB))./100).^0.42)./(27.13+(FL.*abs(RGBw_(1,indB))./100).^0.42)+0.1;
Bw(~indB) = (400.*(FL.*RGBw_(3,~indB)./100).^0.42)./(27.13+(FL.*RGBw_(3,~indB)./100).^0.42)+0.1;

% temporary cartesian representation
a = Ra-12.*Ga./11+Ba./11;
b = (1./9).*(Ra+Ga-2.*Ba);
h = zeros(size(a));
for ind = 1:length(a)
    if a(ind)>=0 && b(ind)>=0
        h(ind) = atand(b(ind)./a(ind));
    elseif a(ind)<0 && b(ind)>=0
        h(ind) = atand(b(ind)./a(ind))+180;
    elseif a(ind)<0 && b(ind)<0
        h(ind) = atand(b(ind)./a(ind))+180;
    elseif a(ind)>=0 && b(ind)<0
        h(ind) = atand(b(ind)./a(ind))+360;
    end
end

% compute et
et = 1./4.*(cos(h.*pi./180+2)+3.8);

% find index i
h(h<20.14) = h(h<20.14)+360;

hi = [20.14 90 164.25 237.53 380.14];
ei = [0.8 0.7 1 1.2 0.8];
Hi = [0 100 200 300 400];
H = zeros(size(h));
for ind = 1:length(h)
    i = find(hi>h(ind));
    if isempty(i)
        i = 5;
    end
    i = i(1)-1;
    % Hue quadrature H
    H(ind) = Hi(i)+(100.*(h(ind)-hi(i))./ei(i))./((h(ind)-hi(i))./ei(i) + (hi(i+1)-h(ind))./ei(i+1));
end

% achromatic response A
A = (2.*Ra+Ga+(1/20).*Ba-0.305).*Nbb;
Aw = (2.*Rw+Gw+(1/20).*Bw-0.305).*Nbb;

% Lightness J
J = 100.*(A./Aw).^(c.*z);

% Brigthness Q
Q = (4./c).*sqrt(J./100).*(Aw+4).*FL.^0.25;

% Temporary magnitude quantity t
t = ((5e4./13).*Nc.*Nbb.*et.*sqrt(a.^2+b.^2))./(Ra+Ga+21./20.*Ba);

% Chroma C
C = t.^0.9.*sqrt(J./100).*(1.64-0.29.^n).^0.73;

% Colourfullness M
M = C.*FL.^0.25;

% Satturation s
S = 100.*sqrt(M./Q);

% cartesian coordinates
ac = C.*cosd(h);
bc = C.*sind(h);
am = M.*cosd(h);
bm = M.*sind(h);
as = S.*cosd(h);
bs = S.*sind(h);

% return structs
cam02.J = J;
cam02.C = C;
cam02.H = H;
cam02.M = M;
cam02.Q = Q;
cam02.s = S;
cam02.ac = ac;
cam02.bc = bc;
cam02.am = am;
cam02.bm = bm;
cam02.as = as;
cam02.bs = bs;

parameter.wp = wp;
parameter.cond = cond;
parameter.c = c;
parameter.Nc = Nc;
parameter.F = F;
parameter.La = La;
parameter.Yb  = Yb;
parameter.k = k;
parameter.FL = FL;
parameter.n = n;
parameter.Nbb = Nbb;
parameter.z = z;
parameter.Aw = Aw;
parameter.D = D;


