function value = is_extension_type(type)

% is_extension_type - check whether proposed string is extension type
% -------------------------------------------------------------------
%
% value = is_extension_type(type)
%
% Input:
% ------
%  type - proposed type string
%
% Output:
% -------
%  value - result of test

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
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

if ~ischar(type)
	value = 0; return;
end

if strcmpi(type, 'extension_type')
	value = 1; return;
end

% value = ismember(lower(type), get_extension_types);

value = ~isempty(find(strcmp(get_extension_types, type), 1));
