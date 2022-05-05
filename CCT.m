% calculating CCT by determining shortest distance between color coordinates and planck locus.
%
% usage: CCT(par1,var1,par2,var2,parameter,mode)
%           par1 = 'x' or 'u'
%           par2 = 'y' or 'v'
%
%           parameters (optional):
%           'range': maximum temperature
%           'start': start temperature
%           'accuracy': digit accuracy of CCT calculation
%           'mode' : 'CIE' constants as in oler CIE documents 
%                    'exact' exact constants from NIST
%
% Author: Frederic Rudawski
% Date: 20.02.2017 - last updated 13.07.2018


function [calc_CCT,DC] = CCT(string1,val1,string2,val2,varargin)


p = inputParser;
%ValidInput = @(f) (max(size(f)) == sum(isnumeric(f) & (f>=0) & (f<=1)));
addRequired(p,'par1',@(f) ismember(f,{'x','u'}))
addRequired(p,'var1',@isnumeric);
addRequired(p,'par2',@(f) ismember(f,{'y','v'}))
addRequired(p,'var2',@isnumeric);
addParameter(p,'warning','off',@(f) ismember(f,{'on','off'}))
addParameter(p,'range',10^6,@isnumemric)
addParameter(p,'accuracy',0.000000000001,@isnumeric)
addParameter(p,'start',1000,@isnumeric)
addParameter(p,'mode','exact',@ischar)
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
    [u_value,v_value] = ciexy2uv(var1,var2);
    u_value(isnan(u_value)) = 0;
    v_value(isnan(v_value)) = 0;
elseif strcmp(p.Results.par1,'u') && strcmp(p.Results.par2,'v')
    u_value = var1;
    v_value = var2;
    u_value(isnan(u_value)) = 0;
    v_value(isnan(v_value)) = 0;
else
    error(['incorrect input combination - To call function use:',10,'CCT(''x'', x_value(s), ''y'', y_value(s)) for x and y values',10,'CCT(''u'', u_value(s), ''v'', v_value(s)) for u and v values'])
end

% calculation
lambda = (360:830).*10^(-9);

% range and accuracy
range = p.Results.range;%10^6; % T in K
accuracy = p.Results.accuracy;%1/10; 
start = p.Results.start;%1000; % T in K

% empty vector for warnings
warvec = [];
counter = 1;

% start/end T
startT = start;
endT = range;

switch p.Results.mode
  case 'exact'
    % constants
    % http://physics.nist.gov/cgi-bin/cuu/Value?c11strc
    % http://physics.nist.gov/cgi-bin/cuu/Value?c22ndrc
    c1 = 3.741771852*10^(-16);
    c2 = 1.438776877*10^(-2);
  case 'CIE'
    % CIE TR 224
    c1 = 3.74183e-16;
    c2 = 1.4388e-2;
end

% CIE standard 2 degree observer: 360 nm - 830 nm
CIExyz = ciespec(360:830,'xyz');

% initialization
calc_CCT = zeros(size(val1));
% loop for vector entries
for value = 1:length(val1)
    
    % start temperature in remek
    remek = linspace(1e6/start,1e6/range,10);
    
    dT = range;
    while abs(dT) > accuracy
        
        % Temperature:
        T = 10^6./remek;
        dT = T(2)-T(1);
        
        % calculation of planck coordinates
        x = zeros(1,size(T,2));
        y = zeros(size(x));
        for i = 1:size(T,2)
            M = c1 ./ lambda.^5 .* (1./(exp(c2./lambda./T(i))-1));
            X = M*CIExyz(1,:)';
            Y = M*CIExyz(2,:)';
            Z = M*CIExyz(3,:)';
            x(i) = X/(X+Y+Z);
            y(i) = Y/(X+Y+Z);
        end
        
        % transformation to u & v
        u = 4.*x ./ (-2.*x + 12.*y + 3);
        v = 6.*y ./ (-2.*x + 12.*y + 3);
        
        % distance to each T
        d = sqrt((u-u_value(value)).^2+(v-v_value(value)).^2);
        %c = 1-d(2:end)./d(1:end-1)
        
        % min distance = CCT
        [~,ind] = min(d);
        DC = min(d);
        %d(ind) = NaN;
        %[~,ind2] = min(d);
        CCTcalc = T(ind);

        % equidistant remek temperature values
        if ind == 1
            remek = linspace(1e6/T(1),1e6/T(3),10);
        elseif ind == 10
            remek = linspace(1e6/T(end-2),1e6/T(end),10);
        else
            %[T(ind-1) T(ind) T(ind+1)]
            remek = linspace(1e6/T(ind-1),1e6/T(ind+1),10);
        end
        
    end
    calc_CCT(value) = CCTcalc;
    % warning generation
    if d(ind) > 0.05
        warvec(counter) = value;
        counter = counter + 1;
        calc_CCT(value) = NaN;
    end
end
% result in range CCT?
calc_CCT(calc_CCT==startT) = NaN;
calc_CCT(calc_CCT==endT) = NaN;
% round
calc_CCT = round(calc_CCT./accuracy).*accuracy;


if rot
    calc_CCT = calc_CCT;
end

% warning for distances over 0.05 -> result not meaningful
%if ~isempty(warvec) && strcmp(p.Results.warning,'on')
%    warning(['delta_uv greater 0.05 -> result not meaningful for ',num2str(max(size(warvec))),' entries: ',num2str(warvec)])
%end

