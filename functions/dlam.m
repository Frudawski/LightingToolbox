% dlam determines the Delta lambda steps for given wavelengths

function [d,lambda] = dlam(lambda)

% evaluate wavelengths
[lambda,idx] = sort(lambda,2);

% spectral range
range(1) = lambda(1);
range(2) = lambda(end);

% lambda range indices
[~,First] = min(abs(lambda(1,:)-range(1)));
[~,Last]  = min(abs(lambda(1,:)-range(2)));

% lamba step width
wave = lambda(lambda~=0);

if ~isempty(wave)
    if wave(1) >= range(1)
        leftstep = zeros(size(lambda));
        leftstep(:,1) = (lambda(:,2)-lambda(:,1))/2;
        leftstep(:,end) = (lambda(:,end)-lambda(:,end-1))/2;
        leftstep(:,2:end-1) = (lambda(:,First+1:Last-1) - lambda(:,First:Last-2))./2;
    else
        leftstep  = (lambda(:,First:Last) - lambda(:,First-1:Last-1))./2;
    end
    if wave(end) <= range(2)
        rightstep = zeros(size(lambda));
        rightstep(:,1) = (lambda(:,2)-lambda(:,1))/2;
        rightstep(:,end) = (lambda(:,end)-lambda(:,end-1))/2;
        rightstep(:,2:end-1) = (lambda(:,First+2:Last) - lambda(:,First+1:Last-1))./2;
    else
        rightstep = (lambda(:,First+1:Last+1) - lambda(:,First:Last))./2;
    end
    lam = leftstep+rightstep;
else
    lam = ones(size(lambda)).*NaN;
end

d = lam(idx);

