% sundiagram
%
% Author: Frederic Rudawski
% Date: 30.06.2022

function sundiagram(coord,offset,date,time,c)

if exist('OCTAVE_VERSION', 'builtin')
    warning ('off', 'Octave:data-file-in-path')
end

% check input
if ~exist('coord','var')
    load('LT_location.mat','coord');
end
if isempty(coord)
    load('LT_location.mat','coord');
end
if ~exist('date','var')
    date = [];
end
if ~exist('time','var')
    time = [];
end
if ~exist('offset','var')
    offset = 0;
end
if isempty(offset)
    offset = 0;
end
if ~exist('c','var')
    c = [0.8 0.4 0.0];
end

%dm = [31 28 31 30 31 30 31 31 30 31 30 31];
days = [31 59 90 120 151 181 212 243 273 304 334 365];
d21 = [21 52 80	111	141	172	202	233	264	294	325	355];
Day = 1:15:365;
Day = sort([Day d21]);

az = NaN(23*2,length(Day)+1);
ga = NaN(23*2,length(Day)+1);


idx = 1;
% loop over year for each half hour
for h = 0:23
    for m = [0 30]
        idx2 = 1;
        for d = Day
            % get month
            [~,M] = min(abs(days-d));
            if isequal(M,1)
                D = d;
            else
                D = d-days(M-1);
            end
            [az(idx,idx2),ga(idx,idx2)] = sunpos([num2str(D,'%02d'),'.',num2str(M,'%02d'),'.2021'],[num2str(h,'%02d'),':',num2str(m,'%02d'),':00'],coord(1),coord(2));
            idx2 = idx2+1;
        end
        idx = idx+1;
    end
end


% close hour loop
az(:,end) = az(:,1);
ga(:,end)  = ga(:,1);
GA = ga;
GA(GA<-85) = NaN;

% plot hour loops
clf
if exist('OCTAVE_VERSION', 'builtin')

    % Octave's polar plot shows lines outside the figure, the following code cleans that up

    AZ = az;
    GA(GA<0) = NaN;
    for n = 1:size(GA,1)
        idx = isnan(GA(n,:));
        idx = diff(idx);
        idx = find(idx);

        if ~isempty(idx)
            idx(2) = idx(2)+1;
            GA(n,idx) = 0;
            % azimuth interpolation:
            switch idx(1)
                case 1
                    AZ01 = interp1([ga(n,idx(1)+1) ga(n,idx(1)+2)],[az(n,idx(1)+1) az(n,idx(1)+2)],0,'extrap','linear');
                case size(ga,2)
                    %AZ01 = interp1([ga(n,idx(1)-2) ga(n,idx(1)-1)],[az(n,idx(1)-2) az(n,idx(1)-1)],0,'extrap','linear');
                otherwise
                    AZ01 = interp1([ga(n,idx(1)-1) ga(n,idx(1)+1)],[az(n,idx(1)-1) az(n,idx(1)+1)],0);
            end
            switch idx(2)
                case 1
                    %AZ02 = interp1([ga(n,idx(2)+1) ga(n,idx(2)+2)],[az(n,idx(2)+1) az(n,idx(2)+2)],0,'extrap','linear');
                case size(ga,2)
                    AZ02 = interp1([ga(n,idx(2)-2) ga(n,idx(2)-1)],[az(n,idx(2)-2) az(n,idx(2)-1)],0,'extrap','linear');
                otherwise
                    AZ02 = interp1([ga(n,idx(2)-1) ga(n,idx(2)+1)],[az(n,idx(2)-1) az(n,idx(2)+1)],0);
            end
            AZ(n,idx(1)) = AZ01;
            AZ(n,idx(2)) = AZ02;
        end
    end


    % plot
    polar(deg2rad(AZ(1:2:end,:)+90)',90-GA(1:2:end,:)','k-')

