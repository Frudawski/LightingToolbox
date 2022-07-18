% CIE skytype determination after Kobav et al.
% Characterization of sky scanner measurements based on CIE and ISO standard CIE S 011/2003
% DOI: 10.1177/1477153512458916
%
% usage: [sky,rms] = kobavskytype(data,az,el,mode)
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
% Kobav M, Bizjak G, Dumortier D.: Characterization of sky scanner measurements
% based on CIE and ISO standard CIE S 011/2003. In: Lighting Research & Technology,
% vol. 45, no. 4, pp. 504–512, 2012, (DOI: 10.1177/1477153512458916).
% https://journals.sagepub.com/doi/10.1177/1477153512458916?icid=int.sj-abstract.citing-articles.1
%
% Author: Frederic Rudawski
% Date: somewhat 2015
% See: https://www.frudawski.de/kobavskytype

function [Sky,rms,sky] = kobavskytype(data,az,el,mode)
% Some messy code, grown over time without much expirience:

if ~exist('mode','var')
    mode = 'cie';
end

% Tregenza patch angles
azimuths = [180 192 204 216 228 240 252 264 276 288 300 312 324 336 348 0 12 24 36 48 60 72 84 96 108 120 132 144 156 168 168 156 144 132 120 108 96 84 72 60 48 36 24 12 0 348 336 324 312 300 288 276 264 252 240 228 216 204 192 180 180 195 210 225 240 255 270 285 300 315 330 345 0 15 30 45 60 75 90 105 120 135 150 165 165 150 135 120 105 90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 180 200 220 240 260 280 300 320 340 0 20 40 60 80 100 120 140 160 150 120 90 60 30 0 330 300 270 240 210 180 180 240 300 0 60 120 0];
elevations = [ones(1,30).*6 ones(1,30).*18 ones(1,24).*30 ones(1,24).*42 ones(1,18).*54 ones(1,12).*66 ones(1,6).*78 90 90 90 90 90 90];
% sun position
if ~exist('az','var')
    meridian = data.sunAzimuth;
    azimuth = data.sunAzimuth;
    elevation = data.sunElevation;
else
    azimuth = az;
    meridian = az;
    elevation = el;
    L = data;
    data = [];
    data.L = L;
    data.missing = [];
    data.numMissing = 0;
end
% find best fitting gradation patches

% with 6 degree almucantar?
%if get(handles.Degree6,'Value') == 0
clear Almucantar;
Almucantar = [90 78 66 54 42 30 18];
%else
%    clear Almucantar;
%    Almucantar = [90 78 66 54 42 30 18 6];
%end

% elevation to high?
limit = 90-2*(90-elevation);
if limit > 18
    clear Almucantar;
    Almucantar = [90 78 66 54 42 30 18];
end
if limit > 30
    clear Almucantar;
    Almucantar = [90 78 66 54 42 30];
end
if limit > 42
    clear Almucantar;
    Almucantar = [90 78 66 54 42];
end
if limit > 54
    clear Almucantar;
    Almucantar = [90 78 66 54];
end
if limit > 66
    clear Almucantar;
    Almucantar = [90 78 66];
end
if limit > 78
    clear Almucantar;
    Almucantar = [90 78];
end

