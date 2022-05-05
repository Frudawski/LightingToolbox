% CIE 1931 x & y Chromaticty
%
% plot x,y coordinates in CIE 1931 x,y Chromaticty diagram.
%
% usage: cie1931(x,y)
%
% optional parameters:
% usage: cie1931(x,y,parameter,value)
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see license.
%
% NOTE: for use in octave the image package is recommended.
%
% parameters:
% input: 'uv','xy' (default: 'xy')
%       input data for plot. u,v coordinates will be first transformed to
%       x,y coordinates.
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
% WhitePoints: plots white points:
%               'A','B','C','D50','D55','D65','D75','D93'
%               'E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'
% Color: 'on','off'
%       plot the cie1931 diagram in color or grayscale (default: 'on')
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
% zoom: numerical vector [x1 x2 y1 y2]
%       Zooms in specified region (default: [0.0  0.8  0.0  0.9])

% Author: Frederic Rudawski
% Date: 05.05.2016 - last updated: 31.10.2019
% See: https://www.frudawski.de/plotciexy

function cie1931(x,y,varargin)

cla reset

if ~exist('x','var')
    x = NaN;
end
if ~exist('y','var')
    y = NaN;
end

p = inputParser;
validVar = @(f) isnumeric(f) || isvector(f);
addRequired(p,'x',validVar);
addRequired(p,'y',validVar);
addParameter(p,'Planck','off',@ischar)
addParameter(p,'DaylightLocus','off',@ischar)
addParameter(p,'Color','on',@ischar)
addParameter(p,'MarkerColor',[],@(f) (ismatrix(f) && size(f,1) == max(size(f))) || isvector(f))
addParameter(p,'Grid','on',@ischar)
addParameter(p,'MarkerSize',10,@isnumeric)
addParameter(p,'IsoTempLines',[],@isvector);
LegendMode = {'off','on','extended'};
addParameter(p,'LegendMode','off',@(f) any(validatestring(f,LegendMode)))
CCTOptions = {'value','range','off'};
addParameter(p,'CCT','off',@(f) any(validatestring(f,CCTOptions)))
CCTMethod = {'Robertson','Hernandez','exact'};
addParameter(p,'CCTMethod','Robertson',@(f) any(validatestring(f,CCTMethod)))
BackgroundOptions = {'black','white'};
addParameter(p,'Background','white',@(f) any(validatestring(f,BackgroundOptions)))
WhitePoints = {'A','B','C','D50','D55','D65','D75','D93','E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'};
addParameter(p,'WhitePoints','',@(f) (sum(ismember(f,WhitePoints)) > 0 || iscell(f)))
Marker = {'+','o','*','.','x','s','d','^','v','>','<','p','h','square','diamond','pentagram','hexagram'};
addParameter(p,'Marker','+',@(f) any(validatestring(f,Marker)))
addParameter(p,'FontSize',8,@isscalar)
addParameter(p,'input','xy',@(f) ismember(f,{'xy','uv'}))
addParameter(p,'zoom',[0 0.8 0 0.9],@isvector)
addParameter(p,'Warning','on',@(f) ismember(f,{'on','off'}))
addParameter(p,'Info','')
addParameter(p,'InfoColor',[])
parse(p,x,y,varargin{:})

%p.Results

if strcmp(p.Results.input,'xy')
    xs = p.Results.x;
    ys = p.Results.y;
elseif strcmp(p.Results.input,'uv')
    [xs,ys] = cieuv2xy(p.Results.x,p.Results.y);
end
if size(xs,2) > xs(1)
    xs = xs';
end
if size(ys,2) > ys(1)
    ys = ys';
end

LegendMode = p.Results.LegendMode;

clr = p.Results.MarkerColor;
if max(size(xs)) ~= size(clr,1)
    clr = repmat(clr,max(size(xs)),1);
end


% whitepoints
try
    W = zeros(21,1);
    [w,~] = ismember({'A','B','C','D50','D55','D65','D75','D93','E','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12'},p.Results.WhitePoints);
    W(w) = 1;
catch
end

% Color depending if color background is present or not - for daylight locus
if strcmp(p.Results.Color,'on') == 0
    plotcolor = [0.66 0.66 0.66]; % a nice gray
else
    plotcolor = [1 1 1]; % white
end