else
    polarplot(deg2rad(az(1:2:end,:)+90)',90-GA(1:2:end,:)','k-')
end
hold on

% user date
if ~isempty(date)
    AZD = NaN(1,23*2);
    GAD = NaN(1,23*2);
    idx = 1;
    for h = 0:23
        for m = [0 30]
            [AZD(idx),GAD(idx)] = sunpos(date,[num2str(h,'%02d'),':',num2str(m,'%02d'),':00'],coord(1),coord(2));
            idx = idx+1;
        end
    end
    if exist('OCTAVE_VERSION', 'builtin')

        % Octave's polar plot shows lines outside the figure, the following code cleans that up

        % interpolate azimuth angle for gamma = 0°
        GA = GAD;
        AZ = AZD;

        % interpolate azimuth values
        AZ01 = interp1(GA(1:length(GA)/2),AZ(1:length(GA)/2),0);
        AZ02 = interp1(GA(length(GA)/2+1:end),AZ(length(GA)/2+1:end),0);
        idx = GA<0;
        % set gamma values < 0 to NaN -> not plotted
        GA(idx) = NaN;
        x = fliplr(find(isnan(GA(1:length(GA)/2))));
        % Add corner points 1: gamma = 0
        if ~isempty(x) && ~isequal(length(x),size(GA,1)/2)
            GA(x(1)) = 0;
            % replace azimuth angle values with interpolated values
            AZ(x(1)) = AZ01;
        end

        x = fliplr(find(isnan(GA(length(GA)/2+1:end))));
        % Add corner points 2: gamma = 0
        if ~isempty(x) && ~isequal(length(x),length(GA)/2)
            GA(length(GA)/2+x(end)) = 0;
            % replace azimuth angle values with interpolated values
            AZ(length(GA)/2+x(end)) = AZ02;
        end

        p = polar(deg2rad(AZ+90),90-GA,'--');
        set(p,'Color',c)

    else
        polarplot(deg2rad(AZD+90),90-GAD,'--','Color',c)
    end
end

% user time
if ~isempty(time)
    % get position over year
    idx = 1;
    AZT = NaN(1,length(Day));
    GAT = NaN(1,length(Day));
    for d = Day
        if isequal(length(time),5)
            time = [time,':00'];
        end
        % get month
        [~,M] = min(abs(days-d));
        if isequal(M,1)
            D = d;
        else
            D = d-days(M-1);
        end
        [AZT(idx),GAT(idx)] = sunpos([num2str(D,'%02d'),'.',num2str(M,'%02d'),'.2021'],time,coord(1),coord(2));
        idx = idx+1;
    end

    % plot
    if exist('OCTAVE_VERSION', 'builtin')

        GA = GAT;
        AZ = AZT;

        GA(GA<0) = NaN;
        idx = isnan(GA);
        idx = diff(idx);
        idx = find(idx);

        if ~isempty(idx)
            idx(2) = idx(2)+1;
            GA(idx) = 0;
        end

        p = polar(deg2rad(AZ+90),90-GA,'--');
        set(p,'Color',c)

    else
        polarplot(deg2rad(AZT+90),90-GAT,'--','Color',c)
    end

    % plot sun position
    if ~isempty(date)
        [UAZ,UGA] = sunpos(date,time,coord(1),coord(2));
        if exist('OCTAVE_VERSION', 'builtin')
            p = polar(deg2rad(UAZ+90),90-UGA,'*');
            set(p,'Color',c,'MarkerSize',6,'LineWidth',2.5);
        else
            polarplot(deg2rad(UAZ+90),90-UGA,'*','Color',c,'MarkerSize',6,'LineWidth',2.5)
        end
    end


end

