function [level, arch] = get_cuda_capability(id)

% get_cuda_capability - level and compiler option
% -----------------------------------------------
%
% [level, arch] = get_cuda_capability(id)
%
% Input:
% ------
%  id - for device (def: 0)
%
% Output:
% -------
%  level - of device
%  arch - nvcc option flag
%
% NOTE: this functions exists and is public to be used in 'build_cuda_mex'

if ~nargin
	id = 0;
end

% NOTE: packing capability as level number helps when comparing devices

cap = cuda_get_capability_mex(id); level = cap(1) + 0.1 * cap(2);

if nargout > 1
	arch = sprintf('compute_%d%d', cap(1), cap(2));
end

