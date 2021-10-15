function value = is_control_command(command)

% is_control_command - check whether input is control command
% -----------------------------------------------------------
%
% value = is_control_command(command)
%
% Input:
% ------
%  command -  command
%
% Output:
% -------
%  value - command indicator

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
% $Revision: 3297 $
% $Date: 2006-01-29 12:34:00 -0500 (Sun, 29 Jan 2006) $
%--------------------------------

% TODO: consider using 'ismember' and discarding this function altogether

value = ~isempty(find(strcmp(get_control_commands,command)));
