function control = control__create(attribute, context)

% SENSOR_GEOMETRY - control__create

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

control(end + 1) = control_create( ...
	'name', 'sensor_geometry', ...
	'alias', 'map', ...
	'style', 'axes', ...
	'lines', 8, ...
	'space', 1.5, ...
	'value', attribute, ...
	'onload', 1 ...
);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'label', ...
	'align', 'right', ...
	'space', 1, ...
	'string', 'Configuration' ...
);

if isempty(which('m_ll2xy'))
	state = '__DISABLE__';
else
	state = '__ENABLE__';
end

control(end + 1) = control_create( ...
	'name', 'units', ...
	'style', 'popup', ...
	'width', 2/5, ...
	'space', -2, ...
	'string', {'xyz', 'lat-lon'}, ...
	'initialstate', state, ...
	'value', 1 ...
);

ellipsoids = { ...
	'normal', ...
	'sphere', ...
	'grs80', ...                      
    'grs67', ...                      
    'wgs84', ...                      
    'wgs72', ...
	'wgs66', ...
	'wgs60', ...                      
    'clrk66', ...                      
    'clrk80', ...                      
    'intl24', ...                      
    'intl67' ...
};

control(end + 1) = control_create( ...
	'name', 'ellipsoid', ...
	'style', 'popup', ...
	'align', 'right', ...
	'width', 2/5, ...
	'space', 1.5, ...
	'string', ellipsoids, ...
	'initialstate', '__DISABLE__', ...
	'value', 5 ...
);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'label', ...
	'align', 'right', ...
	'string', 'Position' ...
);

channels = context.sound.channels;

channel_str = {};

for k = 1:channels
	channel_str{end + 1} = int2str(k);
end
	
control(end + 1) = control_create( ...
	'name', 'channel', ...
	'style', 'popup', ...
	'onload', 1, ...
	'width', 2/5, ...
	'space', -1, ...
	'string', channel_str, ...
	'value', 1 ...
);

control(end + 1) = control_create( ...
	'name', 'reference', ...
	'style', 'checkbox', ...
	'width', 2/5, ...
	'align', 'right', ...
	'initialstate', '__DISABLE__', ...
	'value', 0 ...
);

control(end + 1) = control_create( ...
	'name', 'x', ...
	'style', 'edit' ...
);

control(end + 1) = control_create( ...
	'name', 'y', ...
	'style', 'edit' ...
);

control(end + 1) = control_create( ...
	'name', 'z', ...
	'style', 'edit' ...
);


