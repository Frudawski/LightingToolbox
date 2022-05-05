% plot simplified cie L*a*b* chromaticity

function plotcielab(lab)

% check input
if ~exist('lab','var')
    L = 50;
    a = NaN;
    b = NaN;
else
    if isequal(numel(lab),1)
        L = lab;
        a = NaN;
        b = NaN;
    elseif isequal(numel(lab),0)
        L = 50;
        a = NaN;
        b = NaN;
    else
        L = lab(:,1);
        a = lab(:,2);
        b = lab(:,3);
    end
end
% resolution
pixel = 1000;
grids = linspace(-160,160,pixel);
l = ones(size(grids)).*L;

% lab grid
A = meshgrid(grids,grids);
B = flipud(meshgrid(grids,grids)');
l = meshgrid(l,l);
cf = linspace(0,pi,100);

% limit
lim = sin(cf(round(L)));

step = 0.001;
% colour diagram
v = 0:step:1;
[x,y] = meshgrid(v,v);
y = flipud(y);
z = (1-x-y);
data = cat(3,l,A,B);
lab = reshape(data,[size(data,1)*size(data,2),3]);
xyz = cielab2xyz(lab);
srgb = xyz2srgb(xyz,'D65');
rgb  = reshape(srgb,[size(data,1),size(data,2),3]);
% mask
mask = A.^2+B.^2;
mask(mask>(128*lim)^2) = 0;
mask(mask>0) = 1;
mask = cat(3,mask,mask,mask);
% plot chromticity
imshow(rgb.*mask+~mask)
f = 20;

axis([-pixel/f pixel+pixel/f -pixel/f pixel+pixel/f])
hold on
% coordinates cross
plot(ones(1,100).*pixel/2,linspace(pixel/f,pixel-pixel/f,100),'k','LineWidth',0.5)
plot(linspace(pixel/f,pixel-pixel/f,100),ones(1,100).*pixel/2,'k','LineWidth',0.5)
plot([pixel-2*pixel/f/1.5 pixel-pixel/f pixel-2*pixel/f/1.5],[pixel/2+pixel/3/f pixel/2 pixel/2-pixel/3/f],'k','LineWidth',0.5)
plot([pixel/2+pixel/3/f pixel/2 pixel/2-pixel/3/f],pixel-[pixel-2*pixel/f/1.5 pixel-pixel/f pixel-2*pixel/f/1.5],'k','LineWidth',0.5)
% a and b + L
text(pixel/2,pixel/f/2,'b*','HorizontalAlignment','center','Interpreter','latex')
text(pixel-pixel/f/1.25,pixel/2-pixel/250,'a*','VerticalAlignment','middle','Interpreter','latex')
text(pixel-pixel/f, pixel/f, ['L* = ',num2str(L)],'HorizontalAlignment','right','Interpreter','latex')
if ~isnan(a) && ~isnan(b)
    text(pixel-pixel/f, pixel/f+45, ['a* = ',num2str(a)],'HorizontalAlignment','right','Interpreter','latex')
    text(pixel-pixel/f, pixel/f+90, ['b* = ',num2str(b)],'HorizontalAlignment','right','Interpreter','latex')
end

% circle coordinates with adaptive L radius
r = (pixel/2-2*pixel/f).*lim;
xm = pixel/2;
ym = pixel/2;
% circle 
phi = linspace(0,360,200);
phi = phi./180.*pi;
[xtmp,ytmp] = pol2cart(phi,r); 
x=xtmp+xm;
y=ytmp+ym;
plot(x,y,'k')
% plot a & b coordinate
if L >= 50
    plot(pixel/2+a./128.*(pixel/2-2.1*pixel/f),pixel/2-b./128.*(pixel/2-2.1*pixel/f),'kx');
else
    plot(pixel/2+a./128.*(pixel/2-2.1*pixel/f),pixel/2-b./128.*(pixel/2-2.1*pixel/f),'wx');
end
grid minor
axis off
title('CIE 1976 L*a*b* chromaticity')
hold off
% axis
xticks([100:100:900])
yticks([100:100:900])
xticklabels({'-100','-75','-50','-25','0','25','50','75','100'})
yticklabels({'100','75','50','25','0','-25','-50','-75','-100'})
    
