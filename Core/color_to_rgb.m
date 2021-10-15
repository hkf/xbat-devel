function  [c, S] = color_to_rgb(str)

% color_to_rgb - get rgb values for named color
% ---------------------------------------------
%
% [c, S] = color_to_rgb(str)
%
% Input:
% ------
%  str - color name
%
% Output:
% -------
%  c - rgb values for named color or list of available colors
%  S - menu separators

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
% create name color cell array table
%--

T = { ...
	'Red', [0.7, 0.05, 0.05]; ...
	'Green', [0.05, 0.7, 0.05]; ...
	'Blue', [0, 0.05, 0.7]; ...
	'Cyan', [0, 0.7, 0.7] ;...
	'Magenta', [0.7, 0, 0.7]; ...
	'Yellow', [0.8, 0.8, 0]; ...
	'Black', [0, 0, 0]; ...
	'Dark Gray', [0.25, 0.25, 0.25]; ...
	'Gray', [0.5, 0.5, 0.5]; ...
	'Light Gray', [0.75, 0.75, 0.75]; ...
	'White', [1, 1, 1]; ...
	'Bright Red', [1, 0, 0.05]; ...
	'Bright Green', [0, 1, 0.05]; ...
	'Bright Blue', [0, 0.05, 1]; ...
	'Dark Red', [0.5, 0.05, 0.05]; ...
	'Dark Green', [0.05, 0.5, 0.05]; ...
	'Dark Blue', [0, 0.05, 0.5]; ...
	'Light Red', [1, 0.45, 0.45]; ...
	'Light Green', [0.45, 1, 0.45]; ...
	'Light Blue', [0.45, 0.45, 1] ...
};


if nargin
	
	%--
	% look up color
	%--
	
	ix = find(strcmp(str, T(:, 1)));
	
	if ~isempty(ix)
		c = T{ix, 2};
	else
		c = [];
	end
	
else
	
	%--
	% output all available colors
	%--
	
	c = T(:, 1);
	
	%--
	% output menu separators
	%--
	
	if (nargout > 1)
		
		n = length(c);
		
		S = bin2str(zeros(n, 1)); S{4} = 'On'; S{8} = 'On'; S{12} = 'On';
	
	end
	
end

