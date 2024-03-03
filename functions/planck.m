% Calculate planck's radiant exitance M for a given temperature T in K.
%
% usage: [spec,x,y,u,v] = planck(T,lam)
% e.g.:  spec = planck(10000,380:780);
%        plot(380:780,spec)
%
% If the spectral range lies within or overlap 360 nm - 830 nm the function
% calculates the x,y and u,v color coordinates from the CIE 1931 and CIE 1960
% chromaticity.
%
% The wavelength parameter lam is optional, if not given the default value
% 360:830 is used.
%
% Reference:
% Günther Wyszecki, W. S. Stiles: Colour Science - Concepts and Methods, 
% Quantitative Data and Formulae, 2nd Edition. John Wiley & Sons, Inc., 
% 2000, ISBN: 978-0-471-39918-6.
%
% constants:
% http://physics.nist.gov/cgi-bin/cuu/Value?c11strc
% http://physics.nist.gov/cgi-bin/cuu/Value?c22ndrc
%
% Author: Frederic Rudawski
% Date: 08.07.2016
% last updated: 04.01.2023
% See: https://www.frudawski.de/planck

function [M,x,y,u,v] = planck(T,lam,mode)
  

% define spectral range if not given
if ~exist('lam','var')
    lam = 360:830;
    lambda = lam.*1e-9;
else
    lambda = lam.*1e-9;
end

if ~exist('mode','var')
  mode = 'exact';
end

switch mode
  case 'exact'
    % constants
    % http://physics.nist.gov/cgi-bin/cuu/Value?c11strc
    % http://physics.nist.gov/cgi-bin/cuu/Value?c22ndrc
    c1 = 3.741771852e-16;
    c2 = 1.438776877e-2;
  case 'CIE'
    % CIE TR 224
    c1 = 3.74183e-16;
    c2 = 1.4388e-2;
end
x = zeros(size(T));
y = zeros(size(T));
u = zeros(size(T));
v = zeros(size(T));
M = zeros(max(size(T)),size(lambda,2)).*NaN;

for n = 1:length(T)
    
    % calculation of planck locus and colour coordinates
    M(n,:) = c1 ./ (lambda.^5 .*(exp(c2./(lambda.*T(n)))-1))./1e9;
    
    x(n) = NaN;
    y(n) = NaN;
    u(n) = NaN;
    v(n) = NaN;
    try
        % x,y and u,v calculation - if possible
        [~,x(n),y(n)] = ciespec2xyz(lam,M);
    catch
    end
    % transformation to u & v
    [u(n),v(n)] = ciexy2uv(x(n),y(n));
end

% end of function
end
