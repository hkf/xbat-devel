function varargout = build_mex(varargin)

% build_mex - build mex file using MinGW tools
% --------------------------------------------
%
% Build mex file using the same syntax as MATLAB built-in 'mex'.
%
% This command automatically uses the MinGW tools for compiling
% and linking, it borrows some code from the 'gnumex' project. It
% provides the following additional features:
%
%  1. It will pass '-l' switches straight to the 
%     linker, so if we want to link against library
%     named 'libfftw3.a', we only include '-lfftw3'.
%   
%  2. If you leave out libraries all together, 'build_mex'
%     will link against all available libraries in the
%     'LIBS' directory, and include all corresponding
%     available header files.
%
%  3. 'build_mex' may wrap the stdlib 'malloc', 'calloc', 
%     'realloc', and 'free' calls at link time with their
%     MATLAB counterparts.  It is advisable to do this 
%     when using external libraries and it is done by default.
%     
%   ( NOTE: Wrapping can be disabled by including '-nowrap'
%     as an input argument, the link script generates the 
%     appropriate arguments to pass to GCC. )
%
% Example:
%
% build_mex -v -nowrap -lfftw3 faster_specgram_.c

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
% declare and initialize some variables
%--

mexopts_tpl = [this_path, 'Magic', filesep, 'mexopts.in'];

mexopts_file = [this_path, 'Magic', filesep, 'mexopts.bat'];

wrapflag = 1;

libpath = [this_path, 'LIBS']; inclpath = libpath;

%--
% Check for MinGW presence if necessary
%--

if ispc && isempty(mingw_root)
	error('Unable to find MinGW.');
end
	
%--
% generate mex call, but using our own mexopts.bat for windows machines
%--

% NOTE: this string will grow.

str = 'mex ';

if ispc
    str = [str, '-f "', mexopts_file, '"']; 
end

%--
% set the C standard to gnu89
%--

if isunix
    str = [str, 'CFLAGS=''$CFLAGS -std=gnu89'''];
end

%--
% grab "special" args here, pass the rest to regular mex
%--

libs = {};

for ix = 1:length(varargin)
	
	%--
	% handle symbol wrapping
	%---

	% NOTE: typically used to replace allocation (malloc) routines
	
	if strcmp(varargin{ix}, '-nowrap') 
        wrapflag = 0; continue;
    end
        
    %--
    % for PC's handle '-l' switches properly
    %--
    
    if ispc && strncmp(varargin{ix}, '-l', 2)
        
        file = find_file([strrep(varargin{ix}, '-l', 'lib'), '.a'], libpath , '-a', '-p');

        if iscell(file) && length(file) > 0
            file = file{1};
        end

        libs{end + 1} = ['"', file, '"'];

        continue;
       
    end
        
	%--
	% handle mex arguments
	%--
	
    % NOTE: handle file location in special way

    if exist(varargin{ix}, 'file')
        varargin{ix} = fix_path(varargin{ix}, '"');
    end

    str = [str, ' ', varargin{ix}];
	
end

%--
% handle symbol wrapping
%--

% NOTE: this can be done simply on linux

