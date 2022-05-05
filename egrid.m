% egrid returns a mesurement grid according to DIN 5035-6 or EN 12464,
% with the corresponding measurement points for a given measurement area.
%
% usage: [x,y,numx,numy] = DINgrid(width,length,border,mode,[numx numy])
%
% where: - x and y are the meshpoints coordinates matrices in m
%        - numx and numy are the number of points in x and y dimension
%          can also be used as input arguments (ignoring mode setting)
%        - width is the length of the meshgrid in x dimension in m
%        - length is the length of the meshgrid in y dimension in m
%        - border defines a peripheral zone which is not considered for the
%          meshgrid
%        - mode defines the grid resolution:
%           - 'odd' creates a meshgrid according to DIN 5035-6 with odd
%             numbers of measurement points
%           - 'std' creates a meshgrid according to DIN 12464 (part 1 & 2)
%              with odd or even numbers of measurement points
%
% References:
% Axel Werner Richard Stockmar: Basic concepts of computer aided Iighting design - 
% or how accurate are computer predicted photometrie values. In: CIE X005-1992:
% Proceedings of the CIE Seminar on Computer Programs for Light and Lighting,
% Commission Internationale de l'Eclairage (CIE), Vienna Austria, 1992, 
% ISBN: 978 3 900734 41 1.
% https://cie.co.at/publications/proceedings-cie-seminar-computer-programs-light-and-lighting-5-9-october-1992-vienna
%
% EN 12464-1:2021: Light and lighting - Lighting of work places - Part 1:
% Indoor work places. 2021.
% https://www.en-standard.eu/bs-en-12464-1-2021-light-and-lighting-lighting-of-work-places-indoor-work-places/
%
% Author: Frederic Rudawski
% Date: 10.06.2020 - last edited: 16.07.2020
% See: https://www.frudawski.de/egrid

function [xq,yq,dn,bn] = egrid(d,b,border,mode,sizexy)

if ~exist('mode','var')
    mode = 'std';
end

if ~exist('border','var')
    bz = 0;
else
    bz = border;
end

d = d-2*bz;
b = b-2*bz;

[v,idx] = sort([d b]);

if isequal(idx(2),2)
    x = b;
    if v(2)/v(1)>2
        x = d;
    end
else
    x = d;
    if v(1)/v(2)>2
        x = b;
    end
end

if isequal(x,0)
    xq = NaN;
    yq = NaN;
    dn = 0;
    bn = 0;
    return
end

p = 0.2*5^(log10(x));
p = real(p);

if p > 10
    p = 10;
end

switch mode
    case 'odd'
        dn = round(d/p);
        if isequal(mod(dn,2),0)
            dn  = dn+1;
        end
    case 'std'
        dn = round(d/p);
    case 'up'
        dn = ceil(d/p);
    otherwise
        error(['mode "',mode,'" not valid input parameter.'])
end

switch mode
    case 'odd'
        bn = ceil(b/p);
        if isequal(mod(bn,2),0)
            bn = bn+1;
        end
    case 'std'
        bn = round(b/p);
    case 'up'
        bn = ceil(b/p);
end

if d/dn > p
    dw = p;
else
    dw = d/dn;
end
if b/bn > p
    bw = p;
else
    bw = b/bn;
end

if exist('sizexy','var')
        bn = sizexy(2);
        bw = b/bn;
        dn = sizexy(1);
        dw = d/dn;
end

rgrid = linspace(dw/2,d-dw/2,dn)+bz;
zgrid = linspace(bw/2,b-bw/2,bn)+bz;

[xq,yq] = meshgrid(rgrid,zgrid);


