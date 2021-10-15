function R = test_integral(n,it)

% test_integral - test box filtering code
% ----------------------------------
%
% R = test_integral(n,it)
%
% Input:
% ------
%  n - size of image
%  it - number of iterations
%
% Output:
% -------
%  R - timing and accuracy results

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
% $Revision: 295 $
% $Date: 2004-12-16 13:55:03 -0500 (Thu, 16 Dec 2004) $
%--------------------------------

%------------------------
% HANDLE INPUT
%------------------------

if ((nargin < 2) || isempty(it))
	it = 20;
end

if ((nargin < 1) || isempty(n))
	n = [500,1500];
end

%-------------------------
% RUN TESTS
%-------------------------

%--
% compute and compare filtering performance and accuracy
%--

for k = 1:it
	
	%--
	% create random image
	%--
	
	X = 100000 * rand(n(1),n(2));
	
	%--
	% filter with direct and sparse code
	%--
	
	tic; Y1 = cumsum(cumsum(X,1),2); t1(k) = toc;
	
	tic; Y2 = integral_image_(X); t2(k) = toc;
			
	%--
	% compare output
	%--
	
	E = fast_min_max(Y1 - Y2);
	
	%--
	% pack results and display
	%--
	
	% NOTE: direct computation time, sparse time, speedup ratio, error bounds

	R(k,:) = [t1(k), t2(k), t1(k)/t2(k), E];
	
end

R(it + 1,:) = sum(R,1) ./ it;
	
