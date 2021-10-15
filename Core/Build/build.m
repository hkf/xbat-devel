function [files, destination] = build

% build - generic build for files in a 'MEX' directory
% ----------------------------------------------------
% 
% Move to a 'MEX' directory and call build to build contents

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
% check we are in MEX directory
%--

here = pwd;

if here(end) == filesep
    here(end) = [];
end

if ~strncmp(fliplr(here), 'XEM', 3)
	
	disp(' ');
	disp('This is not a ''MEX'' directory, there is nothing to build!'); 
	disp(' ');
	
	return;
	
end

% NOTE: remove existing files from MEX directory

delete(['*.', mexext]);

%--
% yield to custom build script
%--

private = fullfile(here, 'private');

if exist(fullfile(private, 'build.m'), 'file')
    
	str_line(64, '_');
	disp(' ');
	disp(['CUSTOM build of ''', pwd, ''' ...']);
	str_line(64, '_');
	disp(' ');

    try
        cd(private); [files, destination] = build; cd(here); return;
    catch
        cd(here); nice_catch(lasterror, ['Custom build script failed for ''', here, '''.']);
    end
    
end

%--
% build generically
%--

content = no_dot_dir; names = {content.name};

if isempty(names)
	return;
end

%--
% get library dependences for linker from file if possible
%--

linkflags = {};

if any(strcmp(names, 'deps.txt'))
    
    deps = file_readlines('deps.txt');
    
    for k = 1:length(deps)
        linkflags{k} = strrep(deps{k}, 'lib', '-l');
    end
    
end

disp(' ');

for ix = length(names):-1:1
	
	% NOTE: this enforces two naming conventions for MEX files, the first is the current
	
	if ~any(strfind(names{ix}, '_mex.c')) && ~any(strfind(names{ix}, '_.c'))
		names(ix) = [];
	end
	
end	 

str_line(64, '_');
disp(' ');
disp(['GENERIC build of ''', pwd, ''' ...']);
str_line(64, '_');

for ix = length(names):-1:1

	disp(' '); 
	disp(['- Building ''', names{ix}, ''' ...']);
	
	fun = file_ext(names{ix}); clear(fun);
	
	try
		build_mex(names{ix}, linkflags{:});
	catch
		names(ix) = [];
	end
	
end

disp(' ');

%--
% generate install directory and script
%--

destination = [fileparts(pwd), filesep, 'private'];

files = strcat(destination, filesep, file_ext(names, mexext)); 
	
%--
% move compiled files to private folder
%--

if isempty(names)
	files = {}; disp('Nothing to build.'); return;
end

disp('Moving files to private folder.'); 

movefile(['*.', mexext], destination); delete(['*.', mexext]);


