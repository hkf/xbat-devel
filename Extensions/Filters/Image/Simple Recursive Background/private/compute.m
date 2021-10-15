function [X, context] = compute(X, parameter, context)

% SIMPLE RECURSIVE BACKGROUND - compute

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

% TODO: consider if we want a single slice offset in the computation

%--
% compute background estimate
%--

n = size(X, 2); B = zeros(size(X)); lambda = parameter.lambda;

% NOTE: use last background estimate as starting point if available

if isfield(context, 'state') && isfield(context.state, 'background')
	B(:, 1) = (1 - lambda) * context.state.background + lambda * X(:, 1);
end

% NOTE: update background estimate recursively

for k = 2:n
	B(:, k) = (1 - parameter.lambda) * B(:, k - 1) + lambda * X(:, k);
end

%--
% output resulting background or signal estimate
%--

switch lower(parameter.output{1})
	
	case 'background'
		X = B;
		
	case 'signal'
		X = X - B;
		
end

%--
% store last estimate in context, for use when we are paging!
%--

context.state.background = B(:, end);
