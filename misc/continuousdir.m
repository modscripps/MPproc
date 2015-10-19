function dir = continuousdir(dir)

%  routine to make dir continuous rather than wrapping at 2pi
%  assumes dir is in radians

diffdir = diff(dir);
i = find(abs(diffdir)>pi);

for j = 1:length(i)

if diffdir(i(j)) < 0
  ddir = 2*pi;
else
  ddir=-2*pi;
end

dir(i(j)+1:length(dir)) = dir(i(j)+1:length(dir)) + ddir;

end
