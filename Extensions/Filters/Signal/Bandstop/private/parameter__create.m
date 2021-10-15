function parameter = parameter__create(context)

% BANDSTOP - parameter__create

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

%------------------
% SETUP
%------------------

%--
% inherit basic parameters from parent
%--

fun = parent_fun; parameter = fun(context);

%--
% get nyquist from context
%--

nyq = get_sound_rate(context.sound) / 2;

%------------------
% PARAMETERS
%------------------

%--
% hidden parameters
%--

parameter.min_band = parameter.min_band / 2;

parameter.amplitude = [1, 0, 1];

%--
% band parameters
%--

parameter.min_freq = 0.45 * nyq;

parameter.max_freq = 0.55 * nyq;

%--
% design parameters
%--

parameter.stop_ripple = parameter.pass_ripple;
