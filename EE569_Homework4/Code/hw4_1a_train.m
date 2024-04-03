// Name: Reshma Nawaz 
// Student ID: 2852-0938-03
// USC: EE569
 
 
 
 
% Reading the blanket images (1-9)
blanket_input_image1 = readgrey('train/blanket_1.raw', 128, 128);
blanket_input_image2 = readgrey('train/blanket_2.raw', 128, 128);
blanket_input_image3 = readgrey('train/blanket_3.raw', 128, 128);
blanket_input_image4 = readgrey('train/blanket_4.raw', 128, 128);
blanket_input_image5 = readgrey('train/blanket_5.raw', 128, 128);
blanket_input_image6 = readgrey('train/blanket_6.raw', 128, 128);
blanket_input_image7 = readgrey('train/blanket_7.raw', 128, 128);
blanket_input_image8 = readgrey('train/blanket_8.raw', 128, 128);
blanket_input_image9 = readgrey('train/blanket_9.raw', 128, 128);

% Reading the brick images (1-9)
brick_input_image1 = readgrey('train/brick_1.raw', 128, 128);
brick_input_image2 = readgrey('train/brick_2.raw', 128, 128);
brick_input_image3 = readgrey('train/brick_3.raw', 128, 128); 
brick_input_image4 = readgrey('train/brick_4.raw', 128, 128);
brick_input_image5 = readgrey('train/brick_5.raw', 128, 128);
brick_input_image6 = readgrey('train/brick_6.raw', 128, 128);
brick_input_image7 = readgrey('train/brick_7.raw', 128, 128);
brick_input_image8 = readgrey('train/brick_8.raw', 128, 128);
brick_input_image9 = readgrey('train/brick_9.raw', 128, 128);

% Reading the grass images (1-9)
grass_input_image1 = readgrey('train/grass_1.raw', 128, 128);
grass_input_image2 = readgrey('train/grass_2.raw', 128, 128);
grass_input_image3 = readgrey('train/grass_3.raw', 128, 128);
grass_input_image4 = readgrey('train/grass_4.raw', 128, 128);
grass_input_image5 = readgrey('train/grass_5.raw', 128, 128);
grass_input_image6 = readgrey('train/grass_6.raw', 128, 128);
grass_input_image7 = readgrey('train/grass_7.raw', 128, 128);
grass_input_image8 = readgrey('train/grass_8.raw', 128, 128);
grass_input_image9 = readgrey('train/grass_9.raw', 128, 128);

% Reading the stone images (1-9)
stone_input_image1 = readgrey('train/stones_1.raw', 128, 128);
stone_input_image2 = readgrey('train/stones_2.raw', 128, 128);
stone_input_image3 = readgrey('train/stones_3.raw', 128, 128);
stone_input_image4 = readgrey('train/stones_4.raw', 128, 128);
stone_input_image5 = readgrey('train/stones_5.raw', 128, 128);
stone_input_image6 = readgrey('train/stones_6.raw', 128, 128);
stone_input_image7 = readgrey('train/stones_7.raw', 128, 128);
stone_input_image8 = readgrey('train/stones_8.raw', 128, 128);
stone_input_image9 = readgrey('train/stones_9.raw', 128, 128);

%5x5 filter laws: 
level = [1 4 6 4 1];
edge = [-1 -2 0 2 1];
spot = [-1 0 2 0 -1];
wave = [-1 2 0 -2 1];
ripple = [1 -4 6 -4 1];

%extend the boundry of blanket images and update the feature vectors 

train_blanket_input_image1 = boundry_extension(blanket_input_image1, 128);
update_blanket_input_image1 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image1, 128);

train_blanket_input_image2 = boundry_extension(blanket_input_image2, 128);
update_blanket_input_image2 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image2, 128);

train_blanket_input_image3 = boundry_extension(blanket_input_image3, 128);
update_blanket_input_image3 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image3, 128);

train_blanket_input_image4 = boundry_extension(blanket_input_image4, 128);
update_blanket_input_image4 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image4, 128);

train_blanket_input_image5 = boundry_extension(blanket_input_image5, 128);
update_blanket_input_image5 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image5, 128);

train_blanket_input_image6 = boundry_extension(blanket_input_image6, 128);
update_blanket_input_image6 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image6, 128);

train_blanket_input_image7 = boundry_extension(blanket_input_image7, 128);
update_blanket_input_image7 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image7, 128);

train_blanket_input_image8 = boundry_extension(blanket_input_image8, 128);
update_blanket_input_image8 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image8, 128);

train_blanket_input_image9 = boundry_extension(blanket_input_image9, 128);
update_blanket_input_image9 = update_vector(level, edge, spot, wave, ripple, train_blanket_input_image9, 128);


%extend the boundry of brick images and update the feature vectors 

train_brick_input_image1 = boundry_extension(brick_input_image1, 128);
update_brick_input_image1 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image1, 128);

train_brick_input_image2 = boundry_extension(brick_input_image2, 128);
update_brick_input_image2 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image2, 128);

train_brick_input_image3 = boundry_extension(brick_input_image3, 128);
update_brick_input_image3 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image3, 128);

