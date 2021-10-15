function control = parameter__control__create(parameter,context)

% AMPLITUDE ACTIVITY - parameter__control__create

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
% create controls to be used in palette and dialog if required
%--

control(1) = control_create( ...
	'style','tabs', ...
	'label',0, ... % this should be set by control group
	'tab',{'Basic','Refine'}, ...
	'name','Parameter Tabs' ...
	);

control(end + 1) = control_create( ...
	'name','Time Resolution', ...
	'string','Time Resolution', ...
	'tab','Basic', ...
	'align','left', ...
	'style','separator' ...
	);

value = parameter.block;

control(end + 1) = control_create( ...
	'name','block', ...
	'tab','Basic', ...
	'style','slider', ...
	'min',0.01, ...
	'max',10, ...
	'units','sec', ...
	'value',value, ...
	'tooltip','Size of decision block, in seconds' ...
	);

value = parameter.window;

control(end + 1) = control_create( ...
	'name','window', ...
	'tab','Basic', ...
	'style','slider', ...
	'type','integer', ...
	'min',1, ...
	'max',10, ...
	'value',value, ...
	'sliderstep',[1/9,2/9], ...
	'tooltip','Number of blocks used for context in past and future' ...
	);

control(end + 1) = control_create( ...
	'name','Amplitude Statistics', ...
	'tab','Basic', ...
	'string','Amplitude Statistics', ...
	'align','left', ...
	'style','separator' ...
	);

value = parameter.percent;

control(end + 1) = control_create( ...
	'name','percent', ...
	'tab','Basic', ...
	'style','slider', ...
	'min',0, ...
	'max',1, ...
	'value',value, ...
	'tooltip','Percentile of amplitude to be marked as signal' ...
	);


value = parameter.fraction;

control(end + 1) = control_create( ...
	'name','fraction', ...
	'tab','Basic', ...
	'style','slider', ...
	'min',0, ...
	'max',1, ...
	'value',value, ...
	'tooltip','Fraction of decision block that must exceed percentile' ...
	);

value = parameter.relax;

control(end + 1) = control_create( ...
	'name','relax', ...
	'tab','Basic', ...
	'style','slider', ...
	'min',0, ...
	'max',1, ...
	'value',value, ...
	'tooltip','Fraction relaxation for event continuation' ...
	);

control(end + 1) = control_create( ...
	'name','Energy Concentration', ...
	'string','Energy Concentration', ...
	'tab','Refine', ...
	'align','left', ...
	'style','separator' ...
	);

value = parameter.refine;

control(end + 1) = control_create( ...
	'name','refine', ...
	'tab','Refine', ...
	'style','checkbox', ...
	'value',value, ...
	'tooltip','Refine time frequency extent based on energy distribution' ...
	);