% CIE tristimulus curves
WL = 360:830;
xFcn = ciespec(WL,'x');
yFcn = ciespec(WL,'y');
zFcn = ciespec(WL,'z');

% Approximation of planckian locus - valid for: 1000 K < T < 15000 K
T = linspace(1,1000000,1000000);
u_T = (0.860117757+1.54118254.*10^-4.*T+1.28641212.*10^-7.*T.^2)./(1+8.42420235.*10^-4.*T+7.08145163.*10.^-7.*T.^2);
v_T = (0.317398726+4.22806245.*10^-5.*T+4.20481691.*10^-8.*T.^2)./(1-2.89741816.*10^-5.*T+1.61456053.*10.^-7.*T.^2);

Tinfo = [];
% add CCTinfo of x,y in Tinfo if wanted
if strcmp(p.Results.CCT,'value') == 1 || strcmp(p.Results.CCT,'range') == 1 || ~isempty(p.Results.IsoTempLines)
    
    if strcmp(p.Results.CCTMethod,'Robertson') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = RobertsonCCT('x',xs,'y',ys)';
        else
            Tc = RobertsonCCT('x',xs,'y',ys,'warning','off')';
        end
    elseif strcmp(p.Results.CCTMethod,'Hernandez') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = HernandezCCT('x',xs,'y',ys)';
        else
            Tc = HernandezCCT('x',xs,'y',ys,'warning','off')';
        end
    elseif strcmp(p.Results.CCTMethod,'exact') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = round(CCT('x',xs,'y',ys));
        else
            Tc = round(CCT('x',xs,'y',ys,'warning','off'))';
        end
    end

    Tinfo = Tc;
    Tinfo(isnan(Tinfo)) = [];
    Tinfo(Tinfo==0) = [];
    
    if strcmp(p.Results.CCT,'range') == 1
        Tinfo = [min(Tinfo) max(Tinfo)];
    end
    
    if ~isempty(p.Results.IsoTempLines)
        Tinfo = [Tinfo p.Results.IsoTempLines];
    end
end

% CT Info Values
u_Tinfo = (0.860117757+1.54118254.*10^-4.*Tinfo+1.28641212.*10^-7.*Tinfo.^2)./(1+8.42420235.*10^-4.*Tinfo+7.08145163.*10.^-7.*Tinfo.^2);
v_Tinfo = (0.317398726+4.22806245.*10^-5.*Tinfo+4.20481691.*10^-8.*Tinfo.^2)./(1-2.89741816.*10^-5.*Tinfo+1.61456053.*10.^-7.*Tinfo.^2);

