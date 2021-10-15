function [L,f] = struct_menu_labels(X)

% struct_menu_labels - label strings to create a structure info menu
% ---------------------------------------------------------------
%
% [L,f] = struct_menu_labels(X)
%
% Input:
% ------
%  X - structure
%
% Output:
% -------
%  L - label strings
%  f - structure field names

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
% SET PARAMETERS
%--

STRLEN = 32; % truncate strings longer than this

PREC = 5; % precision of number to string functions

%--
% check structure input and get fieldnames
%--

if (~isstruct(X))
	disp(' '); 
	error('Input must be a structure.');
else
	fn = fieldnames(X);
end

%--
% create strings whenever reasonable
%--

for k = 1:length(fn)
	
	%--
	% check for something we can convert
	%--
	
	tmp = getfield(X,fn{k});
	
	% cell arrays are noted
	
	if (iscell(tmp))
	
		L{k} = [title_caps(fn{k}), ': (Cell Array)'];	
		
	% structures are noted
	
	elseif (isstruct(tmp))
	 
		if (length(tmp) == 1)
			L{k} = [title_caps(fn{k}), ': (Structure)'];
		else
			L{k} = [title_caps(fn{k}), ': (Structure Array)'];
		end
		
	% strings are truncated and continued ...

	elseif isstr(tmp)
		
		if (length(tmp) > STRLEN)
			ix = findstr(tmp,' ');
			ix = ix(max(find(ix <= STRLEN)));
			tmp = [tmp(1:ix), ' ...'];
		end
		
		L{k} = [title_caps(fn{k}), ': ' tmp];
		
	elseif isnumeric(tmp)
		
		n = prod(size(tmp));
			
		if (n == 1)
			L{k} = [title_caps(fn{k}), ': ' num2str(tmp,PREC)];
		elseif (n < 6)
			tmp = mat2str(tmp,PREC);
			tmp = strrep(tmp,' ',', ');
			tmp = strrep(tmp,';','; ');
			L{k} = [title_caps(fn{k}), ': ' tmp];
		else
			L{k} = [title_caps(fn{k}), ': (Large Matrix)'];		
		end
		
	end
	
end
		
		
