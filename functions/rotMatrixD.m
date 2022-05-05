% function rotation Matrix
%
% M = rotMatrixD(axis,angle)
%
%      where: M is the rotation matrix             
%             axis ist the axis to be rotated around [x y z]
%             angle is the rotation angle in degree
%
% see: https://en.wikipedia.org/wiki/Rotation_matrix
%
% original Source: Taylor, Camillo J.; Kriegman, David J. (1994).
% "Minimization on the Lie Group SO(3) and Related Manifolds" (PDF).
% Technical Report No. 9405. Yale University.
% https://www.cis.upenn.edu/~cjtaylor/PUBLICATIONS/pdfs/TaylorTR94b.pdf
%
% Author: Frederic Rudawski
% Date: 11.05.2020 - last edited: 13.08.2020

function rot = rotMatrixD(ax,alpha)

% check if rotation axis is all zero
if isequal(sum(ax),0)
    rot = eye(3);
else
    % normalize rotation axis vector
    ax = ax./norm(ax);
    % rot matrix calculation
    rot = [cosd(alpha)+ax(1)^2*(1-cosd(alpha)) ax(1)*ax(2)*(1-cosd(alpha))-ax(3)*sind(alpha) ax(1)*ax(3)*(1-cosd(alpha))+ax(2)*sind(alpha); ...
           ax(1)*ax(2)*(1-cosd(alpha))+ax(3)*sind(alpha) cosd(alpha)+ax(2)^2*(1-cosd(alpha)) ax(2)*ax(3)*(1-cosd(alpha))-ax(1)*sind(alpha); ...
           ax(1)*ax(3)*(1-cosd(alpha))-ax(2)*sind(alpha) ax(2)*ax(3)*(1-cosd(alpha))+ax(1)*sind(alpha) cosd(alpha)+ax(3)^2*(1-cosd(alpha))]';
end


