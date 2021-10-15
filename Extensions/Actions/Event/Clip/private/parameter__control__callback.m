function result = parameter__control__callback(callback, context)

% CLIP - parameter__control__callback

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

result = struct;

pal = callback.pal.handle;

%--
% perform control-specific action
%--

switch callback.control.name
    
    case 'add_token'
        
        str = get_control(pal, 'file_names', 'string');
        
        value = get_control(pal, 'add_token', 'value');
        
        value = file_name_tokens(value{1});
        
        if isempty(str)
            str = value;
        else
            str = [str, '_', value];
        end
        
        set_control(pal, 'file_names', 'string', str);
        
    case 'tapering'
        
        enable = get_control(pal, 'tapering', 'value');

        set_control(pal, 'taper_length', 'enable', enable);
        
end
