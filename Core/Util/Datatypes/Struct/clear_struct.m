function out = clear_struct(in)

% clear_struct - clear contents of struct
% ---------------------------------------
%
% out = clear_struct(in)
%
% Input:
% ------
%  in - structure
%
% Output:
% -------
%  out - structure with empty values

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% check for scalar struct input
%--

if (~isstruct(in) || (length(in) > 1))
	error('Scalar structure input is required.');
end

% NOTE: return same on empty, although this is a different type of empty

if (length(in) == 0)
	out = in; return;
end

%-----------------------------------
% CLEAR STRUCT
%-----------------------------------

%--
% get fields from flattened struct and put together input for struct
%--

in = fieldnames(flatten_struct(in));

in(:,2) = {[]};

% NOTE: we transpose to interleave fields and values in comma-separated list

in = in';

%--
% build empty struct and unflatten
%--

out = unflatten_struct(struct(in{:}));
