% CIE general sky:
% The function calculates the relative luminance distribution of a given
% cie standard general sky and sun position for a Tregenza hemisphere with
% 145 patches.
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage: L = ciesky(type,sun_azimuth,sun_elevation,'target',value,'mode',value)
%
% with:
% - L: Tregenza luminance distribution, columnwise
% - type: cie sky type (1-15), multiple sky types as vector
% - sun_azimuth: sun azimuth angle in °. The azimuth angle starts in north
%   and goes clockwise.
% - sun_elevation: sun eleavation angle in °
% - target (optional): valid values:
%                      - target unit, zenith luminance 'Lz' or
%                      - horizontal illuminance 'Eh'
% - mode (otional): valid values:
%                   - 'center' uses patch center for luminance determination
%                   - 'mean' uses mean of patchcorner luminances as suggestes
%                      by Tregenza in Tregenza, P. R. (2004). "Analysing sky 
%                      luminance scans to obtain frequency distributions of CIE
%                      Standard General Skies"
%
% References:
% ISO 15469:2004(E)/CIE S 011/E:2003: Spatial Distribution of Daylight - 
% CIE Standard General Sky. Commission Internationale de l'Éclairage (CIE),
% Vienna Austria, 2004.
% https://cie.co.at/publications/spatial-distribution-daylight-cie-standard-general-sky
%
% Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103).
% https://journals.sagepub.com/doi/10.1177/096032718701900103
%
% author: Frederic Rudawski
% date: 17.02.2021 - last edited: 11.03.2021
% See: https://www.frudawski.de/ciesky

function L = ciesky(type,sunaz,sunel,varargin)

p = inputParser;
validVar = @(f) isnumeric(f) || isvector(f);
addRequired(p,'type',validVar);
addRequired(p,'sunaz',@isnumeric);
addRequired(p,'sunel',@isnumeric);
addParameter(p,'Lz',1,@isnumeric)
addParameter(p,'Eh',-1,@isnumeric)
addParameter(p,'mode','center')
parse(p,type,sunaz,sunel,varargin{:})

Lz = p.Results.Lz;
Eh = p.Results.Eh;

% cie table parameters: a, b, c, d, e
% ISO 15469:2004, Spatial Distribution of Daylight - CIE Standard General Sky.
cietable = [4   -0.7  0   -1    0;
    4   -0.7  2 -1.5 0.15;
    1.1 -0.8  0   -1    0;
    1.1 -0.8  2 -1.5 0.15;
    0     -1  0   -1    0;
    0     -1  2 -1.5 0.15;
    0     -1  5 -2.5 0.30;
    0     -1 10 -3.0 0.45;
    -1 -0.55  2 -1.5 0.15;
    -1 -0.55  5 -2.5 0.30;
    -1 -0.55 10 -3.0 0.45;
    -1 -0.32 10 -3.0 0.45;
    -1 -0.32 16 -3.0 0.30;
    -1 -0.15 16 -3.0 0.30;
    -1 -0.15 24 -2.8 0.15
    ];

% Tregenza table:
tregenza = [180,192,204,216,228,240,252,264,276,288,300,312,324,336,348,0,12,24,36,48,60,72,84,96,108,120,132,144,156,168,168,156,144,132,120,108,96,84,72,60,48,36,24,12,0,348,336,324,312,300,288,276,264,252,240,228,216,204,192,180,180,195,210,225,240,255,270,285,300,315,330,345,0,15,30,45,60,75,90,105,120,135,150,165,165,150,135,120,105,90,75,60,45,30,15,0,345,330,315,300,285,270,255,240,225,210,195,180,180,200,220,240,260,280,300,320,340,0,20,40,60,80,100,120,140,160,150,120,90,60,30,0,330,300,270,240,210,180,180,240,300,0,60,120,0;6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,66,66,66,66,66,66,66,66,66,66,66,66,78,78,78,78,78,78,90];
%azinc = [12 12 15 15 20 30 60];

