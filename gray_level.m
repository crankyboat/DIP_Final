function G_out = gray_level(G, max_inten, levels)

	[maxJ, maxK] = size(G);
	G_out = zeros(maxJ, maxK);
	
	for i=1:levels
		prev_inten = max_inten/levels*(i-1);
		inten = max_inten/levels*i;
		G_out(prev_inten<=G & G<inten) = i/levels;
	end

end