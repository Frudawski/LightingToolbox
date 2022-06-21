% huecon returns the a connection to a hue bridge containing:
% ip
% user
% bridge id
%
% The function creates a new user i fneccessary.
%
% usage: huecon() or huecon(ip)
%
% where: ip contains the ip-address as char or string (optional)
% 
% Author: Frederic Rudawski
% Date: 28.02.2022


function connection = huecon(bridgenr)

%if ~exist('bridgenr','var')
%    bridgenr = 1;
%end

%if ~exist('ip','var')
    try
        % look for huecon.mat file
        load(which('huecon.mat'),'connection');

        % test connection
        %{
        for n = 1:length(connection)
            % connect to bridge
            if ~isempty(connection{n}.cer)
                [~,resp] = system(['curl --cacert ',which(connection{n}.cer),' --resolve "',connection{n}.id,':443:',connection{n}.ip,'" https://',connection{n}.id,'/api/0/config']);
            else
                warning('Insecure connection to hue bridge!')
            end
            resp = readjson(resp);
            % if not hue bridge
            if ~isempty(resp)
                if ~strcmp(resp.name,'Philips hue')
                    connection{n} = {};
                end
            else
                connection{n} = {};
            end
        end
        %}
    catch

        % find hue bridge ip
        if ~exist('ip','var')
            ip = hueip;
        end
        % create new user
        connection = huenew(ip);
    end
%else

    % find hue bridge ip
%    if ~exist('ip','var')
%        ip = hueip;
%    end
    % create new user
%    connection = huenew(ip);
%end

if exist('bridgenr','var')
    connection = connection(bridgenr);
end

