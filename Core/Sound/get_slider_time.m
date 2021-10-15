function time = get_slider_time(sound, time, backwards)

% get_slider_time - get slider time from sound time
% -------------------------------------------------
%
% time = get_slider_time(sound, time)
%
% Input:
% ------
%  sound - sound
%  time - sound time
%
% Output:
% -------
%  time - slider time

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

if nargin < 3 || isempty(backwards)
	backwards = 0;
end

if has_sessions_enabled(sound) && xor(sound.time_stamp.collapse, backwards)
	time = get_recording_time(sound, time);
end
