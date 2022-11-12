% huemdns tries to resolve hue bridge ip's and id'S over multicast dns
% service.
%
% usage: [ip,id] = huemdns
%
% Author: Frederic Rudawski
% Date: 01.05.2022


function [ip,id] = huemdns(ip)

if ~exist('ip','var')
    ip = {};
end
id = {};


if ispc
        if ~exist('OCTAVE_VERSION', 'builtin')
        % try call dns-sd (Apple Bonjour)
        try
            % check if dns-sd is available
            [dns_sd,~] = system('dns-sd -help');
            if isequal(dns_sd,0)
                
                hidden = ''; %-window hidden

                % LightingToolbox path
                p = which('huecon.mat');
                p = p(1:end-10);
                % call dns-sd (Apple Bonjour)
                %-window hidden
                %system(['powershell ',hidden,' echo - & echo Searching for hue bridges, please wait a moment... & echo This window should close after 5 seconds. & dns-sd -B _hue._tcp > ',p,'hue_dns-sd_search.txt &']);
                % wait for a short time
                pause(5)
                % force close not closing dns-sd
                [~,~] = system('Taskkill/IM cmd.exe');
                % read search results
                str = fileread(which('hue_dns-sd_search.txt'));
                % check for Hue Bridge(s)
                HB = strfind(str,'Philips Hue');

                % loop over found Hue bridges
                if ~isempty(HB)

                    % get bridge id
                    for n = 1%:length(HB)
                        % extract bridge name
                        bridge = str(HB(n):HB(n)+19);
                        % resolve id
                        cmd = ['dns-sd -L "',bridge,'" _hue._tcp local.'];
                        system(['powershell ',hidden,' echo - & echo Resolve Hue bridge id... & echo This Window should close after 5 seconds. & ',cmd,' >> ',p,'hue_dns-sd_search.txt &']);
                        % wait for a short time
                        pause(5)
                        % force close not closing dns-sd
                        [~,~] = system('Taskkill/IM cmd.exe');
                        % extract id
                        idstr = fileread(which('hue_dns-sd_search.txt'));
                        idpos = strfind(idstr,'bridgeid');
                        id{n} = idstr(idpos(n)+9:idpos(n)+24);
                        % id address
                        idaddress = strfind(idstr,'can be reached at');
                        idaddress = idstr(idaddress(n)+18:idaddress(n)+29);
                    end


                    % get bridge ip
                    for n = 1%:length(HB)
                        % resolve ip
                        cmd = ['dns-sd -G v4 ',idaddress,'.local'];
                        system(['powershell ',hidden,' echo - & echo Resolve Hue bridge ip-address... & echo This Window should close after 5 seconds. & ',cmd,' >> ',p,'hue_dns-sd_search.txt &']);
                        % wait for a short time
                        pause(5)
                        % force close not exiting dns-sd
                        [~,~] = system('Taskkill/IM cmd.exe');
                        % extract ip address
                        ipstr = fileread(which('hue_dns-sd_search.txt'));
                        ippos = strfind(ipstr,[idaddress,'.local']);
                        % consecutively cut string before ip address
                        ippos = ippos(n*2);
                        ipstr = ipstr(ippos:end);
                        ippos = strfind(ipstr,' ');
                        ipstr = ipstr(ippos:end);
                        ippos = find(~ismember(ipstr,' '));
                        ipstr = ipstr(ippos:end);
                        % str now begins with ip address, find fist space = end of ip address
                        ippos = find(ismember(ipstr,' '));
                        ip{n} = ipstr(1:ippos-1);
                    end

                end
            end
        catch

      end
      end
        %
    elseif ismac
        % unfinished
        disp('No automatic MAC-OS HUE bridge connection implemented...')
        
    elseif isunix

        % try to use avahi-daemon
        [c,r] = system('avahi-browse -rt _hue._tcp');
        
        % if function call succesful 
        if isequal(c,0)
            % loop over found bridges
            for n = 1:length(strfind(r,'hostname'))/2
                % get id
                ind = strfind(r,'bridgeid=');
                id{n} = r(ind(n*2)+10:ind(n*2)+24);
                % get ip
                adr = strfind(r,'address = ');
                ind1 = strfind(r,'[');
                ind1 = ind1(ind1>adr(n*2));
                ind2 = strfind(r,']');
                ind2 = ind2(ind2>adr(2*n));
                ip{n} = r(ind1(1)+1:ind2(1)-1);
            end
        end

end

