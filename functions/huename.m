% huename allows to change the name of a HUE device
%
% usage:
%
% Author: Frederic Rudawski
% Date: 28.04.2022


function resp = huename(deviceid,name,bridgenr)

if ~exist('bridgenr','var')
    bridgenr = 1;
end
if ~ischar(deviceid)
    deviceid = num2str(deviceid);
end

% HUE bridge connection
con = huecon;
ip = con{bridgenr}.ip;
id = con{bridgenr}.id;
user = con{bridgenr}.user;
cer = con{bridgenr}.cer;

% message body
body = ['{\"name\":\"',name,'\"}'];
% escape space char
body = strrep(body,' ','_'); 

% rename request
if ~isempty(cer)
    [~,jsonresp] = system(['curl -g -s --cacert ',which(cer),' --request PUT --data ',body,' --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights/',deviceid]);
else
    warning('Insecure connection to hue bridge!')
    [~,jsonresp] = system(['curl -s -k --request PUT --data ',body,' https://',ip,'/api/',user,'/lights/',deviceid]);
end
resp = readjson(jsonresp);





