% round function for octave with n digits after decimal point
%
% usage: r = ltfround(x,n,mode)
%
% where: r returns the rounded values
%        x defines the to be rounded values, matrix, vector or scalar
%        n defines the number of decimals
%        mode speifies the rounding opertation (optional):
%           'digits' number of digits after the decimal point (default)
%           'decimals' same as digits
%           'significant' number of significant digits
%
% NOTE: Matlab supports both 'decimals' and 'significant' but Octave does not.
%
% Author: Frederic Rudawski
% Date: 24.12.2023

function r = ltfround(x,n,mode)

if ~exist('n','var')
  n = 0;  
end
if n > 128
    n = 128;
end
if ~exist('mode','var')
    mode = 'digits';
end

switch mode
    case 'digits' % same as 'decimals'
        r = round(x*10.^n)./10.^n;
    case 'decimals' % same as 'digits'
        r = round(x*10.^n)./10.^n;
    case 'significant'
        m = floor(log10(abs(x)));
        f = 10.^(n-m-1);
        r = round(x.*f)./f;
        % special case zero
        r(x==0) = 0;
    otherwise
        error('Unsupported operation mode, use either ''digits'' / ''decimals'' or ''significant''.')
end