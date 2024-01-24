% CIE Colour Rendering Index (CRI) function, Calculation according to CIE TR 13.3:1995
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see license.
%
% usage: [CRI,Ra] = cieCRI(lambda,spec,reference)
%
% where:
% - CRI is the return struct with the calculated values of interest:
%     CRI.Ra: is general colour rendering index Ra
%     CRI.Ri: are the 14 special colour rendering indexes for the 14 test colours
%     CRI.illuminant: specifies the reference illuminant (Planck or daylight)
%     CRI.Tc: is the reference illuminant's correlated colour temperature (CCT)
%     CRI.dC: is the chromaticity difference between reference
%                 illuminant and test illumant. The tolerance of dC
%                 is 5.4*10^-3 which is about 15 MK^-1 (reciprocal megakelvin)
% - Ra: only returns the general colour rendering index Ra
% - lambda specifies the wavelength steps of the test illuminant
% - spec specifies the spetral power distribution of the test lamp
% - reference allows the evaluation for other reference illuminants (optional)
%
% Reference:
% CIE 13.3:1995: Method of measuring and specifying colour rendering properties
% of light sources. Commission Internationale de l'Eclairage (CIE), Vienna Austria,
% 1995, ISBN: 978 3 900734 57 2.
% https://cie.co.at/publications/method-measuring-and-specifying-colour-rendering-properties-light-sources
%
% Author: Frederic Rudawski
% Date: 03.08.2020
% see: https://www.frudawski.de/ciecri


function [CRI,Ra] = ciecri(lam,spec,reference)

% number of test colours
ncolor = 14;
% reference data of the 14 test colours
ref = ciespec(lam,'CRI');

for row = 1:size(spec,1)

% CCT and u,v coordinates of test illuminant
%[~,uk,vk] = ciespec2uvw(lam,spec(row,:));
[~,x,y] = ciespec2xyz(lam,spec(row,:));
[uk,vk] = ciexy2uv(x,y);
uk = ltfround(uk,4);
vk = ltfround(vk,4);

%Tc = RobertsonCCT('u',uk,'v',vk);
%Tc = CCT('u',uk,'v',vk,'accuracy',0.0000000000001,'mode','CIE');
Tc = round(ciexy2cct(x,y));

% reference illuminant
if Tc < 5000
    illuminant = 'Planck';
    [Rspec,~,~,ur,vr] = planck(Tc,lam,'CIE');
    %Ispec = interp1(Ilam,Ispec,lam);
    %[ur,vr] = ciespec2uv(lam,Ispec)
else
    illuminant = 'Daylight';
    [Rspec,Ilam,Ix,Iy] = ciecct2spec(Tc,lam);
    Rspec = interp1(Ilam,Rspec,lam);
    [ur,vr] = ciexy2uv(Ix,Iy);
end

if exist('reference','var')
    illuminant = reference;
    Rspec = ciespec(lam,reference);
    Rspec = interp1(lam,Rspec,lam);
    [ur,vr] = ciexy2uv(Ix,Iy);
end
ur = ltfround(ur,4);
vr = ltfround(vr,4);

% c and d for test illuminant
[ck,dk] = calc_cd(uk,vk);
% c and d for reference illuminant
[cr,dr] = calc_cd(ur,vr);
% c and d for the 8 test colours under reference illuminant
f = 100/ciespec2Y(lam,Rspec);
MRspec = repmat(Rspec,ncolor,1);
MCRspec = MRspec.*ref.*f;
[~,uri,vri] =  ciespec2uvw(lam,MCRspec);
uri = ltfround(uri,4);
vri = ltfround(vri,4);
% c and d for the 8 test colours under test illuminant
f = 100/ciespec2Y(lam,spec(row,:));
MTspec = repmat(spec(row,:),ncolor,1);
MCTspec = MTspec.*ref.*f;
[~,Muk,Mvk] =  ciespec2uvw(lam,MCTspec);
Muk = ltfround(Muk,4);
Mvk = ltfround(Mvk,4);
[cki,dki] = calc_cd(Muk,Mvk);

% u'_i and v'_i - note: u',v' are NOT the CIE 1976 chromaticity coordinates
uki = ltfround((10.872+0.404.*(cr./ck).*cki-4.*(dr./dk).*dki)./(16.518+1.481.*(cr./ck).*cki-(dr./dk).*dki),4);
vki = ltfround(5.520./(16.518+1.481.*(cr./ck).*cki-(dr./dk).*dki),4);

% transformation to CIE 1964 chromaticity (uniform)
Yr = ciespec2Y(lam,MCRspec);
Yk = ciespec2Y(lam,MCTspec);
Wki = ltfround(25.*(Yk).^(1/3)-17,4);
Uki = ltfround(13.*Wki.*(uki-ur),4);
Vki = ltfround(13.*Wki.*(vki-vr),4);
Wri = ltfround(25.*(Yr).^(1/3)-17,4);
Uri = ltfround(13.*Wri.*(uri-ur),4);
Vri = ltfround(13.*Wri.*(vri-vr),4);

% delta E - CIE colour difference formular (1964)
deltaE = sqrt((Uri-Uki).^2 + (Vri-Vki).^2 + (Wri-Wki).^2 );
% delta C - chromaticity difference
deltaC = sqrt((uk-ur).^2 + (vk-vr).^2);

% special color rendering indexes Ri
Ri = 100-4.6.*deltaE;
Ri = ltfround(Ri);
% general color rendering index Ra
% Ra is defined as 1/8*sum(Ri(1:8))
Ra = (1./8.*sum(Ri(1:8,:)));

% struct with usefull information
CRI.Ra(1,row) = Ra;
CRI.Ri(:,row) = Ri;
if size(spec,1) > 1
    CRI.illuminant{row} = illuminant;
else
    CRI.illuminant = illuminant;
end
CRI.Tcp(1,row) = Tc;
CRI.dC(1,row) = deltaC;

end

% help function for c and d parameter determination
function [c,d] = calc_cd(u,v)
 c = 1./v.*(4-u-10.*v);
 d = 1./v.*(1.708.*v+0.404-1.481.*u);