%[~,~,~,~,u_Tinfo,v_Tinfo] = planck(Tinfo');

% transform u and v to x and y
x_T = 3.*u_T ./ (2.*u_T-8.*v_T+4);
y_T = 2.*v_T ./ (2.*u_T-8.*v_T+4);
x_Tinfo = 3.*u_Tinfo ./ (2.*u_Tinfo-8.*v_Tinfo+4);
y_Tinfo = 2.*v_Tinfo ./ (2.*u_Tinfo-8.*v_Tinfo+4);

step = 0.001;
% colour diagram
v = 0:step:1;
[x,y] = meshgrid(v,v);
y = flipud(y);
z = (1-x-y);

% rgb image
data = cat(3,x,y,z);
xyz  = reshape(data,[size(data,1)*size(data,2),3]);
srgb = xyz2srgb(xyz,'D65');
rgb  = reshape(srgb,[size(data,1),size(data,2),3]);

ciex=xFcn./sum([xFcn; yFcn; zFcn],1);
ciey=yFcn./sum([xFcn; yFcn; zFcn]);

% OCTAVE code
if exist('OCTAVE_VERSION', 'builtin')
  
poly = [175.560231755724,175.482527710407,175.400022356684,175.317049458602,175.236739463886,175.161218506262,175.087794161125,175.014938867913,174.945189438668,174.880124778842,174.820607679635,174.770252213918,174.722036673711,174.665367950954,174.595050265963,174.509720869160,174.409249351858,174.308458223786,174.221772058161,174.155594353273,174.112234426342,174.088307167410,174.072590901536,174.057024292786,174.036270609960,174.007917515889,173.971929754687,173.931678596305,173.889035777100,173.845256167111,173.800772620828,173.754438047173,173.705352749050,173.655189400453,173.606018216907,173.559906527214,173.514449742224,173.468498200431,173.423666225833,173.379996016857,173.336865480781,173.291285658761,173.237920453112,173.174238776235,173.101012208515,173.020965455495,172.934256850859,172.842756135349,172.751152603347,172.662105581222,172.576550848802,172.489477381802,172.395603384173,172.296001755019,172.192360361959,172.086630755248,171.982445938222,171.871019445674,171.741213705737,171.587239364847,171.407433863109,171.206113461594,170.992574221804,170.770596367909,170.540661923529,170.300988779736,170.050158668149,169.785868750870,169.504602532254,169.202921712127,168.877520670989,168.524660344249,168.146145461531,167.746219826537,167.328325744596,166.895290352080,166.446327135003,165.976758230656,165.483299011466,164.962663720259,164.411756375275,163.828432761608,163.209895954422,162.552139506799,161.851438065089,161.104579580275,160.309595019389,159.465945758018,158.573111075907,157.631165578262,156.640932577307,155.605095582748,154.524612494681,153.397229336432,152.219236228253,150.985408375971,149.690564758713,148.336817067949,146.928226501376,145.468371778522,143.960396039604,142.405090190101,140.795646664590,139.120682426571,137.363757935118,135.502671199611,133.509340955908,131.370635235575,129.085786557187,126.662156977009,124.118476727786,121.468583913083,118.701276452039,115.807358768397,112.776054847610,109.594323615610,106.260735317928,102.775862946510,99.1275999016733,95.3040562149913,91.2935070022712,87.0824317270964,82.6795344819710,78.1159857333012,73.4372599047498,68.7059212910555,63.9930236869067,59.3158279806231,54.6665228761952,50.0314970581197,45.3907346747777,40.7573153360254,36.1951091539399,31.7564703789208,27.4941905347843,23.4599425470795,19.7046363029537,16.2684712672383,13.1830411530808,10.4757006831256,8.16802800466744,6.28485157264002,4.87542999269080,3.98242535235287,3.63638422545277,3.85852090032154,4.64571323255553,6.01091307169603,7.98839582865335,10.6032905542590,13.8702460850112,17.7661242058630,22.2442056947439,27.2732624201700,32.8203575222175,38.8518024032043,45.3279848294139,52.1766909052169,59.3255333519871,66.7158860270346,74.3024247733750,82.0533952358066,89.9417395853361,97.9397501105561,106.021107332241,114.160719606680,122.347367033701,130.545668138394,138.702349214235,146.773215738364,154.722061215713,162.535424655456,170.237195478923,177.849528011742,185.390757399363,192.876097877721,200.308798144942,207.689989666574,215.029550005768,222.336603758204,229.619672649640,236.884720598308,244.132556473824,251.363408870738,258.577508455251,265.775084971184,272.957603510930,280.128942481592,287.292409080260,294.450280894396,301.603799395751,308.759923092657,315.914394448992,323.066265382129,330.215545356897,337.363332850857,344.513198355454,351.664411296820,358.813686684303,365.959357349119,373.101543868457,380.243835464065,387.378977958644,394.506548796889,401.625918831181,408.736255706423,415.835774705559,422.920926709796,429.988626512439,437.036422593891,444.062463582333,451.064940950767,458.040665647423,464.986332977633,471.898743899668,478.774791157584,485.611587052091,492.404982334296,499.150668334298,505.845283794022,512.486366781797,519.072510400636,525.600488985451,532.065599161240,538.462761902554,544.786505594834,551.031050212293,557.192906096034,563.269312373157,569.256824124726,575.151311365165,580.952605160923,586.650186890891,592.224800070941,597.658162105241,602.932785575716,608.035111132286,612.976999570812,617.778725585283,622.459295078623,627.036599763873,631.520942860260,635.899819576266,640.156159547881,644.272960657274,648.233106013639,652.028235717930,655.669179249501,659.166134692712,662.528222053688,665.763576238097,668.874143663558,671.858667147589,674.719511111516,677.458888275166,680.078849721707,682.581574187010,687.250454556694,689.426303027996,691.503972961702,693.489634972634,695.388638101952,697.205569778691,698.943910385795,700.606060606061,702.192588540645,703.708691019457,705.162853423690,706.563246693848,707.917791621664,709.230985413973,710.500394495371,711.724146175049,712.901231129850,714.031597116994,715.117053483185,716.159198599114,717.158613642121,718.116142602162,719.032941629744,719.911552942295,720.752706639807,721.554522486917,722.314915560207,723.031602573095,723.701916040434,724.328018926374,724.914405134210,725.466776098186,725.992317541613,734.689958783312;994.706162988552,994.713660894085,994.721357956891,994.729031205765,994.736506077245,994.743654084894,994.753155472340,994.764429671332,994.773843088920,994.779215059821,994.779399062061,994.771332783279,994.762479822764,994.763839336752,994.781677747461,994.818360229856,994.873239102319,994.932407479759,994.982968463703,995.018555089107,995.036274018547,995.036399934706,995.027457381772,995.017963860905,995.014038571378,995.019451377005,995.035916904029,995.056593350570,995.073951489250,995.083906929093,995.084588094627,995.075146304647,995.062901628905,995.056209016679,995.060104728891,995.076797422692,995.104553286877,995.135420861164,995.163687877790,995.186661676154,995.203256552733,995.214154351855,995.221112067783,995.224869200165,995.225969325509,995.224949638141,995.218852828219,995.209207050933,995.201237900737,995.197915643678,995.200698080279,995.204745635599,995.203881411065,995.197370526529,995.185114785980,995.167475781960,995.144989831436,995.111468078488,995.060667543383,994.989655793161,994.897829026251,994.788742223302,994.666092237984,994.529878752502,994.379030066525,994.211495003529,994.026104892109,993.823192511841,993.601963093122,993.361294081613,993.099756112070,992.815956111976,992.509320333676,992.179181511579,991.824600324999,991.444393639181,991.035599582243,990.598283773131,990.135319027654,989.649256458518,989.142441723236,988.615134384036,988.062614185432,987.479970082415,986.862692904566,986.206641178268,985.508621833666,984.767935356275,983.984843584411,983.160129028491,982.295195009109,981.391393475993,980.444302195460,979.446266470143,978.388288979098,977.259806708357,976.049669804242,974.752601568272,973.364814142312,971.881566670296,970.297029702970,968.606416013770,966.786845393740,964.799427173198,962.596909556366,960.120878527872,957.307609989474,954.124024777453,950.550189340265,946.574080226950,942.197486626260,937.412327933447,932.169556467651,926.419292027159,920.104177104039,913.157488816906,905.513927796280,897.136261181848,887.992966962805,878.055136745342,867.297957513010,855.683417319768,843.134041922760,829.579513523496,814.968119472881,799.276782271898,782.532394594939,764.746259758755,745.904409252975,725.998196780198,705.024035393713,683.018919160006,660.100065586058,636.402306753657,612.078671719171,587.296520906480,562.244111347926,537.045492011394,511.792931587720,486.595754839788,461.576929488248,436.931543678384,412.883561955398,389.552502361326,366.988617249196,345.176848874598,324.101541400747,303.879938663794,284.658483744169,266.587057348444,249.813571961223,234.387845565804,220.370076799229,207.896497168737,197.074327010360,187.983978638184,180.609199543919,174.836457417464,170.574223703449,167.726260716132,166.196908659772,165.909685495056,166.711081104042,168.407333501259,170.821813368901,173.793040218811,177.229600436131,181.072147090596,185.225617405053,189.605393452189,194.136454574351,198.761519586389,203.481457754588,208.313420940084,213.272227179319,218.370783636923,223.600583949380,228.945201339676,234.404903939389,239.980000259164,245.670910097256,251.475534825225,257.386008318627,263.394418637555,269.493398090253,275.676075070194,281.937813583210,288.275265430807,294.683726111717,301.157977977619,307.692237628426,314.287939393260,320.936520009071,327.632602031251,334.371974582851,341.151709860312,347.971790782156,354.827825754602,361.712663462247,368.620919100151,375.549140203339,382.497847826295,389.458197544984,396.428663208403,403.407578037438,410.393131140469,417.382031943024,424.369311676812,431.351108729196,438.324225950633,445.286097191470,452.233955870555,459.163370835598,466.069946943169,472.949430780738,479.797692788544,486.611339038440,493.385075579074,500.112659561694,506.788821892459,513.409211939143,519.971387823553,526.472626024471,532.908636296091,539.274746159158,545.565885431164,551.775497090026,557.900860515810,563.941938263326,569.898026394917,575.767765075095,581.553120183463,587.241578807904,592.810471414533,598.238065027720,603.503366427023,608.590848292292,613.513842668302,618.294243171496,622.952713619261,627.508854781582,631.973989178209,636.334597566733,640.572275696216,644.668630228407,648.605083694978,652.372039251577,655.981705155584,659.446774587767,662.779007392787,665.989348845240,669.081446997513,672.052925700096,674.904817995745,677.637923311367,680.252782931354,682.751294037697,687.414036004403,689.585988714087,691.657739443344,693.634309182444,695.521444800351,697.324927296032,699.049575021004,700.699300699301,702.275488137007,703.782881945529,705.229707913761,706.623846826792,707.972891065160,709.281377834679,710.547058796831,711.767895201045,712.942679636290,714.071126454350,715.154893871224,716.195550818326,717.193588069069,718.149743437344,719.065048481346,719.941921793272,720.781040176606,721.580485314730,722.338129632276,723.051642251658,723.718163755774,724.339925079430,724.921815945101,725.470022021751,725.992317541613,734.689958783312];
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
if strcmp(p.Results.Color,'on') == 1
    % Color
    % displayable color gammut
    % black background ?
    if strcmp(p.Results.Background,'black')
        % black background
        h = image(rgb.*mask);
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
        Thandle = title('CIE 1931 Chromaticity');
        set(Thandle,'color',[1 1 1]);
    else
        %imshow(rgb.*mask+~mask);
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard
        image(rgb)
        hold on
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
        Thandle = title('CIE 1931 Chromaticity');
        Thandle.Color = [1 1 1];

    else
        % polygon of mask
        image(ones(size(rgb))); % for correct y-invert axis
        hold on
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard        
    end
end
hold on;
 
% MATLAB code
else
 
% polygon of mask
warning('off','MATLAB:polyshape:repairedBySimplify')
poly = polyshape({[1 1000 1000 1 1],ciex.*1000},{[1 1 1000 1000 1],(1-ciey).*1000});
warning('on','MATLAB:polyshape:repairedBySimplify')

% show image
if strcmp(p.Results.Color,'on') == 1
    % Color
    % displayable color gammut
    % black background ?
    if strcmp(p.Results.Background,'black')
        % black background
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
        Thandle = title('CIE 1931 Chromaticity');
        Thandle.Color = [1 1 1];
    else
        %imshow(rgb.*mask+~mask);
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard
        image(rgb);
        hold on
        mask = plot(poly);
        mask.FaceAlpha = 1;
        mask.FaceColor = [1 1 1];
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
        Thandle = title('CIE 1931 Chromaticity');
        Thandle.Color = [1 1 1];

    else
        % polygon of mask
        image(ones(size(rgb))); % for correct y-invert axis
        hold on
        ax = gca;
        fig = gcf;
        set(ax,'color',[1 1 1])
        set(fig,'color',[0.95 0.95 0.95])% Matlab standard        
    end
end
hold on;

end


% Border plot coordinates
x = ciex;
y = ciey;
% connect start and end point
x(1,472) = x(1,1);
y(1,472) = y(1,1);
% Border plot
plot(x*1000,1000-(y*1000),'Color','k', 'Linewidth', 1.25);
% nm labels
%[C,IA,IB]=intersect(WL,[400 460 470 480 490 520 540 560 580 600 620 700]);
%text(nciex(IA),nciey(IA),num2str(WL(IA).'));

% GRID ON
if strcmp(p.Results.Grid,'on') == 1
    grid on
end

% DAYLIGHT LOCUS
if strcmp(p.Results.DaylightLocus,'on') == 1
    % Daylight CCT locus
    T4k = T(T >= 4000 & T <= 7000); % formular for x depends on CT
    T7k = T(T > 7000 & T <= 25000);
    % x, y coordinates
    xd(1:size(T4k,2)) = 0.244063 + 0.09911.*10.^3./T4k ...
        + 2.9678.*10.^6./T4k.^2-4.6070.*10.^9./T4k.^3;
    xd(size(T4k,2)+1:size(T7k,2)+size(T4k,2))...
        = 0.237040 + 0.24748.*10.^3./T7k ...
        + 1.9018.*10.^6./T7k.^2-2.0064.*10.^9./T7k.^3;
    
    yd = -3.*xd.^2+2.87.*xd-0.275;
    % plot daylight locus
    plot(xd.*1000,1000-(yd.*1000),'Color',plotcolor,'Linewidth',1.25);
    text(xd(end)*1000,1000-(yd(end)*1000),'Daylight locus  ','FontSize',p.Results.FontSize,'HorizontalAlignment','right', 'Color', plotcolor);
end

% PLANCIAN LOCUS
if strcmp(p.Results.Planck,'on') == 1
    % planc locus plot
    plot(x_T(1000:end).*1000,1000-(y_T(1000:end).*1000),'Color',[0 0 0], 'Linewidth', 1.5);
    % planckian locus text
    text(x_T(end)*1000,1000-(y_T(end)*1000-15),'Planckian locus  ','FontSize',p.Results.FontSize,'HorizontalAlignment','right', 'Color', 'k');
    
    % Ploting markers ISOTHERMS
    if ~isempty(p.Results.IsoTempLines) || strcmp(p.Results.CCT,'value') || strcmp(p.Results.CCT,'range')
        len = 0.05;
        Tinfo(Tinfo==0) = [];
        Tinfo(Tinfo>1000000) = [];
        % derivation from u_T and v_T
        diff_u_T = diff(u_T);
        diff_v_T = diff(v_T);
        % derivation form points of interest
        du = diff_u_T(Tinfo);
        dv = diff_v_T(Tinfo);
        % resultating slope normal
        m = -1./(dv./du);
        % random line length
        um(1:size(Tinfo,2)) = len;%0.025;
        vm = m.*um;
        

        for i = size(Tinfo,2):-1:1
            
            U = [u_Tinfo(i)+um(i) u_Tinfo(i)-um(i)];
            V = [v_Tinfo(i)+vm(i) v_Tinfo(i)-vm(i)];
            
            X = 3.*U ./ (2.*U-8.*V+4);
            Y = 2.*V ./ (2.*U-8.*V+4);
            
            % x and y are now derivated from f(x) and f(y)
            
            % get slope
            dx = X(2)-X(1);
            dy = Y(2)-Y(1);
            slope = dy/dx;
            % slope for normal to fcn
            m = slope;

            % Correct dx for uniform length
            dx = sqrt(len^2/(1+m^2));
            dy = m*dx;
            lmarker  = len+0.02;
            dxmarker = sqrt(lmarker^2/(1+m^2));
            dymarker = m*dxmarker;
            
            x = x_Tinfo(i);
            y = y_Tinfo(i);
            X = [x-dx x+dx];
            Y = [y-dy y+dy];
            Xmarker = [x-dxmarker x+dxmarker];
            Ymarker = [y-dymarker y+dymarker];
            
            % plot
            x = X.*1000;
            y = 1000-(Y.*1000);
            iso = plot(x,y,'k','Linewidth', 1);
            
            
            % numbers
            x = Xmarker.*1000;
            y = 1000-(Ymarker.*1000);
            % correct side of line
            if m >= 0
                xmarker = x(2);
                ymarker = y(2);
            else
                xmarker = x(1);
                ymarker = y(1);
            end
            
            
            CCTinfoText = [num2str(Tinfo(i)),' K'];
            text(xmarker,ymarker,CCTinfoText,...
                'FontSize',p.Results.FontSize,'HorizontalAlignment','center');
            
        end
        
    end
end

% WHITE POINT PLOT
if ~isempty(p.Results.WhitePoints)
    if strcmp(p.Results.WhitePoints,'') == 0
        
        if ~iscell(p.Results.WhitePoints)
            wp = {p.Results.WhitePoints};
        else
            wp = p.Results.WhitePoints;
        end
            
        for k = 1:numel(wp)
                [~,WP] = ciewhitepoint(wp{k});
                plot(WP(1)*1000,1000-WP(2)*1000,p.Results.Marker,'Color',plotcolor,'MarkerSize',p.Results.MarkerSize,'Linewidth',1.25);
                text(WP(1)*1000+15,1000-WP(2)*1000,wp{k},...
                    'FontSize',p.Results.FontSize,'HorizontalAlignment','left', 'Color', plotcolor);
        end
    end
end

% Info text points - wavelength
%[C,IA,IB]=intersect(WL,[400 460 470 480 490 520 540 560 580 600 620 700]);
%text(ciex(IA),ciey(IA),num2str(WL(IA).'));

% set correct axis labels
axis on;
axis equal
axis([p.Results.zoom(1) p.Results.zoom(2) 1-p.Results.zoom(4) 1-p.Results.zoom(3)].*1000);
set(gca,'XTickLabel',get(gca,'XTick')/(size(rgb,2)-1));
set(gca,'YTickLabel',1-get(gca,'YTick')/(size(rgb,1)-1));
title('CIE 1931 Chromaticity');
xlabel('x'); ylabel('y');

% plot x and y
if isempty(p.Results.MarkerColor)
    hold all
    % in loop for correct legend entries
    for m = 1:max(size(xs))
        marker(m) = plot(xs(m).*1000,1000-(ys(m).*1000),p.Results.Marker,'markersize',p.Results.MarkerSize,'Linewidth',1.25);
    end
else
    for m = 1:max(size(xs))
        marker(m) = plot(xs(m).*1000,1000-(ys(m).*1000),p.Results.Marker,'markersize',p.Results.MarkerSize,'Linewidth',1.25,'Color',clr(m,:));
    end
end

if ~iscell(p.Results.Info)
    if ~strcmp(p.Results.Info,'')
        LegendMode = 'off';
        y1 = 0.800;
        y2 = 0.850;
        x1 = 0.50;
        x2 = 0.75;
        %fill([x1 x2 x2 x1 x1].*1000,1000-[y1 y1 y2 y2 y1].*1000,[1 1 1])
        %,x2*1000,1000-(y1+(y2-y1)/2)*1000,'String',p.Results.Info,'FitBoxToText','on'
        t = annotation('textbox',[0.55 0.8 0.2 0.1],'String',p.Results.Info,'FitBoxToText','on','HorizontalAlignment','right');
        uistack(t,'top');
    end
else
    for n = 1:length(p.Results.Info)
        y1 = 0.800;
        y2 = 0.850;
        x1 = 0.50;
        x2 = 0.75;
        if ~strcmp(p.Results.Info{n},'')
            LegendMode = 'off';
            y1 = 0.800;
            y2 = 0.850;
            x1 = 0.50;
            x2 = 0.75;
            %fill([x1 x2 x2 x1 x1].*1000,1000-[y1 y1 y2 y2 y1].*1000,[1 1 1])
            %,x2*1000,1000-(y1+(y2-y1)/2)*1000,'String',p.Results.Info,'FitBoxToText','on'
            t = annotation('textbox',[0.55 0.8 0.2 0.1],'String',p.Results.Info,'FitBoxToText','on','HorizontalAlignment','right');
            uistack(t,'top');
        end
    end
end

%if strcmp(p.Results.LegendMode,'extended') == 1
switch LegendMode
    case 'extended'
    if strcmp(p.Results.CCTMethod,'Robertson') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = RobertsonCCT('x',xs,'y',ys);
        else
            Tc = RobertsonCCT('x',xs,'y',ys,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'Hernandez') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = HernandezCCT('x',xs,'y',ys);
        else
            Tc = HernandezCCT('x',xs,'y',ys,'warning','off');
        end
    elseif strcmp(p.Results.CCTMethod,'exact') == 1
        if strcmp(p.Results.Warning,'off')
            Tc = round(CCT('x',xs,'y',ys));
        else
            Tc = round(CCT('x',xs,'y',ys,'warning','off'));
        end
    end

    for Leg = 1:max(size(xs))
        legendentry{Leg} = ...
            ['x = ',num2str(xs(Leg)),'   y = ',num2str(ys(Leg)),'   CCT: ',num2str(Tc(Leg)),' K'];
    end
    
%elseif strcmp(p.Results.LegendMode,'on')
    case 'on'
    for Leg = 1:max(size(xs))
        legendentry{Leg} = ...
            ['x = ',num2str(xs(Leg)),'   y = ',num2str(ys(Leg))];
    end
    
%elseif strcmp(p.Results.LegendMode,'off')
    case 'off' 
    otherwise
end

if  strcmp(LegendMode,'on')==1 || strcmp(LegendMode,'extended')==1
    L = legend(marker,legendentry);
    if strcmp(p.Results.Background,'black') == 1
        L.TextColor = [1 1 1];
    end
end



hold off

end