function varargout = set_ptr(fig,curs,fname)

%SETPTR Set figure pointer.
%   SETPTR(FIG,CURSOR_NAME) sets the cursor of the figure w/ handle FIG 
%   according to the cursor_name:
%      'hand'    - open hand for panning indication
%      'hand1'   - open hand with a 1 on the back
%      'hand2'   - open hand with a 2 on the back
%      'closedhand' - closed hand for panning while mouse is down
%      'glass'   - magnifying glass
%      'lrdrag'  - left/right drag cursor
%      'ldrag'   - left drag cursor
%      'rdrag'   - right drag cursor
%      'uddrag'  - up/down drag cursor
%      'udrag'   - up drag cursor
%      'ddrag'   - down drag cursor
%      'add'     - arrow with + sign
%      'addzero' - arrow with 'o'
%      'addpole' - arrow with 'x'
%      'eraser'  - eraser
%      'help'    - arrow with question mark ?
%      [ crosshair | fullcrosshair | {arrow} | ibeam | watch | topl | topr ...
%      | botl | botr | left | top | right | bottom | circle | cross | fleur ]
%           - standard figure cursors
%
%   SetData=set_ptr(CURSOR_NAME) returns a cell array containing 
%   the Property Value pairs which correctly set the pointer to 
%   the CURSOR_NAME specified. For example:
%       SetData=set_ptr('arrow');set(FIG,SetData{:})

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

%   Author: T. Krauss, 10/95
%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 132 $  $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $ 

%--
% now for custom cursors
%--

stringflag = 0;

if (isstr(fig))
	
	if (nargin == 2)
		fname = curs;
	end
	
	curs = fig;
	fig = [];
	stringflag = 1;
	
end

mac_curs = 1;

