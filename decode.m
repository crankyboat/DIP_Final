G1 = readraw('output.raw');
G2 = readraw('output2.raw');

[n,m] = size(G1);
O = zeros(n,m);

for i=1:n
	for j=1:m
		if G1(i,j)+G2(i,j) == 510
			O(i,j) = 255;
		end
	end
end

writeraw(O,'out.raw');