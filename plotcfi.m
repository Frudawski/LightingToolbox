% Plot chromatic a' and b' shift of Colour fidelity Index determination as in CIE 224:2017.
% The function also supports ANSI TM30-20 standard illustrations.
%
% Any errors in the data set or in results generated with the Lighting Toolbox
% are not in the liability of the CIE nor me, see licence.
%
% usage: [CFI,Rf] = plotcfi(lam,spec)
%
% where:
% CFI: Is the extended return struct containing the following fields:
%       Rf: general colour fidelity index
%       Rfi: 99 special colour rendering indices Rf,i for the 99 reference colours
%       Tcp: Correlated Colour Temperature (CCT) Tcp​ of the test illuminant
%       dE: chromaticity diffenrence dE
%       da: delta a' = chromatic shift in a' dimension
%       db: delta b' = chromatic shift in b' dimension
% Rf:	Returns the general colour fidelity index field for the illuminant(s).
% lam:	Is a vector containing the wavelength steps.
% spec:	Is a vector or matrix containing the spectral power distribution of the illuminant(s). For more than one spectrum use a row-wise data matrix.
%
% References:
% CIE 224:2017: CIE 2017 Colour Fidelity Index for accurate scientific use.
% Commission International d'Eclairage (CIE), Vienna Austria, 2017, ISBN: 978-3-902842-61-9.
% URL: https://cie.co.at/publications/cie-2017-colour-fidelity-index-accurate-scientific-use
%
% ANSI/IES TM30-20: IES Method for Evaluating Light Source Color Rendition.
% Illuminating Engineering Society, Geneva, Switzerland, 2020, 
% ISBN: 978-0-87995-379-9.
% URL: https://store.ies.org/product/tm-30-20-ies-method-for-evaluating-light-source-color-rendition/
%
% Author: Frederic Rudawski
% Date: 01.03.2022
% see: https://www.frudawski.de/plotcfi

function plotcfi(CFI,mode,fs)

if ~exist('mode','var')
    mode = 'CIE';
end
if ~exist('fs','var')
    fs = 16; 
end

% colour shift in a' and b'
a = CFI.CIECAM02UCS.at - CFI.CIECAM02UCS.ar;
b = CFI.CIECAM02UCS.bt - CFI.CIECAM02UCS.br;

