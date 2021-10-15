function tok = str_split(str, sep)

% str_split - split strings using delimiter
% -----------------------------------------
%
% tok = str_split(str, sep)
%
% Input:
% ------
%  str - string to split
%
% Output:
% -------
%  tok - string tokens as defined by delimiter

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

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default delimiter
%--

if nargin < 2
	sep = ' ';
end

% NOTE: return full string as cell if delimiter is empty

if isempty(sep)
	tok = {str}; return
end

%-----------------------------------
% SPLIT STRING
%-----------------------------------

%--
% separate string using delimiter
%--

n = length(sep);

switch n
	
	%--
	% single character separator
	%--
	
	case 1
		
		% NOTE: this is only worthwhile if 'strread' is generally much faster
		
		% NOTE: 'strread' fails for the '\' separator, maybe for others
		
		try
			tok = strread(str, '%s', 'delimiter', sep);
		catch
			tok = str_split_int(str, sep, n);
		end
		
	%--
	% multiple character separator
	%--
	
	otherwise

		tok = str_split_int(str, sep, n);
		
end


%-----------------------------------
% STR_SPLIT_INT
%-----------------------------------

function tok = str_split_int(str, sep, n)

ix = findstr(str, sep);

if isempty(ix)
	tok = {str}; return;
end

ix1 = [1, ix + n];

ix2 = [ix - 1, length(str)];

for k = 1:length(ix1)
	tok{k} = str(ix1(k):ix2(k));
end
