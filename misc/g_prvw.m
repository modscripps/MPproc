function g_prvw(filename)

% G_PRVW(FILENAME) Open file in OS X Preview 
%   input filename as a string

n = length(filename);
if n<5
  filename = [filename,'.pdf'];
end

if strcmp(filename(end-3:end),'.pdf')
system(['open -a "Preview" ',filename]);
elseif strcmp(filename(end-3:end),'.eps')
system(['open -a "Preview" ',filename]);
elseif ~strcmp(filename(end-3),'.')
system(['open -a "Preview" ',filename,'.pdf']);
end
end

