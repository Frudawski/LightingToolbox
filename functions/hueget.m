% The hueget function returns information from the Philips HUE system.
%
% usage: h = hueget(resource,element,bridgenr,mode)
%
% where: resource defines the hue system resource:
%           - lights: resource which contains all the light resources
%           - groups: resource which contains all the groups
%           - config: resource which contains all the configuration items
%           - schedules: which contains all the schedules
%           - scenes: which contains all the scenes
%           - sensors: which contains all the sensors
%           - rules: which contains all the rules
%         element: defines which element, e.g. 6 for lamp id nr 6.
%         bridgenr: defines the hue bridge
%         mode: 'secure' (default) or 'allow-insecure' if a secure
%                connection is not possible
%
%
% Author: Frederic Rudawski
% Date: 28.02.2022


function resp = hueget(resource,parameter,bridgenr,mode)


% check input parameters
if ~exist('resource','var')
    resource = '';
end
if ~exist('parameter','var')
    parameter = '';
else
    if isnumeric(parameter)
        parameter = num2str(parameter);
    end
    parameter = ['/',parameter];
end
if ~exist('bridgenr','var')
    bridgenr = 1;
end
if ~exist('mode','var')
    mode = 'secure';
end

% HUE bridge connection
con = huecon;
ip = con{bridgenr}.ip;
user = con{bridgenr}.user;
id = con{bridgenr}.id;
cer = con{bridgenr}.cer;

switch mode
    case 'secure'
        % secure https curl command
        if ~isempty(cer)
            [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request GET --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/',resource,parameter]);
        else
            % unsecure connection
            warning('Insecure connection to hue bridge!')
            [~,jsonresp] = system(['curl -s -k --request GET https://',ip,'/api/',user,'/',resource,parameter]);
        end
    case 'allow-insecure'
        [~,jsonresp] = system(['curl -s -k --request GET https://',ip,'/api/',user,'/',resource,parameter]);
    otherwise
        error('No valid operation mode: use "secure" or "allow-insecure"')
end

resp = readjson(jsonresp);

