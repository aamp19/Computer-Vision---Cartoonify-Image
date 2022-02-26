%Cartoonifying an image
imRGB = imread("johncena.jpg"); %reading an image
grey2 = rgb2gray(imRGB);
edge_detect2=edge(grey2,'Sobel');
%Gaussian filter
Gaussian = imgaussfilt(imRGB,2);

%threshold image
threshRGB = multithresh(imRGB,7);
threshForPlanes = zeros(3,7);            

for i = 1:3
    threshForPlanes(i,:) = multithresh(imRGB(:,:,i),7);
end
value = [0 threshRGB(2:end) 255]; 
quantRGB = imquantize(imRGB, threshRGB, value);

