function [root, status, result] = local_repository(root)

% local_repository - create local subversion repository
% -----------------------------------------------------
%
% [root, status, result] = local_repository(root)
%
% Input:
% ------
%  root - for repository
%
% Output:
% -------
%  root - of repository
%  status - of system call
%  result - of system call

% TODO: add options from 'svnadmin.exe'

%---------------
% HANDLE INPUT
%---------------

%--
% get root interactively if needed
%--

if ~nargin
	
	% NOTE: start path is not valid, we start at 'base' path
	
	root = uigetdir('/\', 'Select Repository Root');
	
	if ~ischar(root)
		root = ''; status = []; result = 'Cancelled'; return;
	end 
	
end

%---------------
% SETUP
%---------------

%--
% check that we can in fact have a root for the repository
%--

root = create_dir(root);

if isempty(root)
	return;
end

%--
% get tool to create repository
%--

tool = get_tool('svnadmin.exe'); 

% NOTE: if we cannot manage our repository we have no repository

if isempty(tool)
	root = '';
end

%---------------
% CREATE REPO
%---------------

%--
% create or verify local repository
%--

% NOTE: the two elements are '.' and '..'

if length(dir(root)) == 2
	[status, result] = system(['"', tool.file, '" create "', root, '"']);	
else	
	[status, result] = system(['"', tool.file, '" verify "', root, '"']);	
end

% NOTE: if repository create or verify failed we have no local repository

if status
	root = '';
end

%--
% update local repositories file if needed
%--

if isempty(root)
	return;
end 

update_repositories(root);


%----------------------------------
% UPDATE_REPOSITORIES
%----------------------------------

function repo = update_repositories(root)

% NOTE: this is not DRY, it is repeated in 'get_repositories'

file = [fileparts(which('svn')), filesep, 'repositories.txt'];

if exist(file, 'file')
	repo = file_readlines(file); repo = union(repo, root);
else
	repo = {root};
end

file_writelines(file, repo);
