% hueset allows to change philips hue group or lamp settings.
%
% usage: resp = huesetgroup(element,mode,parameter,value)
%
% where: resp: reuturns the response of the hue brigde
%        element: defines which group or lamp is to be changed:
%                 groups: char/string of group name or group id, for
%                         several groups, use cell array.
%                 lamps:  numeric or vecotr with lamp id. 
%               name or group id.
%        mode: sets the group lamps status:
%              'on' turns all lamps on
%              'off' turns all lamps off
%              'toggle' turns all lamps off, it at least one is enabled and
%                       turns all lamps on, if all lamps are disabled.
%        parameter & value:
%           - 'bri' = brigthness integer 0-254, numeric or vector
%           - 'ct' = correlated temperatur (on planckian locus) in K, numeric
%                    or vector. Range: 2000 K - 6500 K, ct is overruled by
%                    'xy' setting.
%           - 'xy' = CIE x & y chromaticity coordinates, n x 2 matrix.
%           Overrules 'ct' setting.
%        For each group or lamp, different parameter values can be specified.
%
% Author: Frederic Rudawski
% Date: 31.03.2022

function resp = hueset(element,mode,varargin)

% call huesetlamp or huesetgroup function
if ischar(element) || isstring(element) || iscell(element)
    resp = huesetgroup(element,mode,varargin{:});
elseif isnumeric(element) || isvector(element)
    resp = huesetlamp(element,mode,varargin{:});
end
