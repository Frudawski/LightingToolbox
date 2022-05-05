% CIE 1960 uniform u & v chromaticty
%
% plot u,v coordinates in CIE 1960 u,v chromaticty diagram.
%
% usage: cie1960(u,v)
%
% optional parameters:
% usage: cie1960(u,v,parameter,value,...)
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see license.
%
% NOTE: for use in octave the image package is recommended.
%
% parameters:
% input: 'uv','xy' (default: 'uv')
%       input data for plot. x,y coordinates will be first transformed to
%       u,v coordinates.
% Planck: 'on','off'
%       plot planckian locus (default: 'off')
% CCT: 'value','range','off'
%       plots isotemperature lines over the planckian locus
%       'value': plots for each given value an isotemperature line
%       'range': plots only the min and max isotemperature line
%       'off': plot no isotemperature line (default)
% CCTMethod: 'Robertson','Hernandez','exact'
%       define CCT calculation method:
%       'Robertson': Robertson CCT algrithm (fast and good approximation)
%       'Hernandez': Hernandez-Andres CCT calculation (fastest and good enough approximation)
%       'exact': find minimum distance in uv (CIE1960) diagram to planckian locus (slow but exact calculation)
% IsoTempLines: [CCT1 CCT2 ...]
%       plot additional isotemperature lines in Kelvin, default: []
% DaylightLocus: 'on','off'
%        plot the daylight locus (default: 'off')
% Color: 'on','off'
%       plot the cie1960 diagram in color or bw (default: 'on')
% Background: 'white','black'
%       'white': white background (default)
%       'black': black background
% Marker: '+','o','*','.','x','s','d','^','v','>','<','p','h','square','diamond','pentagram','hexagram'
%       marker for the x,y plot
%       all Matlab standard plot markers are useable (see list above)
% MarkerColor: [r g b]
%       color of the plot marker
%       [] = matlab colormap order (default)
%       [r g b] = uniform rgb color for the plot marker(s)
%       [r1 g1 b1 ; r2 b2 g2 ; ... ] = colormap used for plot marker(s)
% MarkerSize: numeric
%       plot marker size, default: 10
% LegendMode: 'on','off','extended'
%       'off': no legend
%       'on': show plot legend with x and y value
%       'extended': show legend with x, y and CCT value
% Grid: 'on','off'
%       plot grid lines (default: 'on')
% FontSize: numeric
%       Fontsize of text
% Warning: 'on','off'
%       The cie1931 function uses a image processing toolbox function, namely
%       'roipoly'. If the image processing toolbox is not available an
%       alternativ function is used ('inpolygon') which leads to much longer execution time.
%       In that case a warning is shown in the comman window. Also CCT
%       calculation warnings are suppressed.
%       'on': show warning message (default)
%       'off': suppress warning message
% zoom: numerical vector [u1 u2 v1 v2]
%       Zooms in specified region (default: [0.00  0.65  0.00  0.45])
%
% Author: Frederic Rudawski
% Date: 05.05.2016 - last updated 17.07.2018
% See: https://www.frudawski.de/plotcieuv


function cie1960(var1,var2,varargin)

cla reset

if ~exist('var1','var')
    var1 = NaN;
end
if ~exist('var2','var')
    var2 = NaN;
end

