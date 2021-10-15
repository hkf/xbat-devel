function [Y, context] = compute(X, parameter, context)

% CENTER - compute

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
% create structuring element
%--

SE = create_se(parameter);

%--
% compute alternating filters
%--

E = morph_open(morph_close(X, SE), SE);

D = morph_close(morph_open(X, SE), SE);

%--
% compute center
%--

% NOTE: a center is more general than what this function computes

Y = min(E, D);

Y = max(X, Y);

Y = min(Y, max(E, D));

% NOTE: the above is equivalent to

% Y = min(max(X, min(E, D)), max(E, D));
