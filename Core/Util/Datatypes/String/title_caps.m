function str = title_caps(str,pat)

% title_caps - capitalize strings as titles
% -----------------------------------------
%
% str = title_caps(str,pat)
%
% Input:
% ------
%  str - string or cell array
%  pat - space representation pattern (def: '_')
%
% Output:
% -------
%  str - title capitalized strings 

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
% $Revision: 1953 $
% $Date: 2005-10-19 20:22:46 -0400 (Wed, 19 Oct 2005) $
%--------------------------------

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

%--
% set space representation character
%--

if (nargin < 2)
	pat = '_';
end

%--
% handle cell array input recursively
%--

if iscell(str)
		
	for k = 1:numel(str)
		str{k} = title_caps(str{k}, pat);
	end

	return;
	
end

%--
% check for string input
%--

% NOTE: we do nothing is input is not string

if ~ischar(str)
	return;
end

%-----------------------------------------------------
% CAPITALIZE STRING
%-----------------------------------------------------

% NOTE: return quickly for empty strings

if isempty(str)
	return;
end

%--
% apply space replacement if needed
%--

if ~isempty(pat)
	str = strrep(str, pat, ' ');
end

% NOTE: trim spaces and return quickly if string is only space

str = strtrim(str);

if isempty(str)
	return;
end

%--
% capitalize string
%--

% NOTE: capitalize first character and characters following a space or hyphen

try
	
	ix = [1, findstr(str, ' ') + 1, findstr(str, '-') + 1];

	str(ix) = upper(str(ix));

end
	
