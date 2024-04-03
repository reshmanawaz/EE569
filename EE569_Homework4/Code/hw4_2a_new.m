// Name: Reshma Nawaz 
// Student ID: 2852-0938-03
// USC: EE569
 

// % Steps: 
// % Define the twenty-five 5x5 Laws Filters.
// % Extend the boundaries of the input image appropriately.
// % Apply each filter to every pixel in the extended image.
// % Compute the response vectors for each pixel.

height = 512;
width = 512;
channels = 1;

Mosaic_raw = imread('composite.png');

figure(1); 
imshow(Mosaic_raw);

% Level [1,4,6,4,1] ->
% Level * Level 
Filter_Matrix(:,:,1) = [1 4 6 4 1; 4 16 24 16 4; 6 24 36 24 6; 4 16 24 16 4; 1 4 6 4 1]; 
% Level * Edge 
Filter_Matrix(:,:,2) = [-1 -2 0 2 1; -4 -8 0 4 8; -6 -12 0 12 6; -4 -8 0 8 4; -1 -2 0 2 1];
% Level * Spot 
Filter_Matrix(:,:,3) = [-1 0 2 0 -1; -4 0 8 0 -4; -6 0 12 0 -6; -4 0 8 0 -4; -1 0 2 0 -1]; 
% Level * Wave 
Filter_Matrix(:,:,4) = [-1 2 0 -2 1; -4 8 0 -8 4; -6 12 0 -12 6; -4 8 0 -8 4; -1 2 0 -2 1];
% Level * Ripple 
Filter_Matrix(:,:,5) = [1 -4 6 -4 1; 4 -16 24 -16 4; 6 -24 36 -24 6; 4 -16 24 -16 4; 1 -4 6 -4 1]; 

% Edge [-1,-2,0,2,1] ->
% Edge * Level
Filter_Matrix(:,:,6) = [-1 -4 -6 -4 -1; -2 -8 -12 -8 -2; 0 0 0 0 0; 2 8 12 8 12; 1 4 6 4 1]; 
% Edge * Edge 
Filter_Matrix(:,:,7) = [1 2 0 -2 -1; 2 4 0 -4 -2; 0 0 0 0 0; -2 -4 0 4 2; -1 -2 0 2 1];
% Edge * Spot 
Filter_Matrix(:,:,8) = [1 0 -2 0 1; 2 0 -4 0 2; 0 0 0 0 0; -2 0 4 0 -2; -1 0 2 0 -1];
% Edge * Wave 
Filter_Matrix(:,:,9) = [1 -2 0 2 -1; 2 -4 0 4 -2; 0 0 0 0 0; -2 4 0 -4 2; -1 2 0 -2 1];
% Edge * Ripple
Filter_Matrix(:,:,10) = [-1 4 -6 4 -1; -2 8 -12 8 -2; 0 0 0 0 0; 2 -8 12 -8 2; 1 -4 6 -4 1]; 

% Spot [-1,0,2,0,-1] ->
% Spot * Level
Filter_Matrix(:,:,11) = [-1 -4 -6 -4 -1; 0 0 0 0 0; 2 8 12 8 2; 0 0 0 0 0; -1 -4 -6 -4 -1]; 
% Spot * Edge 
Filter_Matrix(:,:,12) = [1 2 0 -2 -1; 0 0 0 0 0; -2 -4 0 4 2; 0 0 0 0 0; 1 2 0 -2 -1];
% Spot * Spot 
Filter_Matrix(:,:,13) = [1 0 -2 0 1; 0 0 0 0 0; -2 0 4 0 -2; 0 0 0 0 0; 1 0 -2 0 1]; 
% Spot * Wave 
Filter_Matrix(:,:,14) = [1 -2 0 2 1; 0 0 0 0 0; -2 4 0 -4 2; 0 0 0 0 0; 1 -2 0 2 -1]; 
% Spot * Ripple 
Filter_Matrix(:,:,15) = [-1 4 -6 4 -1; 0 0 0 0 0; 2 -8 12 -8 2; 0 0 0 0 0; -1 4 -6 4 -1]; 

% Wave [-1,2,0,-2,1] ->
% Wave * Level
Filter_Matrix(:,:,16) = [-1 -4 -6 -4 -1; 2 8 12 8 2; 0 0 0 0 0; -2 -8 -12 -8 -2; 1 4 6 4 1];
% Wave * Edge 
Filter_Matrix(:,:,17) = [1 2 0 -2 -1; -2 -4 0 4 2; 0 0 0 0 0; 2 4 0 -4 -2; -1 -2 0 2 1]; 
% Wave * Spot
Filter_Matrix(:,:,18) = [1 0 -2 0 1; -2 0 4 0 -2; 0 0 0 0 0; 2 0 -4 0 2; -1 0 2 0 -1]; 
% Wave * Wave 
Filter_Matrix(:,:,19) = [1 -2 0 2 -1; -2 4 0 -4 2; 0 0 0 0 0; 2 -4 0 4 -2; -1 2 0 -2 1];
% Wave * Ripple 
Filter_Matrix(:,:,20) = [-1 4 -6 4 -1; 2 -8 12 -8 2; 0 0 0 0 0; -2 8 -12 8 -2; 1 -4 6 -4 1]; 

