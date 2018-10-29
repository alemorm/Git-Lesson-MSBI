function LowPassFilter = LPfilter_Virginia_Hinostroza(picture, aperture)
% LPfilter_Virginia_Hinostroza is a function that takes a picture and
% applies a filter to the FFT2 of an image such that only low frequency
% signals are used to reconstruct the final image.  The function requires
% input of the picture to be used and the length of the desired
% aperture (i.e. the window).  NOTE: the aperture cannot exceed the
% shortest dimension of the original image.  

% The function will generate a 1 x 3 subplot of:
% 1) the original image, 
% 2) filtered image in k-space, and 
% 3) the filtered image in space (i.e. not in k-space).

% EXAMPLE: User wants to filter their picture, puppy.jpg, so that the final
% image is reconstructed solely from the low-frequency (i.e. intensity)
% pixels.  The user would then enter A =
% LPfilter_Virginia_Hinostroza('puppy.jpg', 100).  The function will return
% a 1 x 3 figure with a picture of the original, the filtered k-space, and the
% reconstructed image.

% Loading the image: THIS PART NOT WORKING
% inputpic = load(picture);
% image = inputpic

image = imread(picture);
image = rgb2gray(image);                       % will convert to grayscale in case image is in color

image_fft = fft2(image);                         % fourier transform of image
image_ffts = fftshift(image_fft);        % shift of fourier transform of image (k space) s. t. zero-frequency components are at the center

% Creation of los pass filter (lpf)
[num_rows, num_columns] = size(image);        % get size of image
lpf = zeros(num_rows, num_columns);               % initiating low pass filter of same size as image
stpt = [num_rows/2, num_columns/2];              % starting point = [rows/2, columns/2]
width = aperture/2;                                                       % width on each side of starting point

for i = (stpt(1) - width) : (stpt(1) + width)
    for j = (stpt(2) - width) : (stpt(2) + width)
        lpf (i , j) = 1;
    end
end

% Filtering the original image
 image_lpf = lpf .* image_fft;                             % filtered image in k space
 image_lpf_space = ifft2(image_lpf);             % filtered image in space


% Subplots of all images
figure()
subplot(1,3,1)
imagesc(image); colormap gray                         % original
title('Original')
subplot(1,3,2)
imagesc(abs(image_lpf), [1 1000])                  % filtered k-space image
title('Filtered image in k space')
subplot(1,3,3)
imagesc(abs(image_lpf_space))                       %filtered image in space
title('Reconstructed *filtered* image')
sgtitle('Effects of Low Frequency Filter')