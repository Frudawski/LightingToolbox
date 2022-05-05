% calculation of the total luminous flux of a given luminous intensity
% distribution curve (LDC).
%
% usage: Phi = ldc2Phi(ldc)
%
% Author: Frederic Rudawski
% Date: 12.06.2020 - edited: 08.10.2020, 07.12.2021
% See: https://www.frudawski.de/ldc2Phi

function Phi = ldc2Phi(ldc)
dG = diff(ldc.anglesG);
dG(end+1,:) = dG(1,:);
dG = deg2rad(dG);
% C angle
dC = diff(ldc.anglesC');
dC(end+1,:) = dC(1,:);
dC = dC';
dC = deg2rad(dC);
% solid angle omega 
omega = dC.*dG.*sind(ldc.anglesG);

% calculate luminous flux
if isequal(ldc.anglesC(1,1),0) && isequal(ldc.anglesC(1,end),360)
    omega = omega(:,1:end-1);
    Phi = sum(sum(ldc.I(:,1:end-1).*omega));
else
    Phi = sum(sum(ldc.I.*omega));
end


