% Test Lighting Toolbox function: bayerpattern
%
% Author: Frederic Rudawski
% Date: 30.09.2023 (Saturday)

%% Check for assumed correct values and result size

% test function
try
   f1 = figure('visible','off'); % create invisible figure
   bayerpattern(6) % call bayerpattern plot function
   close(f1) % close figure
catch
    assert(0) % error appeared during bayerpattern call
end
