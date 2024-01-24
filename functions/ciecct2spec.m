% Judd spectral daylight reconstruction from CCT in 5 nm steps from 300 nm
% to 830 nm as in CIE 15:2004 considering NOTE 6 on p. 13.
%
% usage: [spectrum,wavelength,xd,yd] = cieCCT2spec(Tc)
%
% xd: CIE 1931 chromaticity x coordinate calculated from CCT
% yd: CIE 1931 chromaticity y coordinate calculated from CCT
%
% Spectra for CCT's outside the range of 4000 K to 25000 K are returned as NaN's.
%
% example - plot the spectral recunstruction of daylight for a CCT of 5500 K and 8000 K.
%       
%   [spec,lam] = ciecct2spec([5500 8000]);
%    plot(lam,spec)
%
% Reference
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage (CIE),
% Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
% 
% Author: Frederic Rudawski
% Date: 03.07.2018
% last edited: 26.05.2021
% See: https://www.frudawski.de/ciecct2spec

function [spec,lambda,xd,yd] = ciecct2spec(Tc,lam,Y,W,df)

% check input
if ~exist('Y','var')
    Y = [];
end
if ~exist('W','var')
    W = 'VL';
end

% apply factor as demanded in CIE 15:2018 p. 13 note 6:
if ~exist('f','var')
    df = 1.4388/1.4380;
end
% apply factor to Tc
Tc = Tc.*df;

% Judd eigenvectors
% row 1: wavelength in nm
% row 2: S_0
% row 3: S_1
% row 4: S_2
S = [300 305 310 315 320 325 330 335 340 345 350 355 360 365 370 375 380 385 390 395 400 405 410 415 420 425 430 435 440 445 450 455 460 465 470 475 480 485 490 495 500 505 510 515 520 525 530 535 540 545 550 555 560 565 570 575 580 585 590 595 600 605 610 615 620 625 630 635 640 645 650 655 660 665 670 675 680 685 690 695 700 705 710 715 720 725 730 735 740 745 750 755 760 765 770 775 780 785 790 795 800 805 810 815 820 825 830;...
     0.04	3.02	6.00	17.80	29.60	42.45	55.30	56.30	57.30	59.55	61.80	61.65	61.50	65.15	68.80	66.10	63.40	64.60	65.80	80.30	94.80	99.80	104.80	105.35	105.90	101.35	96.80	105.35	113.90	119.75	125.60	125.55	125.50	123.40	121.30	121.30	121.30	117.40	113.50	113.30	113.10	111.95	110.80	108.65	106.50	107.65	108.80	107.05	105.30	104.85	104.40	102.20	100.00	98.00	96.00	95.55	95.10	92.10	89.10	89.80	90.50	90.40	90.30	89.35	88.40	86.20	84.00	84.55	85.10	83.50	81.90	82.25	82.60	83.75	84.90	83.10	81.30	76.60	71.90	73.10	74.30	75.35	76.40	69.85	63.30	67.50	71.70	74.35	77.00	71.10	65.20	56.45	47.70	58.15	68.60	66.80	65.00	65.50	66.00	63.50	61.00	57.15	53.30	56.10	58.90	60.40	61.90;...
     0.02	2.26	4.50	13.45	22.40	32.20	42.00	41.30	40.60	41.10	41.60	39.80	38.00	40.20	42.40	40.45	38.50	36.75	35.00	39.20	43.40	44.85	46.30	45.10	43.90	40.50	37.10	36.90	36.70	36.30	35.90	34.25	32.60	30.25	27.90	26.10	24.30	22.20	20.10	18.15	16.20	14.70	13.20	10.90	8.60	7.35	6.10	5.15	4.20	3.05	1.90	0.95	0.00	-0.80	-1.60	-2.55	-3.50	-3.50	-3.50	-4.65	-5.80	-6.50	-7.20	-7.90	-8.60	-9.05	-9.50	-10.20	-10.90	-10.80	-10.70	-11.35	-12.00	-13.00	-14.00	-13.80	-13.60	-12.80	-12.00	-12.65	-13.30	-13.10	-12.90	-11.75	-10.60	-11.10	-11.60	-11.90	-12.20	-11.20	-10.20	-9.00	-7.80	-9.50	-11.20	-10.80	-10.40	-10.50	-10.60	-10.15	-9.70	-9.00	-8.30	-8.80	-9.30	-9.55	-9.80;....
     0.00	1.00	2.00	3.00	4.00	6.25	8.50	8.15	7.80	7.25	6.70	6.00	5.30	5.70	6.10	4.55	3.00	2.10	1.20	0.05	-1.10	-0.80	-0.50	-0.60	-0.70	-0.95	-1.20	-1.90	-2.60	-2.75	-2.90	-2.85	-2.80	-2.70	-2.60	-2.60	-2.60	-2.20	-1.80	-1.65	-1.50	-1.40	-1.30	-1.25	-1.20	-1.10	-1.00	-0.75	-0.50	-0.40	-0.30	-0.15	0.00	0.10	0.20	0.35	0.50	1.30	2.10	2.65	3.20	3.65	4.10	4.40	4.70	4.90	5.10	5.90	6.70	7.00	7.30	7.95	8.60	9.20	9.80	10.00	10.20	9.25	8.30	8.95	9.60	9.05	8.50	7.75	7.00	7.30	7.60	7.80	8.00	7.35	6.70	5.95	5.20	6.30	7.40	7.10	6.80	6.90	7.00	6.70	6.40	5.95	5.50	5.80	6.10	6.30	6.50];

