function tool = get_svn(local)

% get_svn - get svn tool, from network if needed
% ----------------------------------------------
%
% tool = get_svn
%
% Output:
% -------
%  tool - svn tool

% TODO: 'get_cvs' url = 'http://ftp.gnu.org/non-gnu/cvs/binary/stable/x86-woe/cvs-1-11-22.zip'

%--
% get tool in linux
%--

if ~ispc
	tool = get_tool('svn'); return;
end

%--
% get tool for PC
%--

% NOTE: if we set the local flag, we force the use of a local version of subversion

if ~nargin
	local = false;
end 

% NOTE: we use the system version if available and no local request

if ~local
	tool = get_windows_svn;

	if ~isempty(tool)
		return;
	end
end

tool = get_tool('svn.exe'); 

if ~isempty(tool)
	return;
end

% NOTE: this unravels a possible recursive call to 'get_curl'

get_curl;

% TODO: get the current value from a server, save a special text file in the tool root to manage updates

% current = 'http://subversion.tigris.org/downloads/svn-win32-1.4.3.zip';

% current = 'http://subversion.tigris.org/files/documents/15/41094/svn-win32-1.4.6.zip'; % NOTE: the new URL format looks less stable than the previous

current = 'http://xbat.org/downloads/installers/CollabNet_Subversion_Client_1.6.6.zip';

if isempty(tool) && install_tool('Subversion', current)

	tool = get_tool('svn.exe');
	
end


