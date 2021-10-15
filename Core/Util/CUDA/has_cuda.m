function [count, level] = has_cuda

% has_cuda - device count and level
% ---------------------------------
%
% [count, level] = has_cuda
%
% Output:
% -------
%  count - of cuda devices
%  level - for each device

%--
% manage persistent store
%--

persistent COUNT LEVEL;

if ~isempty(COUNT)
	count = COUNT; level = LEVEL; return;
end

%--
% get device count and level for each
%--

% NOTE: a zero count with a -1 level indicates missing software

try
	count = cuda_get_count_mex; level = zeros(1, count);
catch
	count = 0; level = -1; return; % NOTE: in this case we do not set the persistent store
end

for k = 1:count
	level(k) = get_cuda_capability(k - 1); % NOTE: devices are numbered starting at 0
end

COUNT = count; LEVEL = level;