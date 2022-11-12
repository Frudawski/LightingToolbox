% huedel deletes devices over their ID
%
% usage: resp = huedel(id,bridgenr,mode)
%
% where: resp: is the response struct of the hue bridge
%        id: is one or more device id's numeric or vector, max 10
%                devices in one function call.
%        bridgenr: specifies which bridge to use, default 1
%        mode: 'secure' (default) or 'allow-insecure' if a secure
%               connection is not possible
%
% Author: Frederic Rudawski
% Date: 11.11.2022


function resp = huedel(nr,bridgenr,mode)

if ~exist('nr','var')
    error('Specify device id to remove from hue bridge.')
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
id = con{bridgenr}.id;
user = con{bridgenr}.user;
cer = con{bridgenr}.cer;

% add devices one after the other
for n = 1:numel(nr)
    body = ['{\"deviceid\":[\"',id(n),'\"]}'];
    switch mode
        case 'secure'
            [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request DELETE --data ',body,' --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights/',num2str(nr(n))]);
        case 'allow-insecure'
            [~,jsonresp] = system(['curl -s -k --request DELETE --data ',body,' https://',ip,'/api/',user,'/lights/',num2str(nr(n))]);
    end
    resp = readjson(jsonresp);
end








