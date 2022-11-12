% hueadd add devices over thier serial number
%
% usage: resp = hueadd(serial,bridgenr,mode)
%
% where: resp: is the response struct of the hue bridge
%        serial: is one or more serial numbers char or cell-array, max 10
%                devices in one function call.
%        bridgenr: specifies which bridge to use, default 1
%        mode: 'secure' (default) or 'allow-insecure' if a secure
%               connection is not possible

%
% Author: Frederic Rudawski
% Date: 27.04.2022


function resp = hueadd(serial,bridgenr,mode)

if ~exist('serial','var')
    error('Specify device serial number to add to hue bridge.')
end
if ~exist('bridgenr','var')
    bridgenr = 1;
end
if ~exist('mode','var')
    mode = 'secure';
end

% check that serial number input is cell
h = whos('serial','var');
if strcmp(h.class,'char')
    s = serial;
    clear serial
    serial{1} = s;
end

% HUE bridge connection
con = huecon;
ip = con{bridgenr}.ip;
id = con{bridgenr}.id;
user = con{bridgenr}.user;
cer = con{bridgenr}.cer;

% add devices one after the other
%for n = 1:length(serial)
    %body = ['{\"deviceid\":[\"',serial{n},'\"]}'];
    s = join(serial,'\",\"');
    body = ['{\"deviceid\":[\"',s{1},'\"]}'];

    switch mode
        case 'secure'
            %if ~isempty(cer)
                [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request POST --data ',body,' --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights']);
            %else
            %    warning('Insecure connection to hue bridge!')
            %    [~,jsonresp] = system(['curl -s -k --request POST --data ',body,' https://',ip,'/api/',user,'/lights']);
            %end
        case 'allow-insecure'
            [~,jsonresp] = system(['curl -s -k --request POST --data ',body,' https://',ip,'/api/',user,'/lights']);
    end
    resp = readjson(jsonresp);

    if isfield(resp,'success')
        disp('Looking for devices...')
    end

    pause(60)

    switch mode
        case 'secure'
            [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request GET --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights/new']);
        case 'allow-insecure'
            %warning('Insecure connection to hue bridge!')
            [~,jsonresp] = system(['curl -s -k --request GET https://',ip,'/api/',user,'/lights/new']);
    end

    resp = readjson(jsonresp);
%end
%if isequal(length(resp),1)
%    resp = resp{1};
%end