if ~ispc && wrapflag
    
    wrap_file = [this_path, 'Magic', filesep, 'mwraps.c'];
    
    str = [str, ' "', wrap_file, '" ''', wrapstr(wrapflag), '''']; 
    
end

%--
% point gcc to our include directories
%--

d = dir(inclpath);

for ix = 1:length(d)
	
	if ((d(ix).name(1) ~= '.') && d(ix).isdir)
		str = [str, ' ', '-I"', inclpath, filesep, d(ix).name, '"']; 
	end
	
end

%--
% also point to our library dirs
%--

if ~ispc

	d = dir(libpath);

	for ix = 1:length(d)

		if (d(ix).name(1) ~= '.') && d(ix).isdir
			str = [str, ' ', '-L"', libpath, filesep, d(ix).name, '"'];  %#ok<AGROW>
		end

	end

end

%--
% make mexopts.bat file from template
%--

if ispc
    generate_mexopts(mexopts_tpl, mexopts_file, wrapflag, libs); 
end

%--
% run mex with our newly-tweaked options file, and the passed-in args.
%--

disp(' ');

str2 = str_wrap(str);

disp(str2{1});
for k = 2:length(str2)
	disp([' ', str2{k}]);
end 

disp(' ');

try
    eval(str);
catch
    disp('Warning: one or more files failed to build');
end

%--
% display mex string if output is requested
%--

if nargout
    varargout{1} = str;
end


%-----------------------------------------
% GENERATE_MEXOPTS
%-----------------------------------------

function generate_mexopts(in, out, wrapflag, libs)

% generate_mexopts - generate mexoptions file that uses mingw
% ---------------------------------------------------------
%
% generate_mexopts(out,linker,wrap,libs)
%
% Input:
% ------
%  in - options template file
%  out - options file
%  wrapflag - wrap indicator
%  libs - libraries to link

%--
% get pointers to our special files
%--

lines = file_readlines(in);

%--
% set up tokens and associated values
%--

envars = { ...
	'$LINK_LIB$',	cell_cat(libs, ' '); ...
	'$LINKFLAGS$',	wrapstr(wrapflag); ...
	'$PERLPATH$',	fix_path(perlpath, '"'); ...
	'$MATLAB$',		fix_path(matlabroot); ...
	'$MRMEXPATH$',	[this_path, 'Magic']; ...
	'$MINGWPATH$',  [mingw_root, filesep, 'bin']; ...
	'$LINKER$',		[perlpath ' ' fix_path(linker, '"')]; ...
	'$MEXEXT$',		mexext ...
};

%--
% perform token replacement
%--

[lix, vx] = cell_find(lines, envars(:, 1), @strfind);

for ix = 1:length(lix)
	lines(lix(ix)) = strrep(lines(lix(ix)), envars(vx(ix), 1), envars(vx(ix), 2));
end

%--
% output file
%--

file_writelines(out, lines);
	
%--------------------------------------
% PERLPATH
%--------------------------------------

function p = perlpath

p = fix_path(fullfile(matlabroot, 'sys\perl\win32\bin\perl'), '"');


%--------------------------------------
% CELL_CAT
%--------------------------------------

function s = cell_cat(c, j)

s = '';

for ix = 1:length(c)
	s = [s, c{ix}, j];
end


%--------------------------------------
% WRAPSTR
%--------------------------------------

function s = wrapstr(flag)

if flag
	s = '-Wl,--wrap,malloc,--wrap,calloc,--wrap,free,--wrap,realloc';
else
	s = '';
end


%--------------------------------------
% THIS_PATH
%--------------------------------------

function s = this_path()

s = fix_path(fileparts(mfilename('fullpath')));


%--------------------------------------
% LINKER
%--------------------------------------

function s = linker()

s = [this_path, filesep, 'Magic', filesep, 'linkmex.pl'];


%--------------------------------------
% FIX_PATH
%--------------------------------------

function p = fix_path(p, q)


if (nargin < 2)
	q = 0;
end

if (iscell(p))
	
	for ix = 1:length(p)
		p{ix} = fix_path(p{ix}, q);
	end
	
	return;
	
end

if (q)
	
	if (p(1) ~= '"')
		p = ['"', p, '"'];
	end	
	
	return
	
end

if (p(1) == '"')
	p = p(2:end-1);
end

if (p(end) ~= filesep)
	p(end + 1) = filesep;
end



%--------------------------------
% CELL_FIND
%--------------------------------

function [ixlist, jxlist] = cell_find(a, b, compare_handle)

ixlist = []; jxlist = [];

for ix = 1:length(a)
	
	for jx = 1:length(b)
		
		if any(compare_handle(a{ix}, b{jx}))
			
			ixlist(end + 1) = ix; jxlist(end + 1) = jx;
			
		end
		
	end
	
end
