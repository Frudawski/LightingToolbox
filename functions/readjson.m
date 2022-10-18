% read curl json string in octave or matlab
% 
% usage: resp = readjson(str)
%
% Author: Frederic Rudawski
% Date: 26.04.2022

function resp = readjson(resp,mode)

if ~exist('mode','var')
    mode = '{';
end

switch mode
    case '{'
        par1 = '{';
        par2 = '}';
    case '['
        par1 = '[';
        par2 = ']';
end
    
    % only json string
    x1 = strfind(resp,par1);
    try
        x1 = x1(1);
        x2 = strfind(resp,par2);
        x2 = x2(end);
        resp = resp(x1:x2);
    catch
        resp = [];
        return
    end

    % OCTAVE code
    if exist('OCTAVE_VERSION', 'builtin')
        try
            resp = fromJSON(resp); % io package needed
        catch
            %warning('fromJSON not working, io package loaded?')
            resp = [];
        end
    else
    % MATLAB code
        try
            resp = jsondecode(resp);
        catch
            resp = [];
        end
    end

end