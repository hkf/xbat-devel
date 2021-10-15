function [version, exported, info] = svn_version(file)

% svn_version - get svn version string
% ------------------------------------
%
% [version, exported, info] = svn_version(file)
%
% Input:
% ------
%  file - file or directory
%
% Output:
% -------
%  version - string
%  exported - exported test, directory is not a working copy
%  info - svn info

%--
% set default file
%--

if nargin < 1
	file = pwd;
end 

%--
% get exported state and version string from info
%--

info = get_svn_info(file);

exported = isempty(info) || isfield(info, 'svn') || (length(fieldnames(info)) < 2);

if exported
	version = ''; 
else
	version = int2str(info.revision);
end

