function [in, select] = struct_select(in, field, value) 

% struct_select - select elements of struct array by field value
% --------------------------------------------------------------
%
% [out, select] = struct_select(in, field, value)
%
% Input:
% ------
%  in - struct array
%  field - field to select on
%  value - value to select
%
% Output:
% -------
%  out - selected elements of array
%  select - selection indicator

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

%----------------------
% HANDLE INPUT
%----------------------

%--
% check struct and field
%--

if ~isstruct(in)
	error('Selection target must be struct.');
end

if ~isfield(in, field)
	error('Selection field is not page field.');
end 

% NOTE: there is nothing to select, this is odd!

if isempty(in)
	select = []; return;
end

%--
% get relevant field values from in
%--

% NOTE: we assume that the field contents are uniform, this is not known

if ischar(in(1).(field))
	values = {in.(field)};
else
	try
		values = [in.(field)];
	catch
		values = {in.(field)};
	end
end 

%--
% compare values to input field value to select
%--

if isnumeric(values)
	select = (values == value);
end

if iscellstr(values)
	select = strcmp(values, value);
end 

if exist('select', 'var')
	in = in(select); return;
end

select = zeros(size(values));

for k = length(values):-1:1
	
	if ~isequal(values{k}, value)
		in(k) = [];
	else
		select(k) = 1;
	end 
	
end 

