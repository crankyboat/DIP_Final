G = readraw('sample1.raw');
%G = [250,251,252; 253,254,255; 0,1,2];

G2 = padarray(G,[1,1]);
[n,m] = size(G);

OO = zeros(512,512);
O  = zeros(1024,512);
O2 = zeros(1024,512);
MASK = [0,0,0; 0,0,7; 3,5,1]/16;



for i=2:n-1
	for j=2:m-1
		if G2(i,j) > 127
			OO(i-1,j-1) = 255;		
			if rand>0.5
				O(2*(i-1),j-1)   = 255;
				O(2*(i-1)+1,j-1) = 0;
				
				O2(2*(i-1),j-1)   = 0;
				O2(2*(i-1)+1,j-1) = 255;
			
			else
				O(2*(i-1),j-1)   = 0;
				O(2*(i-1)+1,j-1) = 255;
				
				O2(2*(i-1),j-1)   = 255;
				O2(2*(i-1)+1,j-1) = 0;
			end
		else
			
			OO(i-1,j-1) = 0;		
			if rand<0.25
				O(2*(i-1),j-1)   = 255;
				O(2*(i-1)+1,j-1) = 0;
				O2(2*(i-1),j-1)   = 0;
				O2(2*(i-1)+1,j-1) = 0;
			elseif rand<0.5		
				O(2*(i-1),j-1)   = 0;
				O(2*(i-1)+1,j-1) = 255;
				O2(2*(i-1),j-1)   = 0;
				O2(2*(i-1)+1,j-1) = 0;
			elseif rand<0.75
				O(2*(i-1),j-1)   = 0;
				O(2*(i-1)+1,j-1) = 0;
				O2(2*(i-1),j-1)   = 255;
				O2(2*(i-1)+1,j-1) = 0;
			else
				O(2*(i-1),j-1)   = 0;
				O(2*(i-1)+1,j-1) = 0;
				O2(2*(i-1),j-1)   = 0;
				O2(2*(i-1)+1,j-1) = 255;
			end
			
		end
		
		E = G2(i,j)-OO(i-1,j-1);
		G2(i-1:i+1,j-1:j+1) = G2(i-1:i+1,j-1:j+1) + E*MASK;
	end
end

for i=1:m-2
	for j=1:n-2
		if O(i,j)>255
			O(i,j)=255;
		end
		if O(i,j)<0
			O(i,j)=0;
		end
		if O2(i,j)>255
			O2(i,j)=255;
		end
		if O2(i,j)<0
			O2(i,j)=0;
		end
		
	end
end


figure
imshow(G2,[0,255]);
figure
imshow(O ,[0 255]);
figure
imshow(O2,[0 255]);
writeraw(O,'output.raw');
writeraw(O2,'output2.raw');

D = zeros(1024,512);
for i=1:1024
	for j=1:512
		D(i,j) = O(i,j)+O2(i,j)/2;
	end
end

figure
imshow(D,[0 255]);

writeraw(D,'decode.raw');



vid_name = 'vid.avi';
vid_fps = 20;
vid_quality = 100; %100 is max

vid = avifile(vid_name, 'fps', vid_fps, 'quality', vid_quality);
fig = figure;
for i=1:60
	if mod(i,4)==0
		imshow(O);
	else
		imshow(O2);
	end	
	vid = addframe(vid, getframe(fig));
	drawnow
end
vid = close(vid);
