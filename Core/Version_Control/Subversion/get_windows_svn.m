function tool = get_windows_svn(refresh)

% get_windows_svn - get system installed svn client location
% ----------------------------------------------------------
%
% tool = get_windows_svn
%
% Output:
% -------
%  tool - tool

%--
% handle input
%--

if ~nargin
	refresh = false;
end 

%--
% check persistent store
%--

persistent TOOL;

if ~isempty(TOOL) && ~refresh
	tool = TOOL; return;
end

%--
% get system available subversion
%--

% NOTE: we assume an install that adds an element to the path with 'subversion'

path = get_windows_path('subversion');

if isempty(path)
	tool = []; return;
end

% NOTE: we only persist this result once we've found the tool

tool = get_tool(fullfile(path{1}, 'svn.exe'));

if ~isempty(tool)
	TOOL = tool;
end 