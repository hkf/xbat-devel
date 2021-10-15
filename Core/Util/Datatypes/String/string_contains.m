function [value, occurs] = string_contains(str, pat, sensitive)

% string_contains - indicate if string contains pattern
% -----------------------------------------------------
%
% value = string_contains(str, pat, sensitive)
%
% Input:
% ------
%  str - string or string cell array
%  pat - pattern
%  sensitive - indicator (def: 1)
%
% Output:
% -------
%  value - indicator

%--
% by default we are sensitive
%--

if nargin < 3
	sensitive = 1;
end

%--
% handle multiple strings
%--

if iscellstr(str)
	[value, occurs] = iterate(mfilename, str, pat, sensitive); return;
end

%--
% check for occurence of pattern and indicate
%--

% NOTE: this is not efficient when iterating

if ~sensitive
	str = lower(str); pat = lower(pat);
end

% NOTE: the transpose is a trick that fixes the packing of the iteration

occurs = strfind(str, pat)'; value = ~isempty(occurs); 

