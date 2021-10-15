function [value, flag] = get_field(in, field, default)

% get_field - get field from structure
% ------------------------------------
%
% [value,flag] = get_field(in, field, default)
%
% Input:
% ------
%  in - structure to extract from
%  field - field extraction string
%  default - default if extraction fails
%
% Output:
% -------
%  value - result value
%  flag - default indicator

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--
% get field
%--

% NOTE: we allow a small amount of duplication to allow skipping try

if (nargin < 3)

	value = extract_field(in, field); flag = 0;

else

	% get field with default
	
	try
		value = extract_field(in, field); flag = 0;
	catch
		value = default; flag = 1;
	end

end


%--------------------------------
% EXTRACT_FIELD
%--------------------------------

function value = extract_field(in, field)

% NOTE: we do this to handle typical flattened struct names gracefully

if any(field == '_')
	field = strrep(field, '__', '.');
end

% NOTE: we extract composite field using eval, and simple fields directly

if any(field == '.')
	value = eval(['in.', field]);
else
	value = in.(field);
end
