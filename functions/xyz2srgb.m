% CIE xyz to srgb transformation as specified in IEC 61966-2-1:1999
%
% usage: srgb = xyz2srgb(xyz,whitepoint,'method')
%
%          - standard whitepoint: 'D65'
%            whitepoint e.g.: 'A','B','C','D50','D55','D65','D75','E','F2','F7','F11'
%            or numerical tripel: [x y z]
%          - method selects the chromatic adaption method:
%            'XYZ','vonKries',Bradford'
% 
% Transformation as described at:
% https://www.color.org/sRGB.pdf
%
% Chromatic adaptation method:
% http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
%
% Reference:
% IEC 61966-2-1:1999, Multimedia systems and equipment - Colour measurement
% and management - Part 2-1: Colour management - Default RGB colour space - 
% sRGB. Genf, Switzerland: International Electrotechnical Commission (IEC), 1999.
% https://webstore.iec.ch/publication/6168
%
% Author: Frederic Rudawski
% Date: 26.06.2018
% Updated: 23.10.2021 (saturday)
% see: https://www.frudawski.de/xyz2srgb


function [srgb,r,g,b] = xyz2srgb(xyz,wp,method)

if~exist('system','var')
    system = 'xyz';
end

if~exist('method','var')
    method = 'XYZ';
end

if ~exist('wp','var')
    wp = 'D65';
end
if ~exist('profile','var')
    profile = 'IEC';
end

switch profile
    case 'IEC'
        % https://www.color.org/sRGB.pdf
        M = [3.2406255  -1.537208  -0.4986286;
            -0.9689307   1.8757561  0.0415175;
             0.0557101  -0.2040211  1.0569959];
         
        % normalize xyz
        %if sum(xyz)>1
        %    xyz = cieXYZ2xyz(xyz);
        %end
        
        xyz = chromad(wp,'D65',method,system)*xyz';
        srgb =(M*xyz)';
        
        r = srgb(:,1);
        g = srgb(:,2);
        b = srgb(:,3);
        
        % initialize
        R = NaN(size(r));
        G = NaN(size(r));
        B = NaN(size(r));
        
        % gamma correction
        e = -0.0031308;
        
        indr1 = r<e;
        indg1 = g<e;
        indb1 = b<e;
        
        indr2 = r>-e;
        indg2 = g>-e;
        indb2 = b>-e;
        
        R = 12.92.*r;
        G = 12.92.*g;
        B = 12.92.*b;
        
        R(indr1) = -1.055.*(-r(indr1)).^(1./2.4)+0.055;
        G(indg1) = -1.055.*(-g(indg1)).^(1./2.4)+0.055;
        B(indb1) = -1.055.*(-b(indb1)).^(1./2.4)+0.055;

        R(indr2) = 1.055.*r(indr2).^(1./2.4)-0.055;
        G(indg2) = 1.055.*g(indg2).^(1./2.4)-0.055;
        B(indb2) = 1.055.*b(indb2).^(1./2.4)-0.055;
        
    case 'sRGB' % Lindbloom
        
        % XYZ to SRGB transformation matrix:
        % http://www.brucelindbloom.com/Eqn_RGB_XYZ_Matrix.html
        M = [3.2404542 -1.5371385 -0.4985314;
            -0.9692660  1.8760108  0.0415560;
             0.0556434 -0.2040259  1.0572252];
               
        xyz = chromad(wp,'D65',method,system)*xyz';
        srgb = (M*xyz)';
        
        r = srgb(:,1);
        g = srgb(:,2);
        b = srgb(:,3);
        
        % initialize
        R = NaN(size(r));
        G = NaN(size(r));
        B = NaN(size(r));
        
        % gamma correction
        e = 216/24389;
        k = 24389/27;
        
        indr = r<=e;
        indg = g<=e;
        indb = b<=e;
        
        R(indr)  = r(indr).*k./100;
        R(~indr) = 1.16.*r(~indr).^(1/3)-0.16;
        G(indg)  = g(indg).*k./100;
        G(~indg) = 1.16.*g(~indg).^(1/3)-0.16;
        B(indb)  = b(indb).*k./100;
        B(~indb) = 1.16.*b(~indb).^(1/3)-0.16;
        
end

% SRGB range 0 - 1
srgb = [R G B];
srgb(srgb<0) = 0;
srgb(srgb>1) = 1;
r = srgb(:,1);
g = srgb(:,2);
b = srgb(:,3);

end
