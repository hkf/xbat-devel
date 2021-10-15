function move_file(file, destination, pretend)

% move_file - move file considering svn status
% --------------------------------------------
%
% move_file(file, destination, pretend)
%
% Input:
% ------
%  file - file
%  destination - file
%  pretend - flag
%
% See also: delete_file

%--
% handle input
%--

if nargin < 3
	pretend = 1;
end

%--
% check svn status to see if we use svn move or system move
%--

[status, result] = svn('status', file);

if pretend
	disp(result); return;
end

if isempty(result) || (~isempty(result) && (result(1) ~= '?'))
	
	status = svn('move', file, destination);

	if status
		movefile(file, destination);
	end
	
else
	
	movefile(file, destination);
	
end
