function value = string_begins(str, pat, n)

% string_begins - indicate if string begins with pattern
% ------------------------------------------------------
%
% value = string_begins(str, pat)
%
% Input:
% ------
%  str - string or string cell array
%  pat - pattern
%
% Output:
% -------
%  value - indicator

% NOTE: using this approach this function returns a logical vector rather than indices

% NOTE: we get length of pattern if needed to streamline iteration

if nargin < 3
	n = numel(pat);
end

%--
% handle multiple strings
%--

if iscellstr(str)
	value = iterate(mfilename, str, pat, n); return;
end

%--
% check for occurence of pattern and indicate
%--

value = strncmp(pat, str, n);
