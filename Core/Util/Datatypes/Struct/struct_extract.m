function out = struct_extract(in)

% struct_extract - extract structure fields to variables in workspace
% -------------------------------------------------------------------
%
% out = struct_extract(in)
%
% Input:
% ------
%  in - structure
%
% Output:
% -------
%  out - names of variables created

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

% NOTE: this is similar to the function 'extract' in PHP

% TODO: develop extraction modes as in the previously mentioned PHP function

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% return for empty input
%--

out = [];

if (isempty(in))
	return;
end

%--
% check for scalar struct input
%--

% NOTE: use warnings here, since no action is taken

if (~isstruct(in))
	warning('Input must be structure.'); return;
end

if (length(in) > 1)
	warning('Input must be scalar structure.'); return;
end

%-----------------------------------
% EXTRACT
%-----------------------------------

%--
% field names are variable names
%--

out = fieldnames(in);

%--
% evaluate to extract
%--

for k = 1:length(out)
	assignin('caller',out{k},in.(out{k}));
end