% hour labels
ga2106 = ga(1:2:end,Day==d21(6));
az2106 = az(1:2:end,Day==d21(6));
ind = ga2106>0;
for n = 1:length(ind)
    if ind(n)
        if exist('OCTAVE_VERSION', 'builtin')
            if az2106(n)<270 && az2106(n)>90
                [x,y] = pol2cart(deg2rad(az2106(n))+pi/2,90-ga2106(n)-3);
                text(x,y,num2str(n-1+offset),'HorizontalAlignment','center','Color',[0.6 0.6 0.6]);
            else
                [x,y] = pol2cart(deg2rad(az2106(n))+pi/2,90-ga2106(n)+3);
                text(x,y,num2str(n-1+offset),'HorizontalAlignment','center','Color',[0.6 0.6 0.6]);
            end
        else
            if az2106(n)<270 && az2106(n)>90
                text((deg2rad(az2106(n))+pi/2),90-ga2106(n)-3,num2str(n-1+offset),'HorizontalAlignment','center','Color',[0.6 0.6 0.6]);
            else
                text((deg2rad(az2106(n))+pi/2),90-ga2106(n)+3,num2str(n-1+offset),'HorizontalAlignment','center','Color',[0.6 0.6 0.6]);
            end
        end
    end
end

% plot day lines
if exist('OCTAVE_VERSION', 'builtin')

    % Octave's polar plot shows lines outside the figure, the following code cleans that up

    % interpolate azimuth angle for gamma = 0°
    GA = ga;
    GA = GA(:,find(ismember(Day,d21)));
    AZ01 = NaN(1,size(GA,1)/2);
    AZ02 = NaN(1,size(GA,1)/2);
    AZ = az;
    AZ = AZ(:,find(ismember(Day,d21)));
    ind = 1;
    for n = 1:size(GA,2)
        % interpolate azimuth values
        AZ01(ind) = interp1(GA(1:size(GA,1)/2,n),AZ(1:size(GA,1)/2,n),0);
        AZ02(ind) = interp1(GA(size(GA,1)/2+1:end,n),AZ(size(GA,1)/2+1:end,n),0);
        ind = ind+1;
        idx = GA(:,n)<0;
        % set gamma values < 0 to NaN -> not plotted
        GA(idx,n) = NaN;
        x = fliplr(find(isnan(GA(1:size(GA,1)/2,n))));
        % Add corner points 1: gamma = 0
        if ~isempty(x) && ~isequal(length(x),size(GA,1)/2)
            GA(x(end),n) = 0;
            % replace azimuth angle values with interpolated values
            AZ(x(end),n) = AZ01(n);
        end

        x = fliplr(find(isnan(GA(size(GA,1)/2+1:end,n))));
        % Add corner points 2: gamma = 0
        if ~isempty(x) && ~isequal(length(x),size(GA,1)/2)
            GA(size(GA,1)/2+x(1),n) = 0;
            % replace azimuth angle values with interpolated values
            AZ(size(GA,1)/2+x(1),n) = AZ02(n);
        end
    end

    polar(deg2rad(AZ(:,[1:6 12])+90),90-GA(:,[1:6 12]),'k-')
else
    polarplot(deg2rad(az(:,ismember(Day,d21([1:6 12])))+90),90-ga(:,ismember(Day,d21([1:6 12]))),'k-')
end

