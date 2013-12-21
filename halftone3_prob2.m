function halftone3_prob2(filename)
    filename = 'sample1.raw';
	warning('off','all');

	close all;
	max_inten = 255;
	lev = 2;
	f_num = 4;
	
	% load image and threshold
	I = readraw(filename);
	I = gray_level(I, max_inten, lev);
	figure('Name', 'orig I'), imshow(I, [0 1]);
	% pause;
	
	[maxJ, maxK] = size(I);
	
	% split into f_num images
	subI = zeros(maxJ, maxK, f_num);
	
	for j=1:maxJ
		for k=1:2:maxK
			r = rand;
			if I(j, k)==1 & I(j,k+1)==1
				if r < 0.5
					subI(j, k, :) = 1;
					subI(j, k+1, :) = 0;
				else
					subI(j, k, :) = 0;
					subI(j, k+1, :) = 1;
				end
				%{
			elseif I(j, k)==1/lev*2
				if r < 0.5
					for f=1:f_num
						r2 = rand;
						if r2 < 1/f_num
							subI(j, 2*k-1, f) = 1;
							subI(j, 2*k, f) = 0;
						else
							subI(j, 2*k-1, f) = 0;
							subI(j, 2*k, f) = 1;
						end
					end
				else
					for f=1:f_num
						r2 = rand;
						if r2 < 1/f_num
							subI(j, 2*k-1, f) = 0;
							subI(j, 2*k, f) = 1;
						else
							subI(j, 2*k-1, f) = 1;
							subI(j, 2*k, f) = 0;
						end
					end
				end
				%}
				% one white, one black
			elseif I(j, k) + I(j, k+1) == 1
                for f=1:f_num
                    r2 = rand;
                    if r2 < 0.5
                        subI(j, k, f) = 1;
                        subI(j, k+1, f) = 0;
                    else
                        subI(j, k, f) = 0;
                        subI(j, k+1, f) = 1;
                    end
                end
			else
			%elseif I(j, k)==1/lev*1 & I(j, k+1) ==1/lev*1
				if r < 0.5
					subI(j, k, 1:2) = 1;
					subI(j, k+1, 1:2) = 0;
					subI(j, k, 3:4) = 0;
					subI(j, k+1, 3:4) = 1;
				else
					subI(j, k, 1:2) = 0;
					subI(j, k+1, 1:2) = 1;
					subI(j, k, 3:4) = 1;
					subI(j, k+1, 3:4) = 0;
				end
			end
		end
    end
    
    % output images
    outputPath = 'input/';
    for i=1:f_num
        imwrite(subI(:,:,i), strcat(outputPath, num2str(i),'.jpg'), 'jpg', 'Quality', 100);
    end
	
	I_out = subI(:,:,1);
	for i=1:f_num
		figure('Name', 'subI'), imshow(subI(:,:,i));
		I_out = I_out & subI(:,:,i);
	end
	figure('Name', 'and'), imshow(I_out);
	pause;
	close all;
	
	% simu(subI);
	% pause;
	
	% vid_name = 'vid.avi';
	% vid_fps = 20;
	% vid_quality = 100; %100 is max
	% % create vid
	% vid = avifile(vid_name, 'fps', vid_fps, 'quality', vid_quality);
	% % iterations
	% fig = figure;
	% for i=1:80
		% switch mod(i,8)
			% case 0
				% imshow(subI(:,:,1));
			% case 2
				% imshow(subI(:,:,2));
			% case 4
				% imshow(subI(:,:,3));
			% case 6
				% imshow(subI(:,:,4));
			% otherwise
				% white_noise = rand(maxJ, maxK*2);
				% white_noise(white_noise<0.5) = 0;
				% white_noise(white_noise>=0.5) = 1;
				% imshow(white_noise);
		% end
		
		% % capture frame
		% vid = addframe(vid, getframe(fig));
		% drawnow
	% end
	% % close vid
	% vid = close(vid);
	
	% clear M;
	% for f=1:f_num
		% imshow(subI(:,:,f));
		% M(2*f-1) = getframe;
		% white_noise = rand(maxJ, maxK*2);
		% white_noise(white_noise<0.5) = 0;
		% white_noise(white_noise>=0.5) = 1;
		% imshow(white_noise);
		% M(2*f) = getframe;
	% end
	% movie(M, 100, 20);
	% pause;
	
	close all;
	warning('on', 'all');
	
end