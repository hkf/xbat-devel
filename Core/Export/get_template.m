function fun = get_template(view,name)

% get_template - get view template handle
% ---------------------------------------
%
% fun = get_template(view,name)
%
% Input:
% ------
%  view - view name
%  name - template name
%
% Output:
% -------
%  fun - template function handle, empty if it does not exist

% Copyright (C) 2002-2007 Harold K. Figueroa (hkf1@cornell.edu)
% Copyright (C) 2005-2007 Matthew E. Robbins (mer34@cornell.edu)
%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--------------------------------
% SETUP
%--------------------------------

% NOTE: set convenient no fun default

fun = []; 

%--------------------------------
% GET TEMPLATE 
%--------------------------------

%--
% get view from view name
%--

view = get_view(view);

% NOTE: no fun if view is not available

if (isempty(view))
	return;
end 

%--
% get fun from view
%--

if (isfield(view.fun,name))
	fun = view.fun.(name);
end