% UNDER 180 DEG MERIDIAN
count = 1;
% test if meridian is over 180 deg
if meridian <= 180
    % before meridian
    for i = 2:size(Almucantar,2) % for all almucantars except zenith and maybe 6 degree almucantar
        patch = 145; % initialize patch to zenith
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1: 145
            % check for correct almucantar
            if Almucantar(i) == elevations(j)
                % check half before meridian
                if ((azimuths(j) >= 0) && (azimuths(j) < meridian)) || ((azimuths(j) >= meridian+180) && (azimuths(j) < 360))
                    % define parameters
                    a = deg2rad(90-Almucantar(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    % Distance Sun to zenith
                    DistanceSunToZenith = b;
                    if abs(DistanceSunToZenith-DistanceSunToPatch) < Difference
                        Difference = abs(DistanceSunToZenith-DistanceSunToPatch);
                        patch = j;
                        relativeGradation(count) = data.L(j)/data.L(145);
                    end
                end
            end
        end
        differenceGradation(count)  = Difference;
        patchGradation(count) = patch;
        %handles.GradationLineDistance(count) = GradationLineDistance;
        count = count + 1;
    end
    % plotgradation zenit point
    % over meridian
    for i = 2:size(Almucantar,2) % for all almucantars except zenith and maybe 6 degree almucantar
        patch = 145; % initialize patch to zenith
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1: 145
            % check for correct almucantar
            if Almucantar(i) == elevations(j)
                % check half after meridian
                if (azimuths(j) >= meridian) && (azimuths(j) < meridian+180)
                    % define parameters
                    a = deg2rad(90-Almucantar(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    % Distance Sun to zenith
                    DistanceSunToZenith = b;
                    if abs(DistanceSunToZenith-DistanceSunToPatch) < Difference
                        for p = 1:size(Almucantar,2)-1  % check if patch is already in list
                            if patchGradation(p) ~= j
                                Difference = abs(DistanceSunToZenith-DistanceSunToPatch);
                                patch = j;
                                relativeGradation(count) = data.L(j)/data.L(145);
                            end
                        end
                    end
                end
            end
        end
        differenceGradation(count)  = Difference;
        patchGradation(count) = patch;
        count = count + 1;
    end
end

% OVER 180 DEG MERIDIAN
if meridian > 180
    % before meridian
    for i = 2:size(Almucantar,2) % for all almucantars except zenith and maybe 6 degree almucantar
        patch = 145; % initialize patch to zenith
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1:145
            % check for correct almucantar
            if Almucantar(i) == elevations(j)
                % check half before meridian
                if ((azimuths(j) >= meridian-180) && (azimuths(j) < meridian))
                    % define parameters
                    a = deg2rad(90-Almucantar(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    % Distance Sun to zenith
                    DistanceSunToZenith = b;
                    if abs(DistanceSunToZenith-DistanceSunToPatch) < Difference
                        Difference = abs(DistanceSunToZenith-DistanceSunToPatch);
                        patch = j;
                        relativeGradation(count) = data.L(j)/data.L(145);
                    end
                end
            end
        end
        differenceGradation(count)  = Difference;
        patchGradation(count) = patch;
        count = count + 1;
    end
    % plotgradation zenit point
    % over meridian
    for i = 2:size(Almucantar,2) % for all almucantars except zenith and maybe 6 degree almucantar
        patch = 145; % initialize patch to zenith
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1: 145
            % check half after meridian
            if Almucantar(i) == elevations(j)
                % check for left side of Sphere
                if ((azimuths(j) >= meridian) && (azimuths(j) < 360)) || ((azimuths(j) >= 0) && (azimuths(j) < meridian-180))
                    % define parameters
                    a = deg2rad(90-Almucantar(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    % Distance Sun to zenith
                    DistanceSunToZenith = b;
                    if abs(DistanceSunToZenith-DistanceSunToPatch) < Difference
                        for p = 1:size(Almucantar,2)-1  % check if patch is already in list
                            if patchGradation(p) ~= j
                                Difference = abs(DistanceSunToZenith-DistanceSunToPatch);
                                patch = j;
                                relativeGradation(count) = data.L(j)/data.L(145);
                            end
                        end
                    end
                end
            end
        end
        differenceGradation(count)  = Difference;
        patchGradation(count) = patch;
        count = count + 1;
    end
end

% check for errorneous patches - if so, use the other one in same alumcantar
ovrvector = find(data.missing);
gradationOverrange = zeros(1,14); % for overrange test
for i = 1:max(size(ovrvector))
    for j = 1:size(patchGradation,2)
        if ~isempty(ovrvector)
            if patchGradation(1,j) == ovrvector(i)
                gradationOverrange(1,j) = 1;
                patchGradation(1,j) = 0; % set for non existing skypatch for elipse plot
            end
        end
    end
end
% zero value?
for j = 1:size(relativeGradation,2)
    if relativeGradation(1,j) == 0
        gradationOverrange(1,j) = 1;
        patchGradation(1,j) = 0; % set for non existing skypatch for elipse plot
    end
end

% mean Value of the 2 plotgradation patches & Overange behaviour
GRADATION = [];
GRADATION(1) = 1; % zenith value = 1
ErrorGradation = zeros(size(Almucantar)); % Indicator if both patches are overranged or zero valued
for i=1:size(Almucantar,2)-1
    if (gradationOverrange(1,i) == 0) && (gradationOverrange(1,i+size(Almucantar,2)-1) == 0)
        GRADATION(i+1) = (relativeGradation(i)+relativeGradation(i+size(Almucantar,2)-1)) / 2;
        %disp('NO OVR');
    end
    if (gradationOverrange(1,i) == 0) && (gradationOverrange(1,i+size(Almucantar,2)-1) == 1)
        GRADATION(i+1) = relativeGradation(i);
        %disp('first OVR');
    end
    if (gradationOverrange(1,i) == 1) && (gradationOverrange(1,i+size(Almucantar,2)-1) == 0)
        GRADATION(i+1) = relativeGradation(i+size(Almucantar,2)-1);
        %disp('second OVR');
    end
    if (gradationOverrange(1,i) == 1) && (gradationOverrange(1,i+size(Almucantar,2)-1) == 1)
        GRADATION(i+1) = NaN;
        ErrorGradation(1,i+1) = 1;
        %disp('both OVR');
    end
end

% GRADTION GROUP
NewGRADATION = NaN; % initialisation
counting = 1;
for p = 1:size(Almucantar,2)
    if ErrorGradation(1,p) == 0
        %ErrorGradation(1,l)
        NewAlmucantar(counting) = Almucantar(p);
        NewGRADATION(counting) = GRADATION(p);
        counting = counting + 1;
    end
end

Z = abs(NewAlmucantar-90); % zenit angle
RMSdifference = 1000000; % big number for initialisation
GradationGroup = NaN;

CIEa = [4 1.1 0 -1 -1 -1];
CIEb = [-0.7 -0.8 -1 -0.55 -0.32 -0.15];
CIEc = [0 2 5 10 16 24];
CIEd = [-1 -1.5 -2.5 -3 -3 -2.8];
CIEe = [0 0.15 0.3 0.45 0.3 0.15];

for k = 1:6 % for all 6 groups
    % plotgradation function from CIE
    PHI = 1 + CIEa(k).*exp(CIEb(k)./cos(deg2rad(Z(1,1:size(NewAlmucantar,2)))));
    PHINULL = 1+CIEa(k).*exp(CIEb(k));
    phi = PHI/PHINULL;
    
    % Root mean square values -> RMS
    %RMSdiff = abs(sqrt(mean(abs(log10(abs(phi))-log10(abs(NewGRADATION))).^2)));
    RMSdiff = abs(sqrt(mean(abs((abs(phi))-(abs(NewGRADATION))).^2)));
    
    if abs(RMSdiff) < abs(RMSdifference)
        RMSdifference = RMSdiff;
        GradationGroup = k;
    end
end

% if one entry of Gradation is NaN set GRADATION NaN
if sum(isnan(GRADATION)) > 0
    GradationGroup = NaN; %
end

% save gradation rms
k = GradationGroup;
RMS(1) = NaN;
RMSD(1) = NaN;
Gradation_R = NaN;
if ~isnan(k)
    PHI = 1 + CIEa(k).*exp(CIEb(k)./cos(deg2rad(Z(1,1:size(NewAlmucantar,2)))));
    PHINULL = 1+CIEa(k).*exp(CIEb(k));
    phi = PHI/PHINULL;
    %RMSdiff = abs(sqrt(mean(abs(log10(abs(phi))-log10(abs(NewGRADATION))).^2)));
    RMSdiff = abs(sqrt(mean(abs(abs(phi)-abs(NewGRADATION)).^2)));
    RMS(1) = RMSdiff;
    
    k = GradationGroup;
    PHI = 1 + CIEa(k).*exp(CIEb(k)./cos(deg2rad(Z(1,1:size(NewAlmucantar,2)))));
    PHINULL = 1+CIEa(k).*exp(CIEb(k));
    phi = PHI/PHINULL;
    SSR = sum ((NewGRADATION - mean(phi)).^2);
    SSE = sum ((NewGRADATION - phi).^2);
    Gradation_R = (SSR/(SSE+SSR))^(1/2);
    RMSD = abs(sqrt(mean(abs((abs(phi))-(abs(NewGRADATION))).^2)));
    RMSD(1) = RMSD/mean(NewGRADATION);
end

sky.gradation = GradationGroup;
sky.RMSD_grad = RMS(1);
sky.NRMSD_grad = RMSD(1);
patchGradation(patchGradation==0) = [];
sky.grad_patches = patchGradation;
sky.grad_values = NewGRADATION;
sky.R_grad = Gradation_R;

% indicatrix Group
OverrangeVector = find(data.missing);
if isempty(OverrangeVector)
    OverrangeVector = 0;
end

% initialisation
L90 = zeros(2,6);

count = 1;

%if get(handles.Degree6,'Value') == 0
Almucantars = [18 30];
%else
%    Almucantars = [6 18 30];
%end

% if elevation is to high delete values of to high almucantar
if elevation > 60
    temp = Almucantars;
    clear Almucantars;
    for n = 1:size(temp,2)-1
        Almucantars(n) = temp(n);
    end
end
if elevation > 72
    Almucantars = 6; % must be 6 even if it is excluded
end

% for meridian over 180 deg
if meridian > 180
    for i = 1:size(Almucantars,2) % for  almucantars 6-30 if not 6 deg is excluded
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1:145
            if Almucantars(i) == elevations(j)
                % check for Overranged Patch
                overranged = 0;
                CheckSize = size(OverrangeVector);
                for check = 1:CheckSize(2)
                    if OverrangeVector(check) == j
                        overranged = 1;
                    end
                end
                % check after meridian
                if ((azimuths(j) >= meridian) && (azimuths(j) < 360)) || ((azimuths(j) >= 0) && (azimuths(j) < meridian-180)) && data.L(j) ~= 0 && overranged ~= 1
                    if data.L(j) ~= 0
                        % define parameters
                        a = deg2rad(90-Almucantars(i));
                        b = deg2rad(90-elevation);
                        gamma = deg2rad(azimuth - azimuths(j));
                        % Seiten Cosinus Satz
                        DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                        Distance90 = deg2rad(90);
                        % smallest difference
                        if abs(Distance90-abs(DistanceSunToPatch)) < Difference
                            Difference = abs(Distance90-abs(DistanceSunToPatch));
                            L90(1,count) = j; % patchnumber
                            %L90(2,count) = data.L(j); % normalizing luminance
                            L90(3,count) = Difference;
                            %L90(4,count) = rad2deg(gamma);
                        end
                    end
                end
            end
        end
        count = count + 1;
    end
    for i = 1:size(Almucantars,2) % for  almucantars 6-30 if not 6 deg is excluded
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1:145
            if Almucantars(i) == elevations(j)
                % check for Overranged Patch
                overranged = 0;
                CheckSize = size(OverrangeVector);
                for check = 1:CheckSize(2)
                    if OverrangeVector(check) == j
                        overranged = 1;
                    end
                end
                % check before meridian
                if ((azimuths(j) >= meridian-180) && (azimuths(j) < meridian))  && data.L(j) ~= 0 && overranged ~= 1
                    % define parameters
                    a = deg2rad(90-Almucantars(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    %gamma = rad2deg(gamma) % debug
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    Distance90= pi/2;
                    % smallest difference
                    if abs(Distance90-DistanceSunToPatch) < Difference
                        getSizeAgain = size(L90);
                        for p = 1:getSizeAgain(2)
                            if L90(1,p) ~= j
                                Difference = abs(Distance90-DistanceSunToPatch);
                                L90(1,count) = j; % patchnumber
                                %L90(2,count) = data.L(j); % normalizing luminance
                                L90(3,count) = Difference;
                            end
                        end
                    end
                end
            end
        end
        count = count + 1;
    end
end

% for meridian under 180 deg
if meridian < 180
    for i = 1:size(Almucantars,2) % for  almucantars 6-30 if not 6 deg is excluded
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1:145
            if Almucantars(i) == elevations(j)
                % check for Overranged Patch
                overranged = 0;
                for check = 1:data.numMissing
                    if OverrangeVector(check) == j
                        overranged = 1;
                    end
                end
                % check after meridian
                if ((azimuths(j) >= meridian) && (azimuths(j) < meridian+180))  && data.L(j) ~= 0 && overranged ~= 1
                    % define parameters
                    a = deg2rad(90-Almucantars(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    Distance90 = deg2rad(90);
                    % smallest difference
                    if abs(Distance90-abs(DistanceSunToPatch)) < Difference
                        Difference = abs(Distance90-abs(DistanceSunToPatch));
                        L90(1,count) = j; % patchnumber
                        %L90(2,count) = data.L(j); % normalizing luminance
                        L90(3,count) = Difference;
                    end
                end
            end
        end
        count = count + 1;
    end
    for i = 1:size(Almucantars,2) % for  almucantars 6-30 if not 6 deg is excluded
        Difference = 1000000; % just a big number for initilisation
        % for all patches
        for j = 1:145
            if Almucantars(i) == elevations(j)
                % check for Overranged Patch
                overranged = 0;
                CheckSize = size(OverrangeVector);
                for check = 1:CheckSize(2)
                    if OverrangeVector(check) == j
                        overranged = 1;
                    end
                end
                % check before meridian
                if ((azimuths(j) >= meridian+180) && (azimuths(j) < 360)) || ((azimuths(j) >= 0) && (azimuths(j) < meridian))  && data.L(j) ~= 0 && overranged ~= 1
                    % define parameters
                    a = deg2rad(90-Almucantars(i));
                    b = deg2rad(90-elevation);
                    gamma = deg2rad(azimuth - azimuths(j));
                    % Seiten Cosinus Satz
                    DistanceSunToPatch = acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma));
                    Distance90= pi/2;
                    % smallest difference
                    if abs(Distance90-DistanceSunToPatch) < Difference
                        getSizeAgain = size(L90);
                        for p = 1:getSizeAgain(2)
                            if L90(1,p) ~= j
                                Difference = abs(Distance90-DistanceSunToPatch);
                                L90(1,count) = j; % patchnumber
                                %L90(2,count) = data.L(j); % normalizing luminance
                                L90(3,count) = Difference;
                            end
                        end
                    end
                end
            end
        end
        count = count + 1;
    end
end

%{
% Overrange test for plotindicatrix L90 normalizing patch
for k = 1:size(L90,2)
    for p = 1:data.numMissing
        if OverrangeVector(p) == L90(1,k) || L90(2,k) == 0
            % set patch number to non existing and clear values
            L90(:,k) = 0;
        end
    end
end


% replace Overranged patches
for i = 1:size(L90,2)/2
    if L90(1,i) == 0
        L90(:,i) = L90(:,i+size(L90,2)/2);
    end
end

%L90 = zeros(1,size(Almucantars,2));
% Calculate correct normalizing patch for plotindicatrix
%L90(1,:) = Almucantars;
for j = 1:size(L90,2)/2
    L90(2,j) = (L90(2,j)+L90(2,j+size(L90,2)/2))/2;
end
%}

% L90 L correct value
patch_L90 = L90(1,:);
patch_L90(patch_L90==0) = [];
patch_L90(isnan(patch_L90)) = [];
ind_L90 = data.L(patch_L90)';
ind_L90(ind_L90==0) = [];
ind_left  = ind_L90(1:size(ind_L90,2)/2);
ind_right = ind_L90(size(ind_L90,2)/2+1:end);
ind_left(isnan(ind_left)) = ind_right(isnan(ind_left));
ind_right(isnan(ind_right)) = ind_left(isnan(ind_right));
L90_mean = mean([ind_left; ind_right],1);
if isequal(size(L90_mean,2),1)
    L90_mean = [L90_mean NaN];
end
% getting plotindicatrix values
% Initialize
f6  = [];
f18 = [];
f30 = [];
testvar = 0;

if data.numMissing > 0
    OVERRANGE = 1;
else
    OVERRANGE = 0;
end

for n = 1:size(Almucantars,2) % for the used Almucantars
    counter = 1;
    for m = 1:84 % all skypatches on almucantar 6-30 deg
        if Almucantars(n) == elevations(m) % test for correct Almucantar
            % test for Overrange or stupid zero value
            if OVERRANGE == 1
                testvar = 0;
                theOVRSize = size(OverrangeVector);
                for ovr = 1:theOVRSize(2)
                    if OverrangeVector(1,ovr) == m || data.L(m) == 0
                        testvar = 1;
                    end
                end
            end
            if Almucantars(n) == 6 && abs(azimuths(m)-meridian) <= 90 && abs(azimuths(m)-meridian) >= 15 && testvar == 0
                %f6(1,counter) = abs(handles.SkyVector(2,m)-rad2deg(meridian));
                % define parameters
                a = deg2rad(90-Almucantars(n));
                b = deg2rad(90-elevation);
                gamma = deg2rad(azimuth - azimuths(m));
                % Seiten Cosinus Satz
                f6(1,counter) = rad2deg(abs(acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma))));
                try
                    f6(2,counter) = data.L(m)/L90_mean(1,n);
                catch
                    f6(2,counter) = NaN;
                end
                counter = counter + 1;
            end
            if Almucantars(n) == 18  && abs(azimuths(m)-meridian) <= 90 && abs(azimuths(m)-meridian) >= 15 && testvar == 0
                %f18(1,counter) = abs(handles.SkyVector(2,m)-rad2deg(meridian));
                % define parameters
                a = deg2rad(90-Almucantars(n));
                b = deg2rad(90-elevation);
                gamma = deg2rad(azimuth - azimuths(m));
                % Seiten Cosinus Satz
                f18(1,counter) = rad2deg(abs(acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma))));
                try
                    f18(2,counter) = data.L(m)/L90_mean(1,n);
                catch
                    f18(2,counter) = NaN;
                end
                counter = counter + 1;
            end
            if Almucantars(n) == 30  && abs(azimuths(m)-meridian) <= 90 && abs(azimuths(m)-meridian) >= 15 && testvar == 0
                %f30(1,counter) = abs(handles.SkyVector(2,m)-rad2deg(meridian));
                % define parameters
                a = deg2rad(90-Almucantars(n));
                b = deg2rad(90-elevation);
                gamma = deg2rad(azimuth - azimuths(m));
                % Seiten Cosinus Satz
                f30(1,counter) = rad2deg(abs(acos(cos(a)*cos(b) + sin(a)*sin(b)*cos(gamma))));
                try
                    f30(2,counter) = data.L(m)/L90_mean(1,n);
                catch
                    f30(2,counter) = NaN;
                end
                counter = counter + 1;
            end
        end
    end
end


% Indicatrix
InCounter = 1; % counter for handles.IndicatrixGroup
IndicatrixGroup = NaN;

% delete NaN indicatrix patches
[~,c] = find(isnan(f6));
f6(:,c) = [];
[~,c] = find(isnan(f18));
f18(:,c) = [];
[~,c] = find(isnan(f30));
f30(:,c) = [];


% 6 deg Almucantar
InRMSdifference6 = 1000000; % big number for initialisation
if isempty(f6) == 0
    % get correct distances to L90 from each patch
    dx = deg2rad(f6(1,:));
    % rms for measured plotindicatrix of Almucantar 18 deg
    %rms_f18 = abs(sqrt(mean(f18(2,:).^2)));
    % calculate standard values for correct distance
    for k = 1:6 % for all 6 groups
        Indicatrixf = 1 + CIEc(k).*(exp(CIEd(k).*dx)-exp(CIEd(k).*pi./2))+CIEe(k)*cos(dx).^2;
        %fZ = 1+CIEc(k).*(exp(rad2deg(dZ))-exp(CIEd(k).*pi./2))+CIEe(k).*cos(dZ)^2;
        RMSdiff6 = sqrt(mean((f6(2,:)-Indicatrixf).^2));
        if RMSdiff < InRMSdifference6
            InRMSdifference6 = RMSdiff6;
            IndicatrixGroup(InCounter) = k;
        end
    end
    %InRMSdifference % debuging
    InCounter = InCounter + 1;
end
% 18 deg Almucantar
InRMSdifference18 = 1000000; % big number for initialisation
if isempty(f18) == 0
    % get correct distances to L90 from each patch
    dx = deg2rad(f18(1,:));
    % rms for measured plotindicatrix of Almucantar 18 deg
    %rms_f18 = abs(sqrt(mean(f18(2,:).^2)));
    % calculate standard values for correct distance
    for k = 1:6 % for all 6 groups
        Indicatrixf = 1 + CIEc(k).*(exp(CIEd(k).*dx)-exp(CIEd(k).*pi./2))+CIEe(k)*cos(dx).^2;
        %fZ = 1+CIEc(k).*(exp(rad2deg(dZ))-exp(CIEd(k).*pi./2))+CIEe(k).*cos(dZ)^2;
        RMSdiff18 = sqrt(mean((f18(2,:)-Indicatrixf).^2));
        if RMSdiff18 < InRMSdifference18
            InRMSdifference18 = RMSdiff18;
            IndicatrixGroup(InCounter) = k;
        end
    end
    %InRMSdifference % debuging
    InCounter = InCounter + 1;
end
% 30 deg Almucantar
InRMSdifference30 = 1000000; % big number for initialisation
if isempty(f30) == 0
    % get correct distances to L90 from each patch
    dx = deg2rad(f30(1,:));
    % rms for measured plotindicatrix of Almucantar 30 deg
    %rms_f30 = abs(sqrt(mean(f18(2,:).^2)));
    % calculate standard values for correct distance
    for k = 1:6 % for all 6 groups
        Indicatrixf = 1 + CIEc(k).*(exp(CIEd(k).*dx)-exp(CIEd(k).*pi./2))+CIEe(k)*cos(dx).^2;
        %fZ = 1+CIEc(k).*(exp(rad2deg(dZ))-exp(CIEd(k).*pi./2))+CIEe(k).*cos(dZ)^2;
        RMSdiff30 = sqrt(mean((f30(2,:)-Indicatrixf).^2));
        if RMSdiff30 < InRMSdifference30
            InRMSdifference30 = RMSdiff30;
            IndicatrixGroup(InCounter) = k;
        end
    end
    %InRMSdifference % debuging
    InCounter = InCounter + 1;
end


% debuging
%beforeMean = handles.IndicatrixGroup

% count plotindicatrix group solutions, most counts win...
IndicatrixCount = zeros(1,6);
for k = 1:size(IndicatrixGroup,2)
    for j = 1:6 % for all groups
        if IndicatrixGroup(k) == j
            IndicatrixCount(1,j) = IndicatrixCount(1,j) + 1;
        end
    end
end
%IndicatrixCount
% find maximum
maxi = 0;
for j = 1:6 % for all groups
    if IndicatrixCount(1,j) > maxi
        maxi = IndicatrixCount(1,j);
        IndicatrixGroup = j;
    end
end

% debuging
%afterMean = handles.IndicatrixGroup

%handles.IndicatrixGroup = 5

% save indicatrix rms
%handles.RMS(2) = 0;%InRMSdifference;
%[RMS, RMSindex] = min([InRMSdifference6 InRMSdifference18 InRMSdifference30])
k = IndicatrixGroup;
if isnan(f30) == 0
    if isnan(f18) == 0
        if isnan(f6) == 0
            IndicatrixFunction = [f6 f18 f30];
        else
            IndicatrixFunction = [f18 f30];
        end
    else
        IndicatrixFunction = f30;
    end
else
    IndicatrixFunction = [];
end
% RMS diff
%InRMSdifference6
%InRMSdifference18
%InRMSdifference30

% calculate R and (N)RMSD
%comeback('INDICATRIX RMS')
RMS(2) = NaN;
RMSD(2) = NaN;
Indicatrix_R = NaN;
if isempty(IndicatrixFunction) == 0 && isnan(IndicatrixGroup) == 0
    [sortedInd,sortindex] = sort(IndicatrixFunction(1,:));
    dx = deg2rad(sortedInd(1,:));
    %IndicatrixFunction(2,sortindex)
    Indicatrixf = 1 + CIEc(k).*(exp(CIEd(k).*dx)-exp(CIEd(k).*pi./2))+CIEe(k)*cos(dx).^2;
    SSR = sum ((IndicatrixFunction(2,sortindex) - mean(Indicatrixf)).^2);
    SSE = sum ((IndicatrixFunction(2,sortindex) - Indicatrixf).^2);
    Indicatrix_R = (SSR/(SSE+SSR))^(1/2);
    %handles.Indicatrix_R
    RMS(2) = sqrt(mean((IndicatrixFunction(2,sortindex)-Indicatrixf).^2));
    RMSD(2) = RMS(2)/mean(IndicatrixFunction(2,sortindex));
    % pearson correlation
    %{
    figure(11)
    plot(Indicatrixf,IndicatrixFunction(2,sortindex),'r*',Indicatrixf,Indicatrixf,'b:');
    legend(['R = ',num2str(handles.Indicatrix_R)], 'R = 1','Location','northwest');
    grid on
    title('Indicatrix pearson correaltion coefficient');
    ylabel('y');
    xlabel('x');
    %}
end
%guidata(hObject, handles);

sky.indicatrix = IndicatrixGroup;
sky.RMSD_ind = RMS(2);
sky.NRMSD_ind = RMSD(2);
sky.R_ind = Indicatrix_R;
L90 = L90(1,:);
L90(L90==0) = [];
L90(isnan(L90)) = [];
sky.ind_patches = L90(1,:);
sky.ind_values.firstAlmBand = f6;
sky.ind_values.secondAlmBand = f18;
sky.ind_values.thirdAlmBand = f30;


% CIE Skymodel table
% line 1: Typ
% line 2: plotgradation
% line 3: plotindicatrix
CIEModels = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15;
    1 1 2 2 3 3 3 3 4  4  4  5  5  6  6;
    1 2 1 2 1 2 3 4 2  3  4  4  5  5  6];

SkyModel = NaN;
for i = 1:15
    if CIEModels(2,i) == GradationGroup && CIEModels(3,i) == IndicatrixGroup
        SkyModel = i;
    end
end

NearestModels = ...
    [NaN 1 2 3 4  5  6;
    1 1 3 5 9  9  9;
    2 2 4 6 9  9  9;
    3 2 7 7 10 10 12;
    4 8 8 8 11 12 14;
    5 8 8 8 11 13 14;
    6 8 8 8 13 13 15];

% Nearest Skymodel determination (Kobav table)
NearestSky = NaN;
for i = 2:7
    for j = 2:7
        if NearestModels(1,i) == GradationGroup && NearestModels(j,1) == IndicatrixGroup
            NearestSky = NearestModels(j,i);
        end
    end
end

% if Gradation is not clear set Skymodel to NaN
if sum(isnan(GRADATION)) > 0
    NearestSky = NaN;
end

switch mode
    case 'cie'
        Sky = SkyModel;
        rms = mean(RMSD);
    case 'nearest'
        Sky = NearestSky;
        rms = mean(RMSD);
end

end



