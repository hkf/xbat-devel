function [X,opt] = read_flac(f,ix,n,ch,opt)

% read_flac - read samples from sound file
% ----------------------------------------
%
% [X,opt] = read_flac(f,ix,n,ch,opt)
%
% Input:
% ------
%  f - file location
%  ix - initial sample
%  n - number of samples
%  ch - channels to select
%  opt - conversion request options
%
% Output:
% -------
%  X - samples from sound file
%  opt - updated conversion options

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
% $Revision: 587 $
% $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
%--------------------------------
	
%---------------------------------------
% SET PERSISTENT VARIABLES
%---------------------------------------

%--
% set location of command-line utility
%--

persistent FLAC FLAC_READ_TEMP;

if (isempty(FLAC))
	
	FLAC = [fileparts(mfilename('fullpath')), filesep, 'flac.exe'];
	
	% NOTE: use a single temporary file to avoid name creation and delete
	
	FLAC_READ_TEMP = [tempdir, 'FLAC_READ_TEMP'];
	
end

%---------------------------------------
% DECODE USING CLI HELPER
%---------------------------------------
	
temp = [FLAC_READ_TEMP, int2str(rand_ab(1,1,10^6)), '.wav'];

%--
% decode flac to temporary file
%--

cmd_str = [ ...
	'"', FLAC, '" --decode --totally-silent', ... % NOTE: make the decoding silent
	' --skip=', int2str(ix), ...
	' --until=+', int2str(n), ...
	' --force --output-name=', temp, ... % NOTE: force the file to be written
	' "', f, '"' ...
];

system(cmd_str);

%--
% load data from temporary sound file
%--
	
X = read_libsndfile(temp,0,n,ch);

%--
% delete temporary file
%--

delete(temp);
