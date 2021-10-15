function ignore_mex(root)

% ignore_mex - using Subversion properties
% ----------------------------------------
%
% ignore_mex(root)
%
% Input:
% ------
%  root - to scan
%
% See also: svn, scan_dir

% NOTE: by default we start from the top

if ~nargin
	root = fullfile(app_root, 'Core');
end

% NOTE: we only consider updating 'private' directory properties

update = scan_dir(root, @(p)(ternary(string_contains(p, 'private'), p, [])));

iterate(@disp, update);

here = fileparts(mfilename('fullpath'));

for k = 1:numel(update)
	svn('propset', 'svn:ignore', ['-F ', here, '/ignore_mex.txt'], update{k});
end
