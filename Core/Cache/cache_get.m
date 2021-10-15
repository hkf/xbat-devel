function cache = cache_get(label)

% cache_get - clear cache entry
% -------------------------------
%
% cache = cache_get(label)
%
% Input:
% ------
%  label - label of cache entry
%
% Output:
% -------
%  cache - cache structure

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% check for label and get cache entry if it exists
%--

if (nargin < 1)
	
	disp(' ');
	error('Cache label is empty.');

else 
	
	data = get(0,'userdata');
	
	if (isfield(data,'cache') && length(data.cache))
		
		labels = struct_field(data.cache,'label');
		
		ix = find(label == labels);
		if (~isempty(ix))
			cache = data.cache(ix);
		else
			cache = [];
		end
		
	else
		
		cache = [];
		
	end
	
end
		
