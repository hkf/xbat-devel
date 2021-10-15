function root = app_root(root)

% app_root - application root set and get
% ---------------------------------------
%
% root = app_root(root)
%
% Input:
% ------
%  root - to set
%  
% Output:
% -------
%  root - current
%
% See also: app_helper

% NOTE: we use two levels of persistence, 'set_env' to protect against 'clear' and persistent for speed

persistent ROOT;

if nargin
	if ~exist(root, 'dir')
		error(['Proposed root ''', root, ''' does not exist.']);
	end
	
	set_env('app_root', root);
	
	ROOT = root;
else
	if isempty(ROOT)
		root = get_env('app_root');
		
		ROOT = root;
	else
		root = ROOT;
	end
end