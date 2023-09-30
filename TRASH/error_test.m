% Unit tests for the Lighting Toolbox for MATLAB and Octave
%
% Run this script to check for errors after code changes.
%
% Author: Frederic Rudawski
% Date: 25.09.2023

%% check if all functions execute without error
% DEFINITIONS AND REFERENCE DATA
lam = 380:780;
spec = ciespec(lam,'FL4');
spec2 = ciespec(lam,{'D65','D75'});
VL = ciespec(lam,'VL');
sc = ciespec(lam,'sc');



% --- SPECTRAL EVALUATIONS ---


% specbandwidth
try
    specbandwidth(lam,VL);
catch
    assert(0)
end

% speccentroid
try
    speccentroid(lam,VL);
catch
    assert(0)
end

% specpeak
try
    specpeak(lam,VL);
catch
    assert(0)
end

% specspread
try
    specspread(lam,[sc;VL]);
catch
    assert(0)
end

% speceval
try
    speceval(lam,spec);
catch
    assert(0)
end

% ciespec2Y
try
    ciespec2Y(lam,spec);
catch
    assert(0)
end

% ciespec2xyz10
try
    xyz10 = ciespec2xyz10(lam,spec);
catch
    assert(0)
end

% ciespec2xyz
try
    xyz10 = ciespec2xyz(lam,spec);
catch
    assert(0)
end

% ciespec2wp
try
    [XYZ,xyz] = ciespec2wp(lam,spec,'xyz10');
catch
    assert(0)
end

% ciespec2unit
try
    ciespec2unit(lam,spec2,'a-opic');
catch
    assert(0)
end  

% ciek
try
    k = ciek(lam,spec2,'a-opic');
catch
    assert(0)
end  

% ciespec2aopic
try
    ciespec2aopic(lam,spec2);
catch
    assert(0)
end

% cieedq
try
    cieedq(lam,spec,'aopic');
catch
    assert(0)
end

% ciemedi
try
    ciemedi(lam,spec);
catch
    assert(0)
end


% --- Radiometry ---


% planck
try
    LAM = 0:10:1000;
    T = 4000:1000:9000;
    M = planck(T,LAM);
catch
    assert(0)
end


% --- COLORIMETRY ---


% mixYxy
try
    E = [100 300];
    x = [0.3 0.4];
    y = [0.4 0.3];
    [xmix,ymix] = mixYxy(E,x,y);
catch
    assert(0)    
end

% CIECAM02
try
    XYZ = [19.31 23.93 10.14];
    wp = [98.88 90 32.02];
    cond = 'ave';
    La = 20;
    Yb = 18;
    [cam,p] = cieCAM02(XYZ,wp,cond,La,Yb);
catch
    assert(0)
end
% CICAM02inv
try
    XYZ = cieCAM02inv(cam,p);
catch
    assert(0)
end

% CIEXYZ2xyz
try
    XYZ = [685.9847 721.7317 785.84229];
    xyz = cieXYZ2xyz(XYZ);
catch
    assert(0)
end

% srg2xyz
try
    srgb = [0.6080  0.6710  0.5385];
    xyz = srgb2xyz(srgb);
catch
    assert(0)
end

% xyz2srgb
try
    xyz = [0.2905 0.3405 0.3261];
    srgb = xyz2srgb(xyz);
catch
    assert(0)
end

% ciewhitepoint
try
    [XYZ,xyz] = ciewhitepoint('E');
catch
    assert(0)
end

% ciexy2uv
try
    x = 0.3451;
    y = 0.2973;
    ciexy2uv(x,y);
catch
    assert(0)
end

% cieuv2xy
try
    u = 0.2349;
    v = 0.3035;
    cieuv2xy(u,v);
catch
    assert(0)
end

% ciexy2cct
try
    x = 0.3145;
    y = 0.2567;
    ciexy2cct(x,y);
catch
    assert(0)
end

% ciexyz2lab
try
    xyz = [0.2761 0.3405 0.3550];
    lab = ciexyz2lab(xyz);
catch
    assert(0)
end

% ciexyY2XYZ
try
    x = 0.2165;
    y = 0.4358;
    L = 100;
    XYZ = ciexyY2XYZ(x,y,L);
catch
    assert(0)
end

runtests('LT_test_colors.m')

% --- IMAGE PROCESSING ---


% fisheyeang
try
    [theta, rho, omega] = fisheyeang;
catch
    assert(0)
end

% fieldofview
try
    fieldofview(theta,rho,'binocular');
catch
    assert(0)
end

% readhyperspec
try
    IM = readhyperspec('hyperspec.mat');
catch
    assert(0)
end

% readaopic
try
    im = readaopic('image.aop');
catch
    assert(0)
end      

% hyperspec2srgb
try
    IM = readhyperspec('hyperspec.mat');
    srgb = hyperspec2srgb(IM);
catch
    assert(0)
end


% --- PLOTTING ---


% bayerpattern plot
try
    f1 = figure('visible','off');
    bayerpattern(6);
    close(f1)
