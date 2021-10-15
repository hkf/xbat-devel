function desktop = get_desktop

% get_desktop - get the desktop folder for the system user
% --------------------------------------------------------
%
% desktop = get_desktop
%
% Output:
% -------
%  desktop - path to the user's desktop

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

%--
% handle platform specific stuff
%--

switch computer

    case {'GLNX86', 'GLNXA64', 'HPUX', 'SOL2', 'MACI', 'MACI64'}
        [ignore, desktop] = system('echo ~/Desktop'); desktop(end) = ''; %#ok<ASGLU>
      
    case {'MAC'}
        desktop = '';

    case {'PCWIN', 'PCWIN64'}
		desktop = get_windows_desktop;

end