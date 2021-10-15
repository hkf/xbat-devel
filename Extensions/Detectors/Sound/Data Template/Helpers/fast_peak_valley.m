function [ix,h,w] = fast_peak_valley(x,opt)

% fast_peak_valley - fast extrema computation
% -------------------------------------------
%
% [ix,h,w] = fast_peak_valley(x,opt)
%
% Input:
% ------
%  x - input sequence
%  opt - type of extrema (def: 0)
%
% Output:
% -------
%  ix - extrema indices
%  h - extrema heights or depths
%  w - extrema widths

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

% TODO: align input and output for vectors

% TODO: generalize code to handle matrices and take dimension input

%--
% set output option
%--

if ((nargin < 2) || isempty(opt))
	opt = 0;
end

%--
% compute peaks and valleys
%--

% TODO: include opt as part of the low level computation

switch (nargout)
	
	case (1)
		
		ix = fast_peak_valley_(x);
		
		%--
		% select max or min extrema if needed
		%--
		
		% NOTE: this approach to separating peaks is not intuitive
		
		if (opt)
			if (opt > 0)
				ix = ix(ix > 0);
			else
				ix = -ix(ix < 0);
			end
		end
		
	case (2)
		
		[ix,h] = fast_peak_valley_(x);
		
		%--
		% select max or min extrema if needed
		%--
		
		% NOTE: this approach to separating peaks is not intuitive
		
		if (opt)
			if (opt > 0)
				tmp = find(ix > 0);
				ix = ix(tmp);
				h = h(:,tmp);
			else
				tmp = find(ix < 0);
				ix = -ix(tmp);
				h = h(:,tmp);
			end
		end
		
	case (3)
		
		[ix,h,w] = fast_peak_valley_(x);
		
		%--
		% select max or min extrema if needed
		%--
		
		% NOTE: this approach to separating peaks is not intuitive
		
		if (opt)
			if (opt > 0)
				tmp = find(ix > 0);
				ix = ix(tmp);
				h = h(:,tmp);
				w = w(:,tmp);
			else
				tmp = find(ix < 0);
				ix = -ix(tmp);
				h = h(:,tmp);
				w = w(:,tmp);
			end
		end
		
end


