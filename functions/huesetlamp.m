% huesetlamp allows to change philips hue lamp settings.
%
% usage: resp = huesetlamp(lamp,mode,parameter,value)
%
% where: resp: reuturns the response of the hue brigde
%        lamp: defines which lamp is to be changed, numeric or vector of
%              lamp id(s).
%        mode: sets the lamps status:
%              'on' turns all lamps on
%              'off' turns all lamps off
%              'toggle' turns all lamps off, it at least one is enabled and
%                       turns all lamps on, if all lamps are disabled.
%        parameter & value:
%           - 'bri' = brigthness integer 0-254, numeric or vector
%           - 'ct' = correlated temperatur (on planckian locus) in K, numeric
%                    or vector. Range: 2000 K - 6500 K
%           - 'xy' = CIE x & y chromaticity coordinates, n x 2 matrix
%        For each lamp, different parameter values can be specified.
%
% Author: Frederic Rudawski
% Date: 31.03.2022


function resp = huesetlamp(resource,on,varargin)

% input
p = inputParser;
addRequired(p,'resource', @(f) isnumeric(f) || isvector(f))
addOptional(p,'on','toggle',@ischar)
addParameter(p,'bri',[],@(f) isnumeric(f) || isvector(f))
addParameter(p,'ct',[],@(f) isnumeric(f) || isvector(f))
addParameter(p,'xy',[],@(f) isnumeric(f) || isvector(f))
addParameter(p,'bridgenr',1,@isnumeric)
addParameter(p,'connection','secure',@ischar)
parse(p,resource,on,varargin{:})

% bridge nr
bridgenr = p.Results.bridgenr;

% check resource input
r = p.Results.resource;
len = length(r);

% state
switch p.Results.on
    case 'toggle'
        % get status of resource
        m = zeros(size(r));
        for n = 1:length(r)
            h = hueget('lights',r(n));
            m(n) = h.state.on;
        end
        if any(m)
            for n = 1:length(r)
                state(n).on = false;
            end
        else
            for n = 1:length(r)
                state(n).on = true;
            end
        end
    case 'on'
        for n = 1:length(r)
            state(n).on = true;
        end
    case 'off'
        for n = 1:length(r)
            state(n).on = false;
        end
end

% fill struct with parameter
if ~isnan(p.Results.bri)
    if length(p.Results.bri)>1
        for n = 1:length(r)
            state(n).bri = p.Results.bri(n);
        end
    else
        for n = 1:length(r)
            state(n).bri = p.Results.bri;
        end
    end
end
if ~isnan(p.Results.ct)
    if length(p.Results.ct)>1
        for n = 1:length(r)
            state(n).ct = round(1e6./p.Results.ct(n));
        end
    else
        for n = 1:length(r)
            state(n).ct = round(1e6./p.Results.ct);
        end
    end
end
if ~isnan(p.Results.xy)
    if size(p.Results.xy,1)>1
        for n = 1:length(r)
            state(n).xy = p.Results.xy(n,:);
        end
    else
        for n = 1:length(r)
            state(n).xy = p.Results.xy;
        end
    end
end

% HUE bridge connection
con = huecon;
ip = con{bridgenr}.ip;
id = con{bridgenr}.id;
user = con{bridgenr}.user;
cer = con{bridgenr}.cer;

% check if insecure connection is allowed
if strcmp(p.Results.connection,'allow-insecure')
    cer = [];
end

% loop over resources
for n = 1:len
    if exist('OCTAVE_VERSION', 'builtin')
        t = toJSON(state(n));
    else
        t = jsonencode(state(n));
    end
    body = strrep(t,'"','\"');

    % RESTful command
    if strcmp(p.Results.connection,'allow-insecure')
        [~,jsonresp] = system(['curl -s -k --request PUT --data ',body,'  https://',ip,'/api/',user,'/lights/',num2str(r(n)),'/state']);
    else
        if ~isempty(cer)
            [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request PUT --data ',body,' --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/lights/',num2str(r(n)),'/state']);
        else
            warning('Insecure connection to hue bridge!')
            [~,jsonresp] = system(['curl -s -k --request PUT --data ',body,'  https://',ip,'/api/',user,'/lights/',num2str(r(n)),'/state']);
        end
    end
    resp{n} = readjson(jsonresp,'[');
end

if isequal(length(resp),1)
    resp = resp{1};
end

