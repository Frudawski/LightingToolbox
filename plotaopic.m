% plot aopic-image from the AO-dosimeter
%
% usage: plotaopic(im,mode,rotation)
%
% where: mode: specifies the plot mode:
%           - 'aopic' for sc,mc,lc,rh,mel and VL plot (default)
%           - 'sc' for short cone plot only
%           - 'mc' for middle cone plot only
%           - 'lc' for long cone plot only
%           - 'rh' for rhodopic plot only
%           - 'mel' for melanopic plot only
%           - 'VL' for luminance V(lambda) plot only
%        rotation: image rotation in 90 degree steps
%
% Reference:
% CIE S 026/E:2018: CIE System for Metrology of Optical Radiation for ipRGC-
% Influenced Responses to Light. Commission International de l’Éclairage (CIE),
% Vienna Austria, 2018, (DOI: 10.25039/S026.2018).
% https://cie.co.at/publications/cie-system-metrology-optical-radiation-iprgc-influenced-responses-light-0
%
% Author: Frederic Rudawski
% Date: 17.12.2021, edited: 14.01.2022
% See: https://www.frudawski.de/plotaopic

function plotaopic(aopic,channel,mode,rotation)

if ~exist('channel','var')
    channel = 'aopic';
end
if ~exist('mode','var')
    mode = 'log';
end
if ~exist('rotation','var')
    rotation = 0;
end
aopic = rot90(aopic,rotation);

maxalpha = max(max(max(aopic(:,:,1:5))));

strt = {'sc','mc','lc','rh','mel','v'};

switch channel
    case 'aopic'
        a = zeros(5,2);
        for n = 1:6
            subplot(2,3,n)
            if n ~=6
              plotfalsecolours(aopic(:,:,n),mode,["L_{e,",strt{n},"} in W m^{-2}"])
            else
              plotfalsecolours(aopic(:,:,n),mode,["L_{",strt{n},"} in cd m^{-2}"])
            end
            title(['L_{e,',strt{n},'}'])
            %axis off
            %axis equal
            %colorbar
            a(n,:) = caxis;
            if strcmp(mode,'lin')
              caxis([a(n,1) maxalpha])
            end
        end
        if strcmp(mode,'lin')
            caxis([a(n,1) inf])
        end
        % same axis limits octave friendly
        if strcmp(mode,'log')
          for n = 1:5
            subplot(2,3,n)
            c = colorbar;
            caxis([a(n,1) max(a(1:5,2))])
            
            ex1 = min(a(1:5,1));
            ex2 = max(a(1:5,2));  

            ex = 10.^(ex1:ex2);
            num_of_ticks = numel(ex);
            Ticks = log10(ex);
            TickLabels = ex;
            c = colorbar;
            set(c,'ytick',Ticks)
            set(c,'yticklabel',TickLabels)
            caxis([Ticks(1) Ticks(end)])
          end
        end
    case 'sc'
        plotfalsecolours(aopic(:,:,1),mode,["L_{e,",channel,"} in W m^{-2}"])
        title('L_{e,sc}')
        %axis off
        %axis equal
        %colorbar
    case 'mc'
        plotfalsecolours(aopic(:,:,2),mode,["L_{e,",channel,"} in W m^{-2}"])
        title('L_{e,mc}')
        %axis off
        %axis equal
        %colorbar
    case 'lc'
        plotfalsecolours(aopic(:,:,3),mode,["L_{e,",channel,"} in W m^{-2}"])
        title('L_{e,lc}')
        %axis off
        %axis equal
        %colorbar
    case 'rh'
        plotfalsecolours(aopic(:,:,4),mode,["L_{e,",channel,"} in W m^{-2}"])
        title('L_{e,rh}')
        %axis off
        %axis equal
        %colorbar
    case 'mel'
        plotfalsecolours(aopic(:,:,5),mode,["L_{e,",channel,"} in W m^{-2}"])
        title('L_{e,mel}')
        %axis off
        %axis equal
        %colorbar
    case 'VL'
        plotfalsecolours(aopic(:,:,6),mode,["L_{v} in cd m^{-2}"])
        title('L_{v}')
        %axis off
        %axis equal
        %colorbar
    otherwise
        error(['Mode ',mode,' not valid plot mode in plotaopic.'])
        
end