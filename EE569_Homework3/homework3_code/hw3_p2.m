% Load images
fid = fopen('toy_left.raw', 'rb');
img1 = fread(fid, [605, 454], 'uint8')';
fclose(fid);

fid = fopen('toy_middle.raw', 'rb');
img2 = fread(fid, [605, 454], 'uint8')';
fclose(fid);

fid = fopen('toy_right.raw', 'rb');
img3 = fread(fid, [605, 454], 'uint8')';
fclose(fid);

% Convert images to grayscale if needed
if size(img1, 3) == 3
    img1 = rgb2gray(img1);
end
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end
if size(img3, 3) == 3
    img3 = rgb2gray(img3);
end

% Detect features and extract descriptors
points1 = detectSURFFeatures(img1);
[features1, points1] = extractFeatures(img1, points1);

points2 = detectSURFFeatures(img2);
[features2, points2] = extractFeatures(img2, points2);

points3 = detectSURFFeatures(img3);
[features3, points3] = extractFeatures(img3, points3);

% Match features
indexPairs12 = matchFeatures(features1, features2);
matchedPoints1 = points1(indexPairs12(:, 1), :);
matchedPoints2 = points2(indexPairs12(:, 2), :);

indexPairs23 = matchFeatures(features2, features3);
matchedPoints2_ = points2(indexPairs23(:, 1), :);
matchedPoints3 = points3(indexPairs23(:, 2), :);

% Estimate geometric transformation
[tform12, inlierPoints1, inlierPoints2] = estimateGeometricTransform(matchedPoints1, matchedPoints2, 'affine');
[tform23, inlierPoints2_, inlierPoints3] = estimateGeometricTransform(matchedPoints2_, matchedPoints3, 'affine');

% Warp images
outputView = imref2d(size(img1));
panorama12 = imwarp(img2, tform12, 'OutputView', outputView);
panorama23 = imwarp(img3, tform23, 'OutputView', outputView);

% Create the final panorama
panorama = imfuse(img1, panorama12, 'blend', 'Scaling', 'joint');
panorama = imfuse(panorama, panorama23, 'blend', 'Scaling', 'joint');

% Display the panorama
imshow(panorama);
title('Final Panorama');
