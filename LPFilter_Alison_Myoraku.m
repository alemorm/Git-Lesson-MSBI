function LPFilter_Alison_Myoraku(input_image,aperture)
% This function will add a low pass filter to an image given:
% input_image: 2D matrix of any image
% aperture: width of aperture

% Example case: 
% By using the imread function on an example image (AxT1_brain.jpg), we can
% plot the original image in the first subplot space (first part of code).

% The second input allows you to choose the aperture, or the size of the 2D
% matrix that makes the filter. The for loop applies the filter by allowing
% the pixels within the filter to stay the same while nulling the rest. 

% The third and fourth sections of the function allow subplotting of the
% filtered k-space and of the image that is reconstructed from the filtered
% k-space.

% Since we are eliminating higher frequencies with this filter, we see
% details of the brain, but the lines are slightly blurred.

image=imread(input_image);
image=rgb2gray(image);
subplot(1,3,1)
imagesc(image); colormap gray
title('Original Image')

low_pass_filter=zeros(size(image));
filter_width=aperture;
start_point=size(image)/2; %center coordinate in image

for i=(start_point(1) - filter_width/2): (start_point(1) + filter_width/2)
    for j=(start_point(2)-filter_width/2):(start_point(2)+filter_width/2)
        low_pass_filter(i,j)=1;
    end
end

image_fft=fft2(image);
image_fft_shift=fftshift(image_fft);
image_fft_filtered=image_fft_shift.*low_pass_filter;
subplot(1,3,2)
imagesc(abs(image_fft_filtered), [0 1000000]); colormap gray
title('Filtered k-Space')

image_fft_filtered_ifft=ifft2(image_fft_filtered);
subplot(1,3,3)
imagesc(abs(image_fft_filtered_ifft)); colormap gray 
title('Filtered Image, Not in k-space')
end

