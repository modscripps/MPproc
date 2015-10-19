function gpr(filename,varargin)

% gpr Print figure to pdf file and view it in Apple's Preview
%     gpr(FILENAME) Print figure to pdf file with filename FILENAME. This
%     is done via eps. Then open the file in Apple's Preview pdf viewer.
%
%     INPUT   filename - Filename (string) without file extension
%             optional second input: 0 for no preview of the pdf
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 04/03/2013

% get the name of the calling function
[ST,I] = dbstack('-completenames');
CurrentMFileName = ST(end).file;

CurrentDirectory = pwd;

% print to pdf, pass the name of the calling function for latex code
g_pdf(filename,CurrentMFileName,CurrentDirectory)

if ~isempty(varargin)
if varargin{1}==1
% open pdf with Apple Preview
g_prvw(filename)
end
else
g_prvw(filename)
end

