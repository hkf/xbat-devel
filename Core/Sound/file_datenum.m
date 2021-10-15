function out = file_datenum(file, pat)

if nargin < 2
	pat = 'yyyymmdd_HHMMSS';
end

out = [];

%--
% turn pattern into regular expression
%--

reg_pat = pat;

for dig = 'ymdHMS'
	reg_pat = strrep(reg_pat, dig, '\d');
end

reg_pat = strrep(reg_pat, '\\', '\');

%--
% find starting index of pattern in file name
%--

ix = regexp(file, reg_pat);

if isempty(ix)
	return;
end

%--
% get actual pattern string and use it with datenum
%--

str = file(ix:ix + numel(pat) - 1);

pat(regexp(pat, '[^ymdHMS]')) = '';

str(regexp(str, '\D')) = '';

out = datenum(str, pat);


