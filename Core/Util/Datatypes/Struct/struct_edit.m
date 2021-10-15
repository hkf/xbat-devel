function p = struct_edit(p,str)

% struct_edit - edit simple flat structure values
% -----------------------------------------------
%
% p = struct_edit(p,str)
%
% Input:
% ------
%  p - input structure
%  str - title string
%
% Output:
% -------
%  p - output structure

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

%--
% set title string
%--

if ((nargin < 2) & ~isempty(inputname(1)))
	str = ['Edit ' inputname(1) ' ...'];
elseif (isempty(inputname(1)))
	str = 'Struct Edit ...';
end

%--
% get field named and create prompts
%--

field = fieldnames(p);

for k = 1:length(field)
	prompt{k} = string_title(field{k},'_');
end 

%--
% create default answers
%--

for k = 1:length(field)
	tmp = getfield(p,field{k});
	if (isstr(tmp))
		def{k} = tmp;
	elseif (length(tmp) == 1)
		def{k} = num2str(tmp);
	else
		def{k} = mat2str(tmp);
	end 
end

%--
% create input dialog and get answers
%--

ans = input_dialog( ...
	prompt, ...
	str, ...
	[1,32], ...
	def ...
);

%--
% update structure if needed
%--

if (~isempty(ans))
	for k = 1:length(field)
		p = setfield(p,field{k},eval(ans{k}));
	end
else
	p = [];
end