% Ripple [1,-4,6,-4,1] ->
% Ripple * Level 
Filter_Matrix(:,:,21) = [1 4 6 4 1; -4 -16 -24 -16 -4; 6 24 36 24 6; -4 -16 -24 -16 -4; 1 4 6 4 1];
% Ripple * Edge 
Filter_Matrix(:,:,22) = [-1 -2 0 2 1; 4 8 0 -8 -4; -6 -12 0 12 6; 4 8 0 -8 -4; -1 -2 0 2 1];
% Ripple * Spot
Filter_Matrix(:,:,23) = [-1 0 2 0 -1; 4 0 -8 0 4; -6 0 12 0 -6; 4 0 -8 0 4; -1 0 2 0 -1]; 
% Ripple * Wave
Filter_Matrix(:,:,24) = [-1 2 0 -2 1; 4 -8 0 8 -4; -6 12 0 -12 6; 4 -8 0 8 -4; -1 2 0 -2 1]; 
% Ripple * Ripple
Filter_Matrix(:,:,25) = [1 -4 6 -4 1; -4 16 -24 16 -4; 6 -24 36 -24 6; -4 16 -24 16 -4; 1 -4 6 -4 1]; 

Mosaic_Energy_feature = Filter(Mosaic_raw, Filter_Matrix, 39, height, width);

%Normalization
for k=1:24
    NormalisedMean = mean(Mosaic_Energy_feature(:,:,k));
    NormalisedStd = std(Mosaic_Energy_feature(:,:,k));

    for i=1:512
        for j=1:512
            Mosaic_Energy_feature(i, j, k) = (Mosaic_Energy_feature(i, j, k) - NormalisedMean) / NormalisedStd;
        end
    end
end

%Reshape
Mosaic_Reshape = reshape(Mosaic_Energy_feature,[512*512 24]);

%performing k-means clustering
 MaxIters = 100000;
 output_Kmeans = kmeans(Mosaic_Reshape, 5, 'Distance', 'sqeuclidean', 'MaxIter', MaxIters,'OnlinePhase','on');
 label_intensity_map = [0, 63, 127, 191, 255];
 output_Kmeans_reshape = reshape(output_Kmeans, [512 512]);

%initiazlie segmentation output with 0's
 Segmentation_output = zeros(512, 512);

% define the mapping of labels to intensity levels


 for i = 1:512
     for j = 1:512
        % Check for Valid Indeces 
         if output_Kmeans_reshape(i,j) >= 1 && output_Kmeans_reshape(i,j) <= numel(label_intensity_map)
             Segmentation_output(i,j) = label_intensity_map(output_Kmeans_reshape(i,j));
        else
            % fprintf('Index out of bounds at (%d, %d)\n', i, j);
             Segmentation_output(i,j) = 0; 
        end
     end
end

% disp(Segmentation_output);
 Segmentation_output = uint8(Segmentation_output);
 figure(2); 
 imshow(Segmentation_output);

%function to apply the law's filters
function p_energy_out = Filter(data_input, Filter_Matrix, window, height, width)
    vector = {};
    p_energy = zeros(height, width, 25); %pixel energy
    p_energy_out = zeros(height, width, 24); %pixel energy output 
    
    mean = 0;
    for row = 1:512
        for col = 1: 512
            mean = mean + data_input(row,col);
        end
    end
    mean = (mean / (height*width));

     for row = 1:height
         for col = 1:width
             data_input(row,col) = (data_input(row,col)-mean);
         end
     end
      
    pad_img = zeros(516, 516);
    for i = 3:514
        for j = 3:514
            pad_img(i,j) = data_input(i-2,j-2);
        end

    end
    %pad_img(3:514, 3:514) = data_input; 
    
    for filter_index = 1:size(Filter_Matrix,3)
        filters = Filter_Matrix(:,:,filter_index);
        out = zeros(height, width);
        for row = 1: 512
            for col = 1: 512
                out(row,col) = convolution(pad_img, row, col,filters);
            end
        end
        
        vector = [vector, out];
    end
    
   
    for i = 1:25
        
        matrix = cell2mat(vector(i));
        Padding_size = (window-1)/2;
        matrix_mirror_padding = padarray(matrix,[Padding_size Padding_size],'symmetric');
        for row = 1:height
            for col = 1:width
                energy = energy_colvolution(matrix_mirror_padding, row, col, window);
                p_energy(row,col, i) = energy;
            end
        end
    end
    
     
     for i = 1:size(p_energy,1)
         for j = 1:size(p_energy,2)
             for k = 2:size(p_energy,3)
                 p_energy_out(i,j,k-1) = p_energy(i,j,k);
             end
         end
     end
end

%function to compute the energy convolution
function out = energy_colvolution(input_data, row, col, window)
    out = 0;
    for i = 0:window-1
        for j = 0:window-1
            out = out + (input_data(row+i, col+j)*input_data(row+i, col+j));
        end
        out = out /(window * window);
    end
end

%function to perfom the convolution
function out = convolution(input_data, row, col, filter)
    out = 0;
    for i = 0:4
        for j = 0:4
            out = out + (input_data(row+i, col+j) * filter(i+1, j+1));
        end
    end
end






