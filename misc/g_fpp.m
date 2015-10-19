function g_fpp(x,y)

% g_fpp(x,y) Short form of set(gcf,'paperposition',[0 0 x y])
%     g_fpp(X,Y)
%
%     For Matlab 2014b and upwards, this will also set the papersize.
%
%     INPUT   x - width
%             y - height
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 04/16/2015


%% Find Matlab version number
ver = g_matlab_version;


if ver<8.4
set(gcf,'paperunits','inches')
set(gcf,'paperposition',[0 0 x y])
else
set(gcf,'paperunits','inches')
set(gcf,'paperposition',[0 0 x y])
set(gcf,'papersize',[x y])
end
