function [value, info] = is_working_copy(root, fast)

% is_working_copy - check whether a directory is a working copy
% -------------------------------------------------------------
%
% [value, info] = is_working_copy(root)
%
% Input:
% ------
%  root - root directory
%
% Output:
% -------
%  value - result of is working copy test
%  info - svn info

%--
% handle input
%--

if nargin < 2
	fast = 1;
end

if ~nargin
	root = pwd;
end

%--
% perform test
%--

% NOTE: fast test looks for '.svn' in a listing of the directory contents

if fast
	value = ~isempty(strmatch('.svn', ls(root))); info = struct; return; 
end

% NOTE: the full test uses the 'svn' client to answer the question and get versioning info

% TODO: use a 'has_svn' or test for svn install here

try
    [ignore, exported, info] = svn_version(root);
catch
    nice_catch; value = 0; return;
end

value = ~exported;
