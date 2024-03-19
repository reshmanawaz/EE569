% Reading the image (dog)
input_image = readrgb('beans.raw', 494, 82);
figure(1);
imshow(input_image);
title('Input Image: Beans');

[count, order] = analyze_beans(input_image);

function image = readrgb(file_path, width, height)
    % Open the raw data file
    fid = fopen(file_path, 'rb');
    
    % Read the raw data
    raw_data = fread(fid, width * height * 3, 'uint8');
    
    % Close the file
    fclose(fid);
    
    % Reshape the raw data into an image array
    image = reshape(raw_data, [3, width, height]);
    
    % Reorder dimensions and convert to uint8
    image = uint8(permute(image, [3, 2, 1]));
end

function [bean_count, bean_order] = analyze_beans(input_image)
    % Convert image to grayscale
    gray_image = convert_to_grayscale(input_image);

    % Adaptive thresholding with adjusted sensitivity
    binarized_image = adaptive_threshold(gray_image, 0.559); 

    % Invert the binary image
    binarized_image = ~binarized_image;

    % Perform morphological operations to enhance bean regions
    se = strel('disk', 10); 
    enhanced_image = imopen(binarized_image, se);

    % Fill holes in the binary image
    filled_image = imfill(enhanced_image, 'holes');

    % Perform connected component analysis (labeling) to count the number of beans and generate a segmentation mask
    [beans, bean_count] = bwlabel(filled_image, 4); 

    % Initialize array to store bean sizes
    bean_size = zeros(bean_count, 1);

    % Calculate area for each bean
    for i = 1:bean_count
        bean_size(i) = sum(beans(:) == i);
    end

    % Sort the beans based on size
    [~, bean_order] = sort(bean_size);
    
    % Adjust bean order to start from smallest
    bean_order = fliplr(bean_order);

    % Display the total number of beans
    disp(['Total beans = ', num2str(bean_count)]);

    % Display bean order from smallest to largest
    disp('Bean order from smallest to largest:')
    for i = 1:bean_count
        disp(['Bean ', num2str(bean_order(i))]);
    end
end

function binarized_image = adaptive_threshold(image, sensitivity)
    % Convert image to grayscale if it's not already grayscale
    if size(image, 3) == 3
        gray_image = rgb2gray(image);
    else
        gray_image = image;
    end

    % Perform adaptive thresholding
    threshold_image = adaptthresh(gray_image, sensitivity);

    % Binarize the image using the adaptive threshold
    binarized_image = imbinarize(gray_image, threshold_image);
end

function gray_image = convert_to_grayscale(input_image)
    % Convert image to grayscale if it's not already grayscale
    if size(input_image, 3) == 3
        gray_image = rgb2gray(input_image);
    else
        gray_image = input_image;
    end
end
