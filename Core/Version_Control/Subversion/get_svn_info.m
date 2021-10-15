function info = get_svn_info(file)

% get_svn_info - get svn info for file or directory
% -------------------------------------------------
%
% info = get_svn_info(file)
% 
% Input:
% ------
%  file - file or directory
%
% Output:
% -------
%  info - info

%-------------------
% HANDLE INPUT
%-------------------

%--
% set default file
%--

if ~nargin
	file = pwd;
end

% NOTE: we try to get a full filename for files in the MATLAB path, better info path output

if ~exist(file, 'dir') && ~isempty(which(file))
	file = which(file);
end

%-------------------
% GET INFO
%-------------------

% TODO: make sure this handles unavailable 'svn' and non-versioned controlled files

[status, result] = svn('info', file);

info = parse_svn_info(result);

% TODO: improve parsing of properties and get other basic properties

opt = file_readlines; opt.skip = 1; 

% NOTE: we may use the externals to improve project updating, we may manage these directly

[status, result] = svn('propget', 'svn:externals', file);

if ~isempty(result)
	info.prop.externals = file_readlines(result, [], opt);
else
	info.prop.externals = {}; % this may not be needed
end

[status, result] = svn('propget', 'svn:ignore', file);

info.prop.ignore = file_readlines(result, [], opt);

[status, result] = svn('propget', 'svn:keywords', file);

info.prop.keywords = str_split(result);

%--
% display if output not captured
%--

if ~nargout
	disp(flatten(info)); clear info;
end


%-------------------------
% PARSE_SVN_INFO
%-------------------------

function info = parse_svn_info(result)

info = struct;

lines = file_readlines(result); 

if isempty(lines{end})
	lines(end) = []; 
end

for k = 1:length(lines)
	
	[field, value] = strtok(lines{k}, ':'); 
	
	field = lower(strrep(field, ' ', '_')); value = strtrim(value(2:end));
	
	if ~isvarname(field) 
		field = genvarname(field);
	end
	
	try
		info.(field) = eval(value);
	catch
		info.(field) = value;
	end
	
end
