function str = string_scramble(str, opt)

%--
% handle input
%--

if nargin < 2
	opt.fix_ends = 1; opt.tokenize = 1;
end

if ~nargin
	str = opt; return;
end

% NOTE: handle string cell arrays recursively

if iscell(str)
	
	for k = 1:numel(str)
		str{k}= string_scramble(str{k}, opt);
	end
	
	return;
	
end

%--
% scramble string
%--

if isempty(str) 
	return;
end

if opt.tokenize
	
	part = str_split(str); 
	
	if ~iscell(part)
		part = {part}; 
	end
	
	opt.tokenize = 0;
	
	for k = 1:numel(part)
		part{k} = string_scramble(part{k}, opt);
	end
	
	str = str_implode(part); 
	
	return;
	
end

if opt.fix_ends 
	
	if length(str) > 3
		str = [str(1), scramble(str(2:end - 1)), str(end)];
	end
	
else
	
	str = scramble(str);
	
end


%----------------------
% SCRAMBLE
%----------------------

function str = scramble(str)

str = str(randperm(length(str)));

