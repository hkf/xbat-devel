function root = tsvn_root

% tsvn_root - get 'TortoiseSVN' install root
% ------------------------------------------
%
% root = tsvn_root
%
% Output:
% -------
%  root - 'TortoiseSVN' install path
%
% See also: tsvn, svn

%--
% set tentative TortoiseSVN install root
%--

if ~ispc
    root = ''; return;
end

path = get_windows_path;

found = find(~cellfun('isempty', strfind(get_windows_path, 'TortoiseSVN')));

if found	
	% NOTE: we prune the 'bin' at the end
	
	root = fileparts(path{found});
else
	% NOTE: this is the default location on english language windows systems

	root = 'C:\Program Files\TortoiseSVN';
end

%--
% test that the directory exist, otherwise return empty
%--

if isempty(root) || ~exist_dir(root)
	root = '';
end