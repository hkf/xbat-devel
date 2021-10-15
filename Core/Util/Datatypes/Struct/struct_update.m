function X = struct_update(X, Y, opt)

% struct_update - update a structure using another
% ------------------------------------------------
%
% opt = struct_update
%
%   X = struct_update(X, Y, opt)
%
% Input:
% ------
%  X - structure to update
%  Y - source structure
%  opt - update options structure
%
% Output:
% -------
%  opt - default update options structure
%  X - updated structure

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
% $Revision: 1554 $
% $Date: 2005-08-10 18:31:35 -0400 (Wed, 10 Aug 2005) $
%--------------------------------

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set and possibly return default options
%--

if (nargin < 3) || isempty(opt)
	
	%--
	% set default options
	%--
	
	opt.equal = 0; % NOTE: require structures to be equal
	
	opt.flatten = 1; % NOTE: flatten structures to perform update
	
	opt.level = -1;
	
	%--
	% output options if needed
	%--
	
	if ~nargin
		X = opt; return;
	end 
	
end 

if ~isfield(opt, 'level')
	opt.level = -1;
end

%--
% return if the update source is empty
%--

% NOTE: this really happens

if isempty(Y)
	return;
end 

%---------------------------
% UPDATE STRUCT
%---------------------------

%--
% flatten structures if needed
%--

if opt.flatten	
	X = flatten_struct(X, opt.level); Y = flatten_struct(Y, opt.level);
end

%--
% get fieldnames
%--

X_field = fieldnames(X); Y_field = fieldnames(Y);

%--
% check for equal structures if needed
%--

if opt.equal
	
	% NOTE: equality is a check on contents and order, not a set operation
	
	% TODO: consider allowing order to be omitted
	
	if ~isequal(X_field, Y_field)
		
		if opt.flatten
			error('Flattened input structures have different forms.');
		else
			error('Input structures have different forms.');
		end
		
	end 
	
end

%--
% update structure fields
%--

% TODO: develop struct merge, and various modes for update

% NOTE: loop over shorter set of fields

if (length(X_field) < length(Y_field))
	
	for k = 1:length(X_field)

		match = find(strcmp(Y_field, X_field{k}));
		
		if ~isempty(match)
			X.(X_field{k}) = Y.(X_field{k});
		end

	end
	
else
	
	for k = 1:length(Y_field)

		match = find(strcmp(X_field, Y_field{k}));
		
		if ~isempty(match)
			X.(Y_field{k}) = Y.(Y_field{k});
		end

	end
	
end

%--
% unflatten structures if needed
%--

if opt.flatten
	X = unflatten_struct(X); Y = unflatten_struct(Y);
end
