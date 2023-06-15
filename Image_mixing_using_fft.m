
clc;
clear;
close all;
%%
% notes:
% mat2gray(0 is a different option for pretty much the same operation
% we should note though that in case of uint mat2gray we should stick to
% log() instead of 20*log10() which is done for uint8()

try  % checking wether or not the files are even there.
    img1=imread("image2.jpg");
    img2=imread("image4.jpg");
catch
    disp("Failed to open one of the images, exiting.")
    return;
end

[rows, columns, numcolors1]=size(img1); %   we assume both images are of the same resolution.
[~, ~, numcolors2]=size(img2);          
if numcolors1>1
    img1=rgb2gray(img1);
end
if numcolors2>1
    img2=rgb2gray(img2);
end

img1_fft=20*log10((abs(fftshift(fft2(double(img1)))))); % converting the to the frequency domain
img2_fft=20*log10((abs(fftshift(fft2(double(img2))))));
img1_fft=uint8(img1_fft);  
img2_fft=uint8(img2_fft);      

figure;
subplot(2,2,1)
imshow(img1);
title("Original first image");

subplot(2,2,2)
imshow(img2);
title("Original second image");

subplot(2,2,3)
imshow(img1_fft);
title("Magnitude of first image FFT");

subplot(2,2,4)
imshow(img2_fft);
title("Magnitude of the second image FFT");

%%

img1_low_freq=fftshift(fft2(double(img1)));
img2_high_freq=fftshift(fft2(double(img2)));

img1_low_freq(1:end,1:0.45*end)=0;  % remove all the high requencies of the first image.
img1_low_freq(1:end,0.55*end+1:end)=0; 
img1_low_freq(1:0.45*end,1:end)=0;
img1_low_freq(0.55*end+1:end,1:end)=0;

img2_high_freq(0.45*end+1:0.55*end,0.45*end+1:0.55*end)=0; % remove all the low frequencies of the second image.

img1_low_freq_disp=uint8(20*log(abs(img1_low_freq)));   % Preparing to display the image in frequency domain
img2_high_freq_disp=uint8(20*log(abs(img2_high_freq)));

restored_img1_low_freq=uint8(abs(ifft2(ifftshift(img1_low_freq))));  % Restoring the image back to time domain.
restored_img2_high_freq=uint8(abs(ifft2(ifftshift(img2_high_freq))));
figure; % Plotting everything
subplot(2,2,1)
imshow(img1_low_freq_disp);
title("First image in frequency domain [high frequencies removed]");

subplot(2,2,2)
imshow(restored_img1_low_freq);
title("First image in time domain [high frequencies removed]");

subplot(2,2,3)
imshow(img2_high_freq_disp);
title("Second image in frequency domain [low frequencies removed]");

subplot(2,2,4)
imshow(restored_img2_high_freq);
title("Original first image in time domain [low frequencies removed]");


%%

new_image_fft=img2_high_freq+img1_low_freq;   % combining the two images in frequency domain
new_image_fft_disp=uint8(20*log10(abs(new_image_fft)));

new_image=abs(ifft2(ifftshift(new_image_fft)));      % restoring the image back to the time domain
factor=255/max(new_image(:));
new_image=uint8(new_image*factor);    % normalizing values+ restoring uint8() format.
figure;         % Plotting
subplot(2,1,1)
imshow(new_image)

subplot(2,1,2)
imshow(new_image_fft_disp)



