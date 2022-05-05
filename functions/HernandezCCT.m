function CCT = HernandezCCT(string1,val1,string2,val2,varargin)
% CCT calculation with Hernández procedure. 
% NOT RECOMMENDED - ONLY FOR DAYLIGHT
%  
%  Described in: "Calculating correlated color temperatures across the
%  entire gamut of daylight and skylight chromaticities" 
%  by Javier Hernández-Andrés, Raymond L. Lee, Jr., and Javier Romero
% 
% Range 3000 K to 8x10^5 K
% Works with x,y and u,v coordinates
% 
% Usage: HernandezCCT('x',x_value,'y',y_value) or HernandezCCT('u',u_value,'v',v_value)
%
% Author: Frederic Rudawski
% Date: 05.05.2016 - last updated 13.07.2018

p = inputParser;
%ValidInput = @(f) (max(size(f)) == sum(isnumeric(f) & (f>=0) & (f<=1)));
addRequired(p,'par1',@(f) ismember(f,{'x','u'}))
addRequired(p,'var1',@isnumeric);
addRequired(p,'par2',@(f) ismember(f,{'y','v'}))
addRequired(p,'var2',@isnumeric);
addParameter(p,'warning','on',@(f) ismember(f,{'on','off'}))
parse(p,string1,val1,string2,val2,varargin{:})


% rotate if necesary
rot = 0;
if size(p.Results.var1,1) > size(p.Results.var1,2)
    var1 = p.Results.var1';
    rot = 1;
else
    var1 = p.Results.var1;
end
if size(p.Results.var2,1) > size(p.Results.var2,2)
    var2 = p.Results.var2';
    rot = 1;
else
    var2 = p.Results.var2;
end

if sum(size(var1)) ~= sum(size(var2))
    error('Input variables must have same size.')
end

if strcmp(p.Results.par1,'x') && strcmp(p.Results.par2,'y')
    x = var1;
    y = var2;
    x(isnan(x)) = 0;
    y(isnan(y)) = 0;
elseif strcmp(p.Results.par1,'u') && strcmp(p.Results.par2,'v')
    [x,y] = cieuv2xy(p.Results.var1,p.Results.var2);
    x(isnan(x)) = 0;
    y(isnan(y)) = 0;
else
    error(['incorrect input combination - To call function use:',10,'RobertsonCCT(''x'', x_value(s), ''y'', y_value(s)) for x and y values',10,'RobertsonCCT(''u'', u_value(s), ''v'', v_value(s)) for u and v values'])
end

% constants
xe = [0.3366 0.3356];
ye = [0.1735 0.1691];
A0 = [-949.86315 36284.48953];
A1 = [6253.80338 0.00228];
t1 = [0.92159 0.07861];
A2 = [28.70599 5.4535*10^(-36)];
t2 = [0.20039 0.01543];
A3 = 0.00004;
t3 = 0.07125;

% inverse slope line
n = (x-xe(1))./(y-ye(1));
% First CCT calculation
CCT1 = A0(1) + A1(1).*exp(-n./t1(1)) + A2(1).*exp(-n./t2(1)) + A3.*exp(-n./t3);
% zero NaN values
CCT1(isnan(CCT1) == 1) = 0;

% inverse slope line
n = (x-xe(2))./(y-ye(2));
% second calculation of CCT
CCT2 = A0(2) + A1(2).*exp(-n./t1(2)) + A2(2).*exp(-n./t2(2)) + A3.*exp(-n./t3);
% zero NaN values
CCT2(isnan(CCT2) == 1) = 0;

% check for higher values than 50000
new = CCT1 >= 50000;

CCT = CCT1;
CCT(new) = CCT2(new);

% minimum and maxima CCT
CCT(CCT<3000) = NaN;
CCT(CCT>8E5) = NaN;

% warnings:
if sum(isnan(CCT)==1) > 0 && strcmp(p.Results.warning,'on')
    warning([num2str(sum(isnan(CCT)==1)),' CCT values out of range for Hernandez CCT algorithm']);
end

if rot
    CCT = CCT';
end

% return CCT
CCT = round(CCT);
