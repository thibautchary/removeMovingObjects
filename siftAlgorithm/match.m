% [im1 im2 locs1 locs2] = match(image1, image2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% 
% Inputs:
%   - image1 = path of reference image
%   - image2 = path of image being processed
% 
% Outputs:
%   - im1 = image array of reference image in double format
%   - im2 = image array of image being processed in double format
%   - locs1 = 2xN matrix containing all matched feature locations in the
%     reference image
%   - locs2 = 2xN matrix containing all matched feature locations in the image
%     being processed
% N is the number of matched features found, and the first and second row
% of botch loc1 and loc2 respectively represent the row and column number
% of the image of the kth feature (k being the column number).
%
%
% Example: match('scene.pgm','book.pgm');

function [im1, im2, matchLocs1, matchLocs2] = match(image1, image2)

% Find SIFT keypoints for each image
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end

% Create a new image showing the two images side by side.
% im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.

% UNCOMMENT COMMENTED LINES BELOW TO PLOT FIGURE;
% figure('Position', [100 100 size(im3,2) size(im3,1)]);
% colormap('gray');
% imagesc(im3);
% hold on;
% cols1 = size(im1,2);
matchLocs1 = zeros(2,size(im1,2));
matchLocs2 = zeros(2,size(im1,2));
for i = 1: size(des1,1)
  if (match(i) > 0)
    % line([loc1(i,2) loc2(match(i),2)+cols1], ...
    %    [loc1(i,1) loc2(match(i),1)], 'Color', 'c');
    matchLocs1(:,i) = [loc1(i,1);  loc1(i,2)];
    matchLocs2(:,i) = [loc2(match(i),1); loc2(match(i),2)];
  end
end
% hold off;
num = sum(match > 0);
fprintf('Found %d matches.\n', num);
f1 = find(matchLocs1(1,:) ~= 0);
matchLocs1 = matchLocs1(:,f1);
f2 = find(matchLocs2(1,:) ~= 0);
matchLocs2 = matchLocs2(:,f2);

end





