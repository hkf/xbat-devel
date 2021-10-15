function control = control__create(attribute, context)

% SENSOR_CALIBRATION - control__create

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

channels = context.sound.channels;

if numel(attribute.calibration) < channels
    attribute.calibration(channels) = 0;
end

channel_str = {};

for k = 1:channels
	channel_str{end + 1} = int2str(k);
end
	
channel = 1;

control(end + 1) = control_create( ...
	'name', 'channel', ...
	'style', 'popup', ...
	'width', 2/5, ...
	'string', channel_str, ...
	'value', channel ...
);

control(end + 1) = control_create( ...
    'name', 'offset', ...
    'alias', 'Offset (dB)', ...
    'tooltip', 'The sound pressure at 1 least significant bit (lsb).', ...
    'style', 'slider', ...
    'space', 1.25, ...
    'onload', 1, ...
    'min', -100, ...
    'max', 100, ...
    'value', attribute.calibration(channel) ...
);

control(end + 1) = control_create( ...
    'style', 'separator' ...
);

control(end + 1) = control_create( ...
    'name', 'reference', ...
    'alias', 'Reference (uPa)', ...
    'style', 'slider', ...
    'min', 0, ...
    'max', 100, ...
    'value', attribute.reference ...
);
    
control(end + 1) = control_create( ...
    'name', 'calibration', ...
    'style', 'axes', ...
    'lines', 1, ...
    'space', -1, ...
    'value', [], ...
    'initialstate', '__HIDE__' ...
);


