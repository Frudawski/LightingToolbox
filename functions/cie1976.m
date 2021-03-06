% CIE 1976 uniform u' & v' chromaticty
%
% plot u,v coordinates in CIE 1976 u',v' chromaticty diagram.
%
% usage: cie1976(u,v)
%
% optional parameters:
% usage: cie1976(u,v,parameter,value,...)
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
% See: https://www.frudawski.de/plotcieuv_


function cie1976(var1,var2,varargin)

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
wp = {'A','B','C','D50','D55','D65','D75','D93','E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'};
addParameter(p,'WhitePoints','',@(f) (sum(ismember(f,wp)) > 0 || iscell(f)))
Marker = {'+','o','*','.','x','s','d','^','v','>','<','p','h','square','diamond','pentagram','hexagram'};
addParameter(p,'Marker','+',@(f) any(validatestring(f,Marker)))
addParameter(p,'FontSize',8,@isscalar)
addParameter(p,'input','uv',@(f) ismember(f,{'xy','uv'}))
addParameter(p,'zoom',[0 0.65 0 0.60],@isvector)
addParameter(p,'Warning','on',@(f) ismember(f,{'on','off'}))
parse(p,var1,var2,varargin{:})

%p.Results

if strcmp(p.Results.input,'uv')
    us = p.Results.var1;
    vs = p.Results.var2;
elseif strcmp(p.Results.input,'xy')
    [us,vs] = ciexy2uv(p.Results.var1,p.Results.var2);
    vs = vs.*1.5;
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

if strcmp(p.Results.Planck,'on')
    % Approximation of planckian locus - valid for: 1000 K < T < 15000 K
    T = linspace(1,1000000,1000000);
    u_T = (0.860117757+1.54118254.*10^-4.*T+1.28641212.*10^-7.*T.^2)./(1+8.42420235.*10^-4.*T+7.08145163.*10.^-7.*T.^2);
    v_T = (0.317398726+4.22806245.*10^-5.*T+4.20481691.*10^-8.*T.^2)./(1-2.89741816.*10^-5.*T+1.61456053.*10.^-7.*T.^2);
    v_T = v_T.*1.5;
elseif strcmp(p.Results.Planck,'exact') %  slow
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
    v_T = 9.*y ./ (-2.*x + 12.*y + 3);
end

Tinfo = [];
% add CCTinfo of u,v in Tinfo if wanted
if strcmp(p.Results.CCT,'value') == 1 || strcmp(p.Results.CCT,'range') == 1 || ~isempty(p.Results.IsoTempLines)
    if strcmp(p.Results.CCTMethod,'Robertson') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = RobertsonCCT('u',us,'v',vs./1.5);
        else
            Tc = RobertsonCCT('u',us,'v',vs./1.5,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'Hernandez') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = HernandezCCT('u',us,'v',vs./1.5);
        else
            Tc = HernandezCCT('u',us,'v',vs./1.5,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'exact') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = round(CCT('u',us,'v',vs./1.5));
        else
            Tc = round(CCT('u',us,'v',vs./1.5,'warning','off'))';
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
    v_Tinfo = v_Tinfo.*1.5;
elseif strcmp(p.Results.Planck,'exact')
    [~,~,~,~,u_Tinfo,v_Tinfo] = planck(Tinfo,[360 830]);
    v_Tinfo = v_Tinfo.*1.5;
end



% color diagram
d = 0:.001:1;
[u,v] = meshgrid(d,d);
v = flipud(v);
v = v;
[x,y] = cieuv2xy(u,v./1.5);
z = ones(size(x))-x-y;

data = cat(3,x,y,z);
xyz = reshape(data,[size(data,1)*size(data,2),3]);
srgb = xyz2srgb(xyz,'D65');
rgb = reshape(srgb,[size(data,1),size(data,2),3]);
X=xFcn./sum([xFcn; yFcn; zFcn]);
Y=yFcn./sum([xFcn; yFcn; zFcn]);
Z=zFcn./sum([xFcn; yFcn; zFcn]);
cieu=4.*X./(X+15.*Y+3.*Z);
ciev=9.*Y./(X+15.*Y+3.*Z);
ncieu=cieu*size(rgb,2);
nciev=size(rgb,1)-ciev*size(rgb,1);

