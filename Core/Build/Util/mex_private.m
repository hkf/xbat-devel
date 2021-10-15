function varargout = mex_private(varargin)

% mex_private: call build_mex, and put files where they need to be according
% to the xbat idiom of dir/MEX/foo.c --> dir/private/foo.dll
%
% M. Robbins
%
%

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

d1 = dir;
build_mex(varargin{:});
d2 = dir;

fn = '';
for ix = 1:length(d2)
	if ~d2(ix).isdir	
		if isempty(strfind([d1.name], d2(ix).name))
			fn = d2(ix).name;
			break
		end
	end
end

% TODO: only clear the function being compiled

clear('functions');

movefile(fn, ['..', filesep, 'private']);

