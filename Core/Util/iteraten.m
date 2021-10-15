function varargout = iteraten(fun, n, varargin)

% iteratek - iterate function over arrays positioned anywhere in arguments
% ------------------------------------------------------------------------
%
% [out1, ... , outj, ... ] = iteraten(fun, n, arg1, ... , items, ... , argk, ... )
%
% Input:
% ------
%  fun - function
%  items - items (these are in the n-th positions, hence the name)
%  argk - argument
%
% Output:
% -------
%  outj - output
%
% See also: iterate

% TODO: remove waitbar cod to make more portable, create small iteration toolbox


% NOTE: this function only depends on the 'function_handle' overloaded 'exist'

% TODO: multiple values of 'n', fully parallel iteration, is not yet implemented

% NOTE: iterate now becomes a special case of this function

% TODO: consider the possibility of block iteration, for already vectortized functions

%------------------
% HANDLE INPUT
%------------------

%--
% check for function to iterate
%--

if isempty(fun)
	error('Function to iterate is required input.');
end

%--
% ensure proper function handle input
%--

if ischar(fun)
	fun = str2func(fun);
end

if ~isa(fun, 'function_handle')
	error('Function input must be string or function handle.');
end

% NOTE: what is the point of this check, are we providing some useful error?

% % NOTE: this 'exist' is overloaded for function handles
% 
% if ~exist(fun) %#ok<EXIST> 
% 	error('Function to iterate does not exist.');
% end

% TODO: this check is too costly, consider if there is another way

% NOTE: check compatibility of output argument numbers

% NOTE: the first part of this condition handles functions which output variable arguments

% try
% 	
% 	if (nargout(fun) > 0) && (nargout > nargout(fun))
% 		error('Requested number of outputs exceeds available outputs.');
% 	end
% 	
% catch
% 	
% 	% NOTE: in the case of methods 'nargout' believes the function does not exist
% 	
% % 	disp('ITERATE: Unable to check compatibility of output arguments.');
% 
% end

%--
% check for waitbar directive
%--

% TODO: allow for some configuration of the waitbar, perhaps make this a struct

% NOTE: of course this requires a mini-framework

wait = ischar(varargin{end}) && strcmp(varargin{end}, '__WAITBAR__');

if wait
	varargin(end) = [];
end

%--
% get items and args from input
%--

% NOTE: empty indicator indices mean fully parallel iteration

% if isempty(n)
% 	n = 1:numel(varargin);
% end

if any(n < 1) || any(n > numel(varargin))
	error('Iterator items index is out of range.');
end

items = varargin{n}; 

% TODO: consider what to do about the outputs in this case

if ~numel(items)
	return;
end

args1 = varargin(1:(n - 1)); args2 = varargin((n + 1):end); 



% TODO: implement the general case, what follows id part of the code

% %--
% % copy item arguments to iterate and check size,
% %--
% 
% items = varargin(n); count = numel(items{1});
% 
% for k = 2:numel(items)
% 	if numel(items{k}) ~= count
% 		error('Items to iterate must have matching number of items.');
% 	end
% end 
% 
% % NOTE: we also rename the varargin to args for clarity
% 
% args = varargin; 



%------------------
% ITERATE
%------------------

%--
% create waitbar
%--

if wait
	pal = iteraten_waitbar(fun);
end

%--
% iterate
%--

% NOTE: the shape of the items to iterate over turn outs to be quite useful

shape = size(items); outputs = cell(shape); is_cell = iscell(items);

for k = 1:numel(items)

	%--
	% get item 
	%--
	
	if is_cell
		item = items{k};
	else
		item = items(k);
	end
	
	%--
	% get and pack result
	%--
	
	% NOTE: this is the simple, no error-handling version of this function
	
% 	[varargout{1:nargout}] = fun(item, args{:});
	
	% TODO: improve error handling, this simply displays the item we failed on
	
	try
	
		[varargout{1:nargout}] = fun(args1{:}, item, args2{:});
	
	catch

		if isstruct(item)
			flatten(item)
		else
			item %#ok<NOPRT>
		end

		% NOTE: don't leave orphaned waitbars, we don't like orphans
		
		if wait && ishandle(pal)
			close(pal);
		end
		
		rethrow(lasterror);

	end
	
	outputs{k} = varargout;
	
	%--
	% update waitbar
	%--
	
	% NOTE: the waitbar related code in this iteration is fragile
	
	if wait

		% TODO: smart shortening of item for display
		
		if ischar(item)
			waitbar_update(pal, 'PROGRESS', 'value', k / numel(items), 'message', item);
		else
			waitbar_update(pal, 'PROGRESS', 'value', k / numel(items));
		end
			
	end
	
end

if wait
	close(pal);
end

%--
% re-pack outputs
%--

% TODO: consider improving concatenation 

% NOTE: pre-allocating this array to the right shape, saves various calls to 'reshape'

output = cell(shape);

for j = 1:nargout
	
	for k = 1:numel(items)
		output{k} = outputs{k}{j};
	end
	
	varargout{j} = output;
	
	% NOTE: this tries to produce a simple matrix, the 'try' replaces the 'uniformoutput' flag
	
	if ~iscellstr(varargout{j})
		
		try %#ok<TRYNC>
			varargout{j} = cell2mat(varargout{j});
% 		catch
% 			nice_catch(lasterror, 'Failed to pack as matrix!');
		end
		
	end
	
end


%---------------------------
% ITERATEN_WAITBAR
%---------------------------

function pal = iteraten_waitbar(fun)

%--
% configure waitbar
%--

control = control_create( ...
	'name', 'PROGRESS', ...
	'alias', ['Iterating ''', func2str(fun), ''' ...'], ...
	'style', 'waitbar', ...
	'confirm', 1, ...
	'lines', 1.1, ...
	'space', 2 ...
);

name = 'Iterating ...';

par = get_xbat_figs('type', 'waitbar');

opt = waitbar_group; opt.show_after = 1;

%--
% create waitbar
%--

if numel(par) == 1
	pal = waitbar_group(name, control, par, 'bottom', opt); 
else
	pal = waitbar_group(name, control, [], [], opt);
end