p = inputParser;
validVar = @(f) isnumeric(f);
addRequired(p,'var1',validVar);
addRequired(p,'var2',validVar);
addParameter(p,'Planck','off',@(f) ismember(f,{'on','off','exact'}))
addParameter(p,'DaylightLocus','off',@ischar)
addParameter(p,'Color','on',@ischar)
addParameter(p,'MarkerColor',[],@(f) (ismatrix(f) && size(f,1) == max(size(f))) || isvector(f))
addParameter(p,'Grid','on',@ischar)
addParameter(p,'MarkerSize',10,@isnumeric)
addParameter(p,'IsoTempLines',[],@isvector);
LegendMode = {'off','on','extended'};
addParameter(p,'LegendMode','off',@(f) any(validatestring(f,LegendMode)))
CCTOptions = {'value','range','off'};
addParameter(p,'CCT','value',@(f) any(validatestring(f,CCTOptions)))
CCTMethod = {'Robertson','Hernandez','exact'};
addParameter(p,'CCTMethod','Robertson',@(f) any(validatestring(f,CCTMethod)))
BackgroundOptions = {'black','white'};
addParameter(p,'Background','white',@(f) any(validatestring(f,BackgroundOptions)))
WhitePoints = {'A','B','C','D50','D55','D65','D75','D93','E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'};
addParameter(p,'WhitePoints','',@(f) (sum(ismember(f,WhitePoints)) > 0 || iscell(f)))
Marker = {'+','o','*','.','x','s','d','^','v','>','<','p','h','square','diamond','pentagram','hexagram'};
addParameter(p,'Marker','+',@(f) any(validatestring(f,Marker)))
addParameter(p,'FontSize',8,@isscalar)
addParameter(p,'input','uv',@(f) ismember(f,{'xy','uv'}))
addParameter(p,'zoom',[0 0.65 0 0.45],@isvector)
addParameter(p,'Warning','on',@(f) ismember(f,{'on','off'}))
parse(p,var1,var2,varargin{:})

%p.Results

if strcmp(p.Results.input,'uv')
    us = p.Results.var1;
    vs = p.Results.var2;
elseif strcmp(p.Results.input,'xy')
    [us,vs] = ciexy2uv(p.Results.var1,p.Results.var2);
end
if size(us,2) > us(1)
    us = us';
end
if size(vs,2) > vs(1)
    vs = vs';
end

% color
clr = p.Results.MarkerColor;
if max(size(us)) ~= size(clr,1)
    clr = repmat(clr,max(size(us)),1);
end

plot_u = us;
plot_v = vs;

% whitepoints
try
    W = zeros(21,1);
    [~,w] = ismember(p.Results.WhitePoints,{'A','B','C','D50','D55','D65','D75','D93','E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'});
    W(w) = 1;
catch
end

% Color depending if color background is present or not - should be for
% daylight locus
if strcmp(p.Results.Color,'off')
    plotcolor = [0.55 0.55 0.55]; % gray
else
    plotcolor = [1 1 1]; % white
end

% CIE tristimulus curves (DIN EN ISO 11664-1)
WL = 360:830;
xFcn = ciespec(WL,'x');
yFcn = ciespec(WL,'y');
zFcn = ciespec(WL,'z');

%if strcmp(p.Results.Planck,'on')
    % Approximation of planckian locus - valid for: 1000 K < T < 15000 K
    T = linspace(1,1000000,1000000);
    u_T = (0.860117757+1.54118254.*10^-4.*T+1.28641212.*10^-7.*T.^2)./(1+8.42420235.*10^-4.*T+7.08145163.*10.^-7.*T.^2);
    v_T = (0.317398726+4.22806245.*10^-5.*T+4.20481691.*10^-8.*T.^2)./(1-2.89741816.*10^-5.*T+1.61456053.*10.^-7.*T.^2);
if strcmp(p.Results.Planck,'exact') %  slow
    % constants
    c1 = 3.741771790*10^(-16);
    c2 = 1.43877736*10^(-2);
    % T range
    start = 1;
    stop  = 150000;
    % temp & lambda range
    T = start:stop;
    lambda = (360:830).*10^(-9);
    % calculation of planck locus
    x = zeros(1,size(T,2));
    y = zeros(size(x));
    for i = 1:size(T,2)
        M = c1 ./ lambda.^5 ./(exp(c2./lambda./T(i))-1);
        X = M*xFcn';
        Y = M*yFcn';
        Z = M*zFcn';
        x(i) = X/(X+Y+Z);
        y(i) = Y/(X+Y+Z);
    end
    u_T = 4.*x ./ (-2.*x + 12.*y + 3);
    v_T = 6.*y ./ (-2.*x + 12.*y + 3);
end

