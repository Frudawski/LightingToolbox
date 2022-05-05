% CIE srgb to xyz transformation as specified in IEC 61966-2-1:1999
%
% usage: xyz = srgb2xyz(srgb,whitepoint,'method')
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
% Date: 23.10.2021 (saturday), last updaate: 21.03.2022
% See: https://www.frudawski.de/srgb2xyz

function [xyz,x,y,z] = srgb2xyz(srgb,wp,method)

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


r = srgb(:,1);
g = srgb(:,2);
b = srgb(:,3);

% initialize
R = zeros(size(r)).*NaN;
G = zeros(size(r)).*NaN;
B = zeros(size(r)).*NaN;

switch profile
    case 'IEC'
        
        % gamma correction
        e = 0.04045;
        
        indr = r<=e;
        indg = g<=e;
        indb = b<=e;
        
        R(indr)  = 12.92./r(indr);
        R(~indr) = ((r(~indr)+0.055)./1.055).^(2.4);
        G(indg)  = 12.92./g(indg);
        G(~indg) = ((g(~indg)+0.055)./1.055).^(2.4);
        B(indb)  = 12.92./b(indb);
        B(~indb) = ((b(~indb)+0.055)./1.055).^(2.4);
        
        % https://www.color.org/sRGB.pdf
        M = [3.2406255  -1.537208  -0.4986286;
            -0.9689307   1.8757561  0.0415175;
             0.0557101  -0.2040211  1.0569959];
        
        xyz = (inv(chromad('D65',wp,method,system))\((M\[R G B]')))';
        
        x = xyz(:,1);
        y = xyz(:,2);
        z = xyz(:,3);
        
    case 'sRGB' % Lindbloom
        
        k = 24389/27;
        
        indr = r<=0.08;
        indg = g<=0.08;
        indb = b<=0.08;
        
        R(indr)  = 100.*r(indr)./k;
        R(~indr) = ((r(~indr)+0.16)./1.16).^3;
        G(indg)  = 100.*g(indg)./k;
        G(~indg) = ((g(~indg)+0.16)./1.16).^3;
        B(indb)  = 100.*b(indb)./k;
        B(~indb) = ((b(~indb)+0.16)./1.16).^3;
        
        % SRGB to XYZ transformation matrix:
        % http://www.brucelindbloom.com/Eqn_RGB_XYZ_Matrix.html
        M = [ 0.4124564  0.3575761  0.1804375;
            0.2126729  0.7151522  0.0721750;
            0.0193339  0.1191920  0.9503041];
        
        xyz = (chromad('D65',wp,method,system)*((M*[R G B]')))';     
        
        x = xyz(:,1);
        y = xyz(:,2);
        z = xyz(:,3);

end
