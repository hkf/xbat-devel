function [info, known_tags] = events_info_str(par, fields, opt)

% events_info_str - create info string for list of browser events
% ---------------------------------------------------------------
%
% [info, known_tags] = events_info_str(par, fields, opt)
%
% Input:
% ------
%  par - browser handle
%  fields - fields to display
%  opt - list options
%
% Output:
% -------
%  info - cell array of event strings

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
% $Revision: 5673 $
% $Date: 2006-07-11 17:21:35 -0400 (Tue, 11 Jul 2006) $
%--------------------------------

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% set and possibly output default options
%--

if (nargin < 3) || isempty(opt)
	
	opt.page = 0; opt.visible = 0; opt.order = 'name';
	
	if ~nargin
		info = opt; return;
	end
	
end

%--
% check sort order value
%--

orders = {'name', 'score', 'time', 'rating'};

if ~ismember(opt.order, orders)
	error(['Unrecognized sort order ''', opt.order, '''.']);
end

%--
% check browser input
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%--
% set default fields
%--

if (nargin < 2) || isempty(fields)
	
	fields = { ...
		'score', ...
		'rating', ...
		'label', ...
		'channel', ...
		'time' ...
	};

end

%----------------------------
% SETUP
%----------------------------

%--
% get browser state
%--

data = get_browser(par); 

%--
% create convenience variables for parts of state
%--

log = data.browser.log; 

sound = data.browser.sound;

grid = data.browser.grid;

%----------------------------
% KEEP VISIBLE
%----------------------------

%--
% select only displayed channels
%--

% NOTE: it makes sense to use visibility filtering all the time

if opt.visible
	
	%--
	% select remove invisible logs
	%--
	
	log(~[log.visible]) = [];
	
	if isempty(log)
		info = []; known_tags = {}; return;
	end
	
	%--
	% select visible events
	%--
	
	channel = get_channels(data.browser.channels);
	
	if length(channel) < sound.channels
		
		for k = 1:length(log)
			
			%--
			% get event channels and check which are visible
			%--

			event_channel = [log(k).event.channel];

			%--
			% find visible event indices
			%--
			
			ix = zeros(size(event_channel));

			for j = 1:length(channel)
				ix = ix | (event_channel == channel(j));
			end

			ix = find(ix);
			
			%--
			% update log copy
			%--
			
			log(k).event = log(k).event(ix); log(k).length = length(ix);

		end
	
	end
	
end

%----------------------------
% REMOVE EMPTY LOGS
%----------------------------

for k = length(log):-1:1
	
	if isempty(log(k).event)
		log(k) = [];
	end
	
end

%----------------------------
% GET KNOWN TAGS
%----------------------------

% TODO: factor this whenever we come across it again

known_tags = {};

for k = 1:length(log)
	known_tags = union(known_tags, unique_tags(log(k).event));
end

%--
% remove empty tags
%--

known_tags = setdiff(known_tags, {''});

for k = 1:length(known_tags)
	
	if known_tags{k}(1) == '*'
		known_tags{k}(1) = [];
	end
	
end

%----------------------------
% CREATE STRINGS
%----------------------------

%--
% order logs if sort order is name
%--

if strcmp(opt.order, 'name')
	[ignore, ix] = sort({log.file}); log = log(ix);
end

%--
% loop over logs to generate event strings
%--

% NOTE: putting strings in cell arrays preserves whitespace in 'strcat'

info = cell(0);

for k = 1:length(log)
	
	%-----------------
	% PREFIX STRING
	%-----------------

	% NOTE: this part of the string is invariant to the fields input

	% TODO: replace this with a call to 'event_name' when it is done
	
	SK = strcat(file_ext(log(k).file), {' # '}, int_to_str(struct_field(log(k).event, 'id')), {':  '});

	%-----------------
	% FIELDS STRINGS
	%-----------------

	for j = 1:length(fields)

		switch fields{j}

			%-----------------
			% SCORE
			%-----------------
			
			case 'score'

				% NOTE: we display score as fractional percent 

				score = struct_field(log(k).event, 'score');

				score = round(1000 * score) / 10;

				part = strcat(num2str(score), '%');
				
			%-----------------
			% RATING
			%-----------------
			
			case 'rating'
				
				rating = struct_field(log(k).event, 'rating');
				
				rating(isnan(rating)) = 0;
				
				part = strcat(str_line(rating, '*'), str_line(5 - rating,' '));

			%-----------------
			% LEVEL
			%-----------------
			
			case 'level'
				
				part = strcat({'L = '}, int_to_str(struct_field(log(k).event, 'level')));

			%-----------------
			% LABEL
			%-----------------
			
			% TODO: implement label using marked tags, here and in a few other places
			
			case 'label'

				part = get_label(log(k).event);
			
				if iscell(part)
					part = part'; 
				end
				
			%-----------------
			% CHANNEL
			%-----------------
			
			case 'channel'

				part = strcat({'Ch = '}, int_to_str(struct_field(log(k).event, 'channel')));

			%-----------------
			% TIME
			%-----------------
			
			case 'time'

				%--
				% get values
				%--

				t = struct_field(log(k).event, 'time'); t = t(:, 1);

				%--
				% map from record time to real time
				%--
				
				t = map_time(sound, 'real', 'record', t);

				%--
				% get string
				%--
				
				part = strcat({'T = '}, get_grid_time_string(grid, t, sound.realtime));

		end

		%-----------------
		% CONCATENATE
		%-----------------

		SK = strcat(SK, part);
	
		% NOTE: separate fields using comma
		
		if j < length(fields)
			SK = strcat(SK, {',  '});
		end

	end

	%--
	% remove orphaned commas
	%--

	% NOTE: there must be a better way

	SK = strrep(SK, ':  ,', ': ');

	SK = strrep(SK, ',  ,', ',');
	
	SK = strrep(SK, ',,', ',');
	
	%--
	% append event strings
	%--
	
	info = {info{:}, SK{:}};

end

% NOTE: return if there is nothing to sort

if isempty(info)
	info = {}; return;
end

%----------------------------
% SORT STRINGS
%----------------------------

%--
% get sorting information
%--

% NOTE: time mapping is not required since sessions are monotone

score = []; rating = []; channel = []; time = [];

for k = 1:length(log)
	
	% NOTE: the comma-separated list approach does not handle nan values
	
% 	part = [log(k).event.score]'; score = [score; part]; 
	
	part = struct_field(log(k).event, 'score'); score = [score; part]; 
	
	part = struct_field(log(k).event, 'rating'); rating = [rating; part]; 
	
	part = [log(k).event.channel]'; channel = [channel; part];
	
	time = [time; reshape([log(k).event.time]', 2, [])'];
	
end

time = time(:, 1);

%--
% sort to compute order and order strings
%--

if ~strcmp(opt.order, 'name')
	
	switch opt.order

		case 'score'
			[ignore, ix] = sortrows([score, time, channel], [-1, 2, 3]);
			
		case 'rating'
			[ignore, ix] = sortrows([rating, time, channel], [-1, 2, 3]);

		case 'time'
			[ignore, ix] = sortrows([time, channel, score], [1, 2, -3]);

	end

	info = info(ix);

end
