clc;
clear all;
close all;

im = imread('img1.jpg');
im1 = im(1:(end-100),:,:,:);
im2 = im(101:end,:,:);

locs1 = [200 300 500 600;
         120 520 150 200];
locs2 = [100 200 400 500;
         120 520 150 200];
     
im3 = appendimages(im1,im2);
figure('Position', [100 100 size(im3,2)/2 size(im3,1)/2])
colormap('gray'); imagesc(im3);
set(gca,'DataAspectRatio',[1 1 1]);
hold on;
for k = 1:length(locs1);
    line([locs1(2,k) locs2(2,k)+size(im1,2)],[locs1(1,k), locs2(1,k)],'Color','c');
end
hold off;
     
log1 = locs2;
log2 = locs1;
     
H=trans(log2(1,1),log2(2,1),log1(1,1),log1(2,1),...
                      log2(1,2),log2(2,2),log1(1,2),log1(2,2),...
                      log2(1,3),log2(2,3),log1(1,3),log1(2,3),...
                      log2(1,4),log2(2,4),log1(1,4),log1(2,4))
                  
[n, p, c] = size(im1);
refIndexes = [sort(repmat([1:n],1,p)); repmat([1:p],1,n); ones(1,n*p)];
mappedIndexes = round(H*refIndexes);
image_moved_modified = zeros(size(im1));
xindex = reshape(mappedIndexes(1,:),p,n)';
yindex = reshape(mappedIndexes(2,:),p,n)';
for i=101:n
    for j=1:p
        im2_moved(i,j,:) = im2(xindex(i),yindex(j),:);
    end
end

figure;
subplot(211);
image(im1);
subplot(212);
image(im2_moved);