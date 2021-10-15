function keep(varargin)

% keep - keeps a set of variables
% -------------------------------
% 
% keep x1 ... xN
%
% Input:
% ------
%  x1 ... xN - names of variables to keep (separated by spaces)

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
% $Revision: 1.0 $
% $Date: 2003-07-06 13:36:06-04 $
%--------------------------------

%--
% get variables in base workspace
%--

v = evalin('base','who');
vlen = length(v);

%--
% create list of variables to delete
%--

ix = ones(vlen,1);

for k = 1:nargin
	ix = ix & ~strcmp(v,varargin{k});
end

d = find(ix);

dlen = length(d);

%--
% delete indicated variables if any
%--

if (dlen)

	str = 'clear';
	
	for k = 1:dlen
		str = [str,' ',v{d(k)}];
	end
	
	evalin('base',str);
	
end
