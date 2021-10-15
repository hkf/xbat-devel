function out = struct_copy(in, out, match)

% struct_copy - copy fields from one structure to another
% -------------------------------------------------------
%
% out = struct_copy(in, out, match)
%
% Input:
% ------
%  in - source struct
%  out - destination struct
%  match - field match array for differently named fields
%
% Output:
% -------
%  out - structure with copied data

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
% $Revision: 765 $
% $Date: 2005-03-18 18:48:00 -0500 (Fri, 18 Mar 2005) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% set empty match table
%--

if nargin < 3
	match = [];
end

%---------------------------------------------
% GET SOURCE FIELDS
%---------------------------------------------

%--
% get structure fields
%--

in_field = fieldnames(in);

out_field = fieldnames(out);

source_field = cell(size(out_field));

%--
% check match array fields for correctness
%--

% NOTE: this may be turned off for speed

%--
% findout which fields are to be written and with what
%--

for k = length(out_field):-1:1
	
	%--
	% check for field in the match array
	%--
	
	% NOTE: the order is important. match entries override same name copy
	
	if ~isempty(match)
		
		% NOTE: the first column of the match array contains the output fields

		ix = find(strcmp(out_field{k}, match(:,1)));

		% NOTE: the second column of the match array contains the input fields

		if ~isempty(ix)
			source_field{k} = match{ix, 2}; continue;
		end
		
	end
	
	%--
	% check for field in the input structure
	%--
	
	ix = find(strcmp(out_field{k}, in_field));
	
	if ~isempty(ix)
		source_field{k} = in_field{ix}; continue;
	end
	
	%--
	% remove this output field from copy consideration
	%--
	
	out_field(k) = []; source_field(k) = [];
	
end

%---------------------------------------------
% COPY FIELDS
%---------------------------------------------

for k = 1:length(out_field)
	out.(out_field{k}) = in.(source_field{k});
end
