% Create a serialport JETI connection
%
% usage: [jeti,device] = jeticon(COM,lam1,lam2,dlam,timeout)
%
% where: -jeti is the serial object for communication with JETI device
%        -device is the device specific returned information
%        -COM specifies the COM port of the JETI conneciton (use the command
%         seriallist or serialportlist for list of all devices)
%        - lam1 is the start wavelength for JETI measurements (default: 380 nm)
%        - lam2 is the end wavelength for JETI measurements (default: 780 nm)
%        - dlam is the wavelength step, 1 or 5 nm (default = 1)
%        - timeout in s (default: 60 s)
%
% Author: Frederic Rudawski based on a script of Vivith Karumuri
% Date: 08.06.2021
% See: https://www.frudawski.de/jeticon

function [jeti,dev] = jeticon(JETI_COM,lam1,lam2,dlam,timeout)

% check for COM port input
if ~exist('JETI_COM','var')
    s = seriallist;
    if isequal(size(s,1),1)
        JETIC_COM = s;
    end
else
   if isempty(JETI_COM)
       s = seriallist;
       if isequal(size(s,1),1)
            JETIC_COM = s;
       end
   end
end

% check wavelength input
if ~exist('lam1','var')
    lam1 = 380;
end
if ~exist('lam2','var')
    lam2 = 780;
end
if ~exist('dlam','var')
    dlam = 1;
end
switch dlam
    case 1
    case 5
    otherwise
        error('JETI serialport connection: delta lambda must equal 1 or 5!')
end
if ~exist('timeout','var')
    timeout = 60;
end
% connection to spectroradiometer COM port, Check the COM port in Device Manager or use seriallist
jeti = serialport(JETI_COM,921600,"Timeout",timeout); % Set Baudrate to 921600, time out in seconds
configureTerminator(jeti,"CR"); % use CR as Terminator (ALL JETI use CR as terminator)
writeline(jeti,"*IDN?") % Identifier to check the name of the device 
dev = readline(jeti); % Output

% check for JETI
%if ~strcmp(dev(1:4),'JETI')
%    jeti = [];
%    dev = [];
%end

 % set output spectrum wavelength range and step size = 1 or 5
 if ~isempty(dev)
     confstr = ['*CONF:WRAN ',num2str(lam1),' ',num2str(lam2),' ',num2str(dlam)];
     writeline(jeti,confstr);
     jeti.UserData.lam = lam1:dlam:lam2;
     jeti.UserData.laser = 0;
 else
     % no conncetion
     jeti = [];
     error('No JETI device found!')
 end
 
end