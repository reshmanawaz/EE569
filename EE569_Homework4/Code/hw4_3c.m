clear all;
close all;

cat1_img = imread("cat_1.png");
cat2_img = imread("cat_2.png");
cat3_img = imread("cat_3.png");
dog1_img = imread("dog_1.png");

cat1_gray = single(rgb2gray(cat1_img));
cat2_gray = single(rgb2gray(cat2_img));
cat3_gray = single(rgb2gray(cat3_img));
dog1_gray = single(rgb2gray(dog1_img));

[cat1_features, cat1_descriptors] = vl_sift(cat1_gray, 'Octaves', 4, 'Levels', 5, 'PeakThresh', 0, 'EdgeThresh', 5);
[cat2_features, cat2_descriptors] = vl_sift(cat2_gray, 'Octaves', 4, 'Levels', 5, 'PeakThresh', 0, 'EdgeThresh', 5);
[cat3_features, cat3_descriptors] = vl_sift(cat3_gray, 'Octaves', 4, 'Levels', 5, 'PeakThresh', 0, 'EdgeThresh', 5);
[dog1_features, dog1_descriptors] = vl_sift(dog1_gray, 'Octaves', 4, 'Levels', 5, 'PeakThresh', 0, 'EdgeThresh', 5);

% Stack descriptors
all_descriptors = [double(cat1_descriptors), double(cat2_descriptors), double(cat3_descriptors), double(dog1_descriptors)];

% Perform K-means clustering
num_clusters = 8; 
[idx, C] = kmeans(all_descriptors', num_clusters);

% Initialize frequency arrays
f1 = zeros(8, 1);
f2 = zeros(8, 1);
f3 = zeros(8, 1);
f4 = zeros(8, 1);

% Separate cluster indices for each image
c1 = idx(1:182);
c2 = idx(183:386); 
c3 = idx(387:576); 
c4 = idx(577:764); 

for i=1:182
    f1(c1(i)) = f1(c1(i)) + 1;
end

for i=1:204
    f2(c2(i)) = f2(c2(i)) + 1;
end

for i=1:190
    f3(c3(i)) = f3(c3(i)) + 1;
end
for i=1:188
    f4(c4(i)) = f4(c4(i)) + 1;
end

f1 = f1./182;
f2 = f2./204;
f3 = f3./190;
f4 = f4./188;

% Plot histograms
figure;
subplot(2, 2, 1);
bar(f1);
title('Cat 1');
xlabel('Cluster');
ylabel('Frequency');

subplot(2, 2, 2);
bar(f2);
title('Cat 2');
xlabel('Cluster');
ylabel('Frequency');

subplot(2, 2, 3);
bar(f3);
title('Cat 3');
xlabel('Cluster');
ylabel('Frequency');

subplot(2, 2, 4);
bar(f4);
title('Dog 1');
xlabel('Cluster');
ylabel('Frequency');

numerator = 0 ;
denominator = 0 ;
similarityf3_f1 = 0;
similarityf3_f2 = 0;
similarityf3_f4 = 0;
for i = 1 :8
    numerator  = numerator + min(f3(i),f1(i));
    denominator = denominator + max(f3(i),f1(i));
end

similarityf3_f1 = numerator / denominator;
disp(similarityf3_f1);

numerator = 0 ;
denominator = 0 ;

for i = 1 :8
    numerator  = numerator + min(f3(i),f2(i));
    denominator = denominator + max(f3(i),f2(i));
end
similarityf3_f2 = numerator / denominator;
disp(similarityf3_f2);
numerator = 0 ;
denominator = 0 ;

for i = 1 :8
    numerator  = numerator + min(f3(i),f4(i));
    denominator = denominator + max(f3(i),f4(i));
end
similarityf3_f4 = numerator / denominator;
disp(similarityf3_f4);