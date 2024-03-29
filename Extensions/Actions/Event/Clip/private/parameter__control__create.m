function control = parameter__control__create(parameter, context)

% CLIP - parameter__control__create

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

control = empty(control_create);

%--
% tabs
%--

% TODO: the space of the preceding header must be updated based on the type of control that follows

tabs = {'File', 'Name', 'Pad'};

control(end + 1) = control_create( ...
	'style', 'tabs', ...
	'tab', tabs ...
);

%--
% format
%--

% NOTE: the next two lines get writeable format file extensions

formats = get_writeable_formats;

for k = 1:length(formats)
	ext{k} = formats(k).ext{1};
end

ext = upper(ext); value = find(strcmpi(ext, parameter.format));

if isempty(value)
	value = 1;
end

control(end + 1) = control_create( ...
	'name', 'format', ...
	'style', 'popup', ...
	'tab', tabs{1}, ...
	'string', ext, ...
	'value', value ...
);

%--
% output
%--

control(end + 1) = control_create( ...
	'name', 'output', ...
	'alias', 'output directory', ...
	'style', 'file', ...
	'type', 'dir', ...
	'tab', tabs{1}, ...
	'lines', 4, ...
	'space', 0, ...
	'string', parameter.output ...
);

%--
% show files
%--

control(end + 1) = control_create( ... 
	'name', 'show_files', ...
	'style', 'checkbox', ...
	'tab', tabs{1}, ...
	'space', 1.5, ...
	'value', parameter.show_files ...
);

%------------------------------
% FILE NAMING CONVENTION
%------------------------------

str = {'log name', 'sound name', 'event time', 'event id'};

control(end + 1) = control_create( ...
    'name', 'add_token', ...
    'alias', ' ', ...
    'style', 'popup', ...
    'align', 'right', ...
    'width', 0.4, ...
    'space', -0.2, ...
    'tab', tabs{2}, ...
    'string', str, ...
    'value', 1 ...
);

control(end + 1) = control_create( ...
    'name', 'file_names', ...
    'style', 'edit', ...
    'tab', tabs{2}, ...
    'string', '%LOG_NAME%_%EVENT_ID%' ...
);

%------------------------------
% PADDING AND CONFIGURATION
%------------------------------

control(end + 1) = control_create( ...
	'name', 'padding', ...
	'alias', 'length', ...
	'style', 'slider', ...
	'type', 'time', ...
	'tab', tabs{3}, ...
	'min', 0, ...
	'max', 10, ...
	'value', parameter.padding ...
);

control(end + 1) = control_create( ...
	'name', 'taper', ...
	'style', 'checkbox', ...
	'tab', tabs{3}, ...
	'value', parameter.taper ...
);
	
