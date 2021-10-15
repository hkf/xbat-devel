function value = cuda_enabled(value)

% cuda_enabled - indicator
% ------------------------
%
% value = cuda_enabled;
%
% cuda_enabled(value);
%
% Input:
% ------
%  value - to set
%
% Output:
% -------
%  value - current state

% NOTE: exit quickly if we do not have  a cuda device

if ~has_cuda
	value = false; return; 
end

% NOTE: at this point we know we have cuda devices

persistent CUDA_ENABLED;

if ~nargin
	if isempty(CUDA_ENABLED)
		CUDA_ENABLED = true;
	end
else
	if ischar(value)
		switch value
			case {'0', 'false'}, value = false;
				
			case {'1', 'true'}, value = true;
				
			otherwise, error(['Unrecognized cuda enable state ''', value, '''.']);
		end
	end
	
	CUDA_ENABLED = value;
end

value = CUDA_ENABLED;