if strcmp(p.Results.mode,'center')
    tregenza = deg2rad(tregenza);
    % sky types 1-15
    if type > 0 && type < 16
        
        % parameters
        a = cietable(type,1);
        b = cietable(type,2);
        c = cietable(type,3);
        d = cietable(type,4);
        e = cietable(type,5);
        
        % angles
        sunel = deg2rad(sunel);
        sunaz = deg2rad(sunaz);
        Z  = pi/2-tregenza(2,:);
        Zs = pi/2-sunel;
        x  = acos(cos(Z).*cos(Zs) + sin(Z).*sin(Zs).*cos(abs(tregenza(1,:)-sunaz)));
        
        % indicatrix and gradation
        phi0 = 1+a.*exp(b);
        phiZ = 1 + a.*exp(b./cos(Z));
        fx   = 1 + c.*(exp(d.*x)-exp(d.*pi./2))+e.*cos(x).^2;
        fZs  = 1 + c.*(exp(d.*Zs)-exp(d.*pi./2))+e.*cos(Zs).^2;
        
        % relative luminance
        L = [(fx.*phiZ./fZs./phi0).*Lz]';
        
        % sky type 16: traditional overcast sky
    elseif type == 16
        L = [(1+2.*sin(tregenza(2,:)))./3]';
    else
        error(['Sky type ',num2str(type),' not defined.'])
    end
elseif strcmp(p.Results.mode,'mean')
    % sky types 1-15
    if type > 0 && type < 16
        
        % parameters
        a = cietable(type,1);
        b = cietable(type,2);
        c = cietable(type,3);
        d = cietable(type,4);
        e = cietable(type,5);
        
        % angles
        sunel = deg2rad(sunel);
        sunaz = deg2rad(sunaz);
        angZ = [tregenza(2,1:144)'-6 tregenza(2,1:144)'-6 tregenza(2,1:144)'+6 tregenza(2,1:144)'+6]';
        angZ = angZ(:);
        %angZ = [angZ;repmat(90,1,4*6)'];
        angZ = deg2rad(angZ);
        Z  = pi/2-angZ;
        Z = reshape(Z,4,144)';
        Zs = pi/2-sunel;
        angF = [tregenza(1,1:144)'-6 tregenza(1,1:144)'-6 tregenza(1,1:144)'+6 tregenza(1,1:144)'+6]';
        angF = angF([1 3 2 4],:);
        angF = angF(:);
        %angF = [angF;repelem(3:60:360,1,4)'];
        angF = reshape(angF,4,144)';
        angF(angF<0) = angF(angF<0)+360;
        angF(angF>360) = angF(angF>360)-360;
        angF = deg2rad(angF);
        x  = acos(cos(Z).*cos(Zs) + sin(Z).*sin(Zs).*cos(abs(angF-sunaz)));
        
        % indicatrix and gradation
        phi0 = 1+a.*exp(b);
        phiZ = 1 + a.*exp(b./cos(Z));
        fx   = 1 + c.*(exp(d.*x)-exp(d.*pi./2))+e.*cos(x).^2;
        fZs  = 1 + c.*(exp(d.*Zs)-exp(d.*pi./2))+e.*cos(Zs).^2;
        
        % relative luminance
        L = (fx.*phiZ./fZs./phi0);%.*Lz;
        L = mean(L,2);
        %L = [L(1:144); mean(L(145:end))];
        
        M = deg2rad([30:60:360 0 0 0;ones(1,6).*84 90 90 90]);
        Z  = pi/2-M(2,:);
        x  = acos(cos(Z).*cos(Zs) + sin(Z).*sin(Zs).*cos(abs(M(1,:)-sunaz)));
        phiZ = 1 + a.*exp(b./cos(Z));
        fx   = 1 + c.*(exp(d.*x)-exp(d.*pi./2))+e.*cos(x).^2;
        L145 = mean(fx.*phiZ./fZs./phi0);
        
        L = [L; L145]./L145;
        
        % sky type 16: traditional overcast sky
    elseif type == 16
        angZ = [tregenza(2,1:144)'-6 tregenza(2,1:144)'-6 tregenza(2,1:144)'+6 tregenza(2,1:144)'+6]';
        angZ = angZ(:);
        angZ = [angZ;repmat(90,1,4*6)'];
        angZ = deg2rad(angZ);
        angZ = reshape(angZ,4,150)';
        L = (1+2.*sin(angZ))./3;
        L = [mean(L(1:144,:),2); mean(mean(L(145:150,:)))];
    else
        error(['Sky type ',num2str(type),' not defined.'])
    end
else
    error(['Mode "',p.Results.mode,'" not supported.'])
end
% absolute values
if ~isequal(Eh,-1)
    E = polardataE(L,[]);
    L = L.*Eh./E;
end