switch (curs)
	
	case ('hand')
		
		d = ['01801A702648264A124D12496809980188024002200220041004080804080408'...
			'01801BF03FF83FFA1FFF1FFF6FFFFFFFFFFE7FFE3FFE3FFC1FFC0FF807F807F8'...
			'00090008']';
		
	case ('closedhand')
		
		d = ['00000000000000000DB0124C100A080218022002200220041004080804080408'...
			'00000000000000000DB01FFC1FFE0FFE1FFE3FFE3FFE3FFC1FFC0FF807F807F8'...
			'00090008']';
		
	case ('hand1')
		
		d = ['01801A702648264A124D1249680998818982408220822084108409C804080408'...
			'01801BF03FF83FFA1FFF1FFF6FFFFFFFFFFE7FFE3FFE3FFC1FFC0FF807F807F8'...
			'00090008']';
		
	case ('hand2')
		
		d = ['01801A702648264A124D1249680998C18922402220422084110409E804080408'...
			'01801BF03FF83FFA1FFF1FFF6FFFFFFFFFFE7FFE3FFE3FFC1FFC0FF807F807F8'...
			'00090008']';
		
	case ('glass')
		
		d = ['0F0030C04020402080108010801080104020402030F00F38001C000E00070002'...
			'0F0035C06AA05560AAB0D550AAB0D5506AA055703AF80F7C003E001F000F0007'...
			'00060006']';
		
	case ('lrdrag')
		
		d = ['00000280028002800AA01AB03EF87EFC3EF81AB00AA002800280028000000000'...
			'07C007C007C00FE01FF03FF87FFCFFFE7FFC3FF81FF00FE007C007C007C00000'...
			'00070007']';
		
	case ('ldrag')
		
		d = ['00000200020002000A001A003E007E003E001A000A0002000200020000000000'...
			'0700070007000F001F003F007F00FF007F003F001F000F000700070007000000'...
			'00070007']';
		
	case ('rdrag')
		
		d = ['000000800080008000A000B000F800FC00F800B000A000800080008000000000'...
			'00C000C000C000E000F000F800FC00FE00FC00F800F000E000C000C000C00000'...
			'00070007']';
		
	case ('uddrag')
		
		d = ['000000000100038007C00FE003807FFC00007FFC03800FE007C0038001000000'...
			'00000100038007C00FE01FF0FFFEFFFEFFFEFFFEFFFE1FF00FE007C003800100'...
			'00080007']';
		
	case ('udrag')
		
		d = ['000000000100038007C00FE003807FFC00000000000000000000000000000000'...
			'00000100038007C00FE01FF0FFFEFFFEFFFE0000000000000000000000000000' ...
			'00080007']';
		
	case ('ddrag')
		
		d = ['0000000000000000000000000000000000007FFC03800FE007C0038001000000'...
			'00000000000000000000000000000000FFFEFFFEFFFE1FF00FE007C003800100'...
			'00080007']';
		
	case ('add')
		
		cdata = [...
			2   2 NaN NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN
			2   1   2 NaN NaN NaN NaN NaN NaN   2   1   2 NaN NaN NaN NaN
			2   1   1   2 NaN NaN NaN NaN   2   2   1   2   2 NaN NaN NaN
			2   1   1   1   2 NaN NaN   2   1   1   1   1   1   2 NaN NaN
			2   1   1   1   1   2 NaN NaN   2   2   1   2   2 NaN NaN NaN
			2   1   1   1   1   1   2 NaN NaN   2   1   2 NaN NaN NaN NaN
			2   1   1   1   1   1   1   2 NaN NaN   2 NaN NaN NaN NaN NaN
			2   1   1   1   1   1   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			2   1   1   1   1   1   1   1   1   2 NaN NaN NaN NaN NaN NaN
			2   1   1   1   1   1   2   2   2   2   2 NaN NaN NaN NaN NaN
			2   1   1   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN NaN
			2   1   2 NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN
			2   2 NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN
			2 NaN NaN NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN NaN   2   2   2 NaN NaN NaN NaN NaN NaN NaN
		];
		
		hotspot = [1 1];
		mac_curs = 0;
		
	case ('addpole')
		
		cdata = [...
			2   2 NaN NaN NaN NaN NaN   2   2   2 NaN NaN   2   2 NaN NaN
			2   1   2 NaN NaN NaN NaN   2   1   2 NaN   2   1   2 NaN NaN
			2   1   1   2 NaN NaN NaN NaN   2   1   2   1   2   2 NaN NaN
			2   1   1   1   2 NaN NaN NaN NaN   2   1   2 NaN NaN NaN NaN
			2   1   1   1   1   2 NaN NaN   2   1   2   1   2   2 NaN NaN
			2   1   1   1   1   1   2   2   1   2 NaN   2   1   2 NaN NaN
			2   1   1   1   1   1   1   2   2 NaN NaN NaN   2   2 NaN NaN
			2   1   1   1   1   1   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			2   1   1   1   1   1   1   1   1   2 NaN NaN NaN NaN NaN NaN
			2   1   1   1   1   1   2   2   2   2   2 NaN NaN NaN NaN NaN
			2   1   1   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN NaN
			2   1   2 NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN
			2   2 NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN
			2 NaN NaN NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN NaN   2   2   2 NaN NaN NaN NaN NaN NaN NaN
		];
		
		hotspot = [1 1];
		mac_curs = 0;
		
	case ('addzero')
		
		cdata = [...
			2   2 NaN NaN NaN NaN NaN NaN   2   2   2   2   2 NaN NaN NaN
			2   1   2 NaN NaN NaN NaN   2   2   1   1   1   2   2 NaN NaN
			2   1   1   2 NaN NaN NaN   2   1   2   2   2   1   2 NaN NaN
			2   1   1   1   2 NaN NaN   2   1   2 NaN   2   1   2 NaN NaN
			2   1   1   1   1   2 NaN   2   1   2   2   2   1   2 NaN NaN
			2   1   1   1   1   1   2   2   2   1   1   1   2   2 NaN NaN
			2   1   1   1   1   1   1   2   2   2   2   2   2 NaN NaN NaN
			2   1   1   1   1   1   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			2   1   1   1   1   1   1   1   1   2 NaN NaN NaN NaN NaN NaN
			2   1   1   1   1   1   2   2   2   2   2 NaN NaN NaN NaN NaN
			2   1   1   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN NaN
			2   1   2 NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN
			2   2 NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN NaN
			2 NaN NaN NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN   2   1   1   2 NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN NaN   2   2   2 NaN NaN NaN NaN NaN NaN NaN
		];
		
		hotspot = [1 1];
		mac_curs = 0;
		
	case ('eraser')
		
		cdata = [...  
			NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
			1   1   1   1   1   1   1 NaN NaN NaN NaN NaN NaN NaN NaN NaN
			1   1   2   2   2   2   2   1 NaN NaN NaN NaN NaN NaN NaN NaN
			1   2   1   2   2   2   2   2   1 NaN NaN NaN NaN NaN NaN NaN
			1   2   2   1   2   2   2   2   2   1 NaN NaN NaN NaN NaN NaN
			NaN   1   2   2   1   2   2   2   2   2   1 NaN NaN NaN NaN NaN
			NaN NaN   1   2   2   1   2   2   2   2   2   1 NaN NaN NaN NaN
			NaN NaN NaN   1   2   2   1   2   2   2   2   2   1 NaN NaN NaN
			NaN NaN NaN NaN   1   2   2   1   2   2   2   2   2   1 NaN NaN
			NaN NaN NaN NaN NaN   1   2   2   1   2   2   2   2   2   1 NaN
			NaN NaN NaN NaN NaN NaN   1   2   2   1   1   1   1   1   1   1
			NaN NaN NaN NaN NaN NaN NaN   1   2   1   2   2   2   2   2   1
			NaN NaN NaN NaN NaN NaN NaN NaN   1   1   1   1   1   1   1   1
			NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
			NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
		];
		
		hotspot = [2 1];
		mac_curs = 0;
		
	case ('help')
		
		d = ['000040006000707C78FE7CC67EC67F0C7F987C306C3046000630033003000000'...
			'C000E000F07CF8FEFDFFFFFFFFEFFFDEFFFCFFF8FE78EF78CF7887F807F80380'...
			'00010001']';
		
	case ('file')
		
		f = fopen(fname);
		d = fread(f);
		
		% this is a clue to the format used for these pointers
		
		if (length(d)~=137)
			error('file is not the right length');
		end
		
		d(length(d)) = [];
		
	case ('forbidden')
		
		d = ['07C01FF03838703C607CC0E6C1C6C386C706CE067C0C781C38381FF007C00000'...
			'1FF03FF87FFCF87EF0FFE1FFE3EFE7CFEF8FFF0FFE1FFC3E7FFC3FF81FF00FE0'...
			'00070007']'; 
		
	otherwise
		
		Data = {'Pointer',curs};
		
		if (~stringflag)
			set(fig,Data{:});
		end
		
		if (nargout > 0)
			varargout{1} = Data;
		end
		
		return;
		
end

%--
% this part of the code reveals much about the meaning of the strings
%--

if mac_curs
	
	ind = find(d <= '9');
	d(ind) = d(ind) - '0';
	
	ind = find(d >= 'A');
	d(ind) = d(ind) - 'A' + 10;
	
	bitmap = d(1:64);
	bitmap = dec2bin(bitmap,4) - '0';
	bitmap = reshape(bitmap',16,16)';
	
	mask = d(65:128);
	mask = dec2bin(mask,4) - '0';
	mask = reshape(mask',16,16)';
	ind = find(mask == 0);
	mask(ind) = NaN;
	
	cdata = -(-mask + bitmap - 1);
	
	hotspot_h = d(129:132);
	hotspot_h = 16.^(3:-1:0) * hotspot_h;
	
	hotspot_v = d(133:136);
	hotspot_v = 16.^(3:-1:0) * hotspot_v;
	
	hotspot = [hotspot_h, hotspot_v] + 1;
	
end

Data = { ...
	'Pointer','custom', ...
	'PointerShapeCData',cdata, ...
	'PointerShapeHotSpot',hotspot ...
};

if ~stringflag
	set(fig,Data{:});
end

if (nargout > 0)
	varargout{1}=Data;
end
