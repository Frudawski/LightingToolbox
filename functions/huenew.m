% huenew creates a new user for a hue bridge. The function will try to find
% the ip address automatically, if that fails one can specify the
% ip-address as input char/string.
%
% usage: [ip,id] = huenew(ip,con)
%
% where:
%   ip: contains the bridge ip-address
%   id: contains the bridge id
%   input ip: is optional
%   input con: hue connection struct, new bridge will be appended
%
% Author: Frederic Rudawski
% Date: 28.02.2022, last updated 26.04.2022


function connection = huenew(ip,connection)

% check conenction  var
if ~exist('connection','var')
    try
        load(which('huecon.mat'),'connection');
    catch
        connection = {};
    end
end

% check hue bridge ip & id var
if ~exist('ip','var')
    [ip,id] = hueip({},'allow-insecure');
else
    if ~isempty(ip)
        [ip,id] = hueip(ip,'allow-insecure');
    else
        [ip,id] = hueip({},'allow-insecure');
    end
end

% loop over found hue bridges
for n = 1:length(ip)

    % get bridge certificate with openssl
    if isunix %|| ismac
        % MAC not tested!
        [~,t] = system(['timeout 1 openssl s_client -showcerts -connect ',ip{n},':443']);
    elseif ispc
        [~,t] = system(['openssl s_client -showcerts -connect ',ip{n},':443']);
    end
    c1 = strfind(t,'-----BEGIN CERTIFICATE-----');
    c2 = strfind(t,'-----END CERTIFICATE-----');
    c = t(c1:c2+24);
    % read HUE certificate
    chue = fileread(which('hue_cacert.pem'));
    % compare certificates
    if strcmp(c,chue)
        % hue certificate
        cer = 'hue_cacert.pem';
    elseif isempty(c)
        % no certficate found
        selection = questdlg('Unable to get HUE bridge certificate. You can try with default certificate, connect over self-signed certificate or establish an unsecrue connection.', ...
            'No certificate found',......
            'Default','Self-signed','Unsecure','Default');
        switch selection
            % insecure connection
            case 'Unsecure'
                unsecure = questdlg('Are you sure you want to establish a permanent and unsecure connection in your local network?.', ...
                    'Unsecure connection',......
                    'Yes','Cancel','Cancel');
                switch unsecure
                    case 'Yes'
                        cer = [];
                    case 'Cancel'
                        error('Could not establish secure connection to bridge, either no conenction is possible or self-signed certificate is used. Install openssl or download certificate from bridge and save it as hue_cacert_BRIDGE-ID.pem in LightingToolbox folder.');
                end
                % self-signed certificate
            case 'Self-signed'
                selfsigned = questdlg(['You need to download the bridge certificate and save it as hue_cacert_',id{n},'.pem in the LightingToolbox folder. Or cancel, install openssl and try again.'], ...
                    'Prepare self-signed certificate',......
                    'Ok','Cancel','Cancel');
                switch selfsigned
                    case 'Ok'
                        cer = ['hue_cacert_',id{n},'.pem'];
                    case 'Cancel'
                        connection = [];
                        return
                end
                % default certificate
            case 'Default'
                cer = 'hue_cacert.pem';
                [~,resp] = system(['curl --cacert ',which(cer),' --request GET --resolve "',id{n},':443:',ip{n},'" https://',id{n},'/api/']);
                if contains(resp,'CERT_TRUST_IS_UNTRUSTED_ROOT')
                    error('Could not establish secure connection to bridge with default certificate, either no conenction is possible or self-signed certificate is used. Install openssl or download certificate from bridge and save it as hue_cacert_BRIDGE-ID.pem in LightingToolbox folder.');
                end
                % abort
            case 'Cancel' % only 3 buttons supported...
                connection = [];
                return
                % none of the above
            otherwise
                connection = [];
                return
        end
    else
        % self signed certificate
        cer = ['hue_cacert_',id{n},'.pem'];
        filename = which('hue_cacert.pem');
        filename = [filename(1:end-14) cer];
        % save certificate
        f = fopen(filename,'w');
        fprintf(f,c);
        fclose(f);
    end


    % system user name
    user = char(java.lang.System.getProperty('user.name'));
    % create user
    body = ['{\"devicetype\":\"MATLAB#',user,'\"}'];
    if ~isempty(cer)
        [~,jsonresp] = system(['curl --cacert ',which(cer),' --request POST --data ',body,' --resolve "',id{n},':443:',ip{n},'" https://',id{n},'/api']);
    else
        warning('Insecure connection to hue bridge!')
        [~,jsonresp] = system(['curl -k --request POST --data ',body,' https://',ip{n},'/api']);
    end
    resp = readjson(jsonresp);

    try
        % check response
        if strcmp(resp.error.description,'link button not pressed')
            disp(['Press HUE bridge button in the next 30 s to connect (id: ',id{n},').'])

            % initialization
            check = 1;
            nocon = 0;

            % check the next 30 s for successful connection
            while ~isequal(check,0)
                % wait a second
                pause(1)
                % increase counter
                check = check+1;
                % check counter end
                if isequal(check,31)
                    check = 0;
                    nocon = 1;
                end

                % test if connection was successful
                try
                    %resp = webwrite(['http://',ip,'/api'],['{"devicetype":"MATLAB#',user,'"}']);
                    if ~isempty(cer)
                        [~,jsonresp] = system(['curl --cacert ',which(cer),' --request POST --data ',body,' --resolve "',id{n},':443:',ip{n},'" https://',id{n},'/api']);
                    else
                        %warning('unsecure connection!')
                        [~,jsonresp] = system(['curl -k --request POST --data ',body,' https://',ip{n},'/api']);
                    end
                    resp = readjson(jsonresp);

                    % if connection is established
                    if isstruct(resp.success)
                        % add new user
                        user = resp.success.username;
                        check = 0;

                        % ip address
                        connection{end+1}.ip = ip{n};
                        % user name
                        connection{end}.user = user;
                        % bridge id
                        connection{end}.id = id{n};
                        % certificate path
                        connection{end}.cer = cer;

                        % save connection
                        save(which('huecon.mat'),'connection')
                    end
                catch
                end
            end

            % no connection?
            if nocon
                disp('Could not connect to HUE bridge.')
            end
        end

    catch
        disp('Could not find HUE bridge.')
    end

end






