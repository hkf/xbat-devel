function tool = nircmd

% nircmd - get nircmd tool
% ------------------------
%
% tool = nircmd
%
% Output:
% -------
%  tool - tool file and root

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

% TODO: reveal commands

if ~ispc
    tool = []; return;
end

%--
% get tool
%---

tool = get_tool('nircmdc.exe');

%--
% install tool to get tool if needed
%--

switch computer
	case 'PCWIN'
		url = 'http://www.nirsoft.net/utils/nircmd.zip';
		
	case 'PCWIN64'
		url = 'http://www.nirsoft.net/utils/nircmd-x64.zip';
		
	otherwise
		error('This tool is only needed, available on Windows.');
end

if isempty(tool) && install_tool('NirCmd', url);
	
	tool = get_tool('nircmdc.exe');	
end
