% read luminous intensity distribution curve from .ldt EULUMDAT file
%
% usage: ldt = readldt(file)
%
% Author: Frederic Rudawski
% Date: 02.12.2021
% See: https://www.frudawski.de/readldt

function ldt = readldt(file)

ldt = [];

% open file
fid = fopen(file,'r');
if isequal(fid, -1)
    % error
    error(['Could not read file: ',file])
end

% read header
info = textscan(fid,'%s',26,'delimiter','\n');
info = info{1};

% header elements
str = {'ID','type','symmetry','number_of_C_planes','delta_C','number_of_gamma_planes','delta_gamma','protocol_number','luminaire_type','luminaire_number','filename','date_and_user','length','width','height','luminous_length','luminous_width','luminous_heigth_C0','luminous_heigth_C90','luminous_heigth_C180','luminous_heigth_C270','luminous_flux_in_lower_hemisphere','luminaire_efficiency','luminous_intensity_factor','tilt_angle','number_of_lamp_sets'};
transform = [0 1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
for n = 1:26
    if transform(n)
        eval(['header.',str{n},' = str2double(info{',num2str(n),'});']);
    else
        eval(['header.',str{n},' = info{',num2str(n),'};']);
    end
end
ldt.name = header.luminaire_type;

% read header lamp info
lamp_info = textscan(fid,'%s',header.number_of_lamp_sets*6,'delimiter','\n');
lamp_info = lamp_info{1};

% process lamp info
header.number_of_lamps = lamp_info{1:6:header.number_of_lamp_sets*6};
header.lamp_type = lamp_info{2:6:header.number_of_lamp_sets*6};
header.lamp_luminous_flux = lamp_info{3:6:header.number_of_lamp_sets*6};
header.lamp_CCT = lamp_info{4:6:header.number_of_lamp_sets*6};
header.lamp_Ra = lamp_info{5:6:header.number_of_lamp_sets*6};
header.lamp_wattage = lamp_info{6:6:header.number_of_lamp_sets*6};

% direct ratio
direct_ratio = textscan(fid,'%f',10,'delimiter','\n');
direct_ratio = direct_ratio{1};
header.direct_ratio = direct_ratio';

% add header to struct
ldt.header = header;

% get luminous intensity depending on symmetry
switch header.symmetry
    case 0
        C = textscan(fid,'%f',header.number_of_C_planes,'delimiter','\n');
        C = C{1};
        gamma = textscan(fid,'%f',header.number_of_gamma_planes,'delimiter','\n');
        gamma = gamma{1};
        [gamma,C] = meshgrid(gamma,C);
        ldt.anglesC = C';
        ldt.anglesG = gamma';
        I = textscan(fid,'%f',header.number_of_gamma_planes*header.number_of_C_planes,'delimiter','\n');
        ldt.I = reshape(I{1},header.number_of_gamma_planes,header.number_of_C_planes);
    case 1
        if isequal(header.number_of_C_planes,0) || isequal(header.number_of_C_planes,1)
            gamma = textscan(fid,'%f',header.number_of_gamma_planes+1,'delimiter','\n');
            gamma = gamma{1}(2:end);
            C = 0:15:345;
        else
            C = textscan(fid,'%f',header.number_of_C_planes,'delimiter','\n');
            C = C{1};
            gamma = textscan(fid,'%f',header.number_of_gamma_planes,'delimiter','\n');
            gamma = gamma{1};
        end
        [gamma,C] = meshgrid(gamma,C);
        ldt.anglesC = C';
        ldt.anglesG = gamma';
        I = textscan(fid,'%f',header.number_of_gamma_planes,'delimiter','\n');
        ldt.I = repmat(I{1},1,size(ldt.anglesG,2));
    case 2
        C = textscan(fid,'%f',header.number_of_C_planes,'delimiter','\n');
        C = C{1};
        gamma = textscan(fid,'%f',header.number_of_gamma_planes,'delimiter','\n');
        gamma = gamma{1};
        [gamma,C] = meshgrid(gamma,C);
        ldt.anglesC = C';
        ldt.anglesG = gamma';
        I = textscan(fid,'%f',header.number_of_gamma_planes*header.number_of_C_planes,'delimiter','\n');
        I = reshape(I{1},header.number_of_gamma_planes,header.number_of_C_planes/2+1);
        ldt.I = [I fliplr(I(:,2:end-1))];
    case 3
        C = textscan(fid,'%f',header.number_of_C_planes,'delimiter','\n');
        C = C{1};
        gamma = textscan(fid,'%f',header.number_of_gamma_planes,'delimiter','\n');
        gamma = gamma{1};
        [gamma,C] = meshgrid(gamma,C);
        ldt.anglesC = C';
        ldt.anglesG = gamma';
        I = textscan(fid,'%f',header.number_of_gamma_planes*header.number_of_C_planes,'delimiter','\n');
        I = reshape(I{1},header.number_of_gamma_planes,header.number_of_C_planes/2+1);
        ldt.I = [I(:,1:floor(size(I,2)/2)) I(:,ceil(size(I,2)/2):end) fliplr(I(:,floor(size(I,2)/2):end-1)) fliplr(I(:,2:(size(I,2)/2)-1))];
    case 4
        C = textscan(fid,'%f',header.number_of_C_planes,'delimiter','\n');
        C = C{1};
        gamma = textscan(fid,'%f',header.number_of_gamma_planes,'delimiter','\n');
        gamma = gamma{1};
        [gamma,C] = meshgrid(gamma,C);
        ldt.anglesC = C';
        ldt.anglesG = gamma';
        I = textscan(fid,'%f',header.number_of_gamma_planes*header.number_of_C_planes,'delimiter','\n');
        I = reshape(I{1},header.number_of_gamma_planes,header.number_of_C_planes/4+1);
        I = [I fliplr(I(:,1:end-1))];
        I = [I fliplr(I(:,2:end-1))];
        ldt.I = I;
end
ldt.I = ldt.I.*header.luminous_intensity_factor;

% close file
fclose(fid);


    