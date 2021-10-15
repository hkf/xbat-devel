function [in,flag,failed] = set_field(in,varargin)

% set_field - set structure field
% -------------------------------
%
% [value,flag,failed] = set_field(in,'field',value, ... ,'field',value)
%
% Input:
% ------
%  in - structure to extract from
%  field - field name
%  value - field value
%
% Output:
% -------
%  in - result struct
%  flag - failure indicator
%  failed - failed fields

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
% get field value pairs
%--

[field,value] = get_field_value(varargin);

%--
% set fields to values
%--

failed = cell(0);

for k = 1:length(field)
	
	[in,flag] = inject_field(in,field{k},value{k});
	
	if (flag)
		failed{end + 1} = field{k};
	end
	
end

%--
% flag number of failures
%--

flag = length(failed);


%--------------------------------
% INJECT_FIELD
%--------------------------------

function [in,flag] = inject_field(in,field,value)

% inject_field - set value of existing structure field
% ----------------------------------------------------
%
% [in,flag] = inject_field(in,field,value)
%
% Input:
% ------
%  in - input struct
%  field - field set string
%  value - field value to set
%
% Output:
% -------
%  in - possibly modified structure
%  flag - failure indicator

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

% NOTE: we will not be injecting unavailable fields

%--
% inject field
%--

if (any(field == '.'))
	
	%--
	% return if there is no field to set
	%--
	
	var = ['in.', field];
	
	try
		eval([var, ';']);
	catch
		flag = 1; return;
	end

	%--
	% inject field
	%--

	eval([var, ' = value;']); flag = 0;
	
%--
% set field
%--

else
	
	%--
	% return if there is no field to set
	%--
	
	if (~isfield(in,field))
		flag = 1; return;
	end

	%--
	% set field
	%--
	
	in.(field) = value; flag = 0;
	
end
