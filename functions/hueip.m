% Returns hue bridge ip address and id in the same local network.
%
% usage: [ip,id] = hueip
%
% Author: Frederic Rudawski
% Date: 28.03.2022, last updated: 25.04.2022

function [IP,id] = hueip(ip,secure)

if ~exist('secure','var')
    secure = 'secure';
end

if ~exist('ip','var')
    ip = {};
end

if isempty(ip)

    id = {};

    % TODO: full zero network configuration
    % Apple -> not yet implemented, Linux -> avahi, Windows -> install bonjour
    [IP,id] = huemdns({},2,'');
    
    % fall back: hue discover end point
    if isempty(IP)
        % get ip list from online list
        url = 'https://discovery.meethue.com/';
        try
          data = webread(url);
        catch
          error(['Cannot connect to "',url,'", check internet connection.'])
          return
        end

        % loop over candidates
        for n = 1:length(data)
            try
                % check with ping first
                if ispc
                    [r,~] = system(['ping ',data(n).internalipaddress, ' -n 1 -w 750']);
                elseif isunix || ismac
                    % MAC untested!
                    [r,~] = system(['timeout 0.75 ping ',data(n).internalipaddress, ' -c 1'],'-echo');
                end

                % if pingable
                if isequal(r,0)
                    try
                        % default certificate
                        [~,resp] = system(['curl --cacert ',which('hue_cacert_.pem'),' --resolve "',data(n).id,':443:',data(n).internalipaddress,'" https://',data(n).id,'/api/0/config']);
                        resp = readjson(resp);
                        % self-signed certificate
                        if isempty(resp)
                            try
                                [~,resp] = system(['curl --cacert ',which(['hue_cacert_',data(n).id,'.pem']),' --resolve "',data(n).id,':443:',data(n).internalipaddress,'" https://',data(n).id,'/api/0/config']);
                                resp = readjson(resp);
                            catch
                                resp = [];
                            end
                        end
                        % last resort: unsecure connection
                        if isempty(resp)
                            if strcmp(secure,'allow-insecure')
                                %warning('Insecure connection to hue bridge!')
                                [~,resp] = system(['curl -k https://',data(n).internalipaddress,'/api/0/config']);
                                resp = readjson(resp);
                            end
                        end
                    catch
                        % insecure https curl command
                        %[~,resp] = system(['curl -k https://',data(n).internalipaddress,'/api/0/config']);
                        resp = [];
                    end

                    if strcmp(resp.name,'Philips hue')
                        % set ip address
                        IP{end+1} = data(n).internalipaddress;
                        id{end+1} = data(n).id;
                    end
                end
            catch
            end
        end
    end

else
    % ip provided & id unknown

    % insecure https curl command = trust on first contact
    [~,resp] = system(['curl -k https://',ip,'/api/0/config']);
    resp = readjson(resp);
    % get id
    id{1} = resp.bridgeid;
    IP{1} = ip;
end