train_brick_input_image4 = boundry_extension(brick_input_image4, 128);
update_brick_input_image4 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image4, 128);

train_brick_input_image5 = boundry_extension(brick_input_image5, 128);
update_brick_input_image5 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image5, 128);

train_brick_input_image6 = boundry_extension(brick_input_image6, 128);
update_brick_input_image6 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image6, 128);

train_brick_input_image7 = boundry_extension(brick_input_image7, 128);
update_brick_input_image7 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image7, 128);

train_brick_input_image8 = boundry_extension(brick_input_image8, 128);
update_brick_input_image8 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image8, 128);

train_brick_input_image9 = boundry_extension(brick_input_image9, 128);
update_brick_input_image9 = update_vector(level, edge, spot, wave, ripple, train_brick_input_image9, 128);


%extend the boundry of grass images and update the feature vectors 

train_grass_input_image1 = boundry_extension(grass_input_image1, 128);
update_grass_input_image1 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image1, 128);

train_grass_input_image2 = boundry_extension(grass_input_image2, 128);
update_grass_input_image2 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image2, 128);

train_grass_input_image3 = boundry_extension(grass_input_image3, 128);
update_grass_input_image3 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image3, 128);

train_grass_input_image4 = boundry_extension(grass_input_image4, 128);
update_grass_input_image4 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image4, 128);

train_grass_input_image5 = boundry_extension(grass_input_image5, 128);
update_grass_input_image5 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image5, 128);

train_grass_input_image6 = boundry_extension(grass_input_image6, 128);
update_grass_input_image6 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image6, 128);

train_grass_input_image7 = boundry_extension(grass_input_image7, 128);
update_grass_input_image7 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image7, 128);

train_grass_input_image8 = boundry_extension(grass_input_image8, 128);
update_grass_input_image8 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image8, 128);

train_grass_input_image9 = boundry_extension(grass_input_image9, 128);
update_grass_input_image9 = update_vector(level, edge, spot, wave, ripple, train_grass_input_image9, 128);

%extend the boundry of stone images and update the feature vectors 

train_stone_input_image1 = boundry_extension(stone_input_image1, 128);
update_stone_input_image1 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image1, 128);

train_stone_input_image2 = boundry_extension(stone_input_image2, 128);
update_stone_input_image2 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image2, 128);

train_stone_input_image3 = boundry_extension(stone_input_image3, 128);
update_stone_input_image3 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image3, 128);

train_stone_input_image4 = boundry_extension(stone_input_image4, 128);
update_stone_input_image4 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image4, 128);

train_stone_input_image5 = boundry_extension(stone_input_image5, 128);
update_stone_input_image5 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image5, 128);

train_stone_input_image6 = boundry_extension(stone_input_image6, 128);
update_stone_input_image6 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image6, 128);

train_stone_input_image7 = boundry_extension(stone_input_image7, 128);
update_stone_input_image7 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image7, 128);

train_stone_input_image8 = boundry_extension(stone_input_image8, 128);
update_stone_input_image8 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image8, 128);

train_stone_input_image9 = boundry_extension(stone_input_image9, 128);
update_stone_input_image9 = update_vector(level, edge, spot, wave, ripple, train_stone_input_image9, 128);

update_vector_total = [
    update_blanket_input_image1; update_blanket_input_image2; update_blanket_input_image3;
    update_blanket_input_image4; update_blanket_input_image5; update_blanket_input_image6;
    update_blanket_input_image7; update_blanket_input_image8; update_blanket_input_image9;
    update_brick_input_image1; update_brick_input_image2; update_brick_input_image3;
    update_brick_input_image4; update_brick_input_image5; update_brick_input_image6;
    update_brick_input_image7; update_brick_input_image8; update_brick_input_image9;
    update_grass_input_image1; update_grass_input_image2; update_grass_input_image3;
    update_grass_input_image4; update_grass_input_image5; update_grass_input_image6;
    update_grass_input_image7; update_grass_input_image8; update_grass_input_image9;
    update_stone_input_image1; update_stone_input_image2; update_stone_input_image3;
    update_stone_input_image4; update_stone_input_image5; update_stone_input_image6;
    update_stone_input_image7; update_stone_input_image8; update_stone_input_image9
];

%Feature dimension reduction via Principal Component Analysis (PCA)

% Step 1: 'data_matrix' with size [36, 25]
data_matrix = zscore(update_vector_total);  % Standardize the data

% Step 2: Perform PCA
[coeff, ~, ~, ~, ~] = pca(data_matrix);

% Step 3: Select the top 3 principal components
reduced_loadings = coeff(:, 1:3);

% Step 4: Transform the data to 3-dimensional space
reduced_data = data_matrix * reduced_loadings;

% Step 5: Plot the reduced 3-D feature vectors
figure;
scatter3(reduced_data(:,1), reduced_data(:,2), reduced_data(:,3), 'filled');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
zlabel('Principal Component 3');
title('3-D Feature Vectors after PCA');
grid on;