% CCT range
ind1 = Tc >= 4000 & Tc <= 7000;
ind2 = Tc >  7000 & Tc <= 25000;

xd = ones(size(Tc)).*NaN; 
yd = ones(size(Tc)).*NaN;

% CIE daylight locus - in dependency of CCT
% x coordinate
% Tc >= 4000 & Tc <= 7000
xd(ind1) = 0.244063 + 0.09911.*10.^3./Tc(ind1) ...
    + 2.9678.*10.^6./Tc(ind1).^2-4.6070.*10.^9./Tc(ind1).^3;
% Tc > 7000 & Tc <= 25000
xd(ind2) = 0.237040 + 0.24748.*10.^3./Tc(ind2) ...
    + 1.9018.*10.^6./Tc(ind2).^2-2.0064.*10.^9./Tc(ind2).^3;

% y coordinate
yd = -3.*xd.^2 + 2.870.*xd - 0.275;
if xd == 0
    yd = NaN;
end

% weighting factors of eigenvectors
m  = 0.0241+0.2562*xd-0.7341*yd;
M1 = ltfround((-1.3515-1.7703.*xd+5.9114.*yd)./m,3);  % see NOTE 6 on p. 13 in CIE15:2018
M2 = ltfround((0.0300-31.4424.*xd+30.0717.*yd)./m,3); % see NOTE 6 on p. 13 in CIE15:2018

% spectral reconstruction
SD = ones(length(Tc),size(S,2)).*NaN;
for i = 1:length(Tc)
    SD(i,:) = S(2,:) + M1(i).*S(3,:) + M2(i).*S(4,:);
end

% wavelength of spectral recunstruction
if ~exist('lam','var')
    lambda = S(1,:);
    spec = zeros(size(SD,1),numel(lambda));
    for n = 1:size(SD,1)
        spec(n,:) = interp1(300:5:830,SD(n,:),lambda);
    end
else
    lambda = lam;
    spec = zeros(size(SD,1),numel(lambda));
    for n = 1:size(SD,1)
        spec(n,:) = interp1(300:5:830,SD(n,:),lambda);
    end
end


% weight spectra
if ~isempty(Y)
    F = ciespec2unit(lambda,spec,W);
    % in case of different weighting functions
    if size(F,2) > 1
        F = diag(F);
    end
    % weighting factor
    f = Y'./F;
    % weight spectra with factor
    spec = spec.*repmat(f,1,length(lambda));
end


