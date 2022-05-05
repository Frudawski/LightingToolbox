% "CIE" Correlated Color Temperature calculation from x,y chromaticity
% coordinates
%
% Any errors in the data set or in results generated with the Lighting
% Toolbox are not in the liability of the CIE nor me, see licence.
%
% usage:
% Tcp = ciexy2cct(x,y,method)
%
% Tcp: Is a scalar or vector containing the resulting Correlated Colour
%      Temperature(s) (CCT) Tcp in K.
% u and v: Are the input scalars or vectors containing the CIE 1960 chromaticity 
%          coordinates u and v.
% ‘method’: (optional) Specifies the determination method:
%           'Robertson': (default) Robertson’s calculation algorithm, formerly 
%                        the only recommended algorithm by the CIE. This method 
%                        is fast and quite accurate.
%           'exact': shortest distance method as described in CIE 15:2018,
%                    very accurate but comparably slow. Results may vary with 
%                    different implementation methods. 
%
% References:
% CIE 15:2018: Colorimetry, 4th Edition. Commission Internationale de l'Eclairage
% (CIE), Vienna Austria, 2018, ISBN: 978-3-902842-13-8 , (DOI: 10.25039/TR.015.2018).
% https://cie.co.at/publications/colorimetry-4th-edition
%
% A. R. Robertson: Computation of Correlated Color Temperature and Distribution
% Temperature. In: Journal of the Optical Society of America, vol. 58, no. 11,
% pp. 1528-1535, 1968, (DOI: 10.1364/JOSA.58.001528).
% https://opg.optica.org/josa/viewmedia.cfm?uri=josa-58-11-1528&seq=0
%
% author: Frederic Rudawski
% Date: 13.11.2019 - last edited: 18.12.2019
% See: https://www.frudawski.de/ciexy2cct

function Tcp = ciexy2cct(x,y,method)

if ~exist('method','var')
    method = 'Robertson';
end

switch method
    case 'Robertson'
        Tcp = RobertsonCCT('x',x,'y',y);
    case 'Hernandez'
        Tcp = HernandezCCT('x',x,'y',y);
    case 'exact'
        Tcp = CCT('x',x,'y',y);
    otherwise
        error('Unknown CCT method!')
end

