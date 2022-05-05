% getskytype determines the CIE sky type for a given luminance distribution
% of a  tregenza hemisphere.
%
% usage: getskytype(L,az,el,mode)
%
% where: L is a vector containing the luminance distribution
%        az defines the sun's azimuth angle
%        el defines the sun's elevation angle
%        mode selects the detemination method:
%           -'tregenza' for Tregenza method which considers the whole 
%             hemisphere, see:
%             "Analysing sky luminance scans to obtain frequency 
%              distributions of CIE Standard General Skies"
%              DOI: 10.1191/1477153504li117oa
%           - 'kobav' for method by kobav et al. which considers only parts
%              of the hemisphere, see:
%              "Characterization of sky scanner measurements based on CIE
%              and ISO standard CIE S 011/2003"
%              DOI: 10.1177/1477153512458916
%
% References:
% ISO 15469:2004(E)/CIE S 011/E:2003: Spatial Distribution of Daylight - 
% CIE Standard General Sky. Commission Internationale de l'Éclairage (CIE),
% Vienna Austria, 2004.
% https://cie.co.at/publications/spatial-distribution-daylight-cie-standard-general-sky
%
% Peter Roy Tregenza: Subdivision of the sky hemisphere for luminance measurements.
% In: Lighting Research and Technology, vol. 19, no. 1, pp. 13-14, 1987, 
% (DOI: 10.1177/096032718701900103).
% https://journals.sagepub.com/doi/10.1177/096032718701900103
%
% Peter Roy Tregenza: Analysing sky luminance scans to obtain frequency 
% distributions of CIE Standard General Skies. In: Lighting Research and 
% Technology, vol. 36, no. 4, pp. pp. 271–281, 2004, (DOI: 10.1191/1477153504li117oa).
% https://journals.sagepub.com/doi/abs/10.1191/1477153504li117oa?journalCode=lrtd
%
% Kobav M, Bizjak G, Dumortier D.: Characterization of sky scanner measurements
% based on CIE and ISO standard CIE S 011/2003. In: Lighting Research & Technology,
% vol. 45, no. 4, pp. 504–512, 2012, (DOI: 10.1177/1477153512458916).
% https://journals.sagepub.com/doi/10.1177/1477153512458916?icid=int.sj-abstract.citing-articles.1
%
% Function author: Frederic Rudawski
% Date: 02.02.2022
% See: https://www.frudawski.de/getskytype

function [sky,rms] = getskytype(L,az,el,mode,parameter)

if ~exist('mode','var')
    mode = 'tregenza';
    parameter = 'center';
else
    if ~exist('parameter','var')
       switch mode
           case 'tregenza'
               parameter = 'center';
           case 'kobav'
               parameter = 'cie';
       end
    end
end

switch mode
    case 'tregenza'
        [sky,rms] = tregenzaskytype(L,az,el,parameter);
    case 'kobav'
        [sky,rms] = kobavskytype(L,az,el,parameter);
end


end




