function LPfilter_Torie_Tsuei(image,laperture,waperture,varargin)
% Author: Torie Tsuei
% Class: MSBI Bootcamp, Homework 8
%   LPFILTER_TORIE_TSUEI Takes in an image file and desired aperture length
%   and width sizes, converts it to a grayscale, then Fourier transforms 
%   the image and retains only the inner aperture of the k-space. Finally, 
%   it inverse Fourier transforms the image to see what the resultant 
%   aperture of k-space captures of the original image. If no aperture 
%   dimensions are chosen, a default aperture length/width/both of 10x10 
%   pixels is chosen. The default image used is called 'AxT1_brain.jpg' and
%   is given along with the .m files. The original image, the k-space of the desired 
%   aperture size, and the inverse Fourier transform of the inner aperture 
%   are shown side by side.
%
% Syntax:
% 
%   LPFILTER_TORIE_TSUEI()
%   LPFILTER_TORIE_TSUEI(image)
%   LPFILTER_TORIE_TSUEI(image,laperture,[])
%   LPFILTER_TORIE_TSUEI(image,[],waperture)
%   LPFILTER_TORIE_TSUEI(image,laperture,waperture)
%   
%
% Description:
%
%   LPFILTER_TORIE_TSUEI() visualizes default image 'AxT1_brain.jpg' as
%   'Original Image', displays a k-space with a default inner 
%   aperture of 10x10 pixels, called 'K-space of Image with Aperture: 10 x 
%   10', and displays the filtered original image called 'Filtered Image with
%   Aperture: 10 x 10'.
%
%   LPFILTER_TORIE_TSUEI(image) visualizes input image file as
%   'Original Image', displays a k-space with a default inner aperture of 
%   10x10 pixels, called 'K-space of Image with Aperture: 10 x 10', and 
%   displays the filtered original image called 'Filtered Image with
%   Aperture: 10 x 10'.
%       image represents the input image file. Must be entered as string,
%       with correct apostrophe syntax 'filename.filetype'
%
%   LPFILTER_TORIE_TSUEI(image,laperture) visualizes input image file as
%   'Original Image', displays a k-space with an inner aperture of 
%   laperturex10 pixels, called 'K-space of Image with Aperture: _ x 10', and 
%   displays the filtered original image called 'Filtered Image with
%   Aperture: _ x 10'.
%       laperture represents the inner aperture input pixel length.
%
%   LPFILTER_TORIE_TSUEI(image,NaN,waperture) visualizes input image file as
%   'Original Image', displays a k-space with an inner aperture of 
%   10xwaperture pixels, called 'K-space of Image with Aperture: 10 x _', and 
%   displays the filtered original image called 'Filtered Image with
%   Aperture: 10 x _'.
%       waperture represents the inner aperture input pixel width.
%       NOTE: if laperture unknown, NaN must be given as the third argument,
%       otherwise waperture will be interpreted as laperture (second
%       argument) and waperture will default to 10 pixels.
%
%   LPFILTER_TORIE_TSUEI(image,laperture,waperture) visualizes input image file as
%   'Original Image', displays a k-space with an inner aperture of 
%   laperturexwaperture pixels, called 'K-space of Image with Aperture: 
%   _ x _', and displays the filtered original image called 'Filtered Image 
%   with Aperture: _ x _'.
% 
% Examples:
%
%   Visualize 'AxT1_brain.jpg' image original, k-space capturing an inner aperture
%   of 10x10 pixels, and the resulting filtered image.
%       1st method: LPfilter_Torie_Tsuei()
%       2nd method: LPfilter_Torie_Tsuei('AxT1_brain.jpg')
%
%   Visualize an input image original, k-space capturing an inner aperture
%   of 15x10 pixels, and the resulting filtered image.
%       LPfilter_Torie_Tsuei('AxT1_brain.jpg',15)
%
%   Visualize an input image original, k-space capturing an inner aperture
%   of 10x20 pixels, and the resulting filtered image.
%       LPfilter_Torie_Tsuei('AxT1_brain.jpg',NaN,20)
%   
%   Visualize an input image original, k-space capturing an inner aperture
%   of 15x20 pixels, and the resulting filtered image.
%       LPfilter_Torie_Tsuei('AxT1_brain.jpg',15,20)
%
% See also NARGIN ISNAN ISCHAR ISSTRUCT ISCELL NDIMS FFT2 FFTSHIFT IFFT
% STRUCT2CELL CELL2MAT MAT2GRAY RGB2GRAY IMAGESC IMREAD

switch nargin
    case 0
        image = 'AxT1_brain.jpg';
        laperture = 10;
        waperture = 10;
    case 1
        laperture = 10;
        waperture = 10;
    case 2
        waperture = 10;
    case 3
        if isnan(laperture) == 1
            laperture = 10;
        end
end

if ischar(image) == 0
    disp('Image file is not readable. Try again!')
end

if laperture < 0 || waperture < 0
    disp('Aperture cannot be negative value. Try again!')
end

x = imread(image);

if isstruct(x) == 1
    x = mat2gray(cell2mat(struct2cell(x)));
end
if iscell(x) == 1
    x = mat2gray(cell2mat(x));
end

if ndims(x) > 2
    x = rgb2gray(x);
end

figure()
subplot(1,3,1)
imagesc(x); colormap gray; title('Original Image')

x_fft = fft2(x);
x_ffts = fftshift(x_fft);

for i = 1:length(x_ffts)
    if i < (length(x_ffts)/2)-laperture/2 || i > (length(x_ffts)/2)+laperture/2
        x_ffts(i,:) = 0;
    end
end

for j = 1:size(x_ffts,2)
    if j < (size(x_ffts,2)/2)-waperture/2 || j > (size(x_ffts,2)/2)+waperture/2
        x_ffts(:,j) = 0;
    end
end

subplot(1,3,2)
imagesc(abs(x_ffts),[1 100000]); colormap gray; title(['K-space of Image with Aperture: ',num2str(laperture),'x',num2str(waperture)])
subplot(1,3,3)
imagesc(abs(ifft2(x_ffts))); colormap gray; title(['Filtered Image with Aperture: ',num2str(laperture),'x',num2str(waperture)])
end
