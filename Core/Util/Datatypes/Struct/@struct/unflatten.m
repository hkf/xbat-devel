function out = unflatten(in, sep)

% unflatten - unflatten struct
% ----------------------------
%
% out = unflatten(in, sep)
%
% Input:
% ------
%  in - flattened scalar struct
%  sep - field separator (def: '__', double underscore)
%
% Output:
% -------
%  out - unflattened struct

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

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default separator
%--

if (nargin < 2) 
	sep = '__';
end

%--
% check for scalar struct
%--

if (length(in) ~= 1)
	error('Scalar struct input is required.');
end

%---------------------------------------
% UNFLATTEN STRUCTURE
%---------------------------------------

% NOTE: the order of flattening and unflattening matters

field = fieldnames(in);

for k = 1:length(field)
	eval(['out.', strrep(field{k}, sep, '.'), ' = in.', field{k}, ';']);
end
