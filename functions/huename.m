% huename allows to change the name of a HUE device
%
% usage: resp = huename(deviceid,name,bridgenr,mode)
%
%        deviceid: is the HUE device number
%        name: the name to bes set
%        bridgenr: allows to specify the brdige
%        mode: 'secure' (default) or 'allow-insecure' if a secure
%               connection is not possible
%
% Author: Frederic Rudawski
% Date: 28.04.2022


function resp = huename(deviceid,name,bridgenr,mode)

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
switch mode
    case 'secure'
    [~,jsonresp] = system(['curl -g -s --cacert ',which(cer),' --request PUT --data ',body,' --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights/',deviceid]);
    case 'allow-insecure'
    %warning('Insecure connection to hue bridge!')
    [~,jsonresp] = system(['curl -s -k --request PUT --data ',body,' https://',ip,'/api/',user,'/lights/',deviceid]);
end
resp = readjson(jsonresp);





