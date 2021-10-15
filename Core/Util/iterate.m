function varargout = iterate(fun, varargin)

% iterate - iterate function over array
% -------------------------------------
%
% [out1, ... , outj, ... ] = iterate(fun, items, arg1, ... , argk, ... )
%
% Input:
% ------
%  fun - function
%  items - items
%  argk - argument
%
% Output:
% -------
%  outj - output
%
% See also: iteraten

% NOTE: the parent function 'iteraten' will be capable of parallel iteration

[varargout{1:nargout}] = iteraten(fun, 1, varargin{:});

