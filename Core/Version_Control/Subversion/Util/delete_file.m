function delete_file(file, pretend)

% delete_file - delete file from system considering svn status
% ------------------------------------------------------------
%
% delete_file(file, pretend)
%
% Input:
% ------
%  file - file
%  pretend - flag
%
% See also: move_file

%--
% handle input
%--

if nargin < 2
	pretend = 1;
end

%--
% check svn status to see if we use svn delete or system delete
%--

[status, result] = svn('status', file);

if pretend
	disp(result); return;
end

if isempty(result) || (~isempty(result) && (result(1) ~= '?'))
	
	status = svn('delete', file);
	
	if status
		delete(file);
	end
	
else
	
	delete(file);
	
end
