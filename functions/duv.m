% The Duv function determines the Duv distance for given u and v chromaticity
% coordinates to the according correlated colour temperature Tcp on the 
% planckian locus. For CCT's below the planckian locas the Duv value is
% negative.
%
% Usage: d = duv(u,v,metohd)
%
% Where: d: is the returned Duv distance to the planckian locus
%        u,v: are the CIE 1960 input u and v chromaticity coordinates 
%        method: specifies the CCT determination method:
%                'Robertson'
%                'exact'
%
% Author: Frederic Rudawski
% Date: 09.03.2022


function d = duv(u,v,method)

% check for method input
if ~exist('method','var')
    method = 'Robertson';
end

% check for method or Tcp
if ischar(method)
    % get correspondig Tcp
    %Tcp = cieuv2cct(u,v,method);
    [x,y] = cieuv2xy(u,v);
    Tcp = ciexy2cct(x,y,method);
else
    Tcp = method;
end

% create  planck source(s)
lam = 360:830;
S = planck(Tcp,lam,'CIE');

% determine u and v of planck source(s)
[~,up,vp] = ciespec2uvw(lam,S);

% determine delta uv distance
d = sqrt((up-u).^2+(vp-v).^2);

% Duv direction
dv = v-vp;
ind = dv<0;
d(ind) = -d(ind);

