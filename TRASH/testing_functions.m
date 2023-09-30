% Unit tests for the Lighting Toolbox for MATLAB and Octave
%
% Run this script to check for errors after code changes.
%
% Author: Frederic Rudawski
% Date: 25.09.2023

%% check if all functions execute without error and behave as expected

% DEFINITIONS AND REFERENCE DATA
lam = 380:780;
spec = ciespec(lam,'FL4');
VL = ciespec(lam,'VL');
sc = ciespec(lam,'sc');

load('test_reference_1.mat','specevaldata')
ref = specevaldata;

% --- CIE METHODS ---


% ciespec2xyz10
%xyz10 = ciespec2xyz10(lam,spec);
%assert(isequal(xyz10,[ref.x10 ref.y10 ref.z10]))


% --- SPECTRAL EVALUATIONS ---

% specpeak
assert(specpeak(lam,VL)==555)

% specspread
assert(round(specspread(lam,[sc;VL]),4)==77.8954)

% speceval
lam = 380:780;
data = speceval(lam,spec);
assert(isequal(data,specevaldata))


% COLORIMETRY


% mixYxy
E = [100 300];
x = [0.3 0.4];
y = [0.4 0.3];
[xmix,ymix] = mixYxy(E,x,y);
assert(isequal(round(xmix,4),0.3800))
assert(isequal(round(ymix,4),0.3200))

% --- IMAGE PROCESSING ---



% readhyperspec
IM = readhyperspec('hyperspec.mat');
assert(isequal(size(IM.image),[500 500 9]))


% --- PLOTTING ---


% bayerpattern plot
try
    f1 = figure('visible','off');
    bayerpattern(6);
    close(f1)
catch
    assert(0)
end


% --- DAYLIGHT ---

% sunset
utc = sunset('21.04.1988',[37.978 23.728]);
assert(strcmp(utc,'15:51:27'))

% sunrise
utc = sunrise('21.04.1988',[37.978 23.728]);
assert(strcmp(utc,'03:01:36'))

% suntime
[utc,localtime] = suntime('13.05.2022',[],'sunset');
assert(strcmp(utc,'18:51:05'))

% sundiagram
try
    f1 = figure('visible','off');
    sundiagram([37.978 23.728],3,'15.04.2020','09:35:15')
    close(f1)
catch
    assert(0)
end

% specsky
load('test_reference_2.mat','L','lam','rgb','spec','Tcp','x','y')
[spec2,lam2,L2,Tcp2,x2,y2,rgb2] = specsky(12,210,30,'Eh',15000);
assert(isequal(L,L2))
assert(isequal(lam,lam2))
assert(isequal(rgb,rgb2))
assert(isequal(spec,spec2))
assert(isequal(Tcp,Tcp2))
assert(isequal(x,x2))
assert(isequal(y,y2))
lam = 380:780;
spec = ciespec(lam,'FL4');

