function info = cuda_device_info(id)

% cuda_device_info - cuda device information
% ------------------------------------------
%
% info = cuda_device_info(id)
%
% Input:
% ------
%  id - for device (def: [], gets info for all available devices)
%
% Output:
% -------
%  info - struct

% NOTE: we first check for availability of devices

if ~has_cuda
	info = []; 
end

%--
% get info for all devices
%--

if ~nargin
	info = cuda_device_info(0);
	
	for id = 1:(has_cuda - 1)
		info = cuda_device_info(id);
	end
	
	return;
end

%--
% get specified device info
%--

info.name = cuda_get_name_mex(id);

info.level = get_cuda_capability(id); % NOTE: this is the only non-mex we call here

info.attributes = cuda_get_attributes_mex(id);

info.totalmem = cuda_get_totalmem_mex(id);

info.id = id;
