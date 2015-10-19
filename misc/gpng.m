function gpng(filename,varargin)

% gpng Print figure to png file and view it in Apple's Preview
%     gpng(FILENAME) Print figure to png file with filename FILENAME.
%     Then open the file in Apple's Preview pdf viewer.
%
%     INPUT   filename - Filename (string) without file extension
%             optional second input: 0 for no preview of the png
%
%     Gunnar Voet
%     gvoet@ucsd.edu
%
%     Last modification: 04/23/2015

% get the name of the calling function
[ST,I] = dbstack('-completenames');
CurrentMFileName = ST(end).file;

CurrentDirectory = pwd;

% print to png, pass the name of the calling function for latex code
g_png(filename,CurrentMFileName,CurrentDirectory)

if ~isempty(varargin)
if varargin{1}==1
% open pdf with Apple Preview
g_prvw_png(filename)
end
else
g_prvw_png(filename)
end