% OCTAVE code
if exist('OCTAVE_VERSION', 'builtin')
  
poly = [259.158576051780	623.989409950380	601.077045274027	599.734332974289	598.328555344570	596.841182900352	595.257897853673	593.567833414824	591.766713272473	589.862897169405	587.863527509523	585.775200917962	583.603951890034	581.349376088146	574.054124610051	571.444117577344	568.743119661924	565.948912845114	563.063920272949	560.092783693516	557.042067766827	553.919068367320	550.715298401437	547.415322675851	544.003685423506	540.464835539907	536.791434157134	532.985198390784	529.043210936805	524.960820386903	520.731664694045	516.349282419423	511.807891492966	502.231966236425	497.193851626016	491.988978533392	486.621284269267	481.096506117446	475.420138528427	469.597478891330	463.640433218327	457.552183261006	451.324225584437	444.947656431319	438.413135903827	431.712648584609	424.873459599865	417.935896259888	410.937559197919	403.913614952135	396.889552019934	389.853501701600	382.783200688751	375.656972846445	368.453636616971	361.165982574976	353.824247941124	346.462596615717	339.113447788994	331.807664357347	324.561930142635	317.376884935100	310.257439772034	303.207355396231	296.229343857023	289.327598980265	282.509017361831	275.778953400125	269.141796686382	262.601069998189	256.158414980187	249.814081666210	243.569425128931	237.426321546000	231.387141691074	225.453472723415	219.625338457941	213.902934732876	208.286353928716	202.775604050929	197.370476338124	192.069507016260	186.871167213688	181.774341039731	176.778307493034	171.882719046875	167.085938570734	162.385579089885	157.779190331980	153.264268053982	148.842691772801	144.509748252610	140.263089389901	136.101466902335	132.024533468580	128.030364383158	124.114665184384	120.274726373416	116.508513165917	112.814539958729	109.192987109282	105.638403195997	102.148583755191	98.7208856767979	95.3522682132359	92.0394097154635	88.7800929593346	85.5727882632779	82.4159909353410	79.3082195985349	76.2477554629797	73.2306123545526	70.2518557394019	67.3065309210033	64.3896012012063	61.5002120510139	58.6361868338317	55.7901279537501	52.9538577822011	50.1182122496026	47.2746382542204	44.4295349702814	41.5966155330302	38.7913778896502	36.0313480538009	33.3258999561776	30.6769637109602	28.0919207681785	25.5774529564322	23.1396253107127	20.7821270079480	18.5079440780101	16.3245703377624	14.2436644294243	12.2814318239312	10.4549148938852	8.77076647246264	7.23461037717489	5.85390490948483	4.63789560213728	3.60411553334497	2.76497244301846	2.12210624881169	1.67558009371642	1.42389758179232	1.37503727311552	1.54550789892199	1.94518827381614	2.58250159004681	3.46275084276108	4.58918671360821	5.97647046410250	7.64280090750160	9.60562652867255	11.8820251937984	14.4849684633455	17.4190192732778	20.6846641643163	24.2764086659335	28.1821168244335	32.3735379838185	36.8504394251921	41.6345320344331	46.7430837892714	52.1883108642766	57.9565038554620	63.9779740921007	70.1815942801938	76.5041788762653	82.8917624248010	89.3099772414055	95.7364356273258	102.142874575093	108.501453026081	114.785426081343	120.956711116808	126.991985078261	132.887339478323	138.638620533129	144.241992410077	149.701063837499	154.969847736035	159.989279765911	164.722228670340	169.148942613436	173.278355626184	177.165995501624	180.863592227011	184.413343111804	187.848993288591	191.189342646309	194.430323499300	197.565636934851	200.587831762279	203.488247488439	206.262613624611	208.923052012609	211.482259647845	213.950167138697	216.333999193254	218.633664435024	220.841343543029	222.951971568027	224.962224200596	226.870259130112	228.675292458450	230.381386296201	231.995787112359	233.527244738179	234.985680247234	236.379194547138	237.709999817287	238.979757483089	240.190240907612	241.342904010657	242.444432180839	243.498492442561	244.501081283460	245.446949217636	246.329252172406	247.145049254034	247.901435580060	248.604936945009	249.262051288347	249.879121129145	250.459303527514	251.005984374569	251.524172618032	252.014086116698	252.469298698374	252.870091270820	253.205119160322	253.477625352459	253.700373448144	253.898793527360	254.094405688996	254.280550751078	254.453557264593	254.610708755400	254.751030912760	254.890265291894	255.042215092429	255.203692733761	255.366927218106	255.518203582927	255.652666503752	255.773386155069	255.875208010749	255.956223360853	256.019804823082	256.072846431697	256.119551203036	256.162183596387	256.203724372035	256.247960848287	256.305825809011	256.383297801955	256.474441500979	256.570105373257	256.658019734102	256.731360244903	256.792991250608	256.844311701284	256.887870328359	256.929108301477	256.970191145233	257.009232796867	257.045968317965	257.082330266776	257.122059270235	257.174149023713	257.243915647892	257.330787126045	257.431325553127	257.536179845445	257.636512245908	257.733300378188	257.826138560095	257.916551155902	258.009644729179	258.108597811093	258.210877878792	258.316351704938	258.424876388577	258.536377735894	258.654068915703	258.779374218881	258.908897918688	259.037621919186
983.417018318796	493.998411492570	490.561556791104	490.361357460175	490.152035826514	489.930592198847	489.694698495755	489.442578158705	489.173565296501	488.888985522373	488.589928412801	488.277399828536	487.952319587629	487.614647080900	486.521787913666	486.130853649865	485.726348129492	485.307991687429	484.876229471579	484.431825674649	483.975820507518	483.509238958566	483.030790050164	482.538269321751	482.029453657831	481.502092801839	480.955232992320	480.388839536060	479.801948614293	479.193405310600	478.561856395595	477.906211190362	477.226003657316	475.790989582220	475.036299542683	474.256855819816	473.453333814057	472.627071969375	471.779326647575	470.911283926529	470.025040336141	469.120488740952	468.195439868284	467.247724505251	466.275179592435	465.276205416431	464.255298800769	463.218972615276	462.173294858857	461.123936331864	460.075007841382	459.024419664003	457.968338183911	456.903051712787	455.824952974781	454.732593791874	453.631096191869	452.526557823152	451.424756755142	450.331185504578	449.248801261830	448.177080216004	447.116008131980	446.065439194000	445.025107164728	443.995473302940	442.977783624855	441.972764941595	440.981002181708	440.002952612185	439.038774335073	438.088767333516	437.153576339877	436.233908688585	435.330532481874	434.443909309604	433.574119554808	432.721374437328	431.885868077708	431.067781292363	430.267285250678	429.484296271789	428.718666565851	427.970313179484	427.239215280754	426.525529121104	425.829224959682	425.150051937370	424.487756669450	423.842085608324	423.213532468396	422.601856583099	422.007247983145	421.430069559904	420.870828451542	420.329738920045	419.806626691807	419.301618151270	418.814959136323	418.346998857006	417.898305349776	417.468776148516	417.059032367712	416.669680088978	416.301322793358	415.954367539355	415.629191124465	415.326424643817	415.046768795170	414.791000798019	414.559932362605	414.353909627871	414.173120275823	414.017842842296	413.888446594048	413.787172075683	413.715141638211	413.671183022734	413.654168033661	413.663005086984	413.699372506584	413.770540359945	413.884303644896	414.049123292575	414.274207375745	414.564926127717	414.933969064731	415.403764172952	415.999368782347	416.749147560241	417.676535879646	418.794138734102	420.118189961284	421.666125024149	423.456172527195	425.513610616091	427.854471561748	430.482116699114	433.397490315852	436.598027127004	440.095234423601	443.907668824464	448.040473294879	452.499828272017	457.293607752489	462.434234901058	467.966602381953	473.945560122341	480.417831012332	487.417515310895	494.948612441003	503.015585446840	511.642062167602	520.855687612994	530.690043604651	541.164186742633	552.259661753586	563.948935543257	576.190001171683	588.925683564761	602.082943986268	615.609622391123	629.462935359151	643.594015576938	657.948595591708	672.439919600887	686.952829322166	701.403709768824	715.731797979007	729.898694817382	743.880732073185	757.605660105543	770.982029240992	783.923379818004	796.349136539703	808.194391037343	819.454020507020	830.141970889812	840.271986748727	849.858225551265	858.926678818980	867.427845202617	875.292725327709	882.484939152914	888.991874022107	894.839694429727	900.139546031529	905.003683099830	909.527564030717	913.793624161074	917.848758136550	921.695649612752	925.340824388110	928.788863470930	932.042576941477	935.109523548520	938.014281775190	940.781197562409	943.431463844300	945.983471353292	948.447155880518	950.816085269973	953.083547610987	955.244607172882	957.295894746095	959.237013209901	961.075215375951	962.820928784258	964.486059336975	966.084102007596	967.628351993276	969.117024595118	970.541851838232	971.893840379422	973.162914359319	974.347726529365	975.456626173005	976.492579005552	977.457874376023	978.354020846426	979.182247739538	979.946378750590	980.650450849186	981.297595362551	981.889954069255	982.426104206946	982.909504946675	983.346513167445	983.740404159590	984.091057536201	984.386445556582	984.614913790383	984.778240796078	984.885766690811	984.957573331809	985.013636625472	985.052245414644	985.072237475106	985.073944425142	985.059763694323	985.049712351836	985.059466357411	985.084301952310	985.114596557357	985.133410385536	985.135790272118	985.131354577126	985.118386920341	985.095128099957	985.059144227997	985.004661057099	984.929432679839	984.836991951449	984.736102180433	984.645350734095	984.590552405839	984.577299125193	984.598438755768	984.637637962096	984.667766832852	984.665016807043	984.632129912314	984.575198898191	984.507519534766	984.453581576291	984.435649488770	984.448149220493	984.478805837316	984.507673449547	984.506973171811	984.448866880185	984.332439742296	984.167156275426	983.973810552914	983.794457887753	983.674375525189	983.615619707658	983.610484261578	983.638580955053	983.664102504368	983.662744924869	983.644485517935	983.613054467950	983.575546749441	983.543781949187	983.519623002590	983.494340834500	983.468379450966	983.442345462122];

mask = poly2mask(poly(1,:),poly(2,:),1001,1001);
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
        Thandle = title('CIE 1976 Chromaticity');
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
        Thandle = title('CIE 1976 Chromaticity');
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
warning('off','MATLAB:polyshape:repairedBySimplify') % turn simplyfying warning off
poly = polyshape({[1 1000 1000 1 1],ncieu},{[1 1 1000 1000 1],nciev});
warning('on','MATLAB:polyshape:repairedBySimplify') % turn simplyfying warning on again


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
        Thandle = title('CIE 1976 Chromaticity');
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
        Thandle = title('CIE 1976 Chromaticity');
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
        diff_v_T = diff(v_T./1.5);
        % derivation from points of interest
        du = diff_u_T(Tinfo);
        dv = diff_v_T(Tinfo)./1.5;
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
    vd = 9.*yd ./ (-2.*xd + 12.*yd + 3);
    
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
        [wpu,wpv] = ciexy2uv(WP(1),WP(2));
        WP = [wpu wpv 1-wpu-wpv];
        WP(2) = WP(2).*1.5;
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
title('CIE 1976 Uniform Chromaticity');
xlabel('u''');
ylabel('v''');


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