% month labels
G = ga(:,ismember(Day,d21([1:6 12])));
A = az(:,ismember(Day,d21([1:6 12])));
lmaz = NaN(1,7);
rmaz = NaN(1,7);
months = {'Jan 21','Feb 21','Mar 21','Apr 21','May 21','Jun 21','Jul 21','Aug 21','Sep 21','Oct 21','Nov 21','Dec 21'};
d = 100;
for n = 1:size(A,2)
    lmaz(n) = interp1(G(1:size(G,1)/2,n),A(1:size(G,1)/2,n),0);
    rmaz(n) = interp1(G(size(G,1)/2+1:end,n),A(size(G,1)/2+1:end,n),0);
    if exist('OCTAVE_VERSION', 'builtin')
        if n<7
            [x,y] = pol2cart(deg2rad(lmaz(n)+90),d);
            text(x,y,months{n},'HorizontalAlignment','right','Color',[0.6 0.6 0.6])
            [x,y] = pol2cart(deg2rad(rmaz(n)+90),d);
            text(x,y,months{length(months)-n},'HorizontalAlignment','left','Color',[0.6 0.6 0.6])
        else
            [x,y] = pol2cart(deg2rad(lmaz(n)+90),d);
            text(x,y,months{12},'HorizontalAlignment','right','Color',[0.6 0.6 0.6])
            [x,y] = pol2cart(deg2rad(rmaz(n)+90),d);
            text(x,y,months{12},'HorizontalAlignment','left','Color',[0.6 0.6 0.6])
        end
    else
        if n<7
            text(deg2rad(lmaz(n)+90),d,months{n},'HorizontalAlignment','right','Color',[0.6 0.6 0.6])
            text(deg2rad(rmaz(n)+90),d,months{length(months)-n},'HorizontalAlignment','left','Color',[0.6 0.6 0.6])
        else
            text(deg2rad(lmaz(n)+90),d,months{12},'HorizontalAlignment','right','Color',[0.6 0.6 0.6])
            text(deg2rad(rmaz(n)+90),d,months{12},'HorizontalAlignment','left','Color',[0.6 0.6 0.6])
        end
    end
end

% appearance
hold off

% correct plot tick labels
pax = gca;
if exist('OCTAVE_VERSION', 'builtin')

    % re-enable warning
    warning ('on', 'Octave:data-file-in-path')

    RTick = 0:10:90;
    RTickLabel = {'90°','80°','70°','60°','50°','40°','30°','20°','10°',''};
    ThetaTick = 0:10:350;
    ThetaTickLabel = fliplr({'E','80°','70°','60°','50°','40°','30°','20°','10°',...
        'N','350°','340°','330°','320°','310°','300°','290°','280°',...
        'W','260°','250°','240°','230°','220°','210°','200°','190°',...
        'S','170°','160°','150°','140°','130°','120°','110°','100°'});

    set(pax,'ttick',ThetaTick);
    set(pax,'rtick',RTick);

    % get all labels
    labels = findall(gca, 'type', 'text');
    L = labels;
    % get label distances
    distances = cellfun(@(x)norm(x(1:2)), get(labels, 'Position'));
    % find theta lables (most common distance)
    [~, ~, b] = unique(round(distances * 100));
    h = hist(b, 1:max(b));
    labels = labels(b == find(h == max(h)));
    % set new label string for theta angles
    for k = 1:numel(labels)
        set(labels(k), 'String', ThetaTickLabel(k));
    end
    % reset labels
    labels = L;
    % get label angles
    angles = cellfun(@(x)cart2pol(x(1:2)), get(labels, 'Position'),'UniformOutput',0);
    angles = cell2mat(angles);
    % find rho labels (most common angle)
    [~, ~, b] = unique(round(angles(:,1) * 100));
    h = hist(b, 1:max(b));
    labels = labels(b == find(h == max(h)));
    % set new label string for theta angles
    for k = 1:numel(labels)
        set(labels(k), 'String', RTickLabel(end-k+1));
    end

else
    axis([0 360 0 90])
    pax.ThetaTick = 0:10:350;
    pax.ThetaTickLabel = {'E','80°','70°','60°','50°','40°','30°','20°','10°',...
        'N','350°','340°','330°','320°','310°','300°','290°','280°',...
        'W','260°','250°','240°','230°','220°','210°','200°','190°',...
        'S','170°','160°','150°','140°','130°','120°','110°','100°'};
    pax.RTick = 10:10:80;
    pax.RTickLabel = {'80°','70°','60°','50°','40°','30°','20°','10°'};
end

title(['longitude: ',num2str(coord(1)),'°   latitude: ',num2str(coord(2)),'°'])

