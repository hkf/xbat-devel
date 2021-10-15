function out = attribute_dialog(ext, context, new)

% attribute_dialog - create dialog for editing an attribute extension
% -------------------------------------------------------------------
%
% out = attribute_dialog(ext, context, new)
%
% Input:
% ------
%  ext - the extension
%  context - the context
%  new - whether we are creating or editing
%
% Output:
% -------
%  out - the dialog handle

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
% handle input
%--

if nargin < 3
	new = 0;
end

if new
	name = 'Add ...';
else
	name = 'Edit ...';
end

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'string', [title_caps(ext.name), '  (', sound_name(context.sound), ')'], ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1 ...
);

ext_control = empty(control_create);

if ~isempty(ext.fun.control.create)
	
	try
		ext_control = ext.fun.control.create(context.attribute, context);
	catch
		extension_warning(ext, 'Control creation failed.', lasterror);
	end

	for k = 1:length(ext_control)
		control(end + 1) = ext_control(k);
	end

end

%--
% configure dialog
%--

opt = dialog_group;

% NOTE: add color according to parent context

opt.header_color = get_extension_color('root');

opt.ext = ext;

opt.width = 12;

%--
% present dialog
%--

callback = {@callback_router, ext.fun.control.callback, context};

out = dialog_group(name, control, opt, callback);


%----------------------------------------
% CALLBACK_ROUTER
%----------------------------------------

function callback_router(obj, eventdata, fun, context)

%--
% get callback context
%--

callback = get_callback_context(obj, 'pack');

%--
% call extension specific callback
%--

if ~isempty(fun)
	fun(callback, context);
end