Tinfo = [];
% add CCTinfo of u,v in Tinfo if wanted
if strcmp(p.Results.CCT,'value') == 1 || strcmp(p.Results.CCT,'range') == 1 || ~isempty(p.Results.IsoTempLines)
    if strcmp(p.Results.CCTMethod,'Robertson') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = RobertsonCCT('u',us,'v',vs);
        else
            Tc = RobertsonCCT('u',us,'v',vs,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'Hernandez') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = HernandezCCT('u',us,'v',vs);
        else
            Tc = HernandezCCT('u',us,'v',vs,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'exact') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = round(CCT('u',us,'v',vs));
        else
            Tc = round(CCT('u',us,'v',vs,'warning','off'))';
        end
    end
    
    Tinfo = Tc;
    Tinfo(isnan(Tinfo)) = [];
    Tinfo(Tinfo==0) = [];
    
    if strcmp(p.Results.CCT,'range') == 1
        Tinfo = [min(Tinfo) max(Tinfo)];
    end
    
    if ~isempty(p.Results.IsoTempLines)
        Tinfo = [Tinfo; p.Results.IsoTempLines'];
    end
end

u_Tinfo = [];
v_Tinfo = [];
% CT Info Values
if strcmp(p.Results.Planck,'on')
    u_Tinfo = (0.860117757+1.54118254.*10^-4.*Tinfo+1.28641212.*10^-7.*Tinfo.^2)./(1+8.42420235.*10^-4.*Tinfo+7.08145163.*10.^-7.*Tinfo.^2);
    v_Tinfo = (0.317398726+4.22806245.*10^-5.*Tinfo+4.20481691.*10^-8.*Tinfo.^2)./(1-2.89741816.*10^-5.*Tinfo+1.61456053.*10.^-7.*Tinfo.^2);
elseif strcmp(p.Results.Planck,'exact')
    [~,~,~,~,u_Tinfo,v_Tinfo] = planck(Tinfo,[360 830]);
end




% color diagram
d = 0:.001:1;
[u,v] = meshgrid(d,d);
v = flipud(v);
[x,y] = cieuv2xy(u,v);
z = ones(size(x))-x-y;

data = cat(3,x,y,z);
xyz = reshape(data,[size(data,1)*size(data,2),3]);
srgb = xyz2srgb(xyz,'D65');
rgb = reshape(srgb,[size(data,1),size(data,2),3]);
X=xFcn./sum([xFcn; yFcn; zFcn]);
Y=yFcn./sum([xFcn; yFcn; zFcn]);
Z=zFcn./sum([xFcn; yFcn; zFcn]);
cieu=4.*X./(X+15.*Y+3.*Z);
ciev=6.*Y./(X+15.*Y+3.*Z);
ncieu=cieu*size(rgb,2);
nciev=size(rgb,1)-ciev*size(rgb,1);

% OCTAVE code
if exist('OCTAVE_VERSION', 'builtin')
  
poly = [259.158576051780	259.037621919186	258.908897918688	258.779374218881	258.654068915703	258.536377735894	258.424876388577	258.316351704938	258.210877878792	258.108597811093	258.009644729179	257.916551155902	257.826138560095	257.733300378188	257.636512245908	257.536179845445	257.431325553127	257.330787126045	257.243915647892	257.174149023713	257.122059270235	257.082330266776	257.045968317965	257.009232796867	256.970191145233	256.929108301477	256.887870328359	256.844311701284	256.792991250608	256.731360244903	256.658019734102	256.570105373257	256.474441500979	256.383297801955	256.305825809011	256.247960848287	256.203724372035	256.162183596387	256.119551203036	256.072846431697	256.019804823082	255.956223360853	255.875208010749	255.773386155069	255.652666503752	255.518203582927	255.366927218106	255.203692733761	255.042215092429	254.890265291894	254.751030912760	254.610708755400	254.453557264593	254.280550751078	254.094405688996	253.898793527360	253.700373448144	253.477625352459	253.205119160322	252.870091270820	252.469298698374	252.014086116698	251.524172618032	251.005984374569	250.459303527514	249.879121129145	249.262051288347	248.604936945009	247.901435580060	247.145049254034	246.329252172406	245.446949217636	244.501081283460	243.498492442561	242.444432180839	241.342904010657	240.190240907612	238.979757483089	237.709999817287	236.379194547138	234.985680247234	233.527244738179	231.995787112359	230.381386296201	228.675292458450	226.870259130112	224.962224200596	222.951971568027	220.841343543029	218.633664435024	216.333999193254	213.950167138697	211.482259647845	208.923052012609	206.262613624611	203.488247488439	200.587831762279	197.565636934851	194.430323499300	191.189342646309	187.848993288591	184.413343111804	180.863592227011	177.165995501624	173.278355626184	169.148942613436	164.722228670340	159.989279765911	154.969847736035	149.701063837499	144.241992410077	138.638620533129	132.887339478323	126.991985078261	120.956711116808	114.785426081343	108.501453026081	102.142874575093	95.7364356273258	89.3099772414055	82.8917624248010	76.5041788762653	70.1815942801938	63.9779740921007	57.9565038554620	52.1883108642766	46.7430837892714	41.6345320344331	36.8504394251921	32.3735379838185	28.1821168244335	24.2764086659335	20.6846641643163	17.4190192732778	14.4849684633455	11.8820251937984	9.60562652867255	7.64280090750160	5.97647046410250	4.58918671360821	3.46275084276108	2.58250159004681	1.94518827381614	1.54550789892199	1.37503727311552	1.42389758179232	1.67558009371642	2.12210624881169	2.76497244301846	3.60411553334497	4.63789560213728	5.85390490948483	7.23461037717489	8.77076647246264	10.4549148938852	12.2814318239312	14.2436644294243	16.3245703377624	18.5079440780101	20.7821270079480	23.1396253107127	25.5774529564322	28.0919207681785	30.6769637109602	33.3258999561776	36.0313480538009	38.7913778896502	41.5966155330302	44.4295349702814	47.2746382542204	50.1182122496026	52.9538577822011	55.7901279537501	58.6361868338317	61.5002120510139	64.3896012012063	67.3065309210033	70.2518557394019	73.2306123545526	76.2477554629797	79.3082195985349	82.4159909353410	85.5727882632779	88.7800929593346	92.0394097154635	95.3522682132359	98.7208856767979	102.148583755191	105.638403195997	109.192987109282	112.814539958729	116.508513165917	120.274726373416	124.114665184384	128.030364383158	132.024533468580	136.101466902335	140.263089389901	144.509748252610	148.842691772801	153.264268053982	157.779190331980	162.385579089885	167.085938570734	171.882719046875	176.778307493034	181.774341039731	186.871167213688	192.069507016260	197.370476338124	202.775604050929	208.286353928716	213.902934732876	219.625338457941	225.453472723415	231.387141691074	237.426321546000	243.569425128931	249.814081666210	256.158414980187	262.601069998189	269.141796686382	275.778953400125	282.509017361831	289.327598980265	296.229343857023	303.207355396231	310.257439772034	317.376884935100	324.561930142635	331.807664357347	339.113447788994	346.462596615717	353.824247941124	361.165982574976	368.453636616971	375.656972846445	382.783200688751	389.853501701600	396.889552019934	403.913614952135	410.937559197919	417.935896259888	424.873459599865	431.712648584609	438.413135903827	444.947656431319	451.324225584437	457.552183261006	463.640433218327	469.597478891330	475.420138528427	481.096506117446	486.621284269267	491.988978533392	497.193851626016	502.231966236425	511.807891492966	516.349282419423	520.731664694045	524.960820386903	529.043210936805	532.985198390784	536.791434157134	540.464835539907	544.003685423506	547.415322675851	550.715298401437	553.919068367320	557.042067766827	560.092783693516	563.063920272949	565.948912845114	568.743119661924	571.444117577344	574.054124610051	581.349376088146	583.603951890034	585.775200917962	587.863527509523	589.862897169405	591.766713272473	593.567833414824	595.257897853673	596.841182900352	599.734332974289	601.077045274027	623.989409215770
989.278012212531	989.294896974748	989.312252967310	989.329560556333	989.346415335060	989.362521299458	989.383697832961	989.408702978633	989.429657011957	989.441829949912	989.442735002912	989.425720636702	989.406989507718	989.410413138438	989.449583683459	989.529638591835	989.649207035276	989.778104183617	989.888293161530	989.965911253457	990.004648781207	990.005115633031	989.985870558211	989.965432813662	989.957099659180	989.969054384194	990.005013023177	990.050132598794	990.088086608209	990.110011204695	990.111844555235	990.091758641397	990.065625837178	990.051532750129	990.060368270559	990.096900489396	990.157401453622	990.224661300966	990.286288453226	990.336440704733	990.372762818665	990.396752066638	990.412257946894	990.420903051417	990.423860181412	990.422273590358	990.409731038238	990.389534634873	990.372977571607	990.366474901224	990.373175796216	990.382629616761	990.381491650070	990.368163609762	990.342424416982	990.305048887872	990.257177793874	990.185493864052	990.076609193589	989.924297037721	989.727371690800	989.493602773060	989.231008778297	988.939669964450	988.617402804631	988.259969379503	987.865063575034	987.433633899457	986.964252500393	986.454831826359	985.902680564284	985.305249584015	984.661719337035	983.971084115337	983.231817686243	982.441942906213	981.595893586281	980.694567892155	979.744683063412	978.752234662184	977.722734671731	976.657372891317	975.547285856172	974.383476917301	973.158008806601	971.863929830730	970.496404781921	969.055698407325	967.544056846649	965.964770587012	964.322314235528	962.620975896200	960.854131708273	959.009521183460	957.073015699013	955.028384627651	952.859242313953	950.560549592073	948.130433075168	945.565838757700	942.862416107383	940.018376020478	937.002455399887	933.759697354352	930.226462953151	926.327916014738	921.989959435276	917.195150218473	911.951896801745	906.284452545987	900.238817034177	893.847991165818	887.094647259875	879.969347004680	872.462927358229	864.566091026469	856.282253212003	847.654686160662	838.737106737028	829.587154715457	820.265796544921	810.821198652672	801.269139845883	791.635219548111	781.959946400592	772.299063727805	762.729343717959	753.308623572767	744.073081594082	735.055295990845	726.283789043174	717.793334114455	709.632623695504	701.839774502391	694.442791161755	687.460029069767	680.903791741996	674.761374778401	669.010390297893	663.632408294002	658.611676873930	653.945220674888	649.630373414894	645.644401587969	641.956156600705	638.529071834993	635.333218848011	632.360315529920	629.605112549642	627.063489615734	624.732018084669	622.598326877235	620.654744466076	618.902981041165	617.342407077394	615.970781684796	614.777416682766	613.745459974190	612.862759156068	612.117690586430	611.499431706828	610.999579188231	610.602509448635	610.289312709821	610.043284085145	609.849471583830	609.699415528384	609.589535763264	609.513693573297	609.466248337722	609.442003391323	609.436112022441	609.447455348490	609.476761092140	609.524781383788	609.592297729365	609.678561894864	609.782080183882	609.902606418581	610.039954908403	610.194000532013	610.364512530113	610.550949762545	610.752794082977	610.969578359570	611.200881862239	611.446453392652	611.706021578475	611.979184099011	612.265536899851	612.564665904671	612.876639424215	613.201078767513	613.537751127871	613.886492613363	614.247218967695	614.620046373269	615.004831988763	615.401237722066	615.809021645597	616.228057072216	616.658504446300	617.100034624913	617.552816639788	618.017019414070	618.492810187169	618.980208786322	619.479111043901	619.989530847859	620.511523500452	621.045187528242	621.590578718472	622.147582958219	622.716079703205	623.295939539736	623.887021654583	624.489272459057	625.102384226585	625.725844889011	626.359182890048	627.001968408124	627.654001454472	628.315176627730	628.985189083237	629.663648868627	630.350071443152	631.043626129333	631.744005421320	632.451386810670	633.165867507887	633.887457003052	634.616504503428	635.351038548768	636.087397461246	636.821729194583	637.549968649854	638.268701141858	638.978892122608	639.682946442669	640.383338560922	641.082624221243	641.782196572571	642.479315076850	643.170199200513	643.850803610954	644.516786394957	645.165149670168	645.796959912190	646.413659160634	647.016693557428	647.607522617686	648.186217765050	648.751381312917	649.302222542705	649.837903879878	650.357533028455	650.860659721480	651.817335771544	652.270807460242	652.707904263730	653.128936873733	653.534632409529	653.925893024040	654.303488661547	654.668061867893	655.019635771887	655.358846214501	655.687193366776	656.006159305711	656.317213671679	656.621217116433	656.917486314386	657.205327791619	657.484232086328	657.753902433243	658.014525275778	658.743098053934	658.968213058419	659.184933219024	659.393285608534	659.592657014915	659.782376864334	659.961718772470	660.129798997170	660.287061465898	660.574238306784	660.707704527403	662.998940921580];

try
  mask = poly2mask(poly(1,:),poly(2,:),1001,1001);
catch
  warning('Image package not available, computation does takes longer. Consider installing image package for Octave: https://octave.sourceforge.io/image/')
  [xgrid,ygrid] = meshgrid(1:1001,1:1001);
   mask = inpolygon(xgrid(:),ygrid(:),poly(1,:),poly(2,:));
   mask = reshape(mask,1001,1001);
end
rgb = rgb.*mask;
rgb = rgb+~mask;

% show image
if strcmp(p.Results.Color,'on')
    % Color
    if strcmp(p.Results.Background,'black')
        image(rgb.*mask)
        hold on
        ax = gca;
        fig = gcf;
        set(ax,'color',[0 0 0])
        set(fig,'color',[0 0 0])
        set(ax,'gridcolor',[1 1 1])
        set(ax,'minorgridcolor',[1 1 1])
        set(ax,'ycolor',[1 1 1])
        set(ax,'xcolor',[1 1 1])
        %fig.InvertHardcopy = 'off';
        Thandle = title('CIE 1960 Chromaticity');
        set(Thandle,'color',[1 1 1]);
    else
        image(rgb);
        hold on
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard

    end
else
        % No color
    
    if strcmp(p.Results.Background,'black')
        image(ones(size(rgb))); % for correct y-invert axis
        hold on
        mask = plot(poly);
        mask.FaceAlpha = 1;
        mask.FaceColor = [0 0 0];
        ax = gca;
        fig = gcf;
        set(ax,'color',[0 0 0])
        set(fig,'color',[0 0 0])
        ax.GridColor = [0.7, 0.7, 0.7];
        ax.XColor = 'w';
        ax.YColor = 'w';
        fig.InvertHardcopy = 'off';
        Thandle = title('CIE 1960 Chromaticity');
        Thandle.Color = [1 1 1];

    else
        image(ones(size(rgb)));
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard        
    end
end
hold on;
axis equal

% MATLAB code
else

% polygon of mask
warning('off','MATLAB:polyshape:repairedBySimplify') % turn simplying warning off
poly = polyshape({[1 1000 1000 1 1],ncieu},{[1 1 1000 1000 1],nciev});
warning('on','MATLAB:polyshape:repairedBySimplify') % turn simplying warning on again


% show image
if strcmp(p.Results.Color,'on')
    % Color
    if strcmp(p.Results.Background,'black')
        image(rgb);
        hold on
        mask = plot(poly);
        mask.FaceAlpha = 1;
        mask.FaceColor = [0 0 0];
        ax = gca;
        fig = gcf;
        set(ax,'color',[0 0 0])
        set(fig,'color',[0 0 0])
        ax.GridColor = [0.7, 0.7, 0.7];
        ax.XColor = 'w';
        ax.YColor = 'w';
        fig.InvertHardcopy = 'off';
        Thandle = title('CIE 1960 Chromaticity');
        Thandle.Color = [1 1 1];
    else
        image(rgb);
        hold on
        mask = plot(poly);
        mask.FaceAlpha = 1;
        mask.FaceColor = [1 1 1];
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard

    end
else
        % No color
    
    if strcmp(p.Results.Background,'black')
        image(ones(size(rgb))); % for correct y-invert axis
        hold on
        mask = plot(poly);
        mask.FaceAlpha = 1;
        mask.FaceColor = [0 0 0];
        ax = gca;
        fig = gcf;
        set(ax,'color',[0 0 0])
        set(fig,'color',[0 0 0])
        ax.GridColor = [0.7, 0.7, 0.7];
        ax.XColor = 'w';
        ax.YColor = 'w';
        fig.InvertHardcopy = 'off';
        Thandle = title('CIE 1960 Chromaticity');
        Thandle.Color = [1 1 1];

    else
        image(ones(size(rgb)));
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard        
    end
end
hold on;
axis equal

end

% Border plot coordinates
u = cieu;
v = ciev;
u(1,472) = u(1,1);
v(1,472) = v(1,1);
plot(u.*1000,1000-(v.*1000),'Color','k', 'Linewidth', 1.25);
% nm labels
%[C,IA,IB]=intersect(WL,[400 460 470 480 490 520 540 560 580 600 620 700]);
%text(nciex(IA),nciey(IA),num2str(WL(IA).'));

% GRID ON
if strcmp(p.Results.Grid,'on')
    grid on
end

% PLANCIAN LOCUS
if strcmp(p.Results.Planck,'on') || strcmp(p.Results.Planck,'exact')
    % planc locus plot
    plot(u_T(1000:end).*1000,1000-(v_T(1000:end).*1000),'Color','k', 'Linewidth', 1.5);
    % planckian locus text
    text(u_T(end)*1000,1000-(v_T(end)*1000-15),'Planckian locus  ','FontSize',8,'HorizontalAlignment','right', 'Color', 'k');
    
    % exclude NaN values in Tinfo
    Tinfo = Tinfo(isnan(Tinfo)==0);
    % Ploting markers ISOTHERMS
    if strcmp(p.Results.CCT,'on') || strcmp(p.Results.CCT,'value')  || strcmp(p.Results.CCT,'range') && ~isempty(Tinfo)
        len = 0.05;
        % derivation from u_T and v_T
        diff_u_T = diff(u_T);
        diff_v_T = diff(v_T);
        % derivation from points of interest
        du = diff_u_T(Tinfo);
        dv = diff_v_T(Tinfo);
        % resultating slope normal
        m = -1./(dv./du);
        % line length
        um(1:size(Tinfo,2)) = len;
        vm = m.*um;
        l = len;
        du = sqrt(l.^2./(1+m.^2));
        dv = m.*du;
        lmarker  = l+0.02;
        for i = numel(Tinfo):-1:1
            
            U = [u_Tinfo(i)+du(i) u_Tinfo(i)-du(i)];
            V = [v_Tinfo(i)+dv(i) v_Tinfo(i)-dv(i)];
            
            dumarker = sqrt(lmarker.^2./(1+m(i).^2));
            dvmarker = m(i).*dumarker;
            
            u = u_Tinfo(i);
            v = v_Tinfo(i);
            X = [u+du u-du];
            Y = [v+dv v-dv];
            Umarker = [u-dumarker u+dumarker];
            Vmarker = [v-dvmarker v+dvmarker];
            
            % plot
            u = U.*1000;
            v = 1000-(V.*1000);
            iso = plot(u,v,'k','Linewidth', 1);
            
            
            % numbers
            u = Umarker.*1000;
            v = 1000-(Vmarker.*1000);
            % correct side of line
            %pos = find(m>0)
            if m(i) >= 0
                xmarker = u(2);
                ymarker = v(2);
            else
                xmarker = u(1);
                ymarker = v(1);
            end
            if ~strcmp(p.Results.CCT,'off')
                CCTinfoText = [num2str(Tinfo(i)),' K'];
                text(xmarker,ymarker,CCTinfoText,...
                    'FontSize',8,'HorizontalAlignment','center');
            else
                %text(xmarker,ymarker,num2str(Tinfo(i)/1000),...
                %    'FontSize',8,'HorizontalAlignment','center');
            end
            
        end
        
    end
end



% DAYLIGHT LOCUS
if strcmp(p.Results.DaylightLocus,'on')
    % Daylight CCT locus
    T4k = T(T >= 4000 & T <= 7000); % formular for x depends on CT
    T7k = T(T > 7000 & T <= 25000);
    % x, y coordinates
    size4k = size(T4k); % for defining size of xd
    size7k = size(T7k);
    xd(1:size4k(2)) = 0.244063 + 0.09911.*10.^3./T4k ...
        + 2.9678.*10.^6./T4k.^2-4.6070.*10.^9./T4k.^3;
    xd(size4k(2)+1:size7k(2)+size4k(2))...
        = 0.237040 + 0.24748.*10.^3./T7k ...
        + 1.9018.*10.^6./T7k.^2-2.0064.*10.^9./T7k.^3;
    yd = -3.*xd.^2+2.87.*xd-0.275;
    
    ud = 4.*xd ./ (-2.*xd + 12.*yd + 3);
    vd = 6.*yd ./ (-2.*xd + 12.*yd + 3);
    
    % plot daylight locus
    plot(ud.*1000,1000-(vd.*1000),'Color',plotcolor,'Linewidth',1.25);
    text(ud(end)*1000,1000-(vd(end)*1000),'Daylight locus  ','FontSize',8,'HorizontalAlignment','right', 'Color', plotcolor);
end

% WHITE POINT PLOT
if strcmp(p.Results.WhitePoints,'') == 0
        
    if ~iscell(p.Results.WhitePoints)
        wp = {p.Results.WhitePoints};
    else
        wp = p.Results.WhitePoints;
    end

    for k = 1:size(wp,1)
        [~,WP] = ciewhitepoint(wp{k});
        wpuv = ciexy2uv(WP(1),WP(2));
        WP(1:2) = wpuv;
        plot(WP(1)*1000,1000-WP(2)*1000,p.Results.Marker,'Color',plotcolor,'MarkerSize',p.Results.MarkerSize,'Linewidth',1.25);
        text(WP(1)*1000+15,1000-WP(2)*1000,wp{k},...
            'FontSize',p.Results.FontSize,'HorizontalAlignment','left', 'Color', plotcolor);
    end
end

% Info text points - wavelength
%[C,IA,IB]=intersect(WL,[400 460 470 480 490 520 540 560 580 600 620 700]);
%text(nciex(IA),nciey(IA),num2str(WL(IA).'));

% set correct axis labels
axis on;
axis([p.Results.zoom(1) p.Results.zoom(2) 1-p.Results.zoom(4) 1-p.Results.zoom(3)].*1000);
set(gca,'XTickLabel',get(gca,'XTick')/(size(rgb,2)-1));
set(gca,'YTickLabel',1-get(gca,'YTick')/(size(rgb,1)-1));
% title
title('CIE 1960 Uniform Chromaticity');
xlabel('u');
ylabel('v');


% get number of points
poi = size(plot_u);
poi = poi(2);
% loop for legend entrys
marker(1:poi) = NaN;
%legendentry(1:poi) = {};
%for l = 1:poi
if isempty(p.Results.MarkerColor)
    hold all
    for j = 1:max(size(us))
        marker(j) = plot(us(j).*1000,1000-(vs(j).*1000),p.Results.Marker,'markersize',p.Results.MarkerSize,'Linewidth',1.25);
    end
else
    for j= 1:max(size(us))
        marker(j) = plot(us(j).*1000,1000-(vs(j).*1000),p.Results.Marker,'markersize',p.Results.MarkerSize,'Linewidth',1.25,'Color',clr(j,:));
    end
end


if strcmp(p.Results.LegendMode,'extended')
    
    if strcmp(p.Results.CCTMethod,'Robertson')
        if strcmp(p.Results.Warning,'off')
            Tc = RobertsonCCT('u',us,'v',vs);
        else
            Tc = RobertsonCCT('u',us,'v',vs,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'Hernandez')
        if strcmp(p.Results.Warning,'off')
            Tc = HernandezCCT('u',us,'v',vs);
        else
            Tc = HernandezCCT('u',us,'v',vs,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'exact')
        if strcmp(p.Results.Warning,'off')
            Tc = round(CCT('u',us,'v',vs));
        else
            Tc = round(CCT('u',us,'v',vs,'warning','off'));
        end
    end
    
    for Leg = 1:max(size(us))
        legendentry{Leg} = ...
            ['u = ',num2str(us(Leg)),'   v = ',num2str(us(Leg)),'   CCT: ',num2str(Tc(Leg)),' K'];
    end
    
elseif strcmp(p.Results.LegendMode,'on')
    
    for Leg = 1:max(size(us))
        legendentry{Leg} = ...
            ['u = ',num2str(us(Leg)),'   v = ',num2str(vs(Leg))];
    end
    
elseif strcmp(p.Results.LegendMode,'off')
    
end

if  strcmp(p.Results.LegendMode,'on')==1 || strcmp(p.Results.LegendMode,'extended')==1
    L = legend(marker,legendentry);
    if strcmp(p.Results.Background,'black') == 1
        L.TextColor = [1 1 1];
    end
end

hold off

end



