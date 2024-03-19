main()

function main()
    input_image = imread('Pig.jpg');
    [R, G, B] = separateRGB(input_image);
    Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;

    [x_norm, y_norm, Y, Y_norm, edge_map] = sobelEdgeDetection(Y);

    figure;
    imshow(uint8(x_norm));
    title('Normalized x-gradient');

    figure;
    imshow(uint8(y_norm));
    title('Normalized y-gradient');

    figure;
    imshow(uint8(Y));
    title('Sobel Edge Detection');

    figure;
    imshow(uint8(Y_norm));
    title('Sobel Edge Detection final');

    figure;
    imshow(uint8(edge_map) * 255);  
    title('Edge Map');
end

function [R, G, B] = separateRGB(rgb_image)
    R = rgb_image(:,:,1);
    G = rgb_image(:,:,2);
    B = rgb_image(:,:,3);
end

function [x_norm, y_norm, Y, Y_norm, edge_map] = sobelEdgeDetection(Y)
    % Convert to double
    X = double(Y);

    % Initialize matrices
    Gx = zeros(size(X));
    Gy = zeros(size(X));
    Y_norm = zeros(size(X));

    % Sobel operator masks
    sobel_x = [-1 0 1; -2 0 2; -1 0 1];
    sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];

    % Perform Sobel edge detection and gradient computation
    for i = 2:size(X, 1) - 1
        for j = 2:size(X, 2) - 1
            % Compute gradients using Sobel masks
            Gx_val = sum(sum(sobel_x .* X(i - 1:i + 1, j - 1:j + 1)));
            Gy_val = sum(sum(sobel_y .* X(i - 1:i + 1, j - 1:j + 1)));

            % Gradient magnitude
            G = sqrt(Gx_val .^ 2 + Gy_val .^ 2);
            Y_norm(i, j) = G;

            % Thresholding
            if G > 127
                edge_map(i, j) = 0;
            else
                edge_map(i, j) = 255;
            end

            % Store gradients
            Gx(i, j) = Gx_val;
            Gy(i, j) = Gy_val;
        end
    end

    % Normalize gradients
    x_norm = ((Gx - min(Gx(:))) ./ (max(Gx(:)) - min(Gx(:)))) .* 255;
    y_norm = ((Gy - min(Gy(:))) ./ (max(Gy(:)) - min(Gy(:)))) .* 255;

    % Compute final edge-detected image
    Y = sqrt(Gx.^2 + Gy.^2);

    % Normalize Y
    Y_norm = 255 * ((Y - min(Y(:))) / (max(Y(:)) - min(Y(:))));

    % Thresholding for edge map
    edge_map = Y_norm > 127;
end
