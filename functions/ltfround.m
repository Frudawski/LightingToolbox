% round function for octave with n digits after decimal point

function r = ltfround(x,n)

if ~exist('n','var')
  n = 0;  
end

r = round(x*10.^n)./10.^n;