switch mode
    case 'CLR'
        try 
          warning ("off", "Octave:data-file-in-path");
        catch
        end
        IM = load('TM30back');
        try 
          warning ("on", "Octave:data-file-in-path");
        catch
        end
        im = IM.im;
        image(im)
        axis equal
        hold on

        A = 40;
        a = a.*size(im,1)/A/2;
        b = b.*size(im,2)/A/2;

        % Plot
        R = size(im,1)./A.*14;
        r = size(im,1)./A;
        plotcircle(size(im,1)/2,size(im,2)/2,R,'k:')
        % theta angles for hue groups
        theta = deg2rad((0:45:359)+22.5);
        [x,y] = pol2cart(theta,R);
        x = x+size(im,1)/2;
        y = y+size(im,1)/2;
        % hue groups
        hg = [1 14;15 30;31 47;48 57;58 69;70 80;81 88;89 99];

        % plot hue groups
        ma = zeros(1,length(theta));
        mb = zeros(1,length(theta));
        for n = 1:length(theta)
            % plot hue circle with r = 2
            plotcircle(x(n),y(n),r,'k-')
            % plot hue shift points
            plot(a(hg(n,1):hg(n,2))+x(n),size(im,2)-b(hg(n,1):hg(n,2))-y(n),'k.')
            % determine hue shift mean
            ma(n) = mean(a(hg(n,1):hg(n,2)));
            mb(n) = mean(b(hg(n,1):hg(n,2)));
            % plot arrow of hue group shift
            quiver(x(n),size(im,2)-y(n),ma(n),-mb(n),0,'LineWidth',2,'Color','k');
        end
        axis([0 size(im,1) 0 size(im,2)])
        %plot([ma ma(1)]+[x x(1)],[mb mb(1)]+[y y(1)],'k--')
    case 'TM30'
        try 
          warning ("off", "Octave:data-file-in-path");
        catch
        end
        IM = load('TM30back');
        try 
          warning ("on", "Octave:data-file-in-path");
        catch
        end
        image(IM.im)
        im = IM.im;
        axis equal
        hold on

        A = 40;
        a = a.*size(im,1)/A/2;
        b = b.*size(im,2)/A/2;

        % Plot
        R = size(im,1)./A.*14;
        %r = size(im,1)./A;
        plotcircle(size(im,1)/2,size(im,2)/2,R,'k-','LineWidth',1.25)
        % theta angles for hue groups
        theta = deg2rad((0:22.5:359)+22.5/2);
        [x,y] = pol2cart(theta,R);
        x = x+size(im,1)/2;
        y = y+size(im,1)/2;
        % hue groups
        huebins = (0:16).*22.5;
        %hg = [1 14;15 30;31 47;48 57;58 69;70 80;81 88;89 99];
        hg = cell(16,1);
        hr = CFI.CIECAM02UCS.hr;
        hr(hr==360) = 0;
        for n = 1:length(huebins)-1
           hg{n} = hr >= huebins(n) & hr < huebins(n+1); 
        end
        
        %bincolour = [163 92 96; 204 118 94; 204 129 69; 216 172 98; 172 153 89;145 158 93; 102 139 94;97 178 144;123 186 166;41 122 126;85 120 141;112 138 178;152 140 170;115 88 119;143 102 130;186 122 142]./255;
        bincolour = [230 40 40;231 75 75;251 129 46;255 129 46;255 181 41;203 202 70;126 185 76;65 192 109;0 156 124;22 188 176;0 164 191;0 133 195;59 98 170;69 104 174;106 78 133;157 105 161;167 79 129]./255;
        
        % plot hue groups
        ma = zeros(1,length(theta));
        mb = zeros(1,length(theta));
        mat = zeros(1,length(theta));
        mbt = zeros(1,length(theta));
        mar = zeros(1,length(theta));
        mbr = zeros(1,length(theta));
        for n = 1:length(theta)
            % plot hue circle with r = 2
            %plotcircle(x(n),y(n),r,'k-')
            % plot hue shift points
            %plot(a(hg(n,1):hg(n,2))+x(n),size(im,2)-b(hg(n,1):hg(n,2))-y(n),'k.')
            % determine hue shift mean
            ma(n) = mean(a(hg{n}));
            mb(n) = mean(b(hg{n}));
            % determine mean a and b per hue bin for test and reference illuminant
            mat(n) = mean(CFI.CIECAM02UCS.at(hg{n}));
            mbt(n) = mean(CFI.CIECAM02UCS.bt(hg{n}));
            mar(n) = mean(CFI.CIECAM02UCS.ar(hg{n}));
            mbr(n) = mean(CFI.CIECAM02UCS.br(hg{n}));
            % plot arrow of hue group shift
            quiver(x(n),size(im,2)-y(n),ma(n),-mb(n),0,'LineWidth',1.5,'Color',bincolour(n,:))
        end
        axis([0 size(im,1) 0 size(im,2)])
        % plot test illuminant
        
        plot([ma ma(1)]+[x x(1)],size(im,2)-([mb mb(1)]+[y y(1)]),'r-','Linewidth',2)
        text(60,100,num2str(round(CFI.Rf)),'FontSize',fs,'FontWeight','bold')
        text(60,210,'{\it R}_f','FontSize',fs-6)
        text(60,1500,[num2str(round(CFI.Tcp)),' K'],'FontSize',fs,'FontWeight','bold')
        text(60,1400,'CCT','FontSize',fs-6)
        % gamut index
        Ar = polyarea(mar,mbr);
        At = polyarea(mat,mbt);
        Rg = 100.*At./Ar;
        text(1525,100,num2str(round(Rg)),'FontSize',fs,'FontWeight','bold','horizontalAlignment','right')
        text(1525,210,'{\it R}_g','FontSize',fs-6,'horizontalAlignment','right')
        % Duv
        text(1525,1500,num2str(CFI.Duv,'%1.4f'),'FontSize',fs,'FontWeight','bold','horizontalAlignment','right')
        text(1525,1400,'{\it D}_{uv}','FontSize',fs-6,'horizontalAlignment','right')

    case 'CIE'
        % Plot
        R = 28;
        r = 2;
        plotcircle(0,0,R,'k:')
        axis equal
        hold on
        % theta angles for hue groups
        theta = deg2rad((0:45:359)+22.5);
        [x,y] = pol2cart(theta,R);
        % hue groups
        hg = [1 14;15 30;31 47;48 57;58 69;70 80;81 88;89 99];
        % plot hue groups
        ma = zeros(1,length(theta));
        mb = zeros(1,length(theta));
        for n = 1:length(theta)
            % plot hue circle with r = 2
            plotcircle(x(n),y(n),r,'k-')
            % plot hue shift points
            plot(a(hg(n,1):hg(n,2))+x(n),b(hg(n,1):hg(n,2))+y(n),'k.')
            % determine hue shift mean
            ma(n) = mean(a(hg(n,1):hg(n,2)));
            mb(n) = mean(b(hg(n,1):hg(n,2)));
            % plot arrow of hue group shift
            quiver(x(n),y(n),ma(n),mb(n),0,'LineWidth',2,'Color','k');
        end

        % apperance
        a = 40;
        axis([-a a -a a])
end

hold off
xticks([])
yticks([])
%xlabel('a''')
%ylabel('b''')