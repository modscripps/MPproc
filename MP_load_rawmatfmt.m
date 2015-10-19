function [okay, Vab, Vcd, Vef, Vgh, aHx, aHy, aHz, aTx, aTy, ...
	cpres, ctemp, ccond, cdox, psdate, pstart, pedate, pstop, ...
	epres, ecurr, edpdt, evolt, engtime ] = MP_load_rawmatfmt(infile,npts)

% Routine to load a raw MVP data file and check that it is complete 

okay = 0;

if exist(infile,'file') == 2
  load(infile)
  okay = 1;
  
  if exist('cpres','var') == 1
    if(length(cpres) < npts);
      okay = 0;
    end
  else
    okay = 0;
  end
  
  if exist('Vab','var') == 1
    if(length(Vab) < npts);
      okay = 0;
    end
  else
    okay = 0;
  end
 
end

% Allow for old ccon instead of ccond - MHA.  Orig saved as *BK.m
if exist('ccon','var')==1
  ccond = ccon;
end

if ~exist('edpdt','var')
  edpdt = NaN*ecurr;
end

if ~exist('evolt','var')
  evolt = NaN*ecurr;
end

if ~exist('engtime','var')
  engtime = ecurr;
  engtime = 1:length(ecurr); %This matches what is in the Hawaii deployment - MHA
end

if ~exist('cdox','var')
  cdox = NaN;
end