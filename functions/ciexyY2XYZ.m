% calculation of XYZ from xyY:
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see licence.
%
% usage: [XYZ,X,Y,Z] = ciexyY2XYZ(x,y,Y)
%
% XYZ or X,Y,Z:	Are the CIE 1931 cone-fundamental-tristimulus values X,Y,Z.
% x and y:	Are the CIE 1931 normalized cone-fundamental trisitmulus values x and y.
% Y:	Is the photometric unit, e.g. illuminance E or luminance L.
%
% Reference:
% Bruce Lindbloom, xyY to XYZ, http://www.brucelindbloom.com/Eqn_xyY_to_XYZ.html
%
% Author: Frederic Rudawski
% Date: 24.11.2019 (Sunday)
% See: https://www.frudawski.de/ciexyY2XYZ


function [XYZ,X,Y,Z] = ciexyY2XYZ(x,y,Y)

% z determination
z = 1-x-y;

% standard Colour Values
X = (Y./y.*x);
Z = (Y./y.*z);
if ~isequal(length(Y),length(X))
    Y = repmat(Y,length(X),1);
end

% return value
XYZ = [X Y Z];


