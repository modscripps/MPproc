function g_prvw_png(filename)
%G_PRVW(FILENAME) Open filename in OS X Preview 
%   input filename as a string

n = length(filename);
if n<5
    filename = [filename,'.png'];
end

if strcmp(filename(end-3:end),'.png')
system(['open -a "Preview" ',filename]);
elseif ~strcmp(filename(end-3),'.')
system(['open -a "Preview" ',filename,'.png']);
end
end

