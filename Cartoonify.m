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

%threshold for edge detection
threshRGB2 = multithresh(imRGB,2);
threshForPlanes2 = zeros(3,7);            

for i = 1:3
    threshForPlanes2(i,:) = multithresh(imRGB(:,:,i),7);
end
value2 = [0 threshRGB2(2:end) 255]; 
quantRGB2 = imquantize(imRGB, threshRGB2, value2);

%bilateral filter
imLAB = rgb2lab(imRGB);
patch = imcrop(imLAB,[34,71,60,55]);
patchSq = patch.^2;
edist = sqrt(sum(patchSq,3));
patchVar = std2(edist).^2;
DoS = 4*patchVar;
smoothedLAB = imbilatfilt(imLAB,DoS);
smoothedRBG = lab2rgb(smoothedLAB,"Out","uint8");

%edge detection
grey = rgb2gray(quantRGB2);
canny_edge = edge(grey2,'canny');
edgeMask = uint8(edge(grey2, 'canny', 0.15));

% Highlight edges using black color.
finalImg(:,:,1) = quantRGB(:,:,1) - quantRGB(:,:,1) .* edgeMask;
finalImg(:,:,2) = quantRGB(:,:,2) - quantRGB(:,:,2) .* edgeMask;
finalImg(:,:,3) = quantRGB(:,:,3) - quantRGB(:,:,3) .* edgeMask;

%display final Image
montage({imRGB, edge_detect2})
title('Original vs. After');
