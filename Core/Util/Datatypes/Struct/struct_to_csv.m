function [lines, header] = struct_to_csv(in, fun)

% struct_to_csv - convert struct to CSV lines of text
% ---------------------------------------------------
%
% [lines, header] = struct_to_csv(in, fun)
%
% Input:
% ------
%  in - struct
%  fun - text conversion helper (def: @to_str)
%
% Output:
% -------
%  lines - struct field value lines
%  header - header line
% 
% NOTE: we cannot handle a struct field that contains a struct array

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

%-------------------
% HANDLE INPUT
%-------------------

%--
% set no conversion helper default
%--

% NOTE: move this helper to the 'Util' directory and write some tests

if nargin < 2
	fun = @to_str;
end

%--
% check for struct input and vectorize
%--

if ~isstruct(in)
	error('Input must be struct.'); 
end

in = in(:)';

%-------------------
% CONVERT STRUCT
%-------------------

%--
% build a value line for each element of the struct array
%--

values = struct2cell(in);

lines = cell(size(values, 3), 1);

for k = 1:length(lines)
	lines{k} = str_implode(values(:, :, k), ', ', fun);
end

%--
% compute the header from fieldnames if needed
%--

if (nargout > 1) || ~nargout
	header = str_implode(fieldnames(in), ', ');
end

%-------------------
% DISPLAY TEMP
%-------------------

if ~nargout
	
	out = [tempname, '.csv']
	
	file_writelines(out, {header, lines{:}});
	
    if ispc
        winopen(out);
    else
        edit(out);
    end
       
end
