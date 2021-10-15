function [SE1,SE2] = se_match(SE1,SE2)

% se_match - match suport of structuring elements
% -----------------------------------------------
%
% [SE1,SE2] = se_match(SE1,SE2)
%
% Input:
% ------
%  SE1, SE2 - structuring elements
%
% Output:
% -------
%  SE1, SE2 - structuring elements with matched support

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% match supports
%--

pq1 = se_supp(SE1);
pq2 = se_supp(SE2);

pq = max(pq1,pq2);

dpq1 = pq - pq1;
dpq2 = pq - pq2;

SE1 = se_loose(SE1,dpq1);
SE2 = se_loose(SE2,dpq2);
 
