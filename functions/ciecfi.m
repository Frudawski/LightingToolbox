% Colour fidelity Index determination as in CIE 224:2017.
%
% Any errors in the data set or in results generated with the Lighting Toolbox 
% are not in the liability of the CIE nor me, see license.
%
% usage: [CFI,Rf] = ciecfi(lam,spec)
%
% where:
% CFI: Is the extended return struct containing the following fields:
%       Rf: general colour fidelity index
%       Rfi: 99 special colour rendering indices Rf,i for the 99 reference colours
%       Tcp: Correlated Colour Temperature (CCT) Tcp​ of the test illuminant
%       dE: chromaticity diffenrence dE
% Rf:	Returns the general colour fidelity index field for the illuminant(s).
% lam:	Is a vector containing the wavelength steps.
% spec:	Is a vector or matrix containing the spectral power distribution of the illuminant(s). For more than one spectrum use a row-wise data matrix.
%
% Reference: 
% CIE 224:2017: CIE 2017 Colour Fidelity Index for accurate scientific use. 
% Commission International d'Eclairage (CIE), Vienna Austria, 2017, ISBN: 978-3-902842-61-9.
% URL: https://cie.co.at/publications/cie-2017-colour-fidelity-index-accurate-scientific-use
%
% Author: Frederic Rudawski
% Date: 26.05.2021
% see: https://www.frudawski.de/ciecfi

function [Rf,Rfg] = ciecfi(lam,specin)

% indices: t = test, r = reference

