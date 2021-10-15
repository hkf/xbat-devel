function desktop = get_windows_desktop(user)

% get_windows_desktop - get desktop for current user, or named user
% -----------------------------------------------------------------
%
% desktop = get_windows_desktop(user)
%
% Input:
% ------
%  user - user name
%
% Output
% ------
%  desktop - desktop path

%--
% return empty if we are not running windows
%--

if ~ispc
	desktop = ''; return;
end

%--
% set default empty user
%--

if ~nargin
    user = [];
end

%--
% get windows environment info
%--

% NOTE: the environment contains many other interesting things not used here

if isempty(user)
	env = get_windows_env;
else
    env.USERNAME = user;
end

%--
% get user desktop folder
%--

name = {env.USERNAME, 'All Users'};

for k = 1:length(name)
	
	% NOTE: build name and check it exists, then return
	
	desktop = ['C:\Documents and Settings\', name{k}, '\Desktop'];

	if exist_dir(desktop)
		return;
	end
end

% NOTE: if we are here none of our desktop choices exists

desktop = '';
