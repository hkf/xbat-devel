function [value, field] = struct_pop(in)

% struct_pop - pop a single field struct
% --------------------------------------
%
% [value, field] = struct_pop(in)
%
% Input:
% ------
%  in - scalar single field struct
%
% Output:
% -------
%  value - field value
%  field - field name

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
% $Revision: 2196 $
% $Date: 2005-12-02 18:16:46 -0500 (Fri, 02 Dec 2005) $
%--------------------------------

%-------------------
% HANDLE INPUT
%-------------------

%--
% check for scalar struct
%--

if ~isstruct(in)
	error('Input must be struct.');
end

if length(in) > 1
	error('Input must be scalar struct.');
end

%--
% check for single field
%--

field = fieldnames(in);

if length(field) > 1
	error('Struct to pop must have a single field.');
end

%-------------------
% POP STRUCT FIELD
%-------------------

field = field{1}; value = in.(field);