for row = 1:size(specin,1)
    
    % current spectrum
    spec = specin(row,:);
    
    % determine Tcp
    [~,x,y] = ciespec2xyz(lam,spec);
    Tcp = CCT('x',x,'y',y,'accuracy',0.0000000000001,'warning','off','mode','CIE');
    
    % determine spectral distribution of reference illuminant depending on Tcp
    if Tcp > 5e3
        S = ciecct2spec(Tcp,lam);
    elseif (Tcp >= 4e3) && (Tcp <= 5e3)
        RP = planck(Tcp,lam,'CIE');
        RD = ciecct2spec(Tcp,lam);
        S1 = 100.*RP./ciespec2unit(lam,RP,'y',1);
        S2 = 100.*RD./ciespec2unit(lam,RD,'y',1);
        S = (Tcp-4e3)./(5e3-4e3).*S2 + (5e3-Tcp)./(5e3-4e3).*S1;
    elseif Tcp < 4e3
        S = planck(Tcp,lam,'CIE');
    end
    S = 100.*S./ciespec2unit(lam,S,'y',1);
    
    % determine 10° Tristimulus values
    X10t = 100.*ciespec2unit(lam,spec.*ciespec(lam,'x10'),'CFI+',1)./ciespec2unit(lam,spec,'y10',1);
    Y10t = 100.*ciespec2unit(lam,spec.*ciespec(lam,'y10'),'CFI+',1)./ciespec2unit(lam,spec,'y10',1);
    Z10t = 100.*ciespec2unit(lam,spec.*ciespec(lam,'z10'),'CFI+',1)./ciespec2unit(lam,spec,'y10',1);
    
    X10r = 100.*ciespec2unit(lam,S.*ciespec(lam,'x10'),'CFI+',1)./ciespec2unit(lam,S,'y10',1);
    Y10r = 100.*ciespec2unit(lam,S.*ciespec(lam,'y10'),'CFI+',1)./ciespec2unit(lam,S,'y10',1);
    Z10r = 100.*ciespec2unit(lam,S.*ciespec(lam,'z10'),'CFI+',1)./ciespec2unit(lam,S,'y10',1);
    
    % determine 10° Tristimulus values of the illuminant white points
    %XYZ10wt = ciespec2wp(lam,spec,'xyz10');
    %XYZ10wr = ciespec2wp(lam,S,'xyz10');
    
    % convert to CAT02 RGB
    MCAT02 = [0.7328 0.4296 -0.1624;-0.7036 1.6975 0.0061;0.0030 0.0136 0.9834];
    RGBt = MCAT02*[X10t;Y10t;Z10t];
    RGBr = MCAT02*[X10r;Y10r;Z10r];
    
    % von Kries like chromatic adaption
    RGBtc = diag(100./RGBt(:,end))*RGBt;
    RGBrc = diag(100./RGBr(:,end))*RGBr;
    
    % convert back to Tristimulus values
    MCAT02inv = [1.096124 -0.278869 0.182745;0.454369 0.473533 0.072098;-0.009628 -0.005698 1.015326];
    XYZ10tc = MCAT02inv*RGBtc;
    XYZ10rc = MCAT02inv*RGBrc;
    
    % cone resonses
    MHPE = [0.38971 0.68898 -0.07868;-0.22981 1.18340 0.04641;0 0 1];
    RGBt_ = MHPE*XYZ10tc;
    RGBr_ = MHPE*XYZ10rc;
    
    % luminance adaptation
    RGBta = (400.*(0.7937.*RGBt_./100).^0.42)./(27.13+(0.7937.*RGBt_./100).^0.42)+0.1;
    RGBra = (400.*(0.7937.*RGBr_./100).^0.42)./(27.13+(0.7937.*RGBr_./100).^0.42)+0.1;
    
    % calculate a,b parameters
    at = RGBta(1,:)-12./11.*RGBta(2,:)+1./11.*RGBta(3,:);
    ar = RGBra(1,:)-12./11.*RGBra(2,:)+1./11.*RGBra(3,:);
    bt = 1./9.*(RGBta(1,:)+RGBta(2,:)-2.*RGBta(3,:));
    br = 1./9.*(RGBra(1,:)+RGBra(2,:)-2.*RGBra(3,:));
    
    % determine achromatic response A
    At = (2.*RGBta(1,:)+RGBta(2,:)+1/20.*RGBta(3,:)-0.305).*1.0003;
    Ar = (2.*RGBra(1,:)+RGBra(2,:)+1/20.*RGBra(3,:)-0.305).*1.0003;
    
    % Lightness J
    Jt = 100.*(At./At(100)).^(0.69*(1.48+sqrt(0.2)));
    Jr = 100.*(Ar./Ar(100)).^(0.69*(1.48+sqrt(0.2)));
    
    % Hue h
    %ht = 180/pi*atan2(bt,at);
    %hr = 180/pi*atan2(br,ar);
    
    ht = zeros(size(at));
    for ind = 1:length(at)
        if at(ind)>=0 && bt(ind)>=0
            ht(ind) = atand(bt(ind)./at(ind));
        elseif at(ind)<0 && bt(ind)>=0
            ht(ind) = atand(bt(ind)./at(ind))+180;
        elseif at(ind)<0 && bt(ind)<0
            ht(ind) = atand(bt(ind)./at(ind))+180;
        elseif at(ind)>=0 && bt(ind)<0
            ht(ind) = atand(bt(ind)./at(ind))+360;
        end
    end
    
    hr = zeros(size(at));
    for ind = 1:length(ar)
        if ar(ind)>=0 && br(ind)>=0
            hr(ind) = atand(br(ind)./ar(ind));
        elseif ar(ind)<0 && br(ind)>=0
            hr(ind) = atand(br(ind)./ar(ind))+180;
        elseif ar(ind)<0 && br(ind)<0
            hr(ind) = atand(br(ind)./ar(ind))+180;
        elseif ar(ind)>=0 && br(ind)<0
            hr(ind) = atand(br(ind)./ar(ind))+360;
        end
    end
    
    % Colourfulness M
    et = 1/4.*(cos(pi/180.*ht+2)+3.8);
    tt = ((5e4/13).*1.0003.*et.*sqrt(at.^2+bt.^2))./(RGBta(1,:)+RGBta(2,:)+21/20.*RGBta(3,:));
    Ct = tt.^0.9.*sqrt(Jt./100).*(1.64-0.29.^0.2).^0.73;
    Mt = Ct.*0.7937.^0.25;
    
    er = 1/4.*(cos(pi/180.*hr+2)+3.8);
    tr = ((5e4/13).*1.0003.*er.*sqrt(ar.^2+br.^2))./(RGBra(1,:)+RGBra(2,:)+21./20.*RGBra(3,:));
    Cr = tr.^0.9.*sqrt(Jr./100).*(1.64-0.29.^0.2).^0.73;
    Mr = Cr.*0.7937.^0.25;
    
    % CAM02-UCS
    M_t = 1/0.0228.*log(1+0.0228.*Mt);
    J_t = ((1+100.*0.007).*Jt)./(1+0.007.*Jt);
    a_t = M_t.*cos(pi/180.*ht);
    b_t = M_t.*sin(pi/180.*ht);
    
    M_r = 1/0.0228.*log(1+0.0228.*Mr);
    J_r = ((1+100.*0.007).*Jr)./(1+0.007.*Jr);
    a_r = M_r.*cos(pi/180.*hr);
    b_r = M_r.*sin(pi/180.*hr);
    
    % deltaE_i
    DEi = sqrt((J_t-J_r).^2+(a_t-a_r).^2+(b_t-b_r).^2);
    DEi = DEi(1:99);
    DEavg = sum(DEi)/99;
    
    % Rf
    Rfi = 10.*log(exp((100-6.73.*DEi)./10)+1);
    Rfg = 10.*log(exp((100-6.73.*DEavg)./10)+1);
    
    Rf.Rf(1,row) = Rfg;
    Rf.Rfi(:,row) = Rfi;
    Rf.dE(1,row) = DEavg;
    Rf.dEi(:,row) = DEi;
    Rf.Tcp(1,row) = Tcp;
    %Rf.cf = 6.73;
    Rf.CIECAM02UCS.Jt(:,row) = J_t(1:99)';
    Rf.CIECAM02UCS.Mt(:,row) = M_t(1:99)';
    Rf.CIECAM02UCS.ht(:,row) = ht(1:99)';
    Rf.CIECAM02UCS.at(:,row) = a_t(1:99)';
    Rf.CIECAM02UCS.bt(:,row) = b_t(1:99)';
    Rf.CIECAM02UCS.Jr(:,row) = J_r(1:99)';
    Rf.CIECAM02UCS.Mr(:,row) = M_r(1:99)';
    Rf.CIECAM02UCS.hr(:,row) = hr(1:99)';
    Rf.CIECAM02UCS.ar(:,row) = a_r(1:99)';
    Rf.CIECAM02UCS.br(:,row) = b_r(1:99)';
    % Duv - for TM30 plots
    [~,ut,vt] = ciespec2uvw(lam,specin);
    Rf.Duv = duv(ut,vt);

end

Rfg = Rf.Rf;