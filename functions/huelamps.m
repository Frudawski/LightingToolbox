% The huelamps function lists all Philips HUE lamps available.
%
% usage: huelamps(lamp,bridgenr,mode)
%
% where:
%        lamp: (optional) specifies the lamp number(s) (numeric or vector) or group (str/char).
%        bridgenr: allows to specify which bridge
%        mode: 'secure' (default) or 'allow-insecure' if a secure
%               connection is not possible
%
% Author: Frederic Rudawski
% Date: 29.03.2022

function lamptab = huelamps(nr,bridgenr,mode)

if ~exist('bridgenr','var')
    bridgenr = 1;
end
if ~exist('mode','var')
    mode = 'secure';
end


% get lamp list
h = hueget('lights','',bridgenr,mode);

% initialize
if exist('OCTAVE_VERSION', 'builtin')
  if ~isempty(h)
    ind = fieldnames(h);
  else
    ind = [];
  end
else
    if ~isempty(h)
        ind = fields(h);
    else
        ind = [];
    end
end
lamps = cell(length(ind),9);
% check input parameter
if ~exist('nr','var')
    nr = 1:length(ind);
end
if isempty(nr)
   nr = 1:length(ind);
end

if exist('OCTAVE_VERSION', 'builtin')
% OCTAVE CODE
  for n = 1:length(ind)
    lamps{n,1} = str2double(ind{n});
    lamps{n,2} = h.(ind{n}).name;
    lamps{n,3} = h.(ind{n}).type;
    lamps{n,4} = '';
    lamps{n,5} = NaN;
    lamps{n,6} = h.(ind{n}).state.on;
    try
       lamps{n,7} = h.(ind{n}).state.bri;
    catch
       lamps{n,7} = NaN;
    end
    try
       lamps{n,8} = round(1e6/h.(ind{n}).state.ct);
    catch
       lamps{n,8} = NaN;
    end
    try
       xy = h.(ind{n}).state.xy;
       lamps{n,9} = xy(1);
       lamps{n,10} = xy(2);
    catch
       lamps{n,9} = NaN;
       lamps{n,10} = NaN;
    end
  end

  try
    col =  {'lamp_id' 'name' 'type' 'group' 'group_id' 'on' 'brightness' 'CCT' 'x' 'y'};
    lamptab = dataframe([col;lamps]);
  catch
    error(['Octave dataframe package not loaded?',char(10),'Install: pkg install -forge dataframe',char(10),'Load: pkg load dataframe'])
  end

% get lights groups
g = hueget('groups','',bridgenr,mode);
ind = fieldnames(g);
for n = 1:length(ind)
    % add group information
    idx = str2double(g.(ind{n}).lights);
    idx = find(ismember(lamptab.lamp_id,idx));
    lamptab.group(idx) = {g.(ind{n}).name};
    lamptab.group_id(idx) = n;
    if ischar(nr)
        if strcmp(nr,g.(ind{n}).name) || strcmp(nr,num2str(ind{n}))
            nr = idx;
        end
    end
end

% selected lamps
lamptab = lamptab(nr,:);

else
% MATLAB CODE

% nr | name | type | group | group nr | on | brighntess | hue | saturration | x | y | ct
for n = 1:length(ind)
    lamps{n,1} = str2double(ind{n}(2:end));
    lamps{n,2} = h.(ind{n}).name;
    lamps{n,3} = h.(ind{n}).type;
    lamps{n,4} = '';
    lamps{n,5} = NaN;
    lamps{n,6} = h.(ind{n}).state.on;
    try
       lamps{n,7} = h.(ind{n}).state.bri;
    catch
       lamps{n,7} = NaN;
    end
    try
       lamps{n,8} = round(1e6/h.(ind{n}).state.ct);
    catch
       lamps{n,8} = NaN;
    end
    try
       xy = h.(ind{n}).state.xy;
       lamps{n,9} = xy(1);
       lamps{n,10} = xy(2);
    catch
       lamps{n,9} = NaN;
       lamps{n,10} = NaN;
    end
end

% create table
lamptab = cell2table([num2cell(1:size(lamps,1),1)',lamps]);
if isempty(lamptab)
    lamptab = cell2table(cell(0,11));
end
lamptab.Properties.VariableNames = {'nr' 'lamp_id' 'name' 'type' 'group' 'group_id' 'on' 'brightness' 'CCT' 'x' 'y'};

% get lights groups
g = hueget('groups','',bridgenr,mode);
if ~isempty(g)
    ind = fields(g);
else
    ind = [];
end
for n = 1:length(ind)
    % add group information
    idx = str2double(g.(ind{n}).lights);
    idx = find(ismember(lamptab.lamp_id,idx));
    lamptab.group(idx) = {g.(ind{n}).name};
    lamptab.group_id(idx) = n;
    % specified lamp number(s) or group name(s) / id(s)
    if ischar(nr)
        if strcmp(nr,g.(ind{n}).name) || strcmp(nr,num2str(ind{n}(2:end)))
            nr = idx;
        end
    end
end

% selected lamps
lamptab = lamptab(nr,:);


end
