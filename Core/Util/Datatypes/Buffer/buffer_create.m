function buf = buffer_create(n,content)

% buffer_create - create a circular buffer of entries
% ---------------------------------------------------
%
% buf = buffer_create(n,content)
%
% Input:
% ------
%  n - length of buffer
%  content - initial content
%
% Output:
% -------
%  buf - buffer

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

% a buffer has a length a current index and content

buf.length = n; 

buf.index = 1;

buf.content = cell(n,1);

buf.updated = zeros(n,1);

% TODO: extend to handle a variable number of input content

% add content if needed

if (nargin > 1) 
	buf = buffer_add(buf,content);
end
