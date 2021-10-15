function [repos, urls] = get_repositories

% get_repositories - registered with local client
% -----------------------------------------------
%
% [repos, urls] = get_repositories
%
% Output:
% -------
%  repos - addresses
%  
%--
% get repository addresses from file
%--

file = [fileparts(which('svn')), filesep, 'repositories.txt'];

if ~exist(file, 'file')
	repos = {};
else
	repos = file_readlines(file);
end

if nargout < 2
	return;
end 

%--
% build urls if needed
%--

types = {'http:', 'https:', 'svn:'};

urls = repos;

for k = 1:length(repos)
	
	start = repos{k}(1:4);
	
	if strcmp(start, 'http') || strcmp(start, 'svn:')
		continue;
	end
	
	urls{k} = strcat('file:///', strrep(repos{k}, filesep, '/'));
end

