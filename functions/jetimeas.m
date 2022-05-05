% Trigger JETI specbos measurement
%
% usage: jetimeas(jeti,mode,time,n)
%
% where: jeti is the seriell connection object
%        mode defines the operation mode 'spec' or 'values'
%        time defines the integration time in ms
%        n defines the number of measurements
%
% Author: Frederic Rudawski based on a script of Vivith Karumuri
% Date: 08.06.2021
% See: https://www.frudawski.de/jetimeas

function meas = jetimeas(jeti,par,int_time,num_meas)

if ~exist('int_time','var')
    int_time = 0; % 0 = auto
end
if ~exist('num_meas','var')
    num_meas = 1;
end

switch par
    
    case 'spec'
        
        % measure spectrum
        
        % initialize function output
        SpectralRad = zeros(size(jeti.UserData.lam));
        % clear JETI output
        flush(jeti)
        writeline(jeti,['*MEAS:SPRAD ',num2str(int_time),' ',num2str(num_meas),' ','7']);
        % wait for JETI measurement if integration time is set
        pause(int_time/1000*num_meas)
        % Read JETI output
        n = length(jeti.UserData.lam);
        for i=1:1:n+2    
            output(i) = readline(jeti);
            if(i>2)
                SpectralRad(i-2) = str2double(extractAfter(output(i),char(9)));
                wavelengths(i-2,1) = str2double(extractBefore(output(i),char(9)));
            end
        end
        meas = SpectralRad;
        
    case 'values'

        % measure derivative Values - Radiance, Luminance, x,y,u',v',Dominant Wavelength, Colour purity,CCT

        % clear JETI output
        flush(jeti)
        % request JETI values
        writeline(jeti,['*MEAS:ALLVAL ',num2str(int_time),' ',num2str(num_meas),' ','7']);
        % wait for JETI measurement if integration time is set
        pause(int_time/1000*num_meas)
        % Read JETI output
        for i=1:1:8             
            output(i) = readline(jeti);
        end
        MeasValues.Ir_Radiance  = str2double(extractAfter(output(1),char(9)));
        MeasValues.Il_Luminance = str2double(extractAfter(output(2),char(9)));
        MeasValues.Chrom_x = str2double(extractAfter(output(3),char(9)));
        MeasValues.Chrom_y = str2double(extractAfter(output(4),char(9)));
        MeasValues.chrom_u = str2double(extractAfter(output(5),char(9)));
        MeasValues.chrom_v = str2double(extractAfter(output(6),char(9)));
        MeasValues.Dominant_Wavelength = str2double(extractAfter(output(7),char(9)));
        MeasValues.Colour_Purity_Percent = str2double(extractAfter(output(8),char(9)));

        meas = MeasValues;
    otherwise
        error(['unknown operation mode: ',par])
end

%*PARA
%*CONf
%*INIT
%*FETCH
%*READ
%*MEAS
%*CONTR
%*CALC
end
