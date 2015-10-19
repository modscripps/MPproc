function g_png(filename,CurrentMFilename,CurrentDirectory)

% G_PNG Print figure to png file
%   g_png(S) Print figure to png file with filename S.
%
%   INPUT   s - Filename (string) without file extension
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Last modification: 04/23/2015
%
%   NOTE:
%   Needs ImageMagick functions!

% %% Find Matlab version number
% ver = g_matlab_version;
% 
% %% Print figure
% if ver<8.4
% print('-depsc2',[filename,'.eps'])
% % fixPSlinestyle([filename,'.eps'],[filename,'.eps']);
% system(['pstopdf ',filename,'.eps']);
% system(['rm ',filename,'.eps']);
% else
% 
% 
% % Added for Matlab2014b: crop the pdf
% % print('-dpdf',[filename,'.pdf'],'-painters')
% print('-dpdf',[filename,'.pdf'],'-painters')
% fprintf('need to rund pdfcrop from MATLAB 2014b upwards...\n');
% system(['pdfcrop --margin 10 ',filename,'.pdf ',filename,'.pdf ']);
% end


print('-dpng','-r300',[filename,'.png'])
cmd = ['convert ',filename,'.png -trim -bordercolor White -border 30x30 ',filename,'.png'];
system(cmd)

%% Output text for inclusion of the file into latex document

% Test whether gpng was called from the command line
CallFromCommandLine =...
  strcmp('/Users/gunnar/Projects/matlab/toolboxes/gunnar/gpng.m',...
         CurrentMFilename);


% Test whether filename was given relative to current directory
fs = strfind(filename,filesep);
if isempty(fs) || fs(1)>1
  FileNameGivenRelativeToCurrentDirectory = 1;
else
  
  dd = dir(CurrentDirectory);
  
  if strcmp(CurrentMFilename(1),filesep)
  FileNameFirstPath = CurrentMFilename(2:fs(2)-1);
  else
  FileNameFirstPath = CurrentMFilename(1:fs(1)-1);
  end
  
  dda = 0;
  for i = 1:length(dd)
    if dd(i).isdir
      if strcmp(dd(i).name,FileNameFirstPath)
        dda = 1;
      end
    end
  end
  
  if dda==1
    FileNameGivenRelativeToCurrentDirectory = 1;
  elseif dda == 0
    FileNameGivenRelativeToCurrentDirectory = 0;
  end
end


% Figure and path name
if FileNameGivenRelativeToCurrentDirectory
CurrentPath = pwd;
if ~strcmp(CurrentPath(end),filesep)
  CurrentPath = [CurrentPath,filesep];
end
% Add full path if not already given in the filename
FullFigureName = [CurrentPath,filename,'.png'];
else
FullFigureName = [filename,'.png'];
end

dispstr = sprintf('\n');
disp(dispstr)
disp('\begin{figure}[htbp]')


disp('\centering')

% File
dispstr = ['\includegraphics[width=1.0\textwidth]{',FullFigureName,'}'];
disp(dispstr)

xCMF = strfind(CurrentMFilename,filesep);
xCMF = xCMF(end);
cm = CurrentMFilename(xCMF+1:end);
cm = strrep(cm,'_','\_');

% Pull caption from tag if not empty
cap = get(gcf,'tag');
if isempty(cap)
  cap = ' ';
end

if CallFromCommandLine
dispstr = ['\caption{',cap,...
           ' \newline {\footnotesize{Created from command line.',...
           '} ',...
           datestr(now,'mm/dd/yy'),...
           '}}}'];  
else
dispstr = ['\caption{',cap,...
           ' \newline {\footnotesize{Created with \clink{file://',...
           CurrentMFilename,...
           '}{',...
           cm,...
           '} ',...
           datestr(now,'mm/dd/yy'),...
           '}}}'];
end


disp(dispstr)
% disp('\caption{ }')

% Label - This filename excluding any folder.
x = strfind(filename,filesep);
if ~isempty(x)
  x = x(end);
  filename = filename(x+1:end);
end
dispstr = ['\label{fig:',filename,'}'];
disp(dispstr)

disp('\end{figure}')

% dispstr = ['% Created with ',...
%            CurrentMFilename,...
%            ' ',...
%            datestr(now,'mm/dd/yy HH:MM')];
% disp(dispstr)

dispstr = sprintf('\n');
disp(dispstr)


end

