% huesearch looks for new devices
%
% usage: resp =  huesearch(bridgenr)
%
% Author: Frederic RUdawski
% Date: 27.04.2022


function resp = huesearch(bridgenr)

if ~exist('bridgenr','var')
    bridgenr = 1;
end

% HUE bridge connection
con = huecon;
ip = con{bridgenr}.ip;
user = con{bridgenr}.user;
id = con{bridgenr}.id;
cer = con{bridgenr}.cer;

% secure https curl command
if ~isempty(cer)
    [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request POST --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights']);
else
    % unsecure connection
    warning('Insecure connection to hue bridge!')
    [~,jsonresp] = system(['curl -s -k --request POST https://',ip,'/api/',user,'/lights']);
end

resp = readjson(jsonresp);

if ~isempty(resp)
    try
        if isfield(resp,'success')
            disp('start search...')
            pause(45)
            % secure https curl command
            if ~isempty(cer)
                [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request GET --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights/new']);
            else
                % unsecure connection
                warning('Insecure connection to hue bridge!')
                [~,jsonresp] = system(['curl -s -k --request GET https://',ip,'/api/',user,'/lights/new']);
            end
            resp = readjson(jsonresp);
            disp('search finished.')
        end
    catch
        resp = [];
    end
end








