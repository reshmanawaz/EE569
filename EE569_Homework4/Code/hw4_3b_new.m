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

[cat1_features, cat1_descriptors] = vl_sift(cat1_gray,'Octaves',4,'Levels',5,'PeakThresh',0,'EdgeThresh',5);
[cat2_features, cat2_descriptors] = vl_sift(cat2_gray,'Octaves',4,'Levels',5,'PeakThresh',0,'EdgeThresh',5);
[cat3_features, cat3_descriptors] = vl_sift(cat3_gray,'Octaves',4,'Levels',5,'PeakThresh',0,'EdgeThresh',5);
[dog1_features, dog1_descriptors] = vl_sift(dog1_gray,'Octaves',4,'Levels',5,'PeakThresh',0,'EdgeThresh',5);

cat1_largest_scale = largestscale(cat1_features(3,:));
dog1_largest_scale = largestscale(dog1_features(3,:));

cat1_ls_descriptor = cat1_descriptors(:,cat1_largest_scale);
cat1_ls_descriptor = double(cat1_ls_descriptor);
dog1_ls_descriptor = dog1_descriptors(:, dog1_largest_scale);
dog1_ls_descriptor = double(dog1_ls_descriptor);

index_cat1_cat3 = nearest_neighbor(cat3_descriptors, cat1_ls_descriptor);
nearest_cat3_from_cat1 = cat3_descriptors(:,index_cat1_cat3);
index_dog1_cat3 = nearest_neighbor(cat3_descriptors, dog1_ls_descriptor);
nearest_cat3_from_dog1 = cat3_descriptors(:,index_dog1_cat3);
index_cat1_cat2 = nearest_neighbor(cat2_descriptors, cat1_ls_descriptor);
nearest_cat2_from_cat1 = cat2_descriptors(:,index_cat1_cat2);
index_cat1_dog1 = nearest_neighbor(dog1_descriptors, cat1_ls_descriptor);
nearest_dog1_from_cat1 = dog1_descriptors(:,index_cat1_dog1);

figure, subplot(1,2,1),imshow(uint8(cat1_img));
set(vl_plotframe(cat1_features(:,cat1_largest_scale)), 'linewidth', 1);
vl_plotsiftdescriptor(cat1_ls_descriptor,cat1_features(:,cat1_largest_scale));
title('Cat 1')

subplot(1,2,2), imshow(uint8(cat3_img));
set(vl_plotframe(cat3_features(:,index_cat1_cat3)),'linewidth', 1);
vl_plotsiftdescriptor(cat3_descriptors(:,index_cat1_cat3), cat3_features(:,index_cat1_cat3));
title('Cat 3')

figure, subplot(1,2,1),imshow(uint8(dog1_img));
set(vl_plotframe(dog1_features(:,dog1_largest_scale)), 'linewidth', 2, 'color', 'red');
set(vl_plotsiftdescriptor(dog1_ls_descriptor,dog1_features(:,dog1_largest_scale)), 'linewidth', 2);
title('Dog 1')

subplot(1,2,2), imshow(uint8(cat3_img));
set(vl_plotframe(cat3_features(:,index_dog1_cat3)),'linewidth', 1);
vl_plotsiftdescriptor(cat3_descriptors(:,index_dog1_cat3), cat3_features(:,index_dog1_cat3));
title('Cat 3')

figure, subplot(1,2,1),imshow(uint8(cat1_img));
set(vl_plotframe(cat1_features(:,cat1_largest_scale)), 'linewidth', 2, 'color', 'red');
set(vl_plotsiftdescriptor(cat1_ls_descriptor,cat1_features(:,cat1_largest_scale)), 'linewidth', 2);
title('Cat 1')

subplot(1,2,2), imshow(uint8(dog1_img));
set(vl_plotframe(dog1_features(:,index_dog1_cat3)),'linewidth', 1);
vl_plotsiftdescriptor(dog1_descriptors(:,index_dog1_cat3), cat3_features(:,index_dog1_cat3));
title('Dog 1')

figure, subplot(1,2,1),imshow(uint8(dog1_img));
set(vl_plotframe(dog1_features(:,dog1_largest_scale)), 'linewidth', 2, 'color', 'red');
set(vl_plotsiftdescriptor(dog1_ls_descriptor,dog1_features(:,dog1_largest_scale)), 'linewidth', 2);
title('Cat 1')

subplot(1,2,2), imshow(uint8(cat3_img));
set(vl_plotframe(cat3_features(:,index_dog1_cat3)),'linewidth', 1);
vl_plotsiftdescriptor(cat3_descriptors(:,index_dog1_cat3), cat3_features(:,index_dog1_cat3));
title('Cat 3')

% Plotting SIFT pairs between Cat 1 and Cat 3
plot_pairs(cat1_descriptors, cat3_descriptors, cat1_features, cat3_features, cat1_img, cat3_img);
title('SIFT Pairs Between Cat 1 and Cat 3');

% Plotting SIFT pairs between Dog 1 and Cat 3
plot_pairs(dog1_descriptors, cat3_descriptors, dog1_features, cat3_features, dog1_img, cat3_img);
title('SIFT Pairs Between Dog 1 and Cat 3');

% Plotting SIFT pairs between Cat 1 and Cat 2
plot_pairs(cat3_descriptors, cat2_descriptors, cat3_features, cat2_features, cat3_img, cat2_img);
title('SIFT Pairs Between Cat 3 and Cat 2');

% Plotting SIFT pairs between Cat 1 and Dog 1
plot_pairs(cat1_descriptors, dog1_descriptors, cat1_features, dog1_features, cat1_img, dog1_img);
title('SIFT Pairs Between Cat 1 and Dog 1');

function plot_pairs(d1, d2, f1, f2, I1, I2)
    [match1and2, scores] = vl_ubcmatch(d1,d2);

    figure, clf; 
    imagesc(uint8(cat(2, I1, I2)));

    x1 = f1(1,match1and2(1,:));
    x2 = f2(1,match1and2(2,:)) + size(I1,2);
    y1 = f1(2,match1and2(1,:));
    y2 = f2(2,match1and2(2,:));

    set(line([x1 ; x2], [y1 ; y2]),'linewidth', 1, 'color', 'blue');

    vl_plotframe(f1(:,match1and2(1,:)));
    f2(1,:) = f2(1,:) + size(I1,2);
    vl_plotframe(f2(:,match1and2(2,:)));
    axis image off;
end

function index_i = nearest_neighbor(desc, ref)
    distance_min = 999999999999.00;
    for i = 1:size(desc,2)
        val = double(desc(:,i));
        distance_i = (val-ref).^2;
        distance = sum(distance_i);

        if distance < distance_min
            distance_min = distance;
            index_i = i;
        end
    end
end

function index = largestscale(f)
    largest_scale = 0;
    for i = 1:size(f,2)
        scale = f(i);
        if (largest_scale < scale)
            largest_scale = scale;
            index = i;
        end
    end
end