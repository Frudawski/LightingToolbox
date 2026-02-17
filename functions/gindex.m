% G-Index
%
% usage: [G,ratio] = gindex(lam,spec,threshold)
%
% with: G = G-Index
%       optional: ratio = ratio of spectral power up to threshold, compared to full spectrum spectral power
%       lam = wavelength steps in nm
%       spec = spectral power distribution threshold = spectral upper
%       optional: threshold in nm, default: 500 nm
%
% Reference:
% Donatello, S., Rodriguez Quintero, R., De Oliveira Gama Caldas, M., Wolf,
% O., Van Tichelen, P., Van Hoof, V. and Geerken, T., Revision of the EU 
% Green Public Procurement Criteria for Road Lighting and traffic signals, 
% EUR 29631 EN, Publications Office of the European Union, Luxembourg, 2019, 
% ISBN 978-92-79-99077-9, doi:10.2760/372897, JRC115406.
%
% Author: Frederic Rudawski
% Date: 13.02.2026
% See: https://www.frudawski.de/gindex

function [G,ratio] = gindex(lam,spec,threshold)

% check for threshold value
if ~exist('theshold','var')
    threshold = 500; 
end

% initiate
G = NaN(size(spec,1),1);
ratio = NaN(size(spec,1),1);
ind = NaN(1,size(lam,1));

% find lam value index closest to threshold
for n = 1:size(lam,1)
    [~,ind(n)] = min(abs(lam(n,:)-threshold));
end
% compare matrix size of lam and spec
if size(lam,1) ~= size(spec,1)
    ind = repmat(ind,size(spec,1),1);
    lam = repmat(lam,size(spec,1),1);
end

% determine G-index for each spectrum - allowing for different wavelength steps
for n = 1:size(spec,1)
    % ratio
    ratio(n,1) = ciespec2unit(lam(n,1:ind(n)),spec(n,1:ind(n)),'E',1)./ciespec2unit(lam(n,:),spec(n,:),'E',1).*100;
    % G-Index
    G(n,1) = -2.5.*log10(ciespec2unit(lam(n,1:ind(n)),spec(n,1:ind(n)),'E',1)./ciespec2Y(lam(n,:),spec(n,:),1));
end

