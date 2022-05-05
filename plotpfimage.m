function plotpfimage(im)
% Plot LMK .pcf image function
%
% usage: plotpfimage(im)
%
% note: an epmty function call opens a popup menu for file selection
%
% For white balancing adjustment a factor between the mean and max
% value of the image matrix is calculated. 
%
% Author: Frederic Rudawski
% Date: 19.07.2017
% See: https://www.frudawski.de/plotpfimage

if ~exist('im','var')
    [file,path] = uigetfile({'*.pcf;*.pf'},'Select image');
    if isequal(file,0)
        return
    end
    if strcmp('pcf',file(end-2:end))
        im = readpcfimage([path file]);
    elseif strcmp('pf',file(end-1:end))
        im = readpfimage([path file]);
    else
       error('Unknown image extension.') 
    end
end
% image adjustment factor
f1 = mean(mean(mean(im)));
f2 = max(max(max(im)));
f = mean([log10(f1) log10(f2)]);
f = 10^(f);
% primitive image adjustment
im = log10(im./f.*10);


% show image
if size(im,3) == 3
    % color
    image(real(im));
else
    % grayscale
    imshow(im);
end

axis off
axis equal

end