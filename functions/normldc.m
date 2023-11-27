% normldc perform the normalization of an ldt to cd/klm.
%
% Author: Frederic Rudawski
% Date: 26.11.2023 (Sunday)


function ldt = normldc(ldt)

% luminous flux
Phi = ldt2Phi(ldt);
% normalize
ldt.I = ldt.I.*1000./Phi;

end
