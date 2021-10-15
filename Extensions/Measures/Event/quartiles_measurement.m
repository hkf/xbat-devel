function out = quartiles_measurement(mode,varargin)

% quartiles_measurement - time and frequency quartiles of event
% -------------------------------------------------------------
%
% measurement = quartiles_measurement('create',h)
% description = quartiles_measurement('describe',h)
%
%         log = quartiles_measurement('batch',log,ix,measurement)
%      	event = quartiles_measurement('batch',sound,event,measurement)
%
%        flag = quartiles_measurement('events',h,m,ix,measurement)
%
%           g = quartiles_measurement('menu',h,m,ix,data)
%           g = quartiles_measurement('display',h,m,ix,data)
%
% Input:
% ------
%  h - handle to parent figure
%  log - log structure
%  ix - indices of events in log
%  measurement - measurement structure (contains current parameter)
%  event - event structure array
%  m - index of log
%
% Output:
% -------
%  measurement - measurement structure
%  description - description structure
%  log - log structure
%  event - event structure array
%  flag - update success indicator
%  g - handles to objects created

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
% $Revision: 689 $
% $Date: 2005-03-09 22:14:37 -0500 (Wed, 09 Mar 2005) $
%--------------------------------

%--------------------------------------------------------
% SET DEFAULT MODE
%--------------------------------------------------------

if (~nargin)
	mode = 'create';
end

%--
% set context flag for create and describe
%--

if ((strcmp(mode,'create') | strcmp(mode,'describe')) & length(varargin))
	h = varargin{1};
	context_flag = 1;
else
	context_flag = 0;
end

%--------------------------------------------------------
% CREATE MEASUREMENT DESCRIPTION
%--------------------------------------------------------

persistent DESCRIPTION_PERSISTENT;

if (context_flag)
	DESCRIPTION_PERSISTENT = measurement_description(h);
else
	if (isempty(DESCRIPTION_PERSISTENT))
		DESCRIPTION_PERSISTENT = measurement_description;
	end
end

description = DESCRIPTION_PERSISTENT;

%--------------------------------------------------------
% CREATE EMPTY MEASUREMENT
%--------------------------------------------------------

%--
% create measurement structure
%--

measurement = measurement_create;

%--
% set name of measurement
%--

measurement.name = description.name;

%--
% create function handle to main annotation function
%--

persistent FUNCTION_HANDLE_PERSISTENT;

if (isempty(FUNCTION_HANDLE_PERSISTENT))
	FUNCTION_HANDLE_PERSISTENT = eval(['@' mfilename]);
end

measurement.fun = FUNCTION_HANDLE_PERSISTENT;

%--
% set measurement parameter
%--
	
persistent PARAMETER_PERSISTENT;

if (context_flag)
	PARAMETER_PERSISTENT = parameter_fun('create',h);
else
	if (isempty(PARAMETER_PERSISTENT))
		PARAMETER_PERSISTENT = parameter_fun('create');
	end
end

measurement.parameter = PARAMETER_PERSISTENT;	

%--
% set value
%--

measurement.value = value_fun('create');
	
%--------------------------------------------------------
% COMPUTE ACCORDING TO MODE
%--------------------------------------------------------

switch (mode)
	
%--------------------------------------------------------
% OUTPUT SAMPLE MEASUREMENT
%--------------------------------------------------------

case ('create')

	out = measurement;
		
%--------------------------------------------------------
% OUTPUT MEASUREMENT DESCRIPTION
%--------------------------------------------------------

case ('describe')

	out = description;

%--------------------------------------------------------
% BATCH ANNOTATE LOG EVENTS OR EVENT SEQUENCE (THESE ARE MEANT FOR THE COMMAND LINE)
%--------------------------------------------------------

