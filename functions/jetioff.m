% JETI laser off
%
% Author: Frederic Rudawski
% Date: 11.06.2021

function jetioff(jeti)
writeline(jeti,'*CONTR:LASER 0');