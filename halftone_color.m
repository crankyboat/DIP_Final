function halftone_color(filename, do_redist)

	warning('off','all');
	
	close all;
	max_inten = 255;
    f_num = 6;
	
	% load image and threshold
	I = imread(filename);
	[maxJ, maxK, ~] = size(I)
	figure('Name', 'orig I'), imshow(I);
	% pause;
	
	% split into RGB
	z = zeros(maxJ, maxK);
	thres_I = zeros(maxJ, maxK, 3);
	for f=1:3
		thres_I(:, :, f) = ( I(:, :, f) >= max_inten/2 ) * max_inten;
	end
	% print
	R = thres_I(:, :, 1);
	figure('Name', 'R'), imshow(cat(3, R, z, z));
	G = thres_I(:, :, 2);
	figure('Name', 'G'), imshow(cat(3, z, G, z));
	B = thres_I(:, :, 3);
	figure('Name', 'B'), imshow(cat(3, z, z, B));
	figure('Name', 'RGB'), imshow(cat(3, R, G, B));
	% pause;
	% close all;
	masks = [];
    masks(:,:,1) = [1 1; 0 0];
    masks(:,:,2) = [1 0; 1 0];
    masks(:,:,3) = [0 0; 1 1];
    masks(:,:,4) = [0 1; 0 1];
    masks(:,:,5) = [1 0; 0 1];
    masks(:,:,6) = [0 1; 1 0];

	% split into r, g, b, k shares
    for f=1:f_num
        subI = zeros(maxJ*2, maxK*2, 4);
        for j=1:maxJ
            for k=1:maxK

                if mod(j, 100)==0 && mod(k, 100)==0
                    j, k
                end

                % generate mask
                %mask = masks(:,:,f);
                mask = masks(:,:,randi([1,f_num]));

                % process k element
                subI((2*j-1):2*j, (2*k-1):2*k, 4) = mask;

                % process r, g, b elements
                for channel=1:3
                    if thres_I(j, k, channel)	% color will be revealed where mask is 1
                        subI((2*j-1):2*j, (2*k-1):2*k, channel) = mask * max_inten;
                    else				% color will be masked where mask is 0
                        subI((2*j-1):2*j, (2*k-1):2*k, channel) = ~mask * max_inten;
                    end
                end

            end
        end

        z = zeros(maxJ*2, maxK*2);
        zz = zeros(maxJ*2);
        R = subI(:, :, 1);
        %figure('Name', 'R'), imshow(cat(3, R, z, z));
        G = subI(:, :, 2);
        %figure('Name', 'G'), imshow(cat(3, z, G, z));
        B = subI(:, :, 3);
        %figure('Name', 'B'), imshow(cat(3, z, z, B));
        K = subI(:, :, 4);
        %figure('Name', 'K'), imshow(cat(3, R, G, B));
       
        %export_fig result.jpg
        %saveas(cat(3,R,G,B), 'result.jpg', 'jpg');
        R_masked = R;
        G_masked = G;
        B_masked = B;
        nR = numel(nonzeros(K==0));
        R_masked(K==0) = (rand(nR,1) < 0.5)*max_inten;
        G_masked(K==0) = (rand(nR,1) < 0.5)*max_inten;
        B_masked(K==0) = (rand(nR,1) < 0.5)*max_inten;
        %figure('Name', 'stacked'), imshow(cat(3, R_masked, G_masked, B_masked));
        imwrite(cat(3,R_masked,G_masked,B_masked), strcat('input/', num2str(f), '.bmp'), 'bmp');
        imwrite(cat(3,R,G,B), strcat('input/', num2str(f), '_noise.bmp'), 'bmp');
    end
	%pause;
	
	% randomly redistribute colors
	if do_redist
		redist_num = 10;
		redist = zeros(maxJ*2, maxK*2, 3, redist_num);
		for r=1:redist_num
			rand1 = rand(maxJ*2, maxK*2) < 0.15;
			rand2 = rand(maxJ*2, maxK*2) < 0.15;
			rand3 = rand(maxJ*2, maxK*2) < 0.15;
			figure('Name', 'redist'), imshow(cat(3, R.*rand1, G.*rand2, B.*rand3));
			redist(:, :, :, r) = cat(3, R.*rand1, G.*rand2, B.*rand3);
			% pause;
		end
	end
	pause;
	close all;
	% pause;
	
    % output images
    % outputPath = 'input/';
    % for i=1:f_num
        % imwrite(subI(:,:,i), strcat(outputPath, num2str(i),'.jpg'), 'jpg', 'Quality', 100);
    % end
	
	% I_out = subI(:,:,1);
	% for i=1:4 %f_num
		% figure('Name', 'subI'), imshow(subI(:,:,i));
		% I_out = I_out & subI(:,:,i);
	% end
	% figure('Name', 'and'), imshow(I_out);
	% pause;
	% close all;
	
	% simu(subI);
	% pause;
	
	% vid output method 1
% 	vid_name = 'color_vid.avi';
% 	vid_fps = 20;
% 	vid_quality = 100; %100 is max
% 	% create vid
% 	vid = avifile(vid_name, 'fps', vid_fps, 'quality', vid_quality);
% 	% iterations
% 	fig = figure;
% 	for i=1:80
% 		
% 		if do_redist
% 			imshow(redist(:, :, :, mod(i, redist_num)+1));
% 		else
% 			switch mod(i,4)
% 				case 0
% 					imshow(cat(3, R, z, z));
% 				case 1
% 					imshow(cat(3, z, G, z));
% 				case 2
% 					imshow(cat(3, z, z, B));
% 				case 3
% 					imshow(K);
% 			end
% 		end
% 		
% 		% capture frame
% 		vid = addframe(vid, getframe(fig));
% 		drawnow
% 	end
% 	% close vid
% 	vid = close(vid);
% 	
	% % vid output method 2
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
