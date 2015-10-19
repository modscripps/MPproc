function MP_acm_create_spintest_file(CalFile)

% MP_ACM_CREATE_SPINTEST_FILE(CalFile)
%
%   Create spintest.txt from FSI ACM or Nortek Aquadop cal file. The file
%   will be saved to the current directory. Note that for the Aquadopp file
%   you have to manually erase everyting but the column with headings.
%
%   INPUT   CalFile - path to cal file
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 09/09/2015
%   Updated: 10/07/2015 to also work for aquadopp

% check for existing spintest.txt file, ask if user wants to overwrite this
if exist('spintest.txt','file')
  fprintf('\n\n WARNING: spintest.txt already exists in this directory.\n');
  x = input(' Do you want to overwrite the existing file? y/n [n]: ','s');
  if isempty(x)
    x = 'n';
  elseif strcmp(x,'y')
    delete('spintest.txt')
  end
else x = 'y';
end

if strcmp(x,'y')
  A = load(CalFile);
  
  [m,n] = size(A);
  
  if n>1 % FSI ACM
  figure
  plot(A(:,3))
  hold on
  plot(A(:,4))
  title('please select 8 points for cal file')
  a = nan(8,1);
  for i = 1:8
  [a(i),~] = ginput(1);
  plot(round(a(i)),A(round(a(i)),3),'marker','.','markersize',20,'color','k')
  plot(round(a(i)),A(round(a(i)),4),'marker','.','markersize',20,'color','k')
  end
  a = round(a);
%   plot(a,A(a,3),'marker','.','markersize',20)
  B = A(a,:);
  save('spintest.txt','B','-ascii')
  
  elseif n==1 % AQDP
  figure
  plot(A)
  hold on
  title('please select 8 points for cal file')
  a = nan(8,1);
  for i = 1:8
  [a(i),~] = ginput(1);
  plot(round(a(i)),A(round(a(i))),'marker','.','markersize',20,'color','k')
  end
  a = round(a);
  B = A(a);
  save('spintest_aqdp.txt','B','-ascii')
  end 

  fprintf('\n Saved spintest.txt.\n');
end