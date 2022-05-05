% Plot spectrum with colour in the visible range.
%
% usage: plotspec(lam,spec,mode)
%
% where:
% lam:  Specifies the wavelength steps.
% spec: Is a vector containing the to be plotted spectrum.
% mode: 'black' -> black background
%       'white' -> white background (default)
%
% author: Frederic Rudawski
% date: 12.06.2018
% see: https://www.frudawski.de/plotspec

function plotspec(wavelength,data,mode)
cla
% background color mode
try
    if strcmp(mode,'black')
        black_background = 1;
    else
        black_background = 0;
    end
catch
    black_background = 0;
end

data = interp1(wavelength,data,380:780);
wavelength = 380:780;

% color mapping
WL = [360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830];
cmap = zeros(max(size(wavelength)),3);

% colors
clr = [0.00142462214627376 0.00159742321430941 0.00179121301780434 0.00200915368114662 0.00225379835003754 0.00252744169820119 0.00283550982114008 0.00318362981606061 0.00357320038496663 0.00400790787668868 0.00449055515888276 0.00501854191033141 0.00560617325647704 0.00627775736287215 0.00706195509146764 0.00798130350358025 0.00908645695257885 0.0103228918991165 0.0119529710376975 0.0133758647489712 0.0148336148996644 0.0162632999481668 0.0177536605971239 0.0194592820399206 0.0215184123615027 0.0240709014457039 0.0272519813487210 0.0310455922020006 0.0355989803204037 0.0403594659406249 0.0452823603665922 0.0501674588127727 0.0551452646039645 0.0605266707372479 0.0663929481008939 0.0729502931147254 0.0802469195675938 0.0881446579366139 0.0960394123834991 0.103735022290718 0.110866224681297 0.117313158873666 0.123659164331370 0.130536824901461 0.138272531587858 0.147292723798082 0.157699817767644 0.169191923557245 0.181342579978419 0.194019494018401 0.206951416137000 0.220042871509678 0.233404457727593 0.247302430017844 0.261782289943488 0.276988056551555 0.292711141650523 0.308820944951056 0.325284825822326 0.342157144026093 0.359421016240834 0.377156368181284 0.394869518400401 0.411947443139099 0.428014870125332 0.442595277478893 0.455659394173534 0.467317972074379 0.477622994670446 0.486572939421729 0.494169052534864 0.500415843476606 0.505337789279466 0.509029719138556 0.511571829335113 0.513026391460531 0.513474100300086 0.512847551802173 0.511193563765578 0.508591993391818 0.504983535693651 0.500476279835524 0.494972535481584 0.488455222718568 0.481084193163422 0.472669064385013 0.463235820689084 0.452833356865049 0.441344481016892 0.428720987991917 0.415057988813509 0.400152170603786 0.383948560592142 0.366072868324774 0.346010930850445 0.323434573001979 0.297466565179600 0.267107376377293 0.231011039855579 0.185489464988464 0.120760817566199 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.237475618861755 0.348805136142226 0.429612779569773 0.496009712074755 0.553659112306589 0.605272177417686 0.652382900833753 0.696021711755456 0.736837022188906 0.775325541219781 0.811804778208981 0.846520671997016 0.879693159146144 0.911450599174806 0.941928838777881 0.971239298254615 0.999448358591765 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0.994674167166715 0.975879776019617 0.956982238833876 0.937982165736318 0.918891627264747 0.899769497355841 0.880672314435068 0.861680447846461 0.842826223390144 0.824144803476683 0.805575963494988 0.787117844434690 0.768703876327140 0.750375517543264 0.732114789990376 0.713955632857317 0.695889985920362 0.677927793065004 0.660068353259479 0.642316523297520 0.624712959940726 0.607295087710981 0.590044849630352 0.573034860294636 0.556231461755908 0.539784348319069 0.523731875902103 0.508166870751685 0.493152047142420 0.478716833936882 0.464819307245894 0.451419926872138 0.438476930843769 0.426024168776465 0.414039906619347 0.402364642837965 0.390864774914068 0.379310195228399 0.367556637338958 0.355669628787734 0.343708767848930 0.331848400165249 0.320232739212832 0.308913113250943 0.297843913033992 0.287071961300391 0.276641921106204 0.266522168649910 0.256785676990715 0.247458902931668 0.238499298677156 0.229939726982054 0.221776075811911 0.214002956120721 0.206604961482005 0.199481180211101 0.192656038617622 0.185999858249246 0.179400805877587 0.172930060937971 0.166610412580371 0.160397731633565 0.154421628312670 0.148614338978983 0.143006714811909 0.137549842089681 0.132203404528554 0.126968835454518 0.121876171579369 0.116937906497772 0.112119755028632 0.107383565381599 0.102770052958491 0.0982855638873425 0.0938739725156877 0.0896109773807703 0.0854085446142813 0.0814461887526604 0.0774653676350486 0.0737874377488528 0.0700787169419087 0.0665147081503797 0.0630984923038042 0.0597317834381033 0.0563953503262720 0.0530860918042206 0.0499957213973090 0.0469459535872569 0.0438772750955411 0.0410233145581777 0.0381615085657916 0.0355117781293378 0.0328040866188338 0.0304752913613894 0.0283130916837946 0.0263020739560044 0.0244325161596948 0.0226940334091827 0.0210783035753963 0.0195777394104831 0.0181880094759036 0.0169020570543712 0.0157151211193356 0.0146206787510296 0.0136109470420043 0.0126829785065483 0.0118367466201176 0.0108496385377518 0.0100801279978805 0.00942629537396063 0.00878762718871951 0.00820030782251016 0.00765653228295184 0.00714587422562900 0.00666816717682659 0.00622180166672948 0.00580561624321292 0.00541698403528945 0.00505406331499138 0.00471498176804310 0.00439843982294805 0.00410304886517257 0.00382786883174017 0.00357162570063441 0.00333262558393409 0.00311009928629587 0.00290243296989175 0.00270847231485574 0.00252714543285450 0.00235759376154520 0.00219932401238139 0.00205161522425368 0.00191401449499963 0.00178564207571627 0.00166596451717540 0.00155440326631294 0.00145036080608680 0.00135334159881164 0.00126280739597666 0.00117831953549031 0.00109950341640213 0.00102583735146375 0.000956987051927225 0.000892532811608366 0.000832156906413086 0.000775759748560424 0.000723101847463921 0.000674024340689882 0.000628309091498240 0.000585737963055374 0.000546090424257611 0.000509129378219179 0.000474693567951932 0.000442545896581155 0.000412546461334959 0.000384617027796619 0.000358556024889060 0.000334306572421740 0.000311688453562332 0.000290561765665647 0.000270867234403457 0.000252545585463731 0.000235416602139727 0.000219482678481823 0.000204601517757296 0.000190756554086945 0.000177845804912572 0.000165809996039644 0.000154570893330733 0.000144107142532417 0.000134359469487343 0.000125268600049784 0.000116794220039048 0.000108855701161746 0.000101495751706997 9.46123892283957e-05 8.82269678569370e-05 8.22588593259135e-05 7.66891036573497e-05 7.14560325487037e-05 6.66426684220515e-05 6.21067147515387e-05 5.79287997492621e-05 5.39903752741217e-05 5.03293612150132e-05 4.69078376617479e-05 4.37447645543242e-05 4.07808678242300e-05;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.0192658478714647 0.142718571977906 0.204957741627141 0.251510159526926 0.290045366891007 0.323669316469040 0.353794061578726 0.381412173689668 0.407002056291104 0.430934476213729 0.453398566607526 0.474573573609184 0.494555683968659 0.513469301265214 0.531501764399654 0.548847990062187 0.565640873360323 0.582009437264967 0.598017974345607 0.613755843121576 0.629310213501223 0.644799801186935 0.660289509748190 0.675858692690063 0.691502187613346 0.707229582297079 0.722983962139907 0.738787729149218 0.754570395669010 0.770416107568151 0.786475464341659 0.802850596312471 0.819665830643799 0.836983963330556 0.854641592543227 0.872425956515546 0.890161663260540 0.907688510993994 0.924898841907071 0.941850046015724 0.958574634301779 0.975125022632059 0.991541962987569 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0.992554957983829 0.978487096852807 0.963969960682943 0.948975746433309 0.933491161540477 0.917527979306234 0.901047747872176 0.884049808890794 0.866524720292796 0.848485731704545 0.829936132930683 0.810870672858000 0.791284406052404 0.771192042653078 0.750549327213063 0.729373014210402 0.707629239833265 0.685278037370269 0.662346146253956 0.638821336745766 0.614738575245236 0.590171289024945 0.565085116798941 0.539437659072492 0.513079652938073 0.485817578629744 0.457426687673700 0.427698251303333 0.396262858108543 0.362928498317734 0.327164860165626 0.288514500811889 0.245595515806724 0.195184183431614 0.129730229215293 0.000551255467909699 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0.00903674252679048 0.0101259963400602 0.0115718315971027 0.0130051871586926 0.0146011710924752 0.0163805554247719 0.0183864030657670 0.0206531218664704 0.0231999838941980 0.0260419043911976 0.0291967791244155 0.0326571402016231 0.0366845443235402 0.0411067644324506 0.0458779657188900 0.0512772509323286 0.0572560233968528 0.0636950149043508 0.0701535328816171 0.0764107847205408 0.0824046665651257 0.0878646295928799 0.0932246989749687 0.0991200472538370 0.105836449655644 0.113656531620676 0.122689926463202 0.132790183637610 0.143433427852911 0.154351531826670 0.165340364121417 0.176231581883484 0.187420442116425 0.199300159014067 0.212405514256727 0.226916565053393 0.243192512119457 0.260672596355870 0.278301334158538 0.295325978477663 0.311224810287229 0.325731440437377 0.340016634207016 0.355364478529160 0.372821622892531 0.393229100410897 0.416784734685810 0.442737443145408 0.470341630440297 0.499031008910353 0.528347164698515 0.558080645656998 0.588618187269476 0.620367001200804 0.653599276996784 0.688534832067113 0.724758052767926 0.761942679649175 0.800327763536883 0.840055536001482 0.881222937522785 0.923875157581616 0.966929724521448 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0.983984985981434 0.960249092444970 0.936397528418185 0.912477250491352 0.888612467575805 0.864904347526011 0.841510673075766 0.818536574179122 0.796002038762674 0.773862256539610 0.752082774180012 0.730602332733763 0.709426054884264 0.688584046997861 0.668060537121698 0.647837654322498 0.627899745268240 0.608215933485907 0.588722661370786 0.569430721731745 0.550275478078613 0.531203817969295 0.512212369082633 0.493159600786450 0.473820475661865 0.453859858874154 0.432903237181167 0.410575063998562 0.386675652795708 0.361036039991995 0.333308805190999 0.303006244833751 0.269274170276562 0.230499135194985 0.183923687809851 0.121967924457255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
% colormapping indices
[~,ind1] = min(abs(WL-wavelength(1)));
[~,ind2] = min(abs(WL-wavelength(end)));
[~,ond1] = min(abs(wavelength-WL(1)));
%[~,ond2] = min(abs(wavelength-WL(end)));
dlam = wavelength(2)-wavelength(1);

cmap(ond1:ond1+length(ind1:dlam:ind2)-1,:) = clr(ind1:dlam:ind2,:);

% check data
y = data';
x = wavelength;
if size(x,1)>size(x,2)
    x = x';
end

% legend dummy plot
if black_background
    plot(NaN,NaN,'Color',[0 0 0])
else
    plot(NaN,NaN,'Color',[1 1 1])
end
hold on

% plot spectrum
for k = 1:size(x,2)-1
    p = patch([x(k)-0.5*dlam x(k)+0.5*dlam x(k)+0.5*dlam x(k)-0.5*dlam x(k)-0.5*dlam],[0 0 y(k+1) y(k) 0],cmap(k,:));  % Plot the histogram
    set(p,'EdgeColor','none')
end

% labels
xlabel('\lambda in nm');
ylabel('SPD');
grid on
a = axis;
axis([wavelength(1) wavelength(end) a(3) a(4)])

fig = gcf;
ax = gca;
% black background ?
if black_background
   if exist('OCTAVE_VERSION', 'builtin')
     set(ax,'color',[0 0 0])
     set(fig,'color',[0 0 0])
     set(ax,'gridcolor',[1 1 1])
     set(ax,'minorgridcolor',[1 1 1])
     set(ax,'ycolor',[1 1 1])
     set(ax,'xcolor',[1 1 1])
     Thandle = title('');
     set(Thandle,'color',[1 1 1]);
   else
     ax = gca;
     set(ax,'color',[0 0 0])
     set(fig,'color',[0 0 0])
     grid on
     ax.GridColor = [0.7, 0.7, 0.7];
     ax.XColor = 'w';
     ax.YColor = 'w';
     fig.InvertHardcopy = 'off';
     plot(x,y,'w-')
end
end

hold off
end