catch
    assert(0)
end

% plotaopic
try
    im = readaopic('image.aop');
    f1 = figure('visible','off');
    plotaopic(im);
    close(f1)
catch
    assert(0)
end

% plotpolarCCT
try
    [~,~,L,~,x,y] = specsky(12,160,40);
    f1 = figure('visible','off');
    [Th,Tv] = plotpolarCCT(x,y,L,[0 90 180 270]);
    close(f1)
catch
    assert(0)
end

% plotpolarE
try
    L = ciesky(12,180,40,'Eh',1e4);
    f1 = figure('visible','off');
    [Eh,Ev] = plotpolarE(L,[0 90 180 270]);
    close(f1)
catch
    assert(0)
end

% plot2dldc
try
    ldc = readldt('lambert.ldt');
    f1 = figure('visible','off');
    plot2dldc(ldc);
    close(f1)
catch
    assert(0)
end

% plot3dldc
try
    ldc = readldt('lambert.ldt');
    f1 = figure('visible','off');
    plot3dldc(ldc);
    close(f1)
catch
    assert(0)
end

% plotcfi
try
    f1 = figure('visible','off');
    ciecfi(lam,spec);
    close(f1)
catch
    assert(0)
end

% colors
try
    colors(5);
catch
    assert(0)
end

% plotcieuv_
try
    u = linspace(0.1,0.2,5);
    v = linspace(0.3,0.2,5);
    c = colours(5);
    f1 = figure('visible','off');
    plotcieuv_(u,v,'marker','.','markercolor',c,...
        'markersize',8,'legendmode','on')
    close(f1)
catch
    assert(0)
end

% plotcieuv
try
    u = linspace(0.1,0.2,5);
    v = linspace(0.3,0.2,5);
    c = colours(5);
    f1 = figure('visible','off');
    plotcieuv(u,v,'marker','.','markercolor',c,...
        'markersize',8,'legendmode','on')
    close(f1)
catch
    assert(0)
end

% plotciexy
try
    x = linspace(0.2,0.3,5);
    y = linspace(0.2,0.3,5);
    c = colours(5);
    f1 = figure('visible','off');
    plotciexy(x,y,'marker','.','markercolor',c,...
        'markersize',8,'legendmode','on')
    close(f1)
catch
    assert(0)
end

% plotcfibar
try
    f1 = figure('visible','off');
    ciecfi(lam,spec);
    close(f1)
catch
    assert(0)
end

% PLOTCRIBAR
try
    cri = ciecri(lam,spec);
    f1 = figure('visible','off');
    plotcribar(cri);
    close(f1)
catch
    assert(0)
end

% plotspecslice
try
    T = [3000:500:9000];
    S = planck(T,lam);
    S = S./max(S')';
    f1 = figure('visible','off');
    plotspecslice(lam,S);
    close(f1)
catch
    assert(0)
end

% plotcolor
try
    c = colours(5);
    f1 = figure('visible','off');
    plotcolour(c)
    close(f1)
catch
    assert(0)
end


% --- DAYLIGHT ---


% sunpos
try
    [az,el] = sunpos('21.05.1987','11:03:22');
catch
    assert(0)
end

% sunset
try
    utc = sunset('21.04.1988',[37.978 23.728]);
catch
    assert(0)
end

% sunrise
try
    utc = sunrise('21.04.1988',[37.978 23.728]);
catch
    assert(0)
end

% suntime
try
    [utc,localtime] = suntime('13.05.2022',[],'sunset');
catch
    assert(0)
end

% sundiagram
try
    f1 = figure('visible','off');
    sundiagram([37.978 23.728],3,'15.04.2020','09:35:15')
    close(f1)
catch
    assert(0)
end

% specsky
try
    specsky(12,210,30,'Eh',15000);
catch
    assert(0)
end

% geteskytype
try
    L = ciesky(12,166,33);
    [sky,RMS] = getskytype(L,166,33,'tregenza');
catch
    assert(0)
end

% tregenzaskytype
try
    L = ciesky(12,166,33);
    [sky,RMS] = tregenzaskytype(L,166,33);
catch
    assert(0)
end

% ciesky
try
    L = ciesky(12,160,30);
catch
    assert(0)
end

% tregenzadist
try
    tregenzadist(35,6);
catch
    assert(0)
end

% TST - true solar time
try
    TST('21.05.1987','11:03:22',37.978,23.728);
catch 
    assert(0)
end

% polardatacct
try
    x = linspace(0.2,0.4,145);
    y = linspace(0.4,0.3,145);
    Y = ciesky(12,166,33);
    [Th,Tv] = polardataCCT(x,y,Y,[0 90 180 270]);
catch 
    assert(0)
end


% --- Measurements ---


% egrid
try
    [x,y] = egrid(5,4);
catch
    assert(0)
end

% cief1
try
    cief1(lam,VL.^(1.05));
catch
    assert(0)
end

% ldc2phi
try
    ldc = readldt('lambert.ldt');
    phi = ldc2Phi(ldc);
catch
    assert(0)
end


