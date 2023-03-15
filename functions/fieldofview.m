% CREATE FIELD OF VIEW IMAGE MASKS
%
% usage: mask = fieldofview(theta,rho,maskmode,theta_mask,rho_mask)
%
% where:
% - theta is rotation angle 
% - rho is the angular distance from the optical axis (image center)
% - maskmode defines the field of view mask:
%    - 'left'   = left eye
%    - 'right'  = right eye
%    - 'overlap' = binocular overlap
%    - 'binocular' = binocular sum
%    - 'user' = user defined theta_mask and rho_mask
% - theta_mask and rho_mask are optional self defined angles limits
%
% Reference field of view angles:
% Baehr, Barfuß and Seifert. "Beleuchtungstechnik Grundlagen".
% 4th. edition. Ed.: LiTG. 2016. HUSS-MEDIEN GmbH, Verlag Technik. p.72.
% ISBN: 978-3-341-016343.
%
% Author: Frederic Rudawski
% Date: 26.02.2023 (sunday)

function maskview = fieldofview(theta,rho,maskmode,theta_mask,rho_mask)

theta = unwrap(deg2rad(theta));
rho = deg2rad(rho);

switch maskmode
    case 'overlap'
        theta_mask = unwrap(deg2rad(0:15:360));
        rho_mask = deg2rad([60 60 60 60 60 59 58 59 60 60 60 60 60 60 57 52 55 66 68 66 55 52 57 60 60]);
    case 'left'
        theta_mask = unwrap(deg2rad(0:15:360));
        rho_mask = deg2rad([60 60 60 60 60 59 58 59 61 65 74 90 90 90 90 90 82 72 68 66 55 52 57 60 60]);
    case 'right'
        theta_mask = unwrap(deg2rad(0:15:360));
        rho_mask = deg2rad([90 90 74 65 61 59 58 59 60 60 60 60 60 60 57 52 55 66 68 72 82 90 90 90 90]);
    case 'binocular'
        theta_mask = unwrap(deg2rad(0:15:360));
        rho_mask = deg2rad([90 90 74 65 61 59 58 59 61 65 74 90 90 90 90 90 82 72 68 72 82 90 90 90 90]);
    case 'user'
        theta_mask = unwrap(deg2rad(theta_mask));
        rho_mask = deg2rad(rho_mask);
    otherwise
        error('Unsupported mask, provide mask specification.')
end

[X,Y] = pol2cart(theta,rho);
[XM,YM] = pol2cart(theta_mask,rho_mask);

maskview = flipud(inpolygon(X,Y,XM,YM));

end






