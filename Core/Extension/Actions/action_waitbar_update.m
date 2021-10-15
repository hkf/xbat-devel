function action_waitbar_update(pal, progress, result, type)

% action_waitbar_update - update function for action waitbar
% ----------------------------------------------------------
%
% action_waitbar_update(pal, progress, result, type)
%
% Input:
% ------
%  pal - waitbar handle
%  result - current target result

% Copyright (C) 2002-2007 Harold K. Figueroa (hkf1@cornell.edu)
% Copyright (C) 2005-2007 Matthew E. Robbins (mer34@cornell.edu)
%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%------------------------
% PROGRESS
%------------------------

waitbar_update(pal, 'PROGRESS', 'value', progress);

%------------------------
% RESULTS
%------------------------

% NOTE: return if there are no results to report

if isempty(result)
	return;
end 

%--
% get listbox handle and string
%--

handles = get_control(pal, 'results', 'handles');

if isempty(handles.obj)
	return;
end

value = get(handles.obj, 'string');

if isempty(value)
	value = {};
end

%--
% update listbox string
%--

value = {value{:}, result_message(result, type)};

% NOTE: the value setting highlights the latest result string

set(handles.obj, ...
	'string', value, 'value', length(value) ...
);


%--------------------------------------------------------------
% RESULT_MESSAGE
%--------------------------------------------------------------

function str = result_message(result, type)

% result_message - produce a message string for an action result
% --------------------------------------------------------------
%
% str = result_message(result, type)
%
% Input:
% ------
%  result - action result
%  type - action type
%
% Output:
% -------
%  str - message string

%--
% display action name
%--

% NOTE: the action name is 'prepare', target name, or 'conclude'

if ischar(result.target)
	str = [upper(result.target), '  '];
else
	str = [get_action_target_name(result.target, type), '  '];
end

%--
% indicate action status in message
%--

switch result.status
		
	case {'undefined', 'failed'}
		
		str = [str, '(', upper(result.status), ')'];
		
	case 'done'
		
		if ~isempty(result.elapsed)
			
			if result.elapsed < 2
				str = [str, '(', num2str(result.elapsed, 4), ' sec)'];
			else
				str = [str, '(', sec_to_clock(result.elapsed), ')'];
			end
			
		end
		
end

%--
% append message to result if needed
%--

if ~isempty(result.message)
	str = [str, '  ', result.message];
end

