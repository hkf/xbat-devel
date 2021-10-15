function syllables = num_syllables(str)

% num_syllables - find the number of syllables in a given word
% ------------------------------------------------------------
%
% syllables = num_syllables(str)

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
% iterate
%--

if iscell(str)
	
	syllables = {};
	
	for k = 1:numel(str)
		syllables{end + 1} = num_syllables(str{k});
	end
	
	return;
	
end

%--
% find number of syllables
%--

ix = is_vowel(str); ix = [0, ix];

%--
% number of syllables is number of vowel groups in many cases
%--

syllables = numel(find(diff(ix) > 0));
