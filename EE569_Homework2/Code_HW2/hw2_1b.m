% Read the images
tiger = imread('Tiger.jpg');
pig = imread('Pig.jpg');

% Convert images to grayscale manually
convert_tiger = 0.2989 * tiger(:,:,1) + 0.5870 * tiger(:,:,2) + 0.1140 * tiger(:,:,3);
convert_pig = 0.2989 * pig(:,:,1) + 0.5870 * pig(:,:,2) + 0.1140 * pig(:,:,3);

% Define thresholds
low_threshold = 0.2; % Adjust as needed
high_threshold = 0.3; % Adjust as needed

% Apply Canny edge detector with thresholds
apply_tiger = edge(convert_tiger, 'Canny', [low_threshold, high_threshold]);
apply_pig = edge(convert_pig, 'Canny', [low_threshold, high_threshold]);

% Display the results
figure; 
subplot(2,2,1);
imshow(tiger);
title('Tiger Image: Original');
subplot(2,2,2);
imshow(uint8(convert_tiger))
title('Tiger Image: Output');
subplot(2,2,3);
imshow(apply_tiger);
title('Canny Output - Tiger');

figure; 
subplot(2,2,1);
imshow(pig);
title('Pig Image: Original');
subplot(2,2,2);
imshow(uint8(convert_pig))
title('Pig Image: Output');
subplot(2,2,3);
imshow(apply_pig);
title('Canny Output - Pig');
