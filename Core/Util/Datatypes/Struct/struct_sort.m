function [in, ix] = struct_sort(in, fields, modes)

% struct_sort - sort struct in various fields
% -------------------------------------------
%
% [out, ix] = struct_sort(in, fields, modes)
%
% Input:
% ------
%  in - input struct array
%  fields - fields to sort by
%  modes - sort modes
%
% Output:
% -------
%  out - sorted struct
%  ix - permutation indices

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% check fields input
%--

if ischar(fields)
	fields = {fields};
end

if ~iscellstr(fields)
	error('Fields input must be a string o string cell array.');
end

for k = 1:length(fields)
	
	if ~isfield(in, fields{k})
		error(['Sort field ''', fields{k}, ''' is not available.']);
	end
	
end

%--
% set and check order
%--

if nargin < 3
	modes = ones(size(fields));
else
	if numel(fields) ~= numel(modes)
		error('Mismatch between fields and modes.');
	end 
end

%---------------------
% SORT
%---------------------

%--
% loop over sort fields
%--

for k = 1:length(fields)
	
	%--
	% get permutation indices for field sort
	%--
	
	% TODO: there should be a reasonable message when we can't sort a field
	
	try
		ix = sort_helper({in.(fields{k})}, modes(k));
	catch
		xml_disp(lasterror); continue;	
	end
	
	%--
	% sort struct
	%--
	
	in = in(ix);
	
end


%---------------------
% SORT_HELPER
%---------------------

function [ix, values] = sort_helper(values, mode)

%--
% align values 
%--

% NOTE: this also strings out dimensions

values = values(:);

%--
% sort strings
%--

if iscellstr(values)
			
	[values, ix] = sort(values);

	if mode <= 0
		ix = flipud(ix);
	end

%--
% sort others
%--

else

	if mode > 0
		mode = 'ascend';
	else
		mode = 'descend';
	end

	[values, ix] = sort(values, 1, mode);

end
