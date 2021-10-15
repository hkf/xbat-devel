function info = get_windows_info(type)

% get_windows_info - get some windows info
% ----------------------------------------
% 
% info = get_windows_info(type)
%
% Input:
% ------
%  type - 'env' or 'reg'
%
% Output:
% -------
%  info - some windows info

%--
% handle input
%--

if ~ispc
	info = struct; return;
end

if ~nargin
	type = 'env';
end 

%--
% get windows info
%--

switch lower(type(1:3))
	
	case 'env', info = get_windows_env;
		
	case 'reg', info = reg_info;

end


%-----------------
% REG_INFO
%-----------------

% NOTE: the info provided by this function is not very useful and not stable

% NOTE: this functions is very fragile, due to the complexity and volatility of the registry

function info = reg_info

info = struct;

%--
% user
%--

info.user = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', ...
	'DefaultUserName' ...
);

%--
% computer
%--

info.computer.name = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', ...
	'DefaultDomainName' ...
);

info.computer.alias = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', ...
	'AltDefaultDomainName' ...
);

info.computer.owner = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion', ...
	'RegisteredOwner' ...
);

%--
% matlab
%--

info.matlab.name = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\MathWorks', ...
	'Name' ...
);

info.matlab.company = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\MathWorks', ...
	'Company' ...
);

%--
% windows
%--

info.windows.name = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion', ...
	'ProductName' ...
);

info.windows.id = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion', ...
	'ProductId' ...
);
