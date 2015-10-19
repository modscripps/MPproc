%
%    hf = getallaxes
%
%    get all axes objects in the current figure
%
%    Ren-Chieh Lien              1995
%
   function hf = getallaxes

   hf = get(gcf,'children');
   k = 0;
   for i = 1:length(hf);
       if strcmp(get(hf(i),'type'),'axes');
	  k = k+1;
	  nhf(k) = hf(i);
       end
   end
   hf = nhf;

