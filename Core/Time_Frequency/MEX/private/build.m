

clear fast_specgram_mex_double;

clear fast_specgram_mex_single;

%--
% build double precision DLL
%--

build_mex( ...
    '../fast_specgram_mex.c', ...
    '-output', 'fast_specgram_mex_double', ...
    '-lfftw3' ...
);

%--
% build single precision DLL
%--

build_mex( ...
    '../fast_specgram_mex.c', ...
    '-DFLOAT', ...
    '-output', 'fast_specgram_mex_single', ...
    '-lfftw3f' ...
);

movefile(['*.', mexext], '../../private');
