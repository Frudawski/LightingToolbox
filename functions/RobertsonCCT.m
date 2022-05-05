
function CCT = RobertsonCCT(string1,val1,string2,val2,varargin)
% Calculate CCT (Correlated Colour Temperature) from x and y or u and v values with
% Robertson algorithm.
%
% see: Robertson 1968, Comutation of Correlated Color Temerature and
% Distribution Temperature
%
% To call function use:
% RobertsonCCT('x', x_value, 'y', y_value) for x and y values
% RobertsonCCT('u', u_value, 'v', v_value) for u and v values
%
% You could also mix x and v or u and y.
%
% The function returns NaN if the point is not in range of the Robertson table.
% 
% Author: Frederic Rudawski
% Date: 05.05.2016 - last updated 04.08.2020
% See: 

p = inputParser;
%ValidInput = @(f) (max(size(f)) == sum(isnumeric(f) & (f>=0) & (f<=1)));
addRequired(p,'par1',@(f) ismember(f,{'x','u'}))
addRequired(p,'var1',@(f) (isnumeric(f) || isvector(f)));
addRequired(p,'par2',@(f) ismember(f,{'y','v'}))
addRequired(p,'var2',@(f) (isnumeric(f) || isvector(f)));
addParameter(p,'warning','on',@(f) ismember(f,{'on','off'}))
parse(p,string1,val1,string2,val2,varargin{:})

% Robertson Table
% Column 1: CCT
% Column 2: u
% Column 3: v
% Column 4: slope

% actual source: http://www.brucelindbloom.com/Eqn_XYZ_to_T.html
Robertson = [1000000,0.180060000000000,0.263520000000000,-0.243410000000000;100000,0.180660000000000,0.265890000000000,-0.254790000000000;50000,0.181330000000000,0.268460000000000,-0.268760000000000;33333,0.182080000000000,0.271190000000000,-0.285390000000000;25000,0.182930000000000,0.274070000000000,-0.304700000000000;20000,0.183880000000000,0.277090000000000,-0.326750000000000;16667,0.184940000000000,0.280210000000000,-0.351560000000000;14286,0.186110000000000,0.283420000000000,-0.379150000000000;12500,0.187400000000000,0.286680000000000,-0.409550000000000;11111,0.188800000000000,0.289970000000000,-0.442780000000000;10000,0.190320000000000,0.293260000000000,-0.478880000000000;8000,0.194620000000000,0.301410000000000,-0.582040000000000;6667,0.199620000000000,0.309210000000000,-0.704710000000000;5714,0.205250000000000,0.316470000000000,-0.849010000000000;5000,0.211420000000000,0.323120000000000,-1.01820000000000;4444,0.218070000000000,0.329090000000000,-1.21680000000000;4000,0.225110000000000,0.334390000000000,-1.45120000000000;3636,0.232470000000000,0.339040000000000,-1.72980000000000;3333,0.240100000000000,0.343080000000000,-2.06370000000000;3077,0.247920000000000,0.346550000000000,-2.46810000000000;2857,0.255910000000000,0.349510000000000,-2.96410000000000;2667,0.264000000000000,0.352000000000000,-3.58140000000000;2500,0.272180000000000,0.354070000000000,-4.36330000000000;2353,0.280390000000000,0.355770000000000,-5.37620000000000;2222,0.288630000000000,0.357140000000000,-6.72620000000000;2105,0.296850000000000,0.358230000000000,-8.59550000000000;2000,0.305050000000000,0.359070000000000,-11.3240000000000;1905,0.313200000000000,0.359680000000000,-15.6280000000000;1818,0.321290000000000,0.360110000000000,-23.3250000000000;1739,0.329310000000000,0.360380000000000,-40.7700000000000;1667,0.337240000000000,0.360510000000000,-116.450000000000];

% rotate if necessary
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
    error('Input variables must have the same size.')
end

if strcmp(p.Results.par1,'x') && strcmp(p.Results.par2,'y')
    [u,v] = ciexy2uv(var1,var2);
    u(isnan(u)) = 0;
    v(isnan(v)) = 0;
elseif strcmp(p.Results.par1,'u') && strcmp(p.Results.par2,'v')
    u = var1;
    v = var2;
    u(isnan(u)) = 0;
    v(isnan(v)) = 0;
else
    error(['incorrect input combination - To call function use:',10,'RobertsonCCT(''x'', x_value(s), ''y'', y_value(s)) for x and y values',10,'RobertsonCCT(''u'', u_value(s), ''v'', v_value(s)) for u and v values'])
end

% loop for calculating CCT
di = zeros(size(Robertson,1),size(u,2));
ut = u;
vt = v;

for j = 1:31
    ui = Robertson(j,2);
    vi = Robertson(j,3);
    mi = Robertson(j,4);
    di(j,1:size(u,2)) = ((vt-vi)-mi.*(ut-ui))./(1+mi.^2).^(0.5);
end

ratio = di(1:end-1,:)./di(2:end,:);
check = ratio<0;

CCT = zeros(size(u)).*NaN;
for i=1:size(u,2)
    
    k = find(check(:,i),1,'first');
    
    if k < 31
        
        if k > 0
            Tj  = Robertson(k,1);
            Tj1 = Robertson(k+1,1);
            dj  = di(k,i);
            dj1 = di(k+1,i);
            CCT(i) = round((1/Tj+dj/(dj-dj1)*(1/Tj1-1/Tj)).^(-1));

        else
            CCT(i) = NaN;
        end
    else
        CCT(i) = NaN;
    end
end

% create  planck source(s)
lam = 360:830;
S = planck(CCT,lam);
% determine u and v of planck source(s)
[~,up,vp] = ciespec2uvw(lam,S);
% determine delta uv distance
duv = sqrt((up'-u).^2+(vp'-v).^2);
% duv < 0.05 not meaningful
ind = duv >= 0.05;
CCT(ind) = NaN;
    
% warnings:
%if sum(isnan(CCT)==1) > 0 && strcmp(p.Results.warning,'on')
%    warning([num2str(sum(isnan(CCT)==1)),' CCT values out of range for Robertson CCT algorithm']);
%end

if rot
    CCT = CCT';
end

% end of function
end