case ('batch')

	%--
	% rename input
	%--
	
	tmp = varargin{1};

	%--
	% handle sound or log 
	%--
	
	if (strcmp(tmp.type,'log'))
		
		%--------------------------------------------------------
		% (log,ix,measurement)
		%--------------------------------------------------------
		
		log = tmp;
		ix = varargin{2};
		
		sound = log.sound;
		event = log.event(ix);
		
		flag_log = 1;
		
	else
		
		%--------------------------------------------------------
		% (sound,event,measurement) THIS IS A SEQUENCE OF ORPHANED EVENTS
		%--------------------------------------------------------
		
		sound = tmp;
		event = varargin{2};
		
		flag_log = 0;
		
	end

	measurement = varargin{3};
	
	%--
	% check name of measurement to add
	%--
	
	if (~strcmp(measurement.name,description.name))
		disp(' '); 
		warning(['Input measurement is ''' measurement.name ''' not ''' description.name '''.']);
		return;
	end
	
	%--
	% get current date string
	%--
	
	curr = now;
	
	%--
	% add or update measurement in event sequence
	%--
	
	for k = 1:length(event)
		
		%--
		% get index of measurement
		%--
		
		tmp = struct_field(event(k).measurement,'name');
		ixa = find(strcmp(tmp,description.name));
		
		%--
		% compute measurement
		%--
		
		if (isempty(ixa))
			
			len = length(event(k).measurement);
			if ((len == 1) & isempty(event(k).measurement(1).name))
				len = 0;
			end
			
			measurement.created = curr;
			measurement.modified = [];
			
			try
				
				measurement.value = ...
					measurement_compute(sound,event(k),measurement.parameter);
				
				event(k).measurement(len + 1) = measurement;

			catch
				
% 				disp(' ');
% 				warning(['Failed to compute ''' description.name ''' for event ' num2str(event.id)]);
				
			end
			
		%--
		% recompute measurement
		%--
		
		else
			
			measurement.created = event(k).measurement(ixa).created;
			measurement.modified = curr;
			
			try
				
				measurement.value = ...
					measurement_compute(sound,event(k),measurement.parameter);
				
				event(k).measurement(ixa) = measurement;
			
			catch
				
% 				disp(' ');
% 				warning(['Failed to compute ''' description.name ''' for event ' num2str(event.id)]);
				
			end
			
		end
		
	end
	
	%--
	% output event sequence
	%--
	
	if (flag_log)
		
		%--------------------------------------------------------
		% (log,ix,measurement)
		%--------------------------------------------------------
		
		log.event(ix) = event;
		out = log;
		
	else
		
		%--------------------------------------------------------
		% (sound,event,measurement)
		%--------------------------------------------------------
		
		out = event;
		
	end
	
%--------------------------------------------------------
% COMPUTE MEASUREMENT OF BROWSER DISPLAYED EVENTS
%--------------------------------------------------------

case ('events')
		
	%--
	% rename input variables
	%--
		
	h = varargin{1};
	m = varargin{2};
	ix = varargin{3};
	
	%--
	% get figure userdata
	%--
	
	data  = get(h,'userdata');
	
	%--
	% handle log browser get parent userdata
	%--

	if (gcf == h)
		flag = 0;
	else
		flag = 1;
	end
	
	%--
	% set default parameter for parameter edit
	%--
	
	nix = length(ix);
	
	if (nix == 1)
		
		%--
		% get measurement index for event
		%--
		
		event = data.browser.log(m).event(ix);
		ixa = find(strcmp(struct_field(event.measurement,'name'),description.name));
		
		%--
		% get current default parameter or current measurement parameter
		%--
		
		if (isempty(ixa))
			param = PARAMETER_PERSISTENT;
		else
			param = event.measurement(ixa).parameter;
		end 
		
	else
		
		%--
		% get current default parameter
		%--
		
		param = PARAMETER_PERSISTENT;
		
	end
	
	%--
	% allow for batch computation within browser
	%--
	
	% this modality of the call to the measurement interface is used to
	% update the value of a measurement upon event editing
	
	flag_batch = (length(varargin) > 3);
	
	if (flag_batch)
		
		%--
		% use input parameter
		%--
		
		param = varargin{4}.('parameter');	
		author = data.browser.author;
		
	else
	
		%--
		% edit parameter
		%--
				
		file = file_ext(data.browser.log(m).file);
		
		% this title should be changed to something more descriptive
		
		title_str = file;
% 		title_str = 'Selected Set';
		
		[param,author] = parameter_edit( ...
			description, ...
			title_str, ...
			param, ...
			data.browser.author ...
		);
	
	end
	
	%--
	% update persistent parameters and browser author
	%--
	
	if (~isempty(param))
		
		PARAMETER_PERSISTENT = param;
		data.browser.author = author;
		
	else
		
		out = 0;
		return;
		
	end
	
	%--
	% create waitbar and get start time
	%--
	
	if (nix > 20)
		
		hw = wait_bar(0,'');
		set(hw,'name',[description.name '  -  ' file]);
		
		start_time = clock;
		
		flag_wait = 1;
		
	else
		
		flag_wait = 0;
		
	end
	
	%--
	% set common values of measurements including parameters
	%--
	
	measurement.author = author;
	
	curr = now;
	measurement.created = curr;
	measurement.modified = [];
	
	measurement.parameter = param;
	
	%--
	% compute measurement for all indicated events
	%--
	
	for k = 1:nix

		%--
		% copy event from log and get measurement index
		%--
		
		event = data.browser.log(m).event(ix(k));
		
		ixa = find(strcmp(struct_field(event.measurement,'name'),description.name));
		
		%--
		% compute measurement
		%--
		
		if (isempty(ixa))
			
			len = length(event.measurement);
			if ((len == 1) & isempty(event.measurement(1).name))
				len = 0;
			end
			
			try
				
				measurement.value = measurement_compute(data.browser.sound,event,measurement.parameter);
				event.measurement(len + 1) = measurement;
				
			catch
			
% 				disp(' ');
% 				warning(['Failed to compute ''' description.name ''' for event ' num2str(event.id)]);
				
			end
					
		%--
		% recompute measurement
		%--
		
		else
		
			measurement.created = event.measurement(ixa).created;
			measurement.modified = curr;
			
			try
				
				measurement.value = measurement_compute(data.browser.sound,event,measurement.parameter);
				event.measurement(ixa) = measurement;
				
			catch
			
% 				disp(' ');
% 				warning(['Failed to compute ''' description.name ''' for event ' num2str(event.id)]);
				
			end
						
		end
		
		%--
		% put measured event into log
		%--
		
		data.browser.log(m).event(ix(k)) = event;
		
		%--
		% update waitbar
		%--
		
		if (flag_wait & ~mod(k,10))
			waitbar((k / nix),hw, ...
				['Events Processed: ' int2str(k) ', Elapsed Time: ' num2str(etime(clock,start_time),'%5.2f')]);
		end
			
	end
	
	%--
	% indicate that we are updating and saving log
	%--
	
	if (flag_wait)
		waitbar(1,hw, ...
			['Updating and saving log ''' file ''' ...'] ...
		);
	end
				
	%--
	% update save state of log
	%--
	
	if (data.browser.log(m).autosave)
		data.browser.log(m).saved = 1;
	else
		data.browser.log(m).saved = 0;
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% save log if needed
	%--
	
	if (data.browser.log(m).autosave)
		log_save(data.browser.log(m));
	end
	
	%--
	% close waitbar
	%--
	
	if (flag_wait)
		close(hw);
	end
	
	%--
	% update event display
	%--

	if (flag == 1)
		
		%--
		% log browser display update for a single or for multiple events
		%--
		
		if (nix == 1)
			
			%--
			% delete previous event display objects
			%--
			
			% we do this object type delete because the axes are tagged as
			% well and we do not need to remove these
			
			type = {'uimenu','uicontextmenu','line','patch','text'};
			
			for k = 1:length(type)
				delete(findall(gcf,'tag',[int2str(m) '.' int2str(ix)],'type',type{k}));
			end

			%--
			% rebuild event display and selection
			%--

			event_view('log',gcf,m,ix);
			event_bdfun(gcf,m,ix);
			
			drawnow;
			
		else
			
			% this is not implemented yet
			
% 			log_browser_display('events');
			
		end
		
	else
		
		%--
		% sound browser display update for a single or for multiple events
		%--
		
		if (nix == 1)
			
			%--
			% delete previous event display objects
			%--
			
			delete(findall(h,'tag',[int2str(m) '.' int2str(ix)]));
			
			%--
			% rebuild even display and selection
			%--
			
			event_view('sound',h,m,ix);
			event_bdfun(h,m,ix);
			
			drawnow;
			
		else
			
			browser_display(h,'events');
			
		end
		
	end
							
%--------------------------------------------------------
% DISPLAY MEASUREMENT INFORMATION IN MENU OR GRAPHICALLY
%--------------------------------------------------------

case ({'menu','display'})
	
	%--
	% rename input
	%--

	h = varargin{1};
	m = varargin{2};
	ix = varargin{3};
	
	%--
	% get userdata if needed
	%--
	
	if (length(varargin) > 3)
		data = varargin{4};
	else
		data = get(h,'userdata');
	end
	
	%--
	% handle both sound and log browser display
	%--
	
	if (~isempty(data.browser.parent))
		
		flag_log = 1;
		
		%--
		% get parent handle and update data
		%--
		
		g = h;
		h = data.browser.parent;
		data = get(h,'userdata');
		
	else
		
		flag_log = 0;
		
	end
	
	%--
	% get event and log filename
	%--

	event = data.browser.log(m).event(ix);
	file = file_ext(data.browser.log(m).file);
	
	%--
	% check for existence of measurement
	%--
	
	ixa = find(strcmp(struct_field(event.measurement,'name'),description.name));
	
	if (isempty(ixa))
		out = [];
		return;
	end
	
	%--
	% compute depending on display mode
	%--
	
	switch (mode)
		
	%--------------------------------------------------------
	% DISPLAY MEASUREMENT INFORMATION MENU
	%--------------------------------------------------------
	
	case ('menu')
		
		%--
		% get event display parent handle
		%--
		
		if (~flag_log)
			g = findobj(h,'type','patch','tag',[int2str(m) '.' int2str(ix)]);
		else
			g = findobj(g,'type','axes','tag',[int2str(m) '.' int2str(ix)]);
			g = findobj(g,'type','image');
		end
		
		if (isempty(g))
			
			out = [];
			return;
			
		else

			%--
			% get contextual menu of parent
			%--
			
			tmp = get(g,'uicontextmenu');
			
			% try to get one, if we fail get the other
			
			g = get_menu(tmp,'Measurement');

			if (isempty(g))
				g = get_menu(tmp,'Measure');
			end
			
			%--
			% create measurement scheme menu and edit option menu
			%--
			
% 			mg = menu_group(g,'',{description.name,['Compute ' description.name ' ...']});

			mg = menu_group(g,'',{description.name,'Edit ...'});
			
			tmp = functions(event.measurement(ixa).fun); 
			tmp = tmp.function;
			
			set(mg(2),'callback', ...
				[tmp '(''events'',' int2str(h) ',' int2str(m) ',' int2str(ix) ');']);
			
			if (get(mg(1),'position') > 1)
				set(mg(1),'separator','on');
			end
			
			%--
			% measurement information display menu
			%--
			
			out = measurement_menu(mg(1),m,event,ixa,description,data);
			
			%--
			% add parent menu handles to output
			%--
			
			out = [mg, out];
			
		end
			
	%--------------------------------------------------------
	% DISPLAY MEASUREMENT GRAPHICALLY
	%--------------------------------------------------------
	
	case ('display')
		
		%--
		% measurement information graphical display
		%--
		
		out = measurement_display(h,m,event,ixa,description,data);
				
		%--
		% tag objects with log and event indices string
		%--
		
		set(out,'tag',[int2str(m) '.' int2str(ix)]);
		
	end
		
end


%--------------------------------------------------------
%  EDITABLE SUB-FUNCTIONS FOR MEASUREMENT
%--------------------------------------------------------


%--------------------------------------------------------
% MEASUREMENT_DESCRIPTION
%--------------------------------------------------------

function description = measurement_description(h)

% measurement_description - create measurement description 
% --------------------------------------------------------
%
% description = measurement_description(h)
%
% Input:
% ------
%  h - figure handle for context
%
% Output:
% -------
%  description.name - name of measurement
%
%  description.parameter - parameter description
%  description.value - value description

%--
% set name
%--

description.name = 'Time-Freq Quartiles';

%--
% create parameter description considering context
%--

if (~nargin)
	description.parameter = parameter_fun('describe'); 
else
	description.parameter = parameter_fun('describe',h); 
end

%--
% create value descriptions
%--

description.value = value_fun('describe');
	
	
%--------------------------------------------------------
%  PARAMETER_FUN
%--------------------------------------------------------

function varargout = parameter_fun(mode,varargin)

% parameter_fun - parameter handling functions
% --------------------------------------------
%
%  description = parameter_fun('describe',h)
%    parameter = parameter_fun('create',h)
%
%        param = parameter_fun('pack',ans)
%          ans = parameter_fun('unpack',param)
%
% Input:
% ------
%  h - figure handle for context
%  ans - parameter cell array
%  param - parameter structure
%
% Output:
% -------
%  param - parameter structure
%
%  parameter - parameter description
%    .field - field names
%    .type - field types
%    .default - default field value
%    .input - input fields
%    .line - display size of input fields
%    .tip - field tips
%    .menu - menu fields
%    .separator - field separators in menu
%
%  ans - parameter value in cell array matching fieldnames

%--
% set mode
%--

if (~nargin)
	mode = 'create';
end 

%--
% compute depending on mode
%--

switch (mode)
	
	%--
	% create parameter structure with default value
	%--
	
	case ('create')
		
		%--
		% get context data (figure userdata)
		%--
		
% 		if (length(varargin))
% 			data = get(varargin{1},'userdata');
% 			context_flag = 1;
% 		else
% 			context_flag = 0;
% 		end
		
		%--
		% create parameter structure 
		%--
		
		param = fast_specgram;
		
		param.contour = 0;
		param.band = 0;
		
		%--
		% output parameter structure
		%--
		
		varargout{1} = param;
	
	%--
	% create parameter description
	%--
	
	case ('describe')
		
% 		get(h,'name')
		
		%--
		% get context data (figure userdata)
		%--
		
% 		if (length(varargin))
% 			data = get(varargin{1},'userdata');
% 			context_flag = 1;
% 		else
% 			context_flag = 0;
% 		end
		
		%--
		% parameter fields
		%--
		
		parameter.field = { ...
			'FFT Length', ...
			'Window Type', ...
			'Window Length', ...
			'Hop Length', ...
			'Contour', ...
			'Band Restriction' ...
		};
	
		%--
		% parameter structure field names
		%--
		
		parameter.struct = { ...
			'fft', ...
			'win_type', ...
			'win_length', ...
			'hop_length', ...
			'contour', ...
			'band' ...
		};
	
		%--
		% parameter field types
		%--
		
		parameter.type = { ...
			'','','','','','' ...
		};
		
		%--
		% parameter field default value
		%--
		
		WINDOWS = window_to_fun;
		ix = find(strcmp(WINDOWS,'Hanning'));
		n = length(WINDOWS);
		WINDOWS{n + 1} = ix;
		
		parameter.default = { ...
			[512, 32, 1024, 2], ...
			WINDOWS, ... 
			[1 0.05 1], ...
			[0.5, 0.05, 1], ...
			{'On','Off',2}, ...
			{'On','Off',2} ...
		};
	
		%--
		% parameter input fields
		%--
		
		parameter.input = { ...
			'FFT Length', ...
			'Window Type', ...
			'Window Length', ...
			'Hop Length', ...
			'Contour', ...
			'Band Restriction' ...
		};
		
		%--
		% parameter field input display size
		%--
		
		parameter.line = [ ...
			1, 40; ...
			1, 26; ...
			1, 40; ...
			1, 40; ...
			1, 26; ...
			1, 26 ...
		];
	
		%--
		% parameter field tips
		%--
		
		parameter.tip = { ...
			'FFT length in samples', ...
			'Type of window used to mask samples', ...
			'Length of window as fraction of FFT Length', ...
			'Advance per spectrogram slice as fraction of FFT length', ...
			'Compute quartiles contours', ...
			'Restrict computations to event band' ...
		};
	
		%--
		% parameter menu fields and separators
		%--
		
		parameter.menu = { ...
			'FFT Length', ...
			'Window Type', ...
			'Window Length', ...
			'Hop Length', ...
			'Contour', ...
			'Band Restriction' ...
		};

		parameter.separator = [];
		
		%--
		% output parameter description
		%--
		
		varargout{1} = parameter;
		
	%--
	% pack parameter cell array in structure
	%--
	
	case ('pack')
		
		%--
		% rename input
		%--
		
		ans = varargin{1};
		
		%--
		% create and update parameter structure
		%--

		param = parameter_fun('create');
		
		param.fft = ans{1};
		param.win_type = ans{2};
		param.win_length = ans{3};
		param.hop = ans{4}; 
		
		if (strcmp(ans{5},'On'))
			param.contour = 1;
		else
			param.contour = 0;
		end
		
		if (strcmp(ans{6},'On'))
			param.band = 1;
		else
			param.band = 0;
		end
				
		%--
		% output parameter structure
		%--
		
		varargout{1} = param;
		
	%--
	% unpack parameter structure to cell array
	%--
	
	case ('unpack')
		
		%--
		% rename input
		%--
		
		param = varargin{1};
		
		%--
		% unpack parameter value into cell array
		%--
		
		ans{1} = param.fft;
		ans{2} = param.win_type;
		ans{3} = param.win_length;
		ans{4} = param.hop;
		
		ans{5} = {bin2str(param.contour)};
		ans{6} = {bin2str(param.band)};
		
		%--
		% output parameter cell array
		%--
		
		varargout{1} = ans;
	
end
	
	
%--------------------------------------------------------
% PARAMETER_EDIT (DEFAULT)
%--------------------------------------------------------

function [param,author] = parameter_edit(description,title,param,author)

% parameter_edit - description generated edit dialog for parameter
% -----------------------------------------------------------------
%
% [param,author] = parameter_edit(description,title,param,author)
%
% Input:
% ------
%  description - measurement description
%  title - title for edit dialog
%  param - input parameter
%  author - current author
%
% Output:
% -------
%  param - parameter structure
%  author - author of parameter selection

%--
% get measurement name and parameter description
%--

name = description.name;

parameter = description.parameter;

%--
% unpack parameter into cell array
%--

ans = parameter_fun('unpack',param);

%--
% update dialog default value using input parameter
%--

n = length(parameter.default);

for k = 1:length(parameter.default)
	
	%--
	% update according to input type
	%--
	
	switch (class(parameter.default{k}))	
			
		%--
		% editable text box
		%--
		
		case ('char')
			
			parameter.default{k} = ans{k};
			
		%--
		% slider input
		%--
		
		case ('double')
			
			parameter.default{k}(1) = ans{k};
			
		%--
		% popup or listbox input
		%--
		
		case ('cell')
			
			ix = find(strcmp(parameter.default{k},ans{k}));
			
			if (~isempty(ix))
				parameter.default{k}{end} = ix;
			else
				parameter.default{k}{end} = 1;
			end
				
	end

end

%--
% add author field to input dialog
%--

parameter.field{n + 1} = 'Author';
parameter.default{n + 1} = author;
parameter.line(n + 1,:) = [1,26];
parameter.tip{n + 1} = 'Author of parameter choice';

%--
% build parameter editing input dialog
%--

ans = input_dialog( ...
	parameter.field, ...
	[name '  -  ' title], ...
	parameter.line, ...
	parameter.default, ...
	parameter.tip ...
);

%--
% output edited parameter if needed
%--

if (isempty(ans))
	
	param = [];
	author = '';
	
else
	
	author = author_validate(ans{n + 1});
	
	if (isempty(author))
		param = [];
	else
		param = parameter_fun('pack',ans(1:n));
	end
	
end

	
%--------------------------------------------------------
%  value_fun
%--------------------------------------------------------

function varargout = value_fun(mode,varargin)

% value_fun - value handling functions
% ------------------------------------
%
% description = value_fun('describe')
%       value = value_fun('create')
%
%       value = value_fun('pack',ans)
%         ans = value_fun('unpack',value)
%
% Input:
% ------
%  ans - value cell array
%  value - value structure
%
% Output:
% -------
%  description - measurement description
%
%    .field - value field names
%    .type - value field types
%    .menu - menu fields
%    .separator - field separators in menu
%
%  value - value structure
%  ans - value cell array

%--
% set default mode
%--

if (~nargin)
	mode = 'create';
end 

%--
% compute according to mode
%--

switch (mode)
	
	%--
	% create value structure
	%--
	
	case ('create')
		
		%--
		% create value structure
		%--
				
		value.time_q1 = [];
		value.time_q2 = [];
		value.time_q3 = [];
				
		value.time_iqr = [];
		value.time_asy = [];
				
		value.freq_q1 = [];
		value.freq_q2 = [];
		value.freq_q3 = [];
				
		value.freq_iqr = [];
		value.freq_asy = [];
        
        value.contour = [];
		
		%--
		% output value structure
		%--
		
		varargout{1} = value;
	
	%--
	% create value description
	%--
	
	case ('describe')
		
		%--
		% value fields
		%--
		
		description.field = { ...
			'Time Q1', ...
			'Time Median', ...
			'Time Q3', ...
			'Time IQR', ...
			'Time Asymmetry', ...
			'Freq Q1', ...
			'Freq Median', ...
			'Freq Q3', ...
			'Freq IQR', ...
			'Freq Asymmetry', ...
            'Quartile Contours' ...
		};
	
		%--
		% value structure fields
		%--
		
		description.struct = { ...
			'time_q1', ...
			'time_q2', ...
			'time_q3', ...
			'time_iqr', ...
			'time_asy', ...
			'freq_q1', ...
			'freq_q2', ...
			'freq_q3', ...
			'freq_iqr', ...
			'freq_asy', ...
            'contour' ...
		};
			
		%--
		% value types
		%--
		
		description.type = { ...
			'datetime', ...
			'datetime', ...
			'datetime', ...
			'sec', ...
			'', ...
			'freq', ...
			'freq', ...
			'freq', ...
			'freq', ...
			'', ...
            '' ...
		};
		
		%--
		% value menu fields and field separators
		%--
			
		description.menu = { ...
			'Time Median', ...
			'Freq Median', ...
			'Time IQR', ...
			'Freq IQR', ...
			'Time Asymmetry', ...
			'Freq Asymmetry' ...
		};
		
		description.separator = [3,5];
		
		%--
		% output value description
		%--
		
		varargout{1} = description;
		
	%--
	% pack value cell array into value structure
	%--
	
	case ('pack')
		
		%--
		% rename input
		%--
		
		ans = varargin{1};
		
		%--
		% pack cell array into value structure
		%--

		value = value_fun('create');
		
		value.time_q1 = ans{1};
		value.time_q2 = ans{2};
		value.time_q3 = ans{3};
		
		value.time_iqr = ans{4};
		value.time_asy = ans{5};
						
		value.freq_q1 = ans{6};
		value.freq_q2 = ans{7};
		value.freq_q3 = ans{8};
		
		value.freq_iqr = ans{9};
		value.freq_asy = ans{10};
        
        value.contour = ans{11};
				
		%--
		% output value structure
		%--
		
		varargout{1} = value;
		
	%--
	% unpack value structure into cell array
	%--
	
	case ('unpack')
		
		%--
		% rename input
		%--
		
		value = varargin{1};
		
		%--
		% unpack structure into cell array
		%--
						
		ans{1} = value.time_q1;
		ans{2} = value.time_q2;
		ans{3} = value.time_q3;
		
		ans{4} = value.time_iqr;
		ans{5} = value.time_asy;
						
		ans{6} = value.freq_q1;
		ans{7} = value.freq_q2;
		ans{8} = value.freq_q3;
		
		ans{9} = value.freq_iqr;
		ans{10} = value.freq_asy;
        
        ans{11} = value.contour;
	
		%--
		% output value cell array
		%--
		
		varargout{1} = ans;
	
end


%--------------------------------------------------------
%  MEASUREMENT_COMPUTE
%--------------------------------------------------------

function value = measurement_compute(sound,event,param)

% measurement_compute - compute measurement
% -----------------------------------------
%
% value = measurement_compute(sound,event,param)
%
% Input:
% ------
%  sound - sound 
%  event - event to measure
%  param - measurement parameter
%
% Output:
% -------
%  value - measurement value

%--
% get event data
%--

X = sound_read(sound,'time',event.time(1),event.duration,event.channel);

X = X - mean(X);

%--
% create value structure
%--

value = value_fun('create');

%--
% time quartiles
%--

c = cumsum(X.^2);
c = c / c(end);

t1 = event.time(1);
r = sound.samplerate;

q = fast_quartiles_(c);

value.time_q1 = t1 + q(1)/r;
value.time_q2 = t1 + q(2)/r;
value.time_q3 = t1 + q(3)/r;

value.time_iqr = value.time_q3 - value.time_q1;
value.time_asy = (value.time_q2 - value.time_q1) / value.time_iqr;

%--
% compute event spectrogram
%--

[B,f,t] = fast_specgram(X,r,'power',param);

n = size(B,2);

%--
% compute band restriction
%--

if (param.band == 1)
	
	%--
	% get row indices corresponding to event band
	%--
	
	q0 = max(find(f <= event.freq(1)));
	q1 = min(find(f >= event.freq(2)));
	
	%--
	% keep band of spectrogram
	%--
	
	B = B(q0:q1,:);
	
else
	
	q0 = 0;
	
end

%--
% median contour
%--

if (param.contour == 1)
	
	value.contour = zeros(3,n);
	
	for k = 1:n
        
        c = cumsum(B(:,k));
        c = c / c(end);
        
        q = fast_quartiles_(c)';
        q = f(q + q0);
        
        if (q(3) - q(1) > 0.25 * q(2))
            q(2) = nan;
        end
        
        value.contour(:,k) = q;
        
	end
	
else
	
	value.contour = [];
	
end

%--
% frequency quartiles
%--

B = sum(B,2) / n;

c = cumsum(B);
c = c / c(end);

q = fast_quartiles_(c) + q0;

value.freq_q1 = f(q(1));
value.freq_q2 = f(q(2));
value.freq_q3 = f(q(3));

value.freq_iqr = value.freq_q3 - value.freq_q1;
value.freq_asy = (value.freq_q2 - value.freq_q1) / value.freq_iqr;


%--------------------------------------------------------
%  MEASUREMENT_MENU (DEFAULT)
%--------------------------------------------------------

function g = measurement_menu(h,m,event,ixa,description,data)

% measurement_menu - create description generated menu display
% ------------------------------------------------------------
%
% g = measurement_menu(h,m,event,ixa,description,data)
%
% Input:
% ------
%  h - handle to parent
%  m - log index
%  event - measured event
%  ixa - measurement index in event
%  description - measurement description
%  data - figure userdata context
%
% Output:
% -------
%  g - handles to created menus

%--
% unpack measurement structures to cell arrays
%--

param = parameter_fun('unpack',event.measurement(ixa).parameter);

value = value_fun('unpack',event.measurement(ixa).value);

%--
% create value menu
%--

name = description.name;

description = description.value;

n = length(description.menu);
L = cell(1,n);
j = 1;

for k = 1:n
	
	%--
	% get field index
	%--
	
	ixf = find(strcmp(description.field,description.menu{k}));
	
	%--
	% create menu label depending on value type
	%--
	
	if (isempty(value{ixf}))
		
		L{k} = [title_caps(description.field{ixf},'_'), ':  (Empty)'];
		
	else
		
		L{k} = [title_caps(description.field{ixf},'_'), ':  '];
		
		%--
		% display according to value class and type
		%--
		
		switch (class(value{ixf}))	
			
			%--
			% string value
			%--
			
			case ('char')
								
				if (length(value{ixf}) <= 32)
					L{k} = [L{k} value{ixf}];
				else
					L{k} = [L{k} value{ixf}(1:28) ' ...'];
				end
				
			%--
			% number value
			%--
			
			case ('double')
				
				%--
				% get type of value field
				%--
				
				type = description.type{ixf};
				
				%--
				% create menu according to value type
				%--
				
				switch (type)
			
					%--
					% datetime and time display
					%--
						
					case ('datetime')
						
						tmp = data.browser.grid.time.labels;
						
						if (strcmp(tmp,'seconds'))
							L{k} = [L{k} num2str(value{ixf})];
						else
							if (data.browser.grid.time.realtime & ~isempty(data.browser.sound.realtime))
								
								date = datevec(data.browser.sound.realtime);
								time = date(4:6)*[3600,60,1]';
								L{k} = [L{k} sec_to_clock(time + value{ixf})];
								
							else
								L{k} = [L{k} sec_to_clock(value{ixf})];
							end
						end
						
					case ('time')
						
						tmp = data.browser.grid.time.labels;
						
						if (strcmp(tmp,'seconds'))
							L{k} = [L{k} num2str(value{ixf})];
						else
							L{k} = [L{k} sec_to_clock(value{ixf})];
						end
						
					%--
					% frequency display
					%--
					
					case ('freq')
						
						tmp = data.browser.grid.freq.labels;
						
						if (strcmp(tmp,'kHz'))
							L{k} = [L{k} num2str(value{ixf} / 1000) ' kHz'];
						else
							L{k} = [L{k} num2str(value{ixf}) ' Hz'];
						end
						
					%--
					% miscellaneous unit or no unit display
					%--
					
					otherwise
						
						L{k} = [L{k} num2str(value{ixf}) ' ' type];
						
				end
				
			%--
			% cell array value (this is not fully supported, currently only strings)
			%--
			
			case ('cell')
	
				if (length(value{ixf}) == 1)
					L{k} = [L{k} value{ixf}{1}];
				else	
					ixc(j) = ixf;
					M{j} = L{k};
					j = j + 1;
				end
				
		end
		
	end
	
end

L{n + 1} = [name ' Info:'];

%--
% set separators
%--
	
S = bin2str(zeros(1,n + 3));

for k = 1:length(description.separator)
	S{description.separator(k)} = 'on';
end

S{n + 1} = 'on';

%--
% create menu items with empty callbacks
%--
	
g1 = menu_group(h,'',L,S);

%--
% disable empty field menus to de-emphasize
%--

for k = 1:length(L)
	if (~isempty(findstr(L{k},'(Empty)')))
		set(g1(k),'enable','off');
	end
end

%--
% add author, creation and modification date information fields
%--

L = { ...
	['Author:  ' event.measurement(ixa).author], ...
	['Created:  ' datestr(event.measurement(ixa).created)] ...
};

if (~isempty(event.measurement(ixa).modified))
	L{3} = ['Modified:  ' datestr(event.measurement(ixa).modified)];
end

S = bin2str(zeros(1,3));
S{2} = 'on'; 

g2 = menu_group(get_menu(g1,[name ' Info:']),'',L,S);

%--
% put all handles together
%--

g = [g1,g2];

%--
% create submenus for cell arrays if needed (only strings are currently supported)
%--

if (j > 1)
	
	for k = 1:length(M)
		L = cell(0);
		tmp = value{ixc(k)};
		for j = 1:length(tmp)
			L{j} = tmp{j};
		end
		gk{k} = menu_group(get_menu(h,M{k}),'',L);
	end
	
	%--
	% append submenu handles to other menu handles
	%--
	
	for k = 1:length(M)
		g = [g, gk{k}];
	end
			
end
	

%--------------------------------------------------------
%  MEASUREMENT_DISPLAY
%--------------------------------------------------------

function g = measurement_display(h,m,event,ixa,description,data)

% measurement_display - create graphical display of measurement data
% ------------------------------------------------------------------
%
% g = measurement_display(h,m,event,ixa,description,data)
%
% Input:
% ------
%  h - handle to figure
%  m - log index
%  event - annotated event
%  ixa - measurement index
%  description - measurement description
%  data - figure userdata context
%
% Output:
% -------
%  g - handles to created graphic objects

%--
% get value
%--

value = event.measurement(ixa).value;

%--
% allocate handle vector
%--

contour = ~isempty(value.contour);

if (contour)
	g = zeros(1,7);
else
	g = zeros(1,4);
end

%--
% set linestyle and color
%--

if (strcmp(data.browser.renderer,'OpenGL'))
	lw1 = 1; 
	lw2 = 1.5;
else
	lw1 = 0.5 + eps;
	lw2 = 2;
end

rgb1 = [1 1 0];
rgb2 = [1 1 0];

%--
% get frequency scaling
%--

if (strcmp(data.browser.grid.freq.labels,'kHz'))
	kHz_flag = 1;
else
	kHz_flag = 0;
end

%--
% get display axes
%--

% NOTE: this only works for the sound display and should be encapsulated

dax = findobj(data.browser.axes,'tag',int2str(event.channel));

%--
% display time quartiles and fences (reduced box plot)
%--

% fixed for this part of the display

y = value.freq_q2;
y = y * ones(1,3);

if (kHz_flag)
	y = y / 1000;
end

% time concentration

x = [value.time_q1, value.time_q2, value.time_q3];

g(1) = line( ...
	'parent',dax, ...
	'xdata',x, ...
	'ydata',y, ...
	'linestyle','-', ...
	'marker','none', ... % 'marker','+', ...
	'color',rgb1, ...
	'linewidth',lw2 ...
);	

% time fences

off = 1.5 * value.time_iqr;
x = [value.time_q1 - off, value.time_q3 + off];

g(2) = line( ...
	'parent',dax, ...
	'xdata',x, ...
	'ydata',y(1:2), ...
	'linestyle','-', ...
	'marker','none', ... % 'marker','+', ...
	'color',rgb2, ...
	'linewidth',lw1 ...
);

%--
% display frequency quartiles and fences (reduced box plot)
%--

% fixed for this part of the display

x = value.time_q2;
x = x * ones(1,3);

% frequency concentration

y = [value.freq_q1, value.freq_q2, value.freq_q3];

if (kHz_flag)
	y = y / 1000;
end

g(3) = line( ...
	'parent',dax, ...
	'xdata',x, ...
	'ydata',y, ...
	'linestyle','-', ...
	'marker','none', ... % 'marker','+', ...
	'color',rgb1, ...
	'linewidth',lw2 ...
);	

% frequency fences

off = 1.5 * value.freq_iqr;
y = [value.freq_q1 - off, value.freq_q3 + off];

if (kHz_flag)
	y = y / 1000;
end

g(4) = line( ...
	'parent',dax, ...
	'xdata',x(1:2), ...
	'ydata',y, ...
	'linestyle','-', ...
	'marker','none', ... % 'marker','+', ...
	'color',rgb2, ...
	'linewidth',lw1 ...
);	

%--
% display quartile contours
%--

if (~isempty(value.contour))
	
	t = linspace(event.time(1),event.time(2),size(value.contour,2));
	
	% median contour
	
	y = value.contour(2,:);
	
	if (kHz_flag)
		y = y / 1000;
	end
	
	g(5) = line( ...
		'parent',dax, ...
        'xdata',t, ...
        'ydata',y, ...
        'linestyle','-', ...
		'color',0.8*[1 0 1], ... % magenta
		'linewidth',lw2 ...
	);	
	
% 	% 25th percentile contour
% 	
% 	y = value.contour(1,:);
%
% 	if (kHz_flag)
% 		y = y / 1000;
% 	end
% 	
% 	g(6) = line( ...
%         'xdata',t, ...
%         'ydata',y, ...
%         'linestyle',':', ...
% 		'color',[1 0 1], ...
% 		'linewidth',0.5 ...
% 	);
% 	
% 	% 75th percentile contour
%
% 	y = value.contour(3,:);
%
% 	if (kHz_flag)
% 		y = y / 1000;
% 	end
% 	
% 	g(7) = line( ...
%         'xdata',t, ...
%         'ydata',y, ...
%         'linestyle',':', ...
% 		'color',[1 0 1], ...
% 		'linewidth',0.5 ...
% 	);

end

%--
% make the display non-interfering with the interface
%--

set(g,'hittest','off');
