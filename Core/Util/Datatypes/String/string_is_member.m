function [value, ix] = string_is_member(str, strs, nocase)

% string_is_member - check whether string inputs are members of string set
% ------------------------------------------------------------------------
%
% [value, ix] = string_is_member(str, strs, nocase)
%
% Input:
% ------
%  str - potential members
%  strs  - string set
%  nocase - indicator
%
% Output:
% -------
%  value - membership indicator
%  ix - index of first occurence in strings set array

% TODO: the index must be zero when we don't find something so that we can 'iterate' over the function

%--
% set case default
%--

if nargin < 3
	nocase = 0;
end

%--
% handle multiple inputs recursively
%--

% NOTE: we assume that cell input is a string cell array for speed

if iscell(str)

	% NOTE: this handles the common special case of an empty cell input
	
	if isempty(str)
		value = []; ix = []; return;
	end
	
	[value, ix] = iterate(mfilename, str, strs, nocase); return;

end

%--
% check set is not empty
%--

% TODO: consider using zero index to indicate the non-member position rather than empty

if isempty(strs)
	value = false; ix = nan; return;
end

%--
% check membership of string
%--

if nocase
	ix = find(strcmpi(str, strs), 1);
else
	ix = find(strcmp(str, strs), 1);
end

if isempty(ix)
	value = false; ix = 0;
else
	value = true; ix = ix(1);
end


