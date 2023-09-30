% Write luminous intensity distribution curve to .ldt EULUMDAT file
%
% usage: writeldt(file,ldt)
%
% where: file: specifies the file name
%        ldt: is the to be written ldt struct
%
% Author: Frederic Rudawski
% Date: 26.02.2023 (sunday)
% See: https://www.frudawski.de/writeldt

function writeldt(file,ldt)

% adjust luminous flux
ldt.header.lamp_luminous_flux = round(ldt2Phi(ldt));

% adjust luminous intensity
ldt.I = ldt.I./ldt.header.luminous_intensity_factor;

% struct fields
f = fieldnames(ldt.header);

% open file
fileID = fopen(file,'w');

% write header
for n = 1:length(f)-1
    value = getfield(ldt.header,f{n});
    if isnumeric(value)
        fprintf(fileID,[num2str(value),'\n']);
    else
        fprintf(fileID,[value,'\n']);
    end
end
for n = 1:length(ldt.header.direct_ratio)
    value = ldt.header.direct_ratio(n);
    fprintf(fileID,[num2str(value),'\n']);
end

% write I data
switch ldt.header.symmetry
    case 0 % no symmetry
        fprintf(fileID,'0\n');
        C = 0:ldt.header.delta_C:(ldt.header.number_of_C_planes-1)*ldt.header.delta_C;
        for n = 1:length(C)
            fprintf(fileID,[num2str(C(n)),'\n']);
        end
        G = 0:ldt.header.delta_gamma:(ldt.header.number_of_gamma_planes-1)*ldt.header.delta_gamma;
        for n = 1:length(G)
            fprintf(fileID,[num2str(G(n)),'\n']);
        end
        I = ldt.I(:);
        for n = 1:length(I)
            value = I(n);
            fprintf(fileID,'%.2f\n',value);
        end
    case 1 % symmetry: vertical axis
        fprintf(fileID,'0\n');
        G = 0:ldt.header.delta_gamma:(ldt.header.number_of_gamma_planes-1)*ldt.header.delta_gamma;
        for n = 1:length(G)
            fprintf(fileID,[num2str(G(n)),'\n']);
        end
        for n = 1:size(ldt.I,1)
            value = ldt.I(n,1);
            fprintf(fileID,'%.2f\n',value);
        end
    case 2 % symmetry: C0-C180
        C = 0:ldt.header.delta_C:(ldt.header.number_of_C_planes-1)*ldt.header.delta_C;
        for n = 1:length(C)
            fprintf(fileID,[num2str(C(n)),'\n']);
        end
        G = 0:ldt.header.delta_gamma:(ldt.header.number_of_gamma_planes-1)*ldt.header.delta_gamma;
        for n = 1:length(G)
            fprintf(fileID,[num2str(G(n)),'\n']);
        end
        I = ldt.I(:);
        for n = 1:length(I)
            value = I(n);
            fprintf(fileID,'%.2f\n',value);
        end
    case 3 % symmetry C90-C270
        
    case 4 % symmetry C0-C180 & C90-C270
        C = 0:ldt.header.delta_C:(ldt.header.number_of_C_planes-1)*ldt.header.delta_C;
        for n = 1:length(C)
            fprintf(fileID,[num2str(C(n)),'\n']);
        end
        G = 0:ldt.header.delta_gamma:(ldt.header.number_of_gamma_planes-1)*ldt.header.delta_gamma;
        for n = 1:length(G)
            fprintf(fileID,[num2str(G(n)),'\n']);
        end
        I = ldt.I(:,1:round(ldt.header.number_of_C_planes/4)+1);
        I = I(:);
        for n = 1:length(I)
            value = I(n);
            fprintf(fileID,'%.2f\n',value);
        end
    otherwise
        error(['Symmetry mode ',num2str(ldt.header.symmetry),' not supported.'])
end

% close file
fclose(fileID);




