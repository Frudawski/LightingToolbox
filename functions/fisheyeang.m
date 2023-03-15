% The fisheyeang function returns pixelwise angles (theta,rho and omega)
% for arbitrary fisheye resolutions.
%
% usage:
% [theta,rho,omega] = fisheyeang(reso,hor_angle)
%
% where:
% - theta is the rotation angle of the fisheye image
% - rho is the inclination angel to the optical axis (image center)
% - omega is the pixelwise resulting solid angle
% - reso defines the iamge resolution scalar mxm or vector nxm
% - hor_angle defines the horizontal (half) opening angle, e.g. 90°
%
% Reference:
% 
%
% Author: Frederic Rudawski
% Date: 26.02.2023 (sunday)


function [theta,rho,omega] = fisheyeang(reso,horangle)

if ~exist('horangle','var')
    horangle = 180;
end
if ~exist('reso','var')
    reso = [500 500];
else
    if isequal(sum(size(reso)),2)
        reso = [reso reso];
    end
end

% equi angular projection
x = linspace(-deg2rad(horangle)/2,deg2rad(horangle)/2,reso(2));
y = x;
[x,y] = meshgrid(x,y);
[az,el] = cart2pol(x,y);

% in deg
rho = rad2deg(el);
theta = rad2deg(az);
theta(theta<0) = 360+theta(theta<0);

% excert?
if reso(2)>reso(1)
    theta = theta((reso(2)-reso(1))/2:(reso(2)-reso(1))/2+reso(1)-1,:);
    rho = rho((reso(2)-reso(1))/2:(reso(2)-reso(1))/2+reso(1)-1,:);
end

% return values
vangle = (reso(1)/2)/(reso(2)/2)*horangle;
OC = deg2rad(horangle/reso(2)) * deg2rad(vangle/reso(1));
omega = OC.*cosd(rho).^3;
omega(omega<0) = NaN;


