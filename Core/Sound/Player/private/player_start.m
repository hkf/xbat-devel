function player_start(player)

%--
% access global player
%--

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

global BUFFERED_PLAYER_1;

%--
% get samples for player
%--

X = get_data(player);

player.buffer = X;

%--
% create player
%--

BUFFERED_PLAYER_1 = audioplayer(X, player.samplerate);

set(BUFFERED_PLAYER_1, ...
	'tag','BUFFERED_PLAYER_1', ...
	'startfcn', @start_cb, ...
	'stopfcn', @stop_cb, ...
	'userdata', player ...
);

%--
% start player
%--

play(BUFFERED_PLAYER_1);
