% CIE CAM02 inverse
%
% Author: Frederic Rudawski
% Date: 22.03.2022

function xyz = cieCAM02inv(cam02,XYZ,wp,cond,La,Yb)

if nargin > 2
    [~,p] = cieCAM02(XYZ,wp,cond,La,Yb);

elseif isequal(nargin,2)
    p = XYZ;
else
    error('Wrong number of input parameters.')
end

% starting with s
Q = 4./p.c.*sqrt(cam02.J./100).*(p.Aw+4).*p.FL.^(0.25);
C = (cam02.s./100).^2.*(Q./p.FL.^(0.25));
J = 6.25.*(p.c.*Q./((p.Aw+4).*p.FL.^(0.25))).^2;

% h table 3
hi = [20.14 90 164.25 237.53 380.14];
ei = [0.8 0.7 1 1.2 0.8];
Hi = [0 100 200 300 400];
h = NaN(size(cam02.H));
% loop over H
for ind = 1:length(cam02.H)
    i = find(Hi>cam02.H(ind));
    if isempty(i)
        i = 5;
    end
    i = i(1)-1;
    % h'
    h(ind) = ((cam02.H(ind)-Hi(i)).*(ei(i+1).*hi(i)-ei(i).*hi(i+1))-100.*hi(i).*ei(i+1))./((cam02.H(ind)-Hi(i)).*(ei(i+1)-ei(i))-100.*ei(i+1));
    if h(ind) > 360
        h(ind) = h(ind) - 360;
    end
end

% t
t = (C./(sqrt(J./100).*(1.64-0.29.^(p.n)).^(0.73))).^(1./0.9);  

% compute et
et = 1./4.*(cos(h.*pi./180+2)+3.8);

% A 
A = p.Aw.*(J./100).^(1./(p.c.*p.z));

% p1 - p3
p1 = ((50000./13).*p.Nc.*p.Nbb.*et)./t;
p2 = (A./p.Nbb)+0.305;
p3 = 21/20;

% a and b
hr = h.*pi./180;
a = NaN(size(hr));
b = NaN(size(hr));
for ind = 1:length(hr)
    if abs(sin(hr(ind))) >= abs(cos(hr(ind)))
        p4 = p1./sin(hr(ind));
        b = (p2.*(2+p3).*(460/1403))./(p4+(2+p3).*(220./1403).*(cos(hr(ind))./sin(hr(ind)))-(27/1403)+p3.*(6300./1403));
        a = b.*(cos(hr(ind)./sin(hr(ind))));
    elseif abs(sin(hr(ind))) < abs(cos(hr(ind)))
        p5 = p1./cos(hr(ind));
        a = (p2.*(2+p3).*(460/1403))./(p5+(2+p3).*(220./1403)-((27./1403)-p3.*(6300./1403)).*((sin(hr(ind))./cos(hr(ind)))));
        b = a.*(sin(hr(ind))./cos(hr(ind)));
    end
end

% RGBa 
Ra = 460./1403.*p2 + 451./1403.*a + 288./1403.*b;
Ga = 460./1403.*p2 - 891./1403.*a - 261./1403.*b;
Ba = 460./1403.*p2 - 220./1403.*a - 6300./1403.*b;

% RGB_
R_ = 100./p.FL.*((27.13.*abs(Ra-0.1))./(400-abs(Ra-0.1))).^(1./0.42);
G_ = 100./p.FL.*((27.13.*abs(Ga-0.1))./(400-abs(Ga-0.1))).^(1./0.42);
B_ = 100./p.FL.*((27.13.*abs(Ba-0.1))./(400-abs(Ba-0.1))).^(1./0.42);

% M_HPE inverse
M_HPE_inv = [1.910197 -1.112124  0.201908;0.370950  0.629054 -0.000008;0.000000  0.000000  1.000000];
         
% CIE CAT02 transformation matrix
Mcat = [0.7328 0.4296 -0.1624;-0.7036 1.6975 0.0061;0.003 0.0136 0.9834];
         
% RGBc
RGBc = Mcat * M_HPE_inv * ([R_' G_' B_'])';
 
% CIE CAT02 inverse matrix
Mcatinv = [1.096124 -0.278869 0.182745;0.454369 0.473533 0.072098;-0.009628 -0.005698 1.015326];

% RGBw
RGBw = Mcat*p.wp';

R = RGBc(1,:)./(p.wp(2).*p.D./RGBw(1)+1-p.D);
G = RGBc(2,:)./(p.wp(2).*p.D./RGBw(2)+1-p.D);
B = RGBc(3,:)./(p.wp(2).*p.D./RGBw(3)+1-p.D);

xyz = (Mcatinv * [R' G' B']')';



