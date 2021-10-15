function time = file_times_from_names(name, pat)

% file_times_from_names - get file times from specially encoded file names
% ------------------------------------------------------------------------
%
% time = file_times_from_names(name)
%
% Input:
% ------
%  name - single name string or cell array of strings
%  
% Output:
% -------
%  time - time (in seconds) of file start times

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
% set default pattern if none given
%--

if nargin < 2
	pat = 'yyyymmdd_HHMMSS';
end

%--
% handle cell array input
%--

time = [];

if iscell(name)
	
	time = {};
	
	for k = 1:numel(name)
		
		time{end + 1} = file_times_from_names(name{k}, pat);
		
		if isempty(time{end})
			break;
		end
		
	end
	
	time = [time{:}];
	
	%--
	% subtract off minimum time
	%--
	
	time = time - min(time);
	
	return;
	
end

%--
% compute the time in seconds using file_datenum
%--

time = file_datenum(name, pat);

if isempty(time)
	return;
end

% NOTE: Get time in seconds:  there are 86400 seconds in a day

time = time * 86400;






