function h = ylabel_edit(s,str)

% ylabel_edit - create editable YLabel and get YLabel string
% ----------------------------------------------------------
% 
% h = ylabel_edit(s)
% s = ylabel_edit(h)
%
% Input:
% ------
%  s - YLabel string
%  h - handle to parent axes (def: gca)
%
% Output:
% -------
%  h - handle of YLabel
%  s - YLabel string

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:52-04 $
%--------------------------------

%--
% handle variable input
%--

if (nargin < 1)
	
	% get YLabel and make editable
	
	h = get(gca,'YLabel');
	
	set(h,'ButtonDownFcn','ylabel_edit([],''Edit'');');
	% set(h,'erasemode','normal');
	
	% output string and return
	
	h = get(h,'string');
	
	return;
	
end	

if (nargin < 2)
	
	if (isstr(s))
	
		str = 'Initialize';
		
	elseif (ishandle(s))
	
		% get YLabel and make editable
	
		h = get(s,'YLabel');
		
		set(h,'ButtonDownFcn','ylabel_edit([],''Edit'');');
		% set(h,'erasemode','normal');
		
		% output string and return
		
		h = get(h,'string');
		
		return;
		
	end
		
end

%--
% main switch
%--

switch (str)

	case ('Initialize')
	
		h = ylabel(s);
		set(h,'ButtonDownFcn','ylabel_edit([],''Edit'');');
		% set(h,'erasemode','normal');
		
	case ('Edit')
	
		h = get(gca,'YLabel');
		set(h,'Color',[0, 0, 0]);
		set(h,'Editing','on');
		waitfor(h,'Editing');
		
end

%--
% set visible color
%--

if (all(get(gcf,'color') == [0, 0, 0]))
	set(get(gca,'YLabel'),'color',[1, 1, 1]);
end
