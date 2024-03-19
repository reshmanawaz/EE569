% Reading the image
input_image = read_gray('board.raw', 768, 768);
figure(1);
imshow(input_image);
title('Input Image: Board');

% Call the countHolesAndObjects function
countHolesAndObjects('board.raw');

function countHolesAndObjects(filename)
    width = 768;
    height = 768;

    % Reading the image
    input_image = read_gray(filename, width, height); 
    
    % Display the input image
    figure(2);
    imshow(input_image);
    title('Input Image: Board');

    % Binarize the image
    binary_image = binary(input_image);

    % Shrinking the image to infinity
    shrinked_image = bwmorph(binary_image, 'shrink', Inf);

    % Apply the filter to count the number of holes
    filter = [0 0 0; 0 1 0; 0 0 0];
    countHoles = Filters(shrinked_image, filter);

    % Increment holes count by 1
    countHoles = countHoles + 1;

    % Display the number of holes
    disp(['Total number of holes =  ', num2str(countHoles)]);

    % Count the connected components in the binary image (excluding background)
    number_of_objects = count_objects(shrinked_image);

    % Increment total count by 1
    number_of_objects = number_of_objects + 1;

    % Display the number of objects
    disp(['Total number of objects found ', num2str(number_of_objects)]);

    % Count the total number of white rectangle objects
    total_white_rectangles = count_white_rectangles(binary_image);
    disp(['Total number of white rectangle objects: ', num2str(total_white_rectangles)]);
    
    % Count the total number of white circle objects
    total_white_circles = count_white_circles(binary_image);
    disp(['Total number of white circle objects: ', num2str(total_white_circles)]);
end


function count = count_objects(input_image)
    % Label connected components in the binary image
    labeled_image = bwlabel(input_image);
    
    % Count the number of unique labels (excluding background)
    count = max(labeled_image(:)) - 1; % Subtract 1 for the background
end

function total_white_rectangles = count_white_rectangles(input_image)
    % Label connected components in the binary image
    labeled_image = bwlabel(input_image);
    
    % Measure properties of the labeled regions
    stats = regionprops(labeled_image, 'Area', 'BoundingBox');
    
    % Initialize counter for rectangle objects
    total_white_rectangles = 0;
    
    % Define a threshold for aspect ratio to identify rectangles
    aspect_ratio_threshold = 2;
    
    % Iterate through each labeled region
    for i = 1:numel(stats)
        % Get the bounding box dimensions
        bbox_width = stats(i).BoundingBox(2);
        bbox_height = stats(i).BoundingBox(4);
        
        % Calculate aspect ratio
        aspect_ratio = bbox_width / bbox_height;
        
        % Check if aspect ratio meets the threshold (indicating a rectangle)
        if aspect_ratio < aspect_ratio_threshold
            % Increment the count of white rectangle objects
            total_white_rectangles = total_white_rectangles + 1;
        end
    end
end

function total_white_circles = count_white_circles(input_image)
    % Label connected components in the binary image
    labeled_image = bwlabel(input_image);
    
    % Measure properties of the labeled regions
    stats = regionprops(labeled_image, 'Area', 'EquivDiameter');
    
    % Initialize counter for circle objects
    total_white_circles = 0;
    
    % Define a threshold for circularity
    circularity_threshold = 0.6; % Adjust as needed
    
    % Iterate through each labeled region
    for i = 1:numel(stats)
        % Calculate circularity (area / (pi * (radius^2)))
        circularity = (4 * pi * stats(i).Area) / (stats(i).EquivDiameter^2 * pi);
        
        % Check if the circularity meets the threshold
        if circularity > circularity_threshold
            % Increment the count of white circle objects
            total_white_circles = total_white_circles + 1;
        end
    end
end

function image = read_gray(file_path, width, height)
    % Open the raw data file
    fid = fopen(file_path, 'rb');
    
    % Check if the file opened successfully
    if fid == -1
        error(['Could not open file: ', file_path]);
    end
    
    % Read the raw data
    raw_data = fread(fid, width * height, 'uint8');
    
    % Close the file
    fclose(fid);
    
    % Reshape the raw data into an image array
    image = reshape(raw_data, [width, height]);
    
    % Convert to uint8
    image = uint8(image');
end

% Function to binarize the input image
function binary_image = binary(input_image)
    % Thresholding: pixels above 128 become white (255), and others become black (0)
    binary_image = input_image > 128;
end

% Function to count occurrences of a filter pattern in the input image
function count = Filters(input_image, filter)
    % Initialize count to 0
    count = 0;
    
    % Get the dimensions of the input image
    [height, width] = size(input_image);
    
    % Iterate over each pixel in the input image, excluding borders
    for row = 2:(height - 1)
        for col = 2:(width - 1)
            % Extract the sub-matrix around the current pixel
            matrix = input_image((row-1):(row+1), (col-1):(col+1));
            
            % Check if the sub-matrix matches the specified filter
            if isequal(matrix, filter)
                % Increment the count if the filter is matched
                count = count + 1;
            end
        end
    end
end
