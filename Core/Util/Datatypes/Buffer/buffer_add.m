function buf = buffer_add(buf,content)

% buffer_add - add entry to buffer
% --------------------------------
%
% buf = buffer_add(buf,content)
%
% Input:
% ------
%  buf - buffer
%  content - entry content
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

% update index and store content

buf.index = max(1, mod(buf.index + 1, buf.length + 1));

buf.content{buf.index} = content;

buf.updated(buf.index) = now;
