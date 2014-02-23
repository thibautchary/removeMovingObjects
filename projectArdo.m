clc;
clear all;
close all;

addpath('siftAlgorithm', 'images/manuallyAligned','images/notAligned');
addpath('images/testImages');

% Part 1: detect matching features;
% ---------------------------------

images = {'test1.jpg','test2.jpg','img3.jpg','img4.jpg','img5.jpg'};

% Trial procedure for image 1 and 2
[im1, im2, locs1, locs2] = match(images{1},images{2});

im3 = appendimages(im1,im2);
figure('Position', [100 100 size(im3,2)/2 size(im3,1)/2])
colormap('gray'); imagesc(im3);
set(gca,'DataAspectRatio',[1 1 1]);
hold on;
for k = 1:length(locs1);
    line([locs1(2,k) locs2(2,k)+size(im1,2)],[locs1(1,k), locs2(1,k)],'Color','c');
end
hold off;

imc1 = imread(images{1});
imc2 = imread(images{2});
BestAlignImages(imc1,imc2,1,locs1,locs2);


% Algorithm as I think it goes:
%     1) Choose an image. This is the reference image.
%     2) Match another image to this image
%     3) For every feature, calculate H matrix elements using LMeDS
%     4) Repeat step 2-4 untill all images are processed
%     5) Apply H matrix to all images except for the reference image
%     6) Now the images have been aligned, remove the objects

 