% Function to Extend the Boundry: 
function J = boundry_extension(image, size)
    image_double = double(image);
    
    % Calculate the sum of all elements in the input image
    total_sum = sum(sum(image_double));
    
    % Calculate the mean value
    mean_value = total_sum / (size * size);
    
    % Subtract the mean value from each element of the input image
    subtracted_image = image_double - mean_value;
    
    % Convert the subtracted image to double
    I = double(subtracted_image);

    % Initialize a matrix J with dimensions (size+4) x (size+4) filled with zeros
    J = zeros(size+4, size+4);
    
    % Set the central region of J (excluding extended boundaries) to be
    % equal to the processed image I
    J(3:size+2, 3:size+2) = I;
    
    % Extend the second row of J using the second row of the processed image I
    J(2, 3:size+2) = I(2, :);
    
    % Extend the first row of J using the third row of the processed image I
    J(1, 3:size+2) = I(3, :);
    
    % Extend the (size+3)th row of J using the (size-1)th row of 
    % the processed image I
    J(size+3, 3:size+2) = I(size-1, :);
    
    % Extend the (size+4)th row of J using the (size-2)th row of 
    % the processed image I
    J(size+4, 3:size+2) = I(size-2, :);
    
    % Extend the second column of J using the fourth column of J
    J(:, 2) = J(:, 4);
    
    % Extend the first column of J using the fifth column of J 
    % 5x5 filter bank response computation 
    J(:, 1) = J(:, 5);
    
    % Extend the (size+3)th column of J using the (size+1)th column of J
    J(:, size+3) = J(:, size+1);
    
    % Extend the (size+4)th column of J using the (size)th column of J
    J(:, size+4) = J(:, size);
          
end

%Function to calculate a set of energy features based on input matrices
% Calculate the Average Energy for Each Filter to Form a 25D Feature Vector
% by mult the transpose 

function J = update_vector(level,edge,spot,wave,ripple, extended_image, size)
    l1 = avg_eng(level'*level, extended_image, 128);
    
    l2 = avg_eng(level'*edge, extended_image, 128);
    l3 = avg_eng(level'*spot, extended_image, 128);
    l4 = avg_eng(level'*wave, extended_image, 128);
    l5 = avg_eng(level'*ripple, extended_image, 128);

    e2 = avg_eng(edge'*edge, extended_image, 128);

    e1 = avg_eng(edge'*level, extended_image, 128);
    e3 = avg_eng(edge'*spot, extended_image, 128);
    e4 = avg_eng(edge'*wave, extended_image, 128);
    e5 = avg_eng(edge'*ripple, extended_image, 128);

    s3 = avg_eng(spot'*spot, extended_image, 128);

    s1 = avg_eng(spot'*level, extended_image, 128);
    s2 = avg_eng(spot'*edge, extended_image, 128);
    s4 = avg_eng(spot'*wave, extended_image, 128);
    s5 = avg_eng(spot'*ripple, extended_image, 128);

    w4 = avg_eng(wave'*wave, extended_image, 128);

    w1 = avg_eng(wave'*level, extended_image, 128);
    w2 = avg_eng(wave'*edge, extended_image, 128);
    w3 = avg_eng(wave'*spot, extended_image, 128);
    w5 = avg_eng(wave'*ripple, extended_image, 128);

    r5 = avg_eng(ripple'*ripple, extended_image, 128);

    r1 = avg_eng(ripple'*level, extended_image, 128);
    r2 = avg_eng(ripple'*edge, extended_image, 128);
    r3 = avg_eng(ripple'*spot, extended_image, 128);
    r4 = avg_eng(ripple'*wave, extended_image, 128);

    %call the update feature vector function 
    m1 = ((l2 + e1) / 2);
    m2 = ((e3 + s2) / 2);
    m3 = ((l3 + s1) / 2);
    m4 = ((e4 + w2) / 2);
    m5 = ((l4 + w1) / 2);
    m6 = ((e5 + r2) / 2);
    m7 = ((l5 + r1) / 2);
    m8 = ((s4 + w3) / 2);
    m9 = ((w5 + r4) / 2);
    m10 = ((s5 + r3) / 2);

    eng_vec = [m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, r5, s3, e2, l1, w4];
    J = eng_vec;
end

% Each Pixel Value Needs to be Squared, Then Summed, 
% Then Divided by the Number of Pixels = Average Energy


% find the average energy of a given filter response over the extended boundry 
function energy = avg_eng(filter, extended_image, size)

% Initialize total energy
energy = 0;

% Iterate over each pixel in the extended boundary image
for row = 3:size+2
    for col = 3:size+2
        % Initialize local average
        local_avg = 0;
        
        % Iterate over a 5x5 window around the current pixel
        for i = -2:2
            for j = -2:2
                % Compute the local average by multiplying the pixel
                % values with the corresponding filter values and summing
                local_avg = local_avg + (extended_image(row+i, col+j) * filter(i+3, j+3));
            end
        end
        
        % Store the local average in the filtered response map
        filtered_response(row-2, col-2) = local_avg;
        
        % Compute the energy contribution of the current pixel and add it
        % to the total energy
        energy = energy + ((1/(size*size)) * abs(filtered_response(row-2, col-2)));
    end
end
end