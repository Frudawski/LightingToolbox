% huesetgroup allows to change philips hue group settings.
%
% usage: resp = huesetgroup(group,mode,parameter,value)
%
% where: resp: reuturns the response of the hue brigde
%        group: defines which group is to be changed, char/string of group
%               name or group id.
%        mode: sets the group lamps status:
%              'on' turns all lamps on
%              'off' turns all lamps off
%              'toggle' turns all lamps off, it at least one is enabled and
%                       turns all lamps on, if all lamps are disabled.
%        parameter & value:
%           - 'bri' = brigthness integer 0-254, numeric or vector
%           - 'ct' = correlated temperatur (on planckian locus) in K, numeric
%                    or vector. Range: 2000 K - 6500 K
%           - 'xy' = CIE x & y chromaticity coordinates, n x 2 matrix
%        For each group, different parameter values can be specified.
%
% Author: Frederic Rudawski
% Date: 31.03.2022


function resp = huesetgroup(resource,on,varargin)

% input
p = inputParser;
addRequired(p,'resource', @(f) ischar(f) || isstring(f) || iscell(f))
addOptional(p,'on','toggle',@ischar)
addParameter(p,'bri',[],@(f) isnumeric(f) || isvector(f))
addParameter(p,'ct',[],@(f) isnumeric(f) || isvector(f))
addParameter(p,'xy',[],@(f) isnumeric(f) || isvector(f))
addParameter(p,'bridgenr',1,@isnumeric)
addParameter(p,'connection','secure',@ischar)
parse(p,resource,on,varargin{:})

% check resource input
r = p.Results.resource;
%if strcmp(r,'0')
%    g = hueget('groups');
%    r = strrep(cell((fields(g))),'x','');
%end

% check for cell input
if iscell(r)
    len = length(r);
else
    r = {r};
    len = 1;
end

% state
switch p.Results.on
    case 'toggle'
        % get status of resource
        m = zeros(size(r));
        for n = 1:len
            h = hueget('lights',r{n});
            m(n) = h.state.on;
        end
        if any(m)
            for n = 1:len
                state(n).on = false;
            end
        else
            for n = 1:len
                state(n).on = true;
            end
        end
    case 'on'
        for n = 1:len
            state(n).on = true;
        end
    case 'off'
        for n = 1:len
            state(n).on = false;
        end
end

% fill struct with parameter
if ~isnan(p.Results.bri)
    if length(p.Results.bri)>1
        for n = 1:len
            state(n).bri = p.Results.bri(n);
        end
    else
        for n = 1:len
            state(n).bri = p.Results.bri;
        end
    end
end
if ~isnan(p.Results.ct)
    if length(p.Results.ct)>1
        for n = 1:len
            state(n).ct = round(1e6./p.Results.ct(n));
        end
    else
        for n = 1:len
            state(n).ct = round(1e6./p.Results.ct);
        end
    end
end
if ~isnan(p.Results.xy)
    if size(p.Results.xy,1)>1
        for n = 1:len
            state(n,:).xy = p.Results.xy(n,:);
        end
    else
        for n = 1:len
            state(n,:).xy = p.Results.bri;
        end
    end
end

% HUE bridge connection
con = huecon;
bridgenr = p.Results.bridgenr;
ip = con{bridgenr}.ip;
id = con{bridgenr}.id;
user = con{bridgenr}.user;
cer = con{bridgenr}.cer;

% check if insecure connection is allowed
if strcmp(p.Results.connection,'allow-insecure')
    cer = [];
end

for n = 1:len
    if exist('OCTAVE_VERSION', 'builtin')
        t = toJSON(state(n));
    else
        t = jsonencode(state(n));
    end
    body = strrep(t,'"','\"');

    % RESTful command
    if strcmp(p.Results.connection,'allow-insecure')
        [~,jsonresp] = system(['curl -s -k --request PUT --data ',body,'  https://',ip,'/api/',user,'/groups/',r{n},'/action']);
    else
        if ~isempty(cer)
            [~,jsonresp] = system(['curl -s --cacert ',which(cer),' --request PUT --data ',body,' --resolve "',id,':443:',ip,'" https://',id,'/api/',user,'/groups/',r{n},'/action']);
        else
            warning('Insecure connection to hue bridge!')
            [~,jsonresp] = system(['curl -s -k --request PUT --data ',body,'  https://',ip,'/api/',user,'/groups/',r{n},'/action']);
        end
    end
    resp{n} = readjson(jsonresp,'[');
end

if isequal(length(resp),1)
    resp = resp{1};
end

%{
% get lights in group
g = hueget('groups');
ind = fieldnames(g);
lamps = cell(size(len));
groups = {};

for n = 1:length(ind)
    for group = 1:len
        if exist('OCTAVE_VERSION', 'builtin')
            if strcmp(g.(ind{n}).name,r{group}) || strcmp(r{group},num2str(ind{n}))
                lamps{group} = str2double(g.(ind{n}).lights);
                groups{end+1} = n;
            end
        else
            if strcmp(g.(ind{n}).name,r{group}) || strcmp(r{group},num2str(ind{n}(2:end)))
                lamps{group} = str2double(g.(ind{n}).lights);
                groups{end+1} = n;
            end
        end
    end
end

% loop over groups
resp = cell(size(len));
for n = 1:len
    if length(r)>1
        if ~isempty(varargin)
            resp{n} = huesetlamp(lamps{n},on,varargin{:});
        else
            resp{n} = huesetlamp(lamps{n},on);
        end
    else
        if ~isempty(varargin)
            resp = huesetlamp(lamps{n},on,varargin{:});
        else
            resp = huesetlamp(lamps{n},on);
        end
    end
end
%}


