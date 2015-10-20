function arrc=CenteredConv(arr,fx,fy)
%function arrc=CenteredConv(arr,fx,fy)
%Perform a (fx by fy) bin convolution on array arr.  The result is not shifxed
%relative to the original.
%Mod 3/99: you can pass in any filter you want
if (nargin == 2)
fil=fx
[fy,fx]=size(fil)
else
fil=1/fy/fx*ones(fy,fx);
end
[m,n]=size(arr);
arrc=zeros(m,n);
arrct=conv2(arr,fil);

%If both are odd then we just shifx.
if rem(fy,2)==1 & rem(fx,2)==1
	arrc=arrct(1+(fy-1)/2:m+(fy-1)/2,1+(fx-1)/2:n+(fx-1)/2);
	
%if fy is even but fx is odd then just shifx in x, interpolate half a bin in y.
elseif rem(fy,2)==0 & rem(fx,2)==1
	arrc(2:m,:)=1/2*(arrct(1+fy/2:m+fy/2-1,1+(fx-1)/2:n+(fx-1)/2) + arrct(1+fy/2 + 1:m+fy/2 ,1+(fx-1)/2:n+(fx-1)/2));

%if  fx is even but fy is odd then just shifx in y, interpolate half a bin in x.
elseif rem(fy,2)==1 & rem(fx,2)==0
	arrc(:,2:n)=1/2*(arrct(1+(fy-1)/2:m+(fy-1)/2 ,1+fx/2:n+fx/2-1) + arrct(1+(fy-1)/2:m+(fy-1)/2 ,1+fx/2 + 1:n+fx/2));

%if both are even then interpolate for both.
elseif rem(fy,2)==0 & rem(fx,2)==0
	arrc(2:m,2:n)=1/2*(arrct(1+fy/2:m+fy/2-1,1+fx/2:n+fx/2-1) + arrct(1+fy/2 + 1:m+fy/2 ,1+fx/2 + 1:n+fx/2));

end


clear arrct
