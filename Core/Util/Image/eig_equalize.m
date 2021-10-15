
% scr_eig 
%--
% load image
%--

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

X = load_rgb;

%--
% compute eigencolor expansion
%--

[Y,V,c] =  rgb_to_eig(X);

% 	%--
% 	% equalize chromatic channels
% 	%--
% 	
% 	for k = 1:2
% 		Y(:,:,k) = hist_equalize(Y(:,:,k));
% 	end
	
	%--
	% shape chromatic channels
	%--
	
	for k = 1:2
		
		b = fast_min_max(Y(:,:,k));
		hc = linspace(b(1),b(2),256);
		x = linspace(0,1,256);
		h = (x.*(1 - x)).^3;
		
		Y(:,:,k) = hist_specify(Y(:,:,k),h,hc);
		
	end

%--
% return to rgb representation
%--

X_new = eig_to_rgb(Y,V,c);


%--
% display input and output
%--

fig; image_view(X); 

fig; image_view(X_new);




