function new_im = LPFilter_Jiamin_Zhou(image,aperture)
%LPFILTER_JIAMIN_ZHOU Return filtered image passing only low frequencies in
%a specified aperture of k-space
%   
%   ===============
%   INPUT ARGUMENTS
%   ===============
%   
%   >> LPFilter_Jiamin_Zhou(image,aperture)
%   
%   image: the 2D matrix for the image to be filtered
%   aperture: the aperture in k-space to be captured
%
%   =======
%   OUTPUTS
%   =======
%
%   Outputs the 2D matrix of the newly filtered image
%
%   =================
%   EXAMPLES OF USAGE
%   =================
%   
%   >> im = LPFilter_Jiamin_Zhou('AxT1_brain.jpg',100);
%   This outputs the new filtered image matrix into im, and produces a
%   1x3 figure with the original image, the filtered k-space with an
%   aperture of 100x100 px, and the resulting filtered image (im), as seen
%   in 'LPFilter_Jiamin_Zhou_Ex100.png'
%   
%

im = rgb2gray(imread(image));
im_fft = fftshift(fft2(im));
% compute sizes
m = size(im_fft,1); % height
n = size(im_fft,2); % width
mask = zeros(size(im_fft));
filter_width_size = -aperture/2:aperture/2;
mask(m/2+filter_width_size,n/2+filter_width_size) = 1;
im_fft_2 = im_fft.*mask;
new_im = abs(ifft2(im_fft_2));

figure()
subplot(1,3,1)
imagesc(im); colormap gray
title('Original')
subplot(1,3,2)
imagesc(abs(im_fft_2),[0 10000]); colormap gray
title('Filtered k-space')
subplot(1,3,3)
imagesc(new_im); colormap gray
title('Filtered image')

end

