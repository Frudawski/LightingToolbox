% Determines a chromatic adaption matrix in xyz colour space.
% 
% usage: M = chromad(source,target,'method','system')
%
%   where: - source is the colour input in xyz colour space (CIE 1931)
%          e.g. 'A','D65','FL1',... or [x y z]
%          - target represents the desired reference colour
%          e.g. 'A','D65','FL1',... or [x y z]
%          - method selects the chromatic adaption method:
%          'XYZ','vonKries','Bradford'
%          - system specifies the CIE standard observer 'xyz' or 'xyz10'
%
%          M is the resulting transformation matrix
%
% Reference:
% Bruce Lindbloom, Chromatic adaptation: http://www.brucelindbloom.com/Eqn_ChromAdapt.html
%
% Author: Frederic Rudawski
% Date: 24.11.2019 (sunday), updatet: 24.10.2021 (sunday), 04.11.2021
% See: https://www.frudawski.de/chromad


function M = chromad(source,destination,method,system)

if~exist('system','var')
    system = 'xyz';
end

if ~exist('method','var')
    method = 'XYZ';
end

% Adaptation matrix
% source: http://www.brucelindbloom.com/index.html?Eqn_xyY_to_XYZ.html
switch method
    case 'XYZ'
        Ma = diag([1 1 1]);
        Ma2 = Ma;
    case 'Bradford'
        Ma = [0.8951000  0.2664000 -0.1614000
             -0.7502000  1.7135000  0.0367000
              0.0389000 -0.0685000  1.0296000];
        Ma2 = [0.9869929 -0.1470543  0.1599627;
               0.4323053  0.5183603  0.0492912;
              -0.0085287  0.0400428  0.9684867];
    case 'vonKries'
        Ma = [0.4002400  0.7076000 -0.0808100
             -0.2263000  1.1653200  0.0457000
              0.0000000  0.0000000  0.9182200];
        Ma2 = [1.8599364 -1.1293816  0.2198974;
               0.3611914  0.6388125 -0.0000064;
               0.0000000  0.0000000  1.0890636];
    otherwise
        error('Unknown method.')
end

% whitepoint of source
cs = whos('source');
if strcmp(cs.class,'char')
    wps = ciewhitepoint(source,system);
else
    wps = source;
end

% whitepoint of destination
cs = whos('destination');
if strcmp(cs.class,'char')
    wpd = ciewhitepoint(destination,system);
else
    wpd = destination;
end

% chromatic adaptation matrix
s = Ma*wps';
d = Ma*wpd';
% matrix multiplication
M = Ma2*diag(d./s)*Ma;
