% Reading the image (dog)
input_image = readrgb('dog.raw', 328, 328);
figure(1);
imshow(input_image);
title('Input Image: Dog');

% Process the image with elliptical star mapping
warped_image = elliptical_star_mapping(input_image);

% Display the warped image
figure(2);
imshow(warped_image);
title('Warped Image: Dog');

reverse_warped_image = reverse_elliptical_star_mapping(warped_image);
% Display the warped image
figure(3);
imshow(reverse_warped_image);
title('Reverse Warped Image: Dog');

% Reading the image (cat)
cat_input_image = readrgb('cat.raw', 328, 328);
figure(4);
imshow(cat_input_image);
title('Input Image: Cat');

% Process the image with elliptical star mapping
cat_warped_image = elliptical_star_mapping(cat_input_image);

% Display the warped image
figure(5);
imshow(cat_warped_image);
title('Warped Image: Cat');

reverse_warped_image_cat = reverse_elliptical_star_mapping(cat_warped_image);
% Display the warped image
figure(6);
imshow(reverse_warped_image_cat);
title('Reverse Warped Image: Cat');

function O = elliptical_star_mapping(I)
    % Initialize output image
    O = zeros(328, 328, 3, 'uint8');

    % Extract RGB channels from input image
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    % Top triangle
    for r = 1:164
        for c = r:(328 - r)
            u = round((0.2171 * r) + (0.7829 * c) + (0.0025 * r * r) + (-0.0001 * r * c) + (-0.0024 * c * c));
            v = c;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                O(u, v, 1) = R(r, c);
                O(u, v, 2) = G(r, c);
                O(u, v, 3) = B(r, c);
            end
        end
    end

    % Bottom triangle
    i = 1;
    for r = 165:328
        for c = (164 - i):(164 + i)
            u = round((1.7733 * r) + (-0.7733 * c) + (-0.0024 * r * r) + (0.0024 * c * c));
            v = c;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                O(u, v, 1) = R(r, c);
                O(u, v, 2) = G(r, c);
                O(u, v, 3) = B(r, c);
            end
        end
        i = i + 1;
    end

    % Left triangle
    for c = 1:164
        for r = c:(328 - c)
            v = round((0.7829 * r) + (0.2171 * c) + (-0.0024 * r * r) + (0.0024 * c * c));
            u = r;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                O(u, v, 1) = R(r, c);
                O(u, v, 2) = G(r, c);
                O(u, v, 3) = B(r, c);
            end
        end
    end

    % Right triangle
    i = 1;
    for c = 165:328
        for r = (164 - i):(164 + i)
            v = round((-0.7733 * r) + (1.7733 * c) + (0.0024 * r * r) + (-0.0024 * c * c));
            u = r;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                O(u, v, 1) = R(r, c);
                O(u, v, 2) = G(r, c);
                O(u, v, 3) = B(r, c);
            end
        end
        i = i + 1;
    end
end

function I = reverse_elliptical_star_mapping(O)
    % Initialize input image
    I = zeros(328, 328, 3, 'uint8');

    % Extract RGB channels from output image
    R = O(:,:,1);
    G = O(:,:,2);
    B = O(:,:,3);

    % Reverse mapping for top triangle
    for r = 1:164
        for c = r:(328 - r)
            u = round((0.2171 * r) + (0.7829 * c) + (0.0025 * r * r) + (-0.0001 * r * c) + (-0.0024 * c * c));
            v = c;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                I(r, c, 1) = R(u, v);
                I(r, c, 2) = G(u, v);
                I(r, c, 3) = B(u, v);
            end
        end
    end

    % Reverse mapping for bottom triangle
    i = 1;
    for r = 165:328
        for c = (164 - i):(164 + i)
            u = round((1.7733 * r) + (-0.7733 * c) + (-0.0024 * r * r) + (0.0024 * c * c));
            v = c;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                I(r, c, 1) = R(u, v);
                I(r, c, 2) = G(u, v);
                I(r, c, 3) = B(u, v);
            end
        end
        i = i + 1;
    end

    % Reverse mapping for left triangle
    for c = 1:164
        for r = c:(328 - c)
            v = round((0.7829 * r) + (0.2171 * c) + (-0.0024 * r * r) + (0.0024 * c * c));
            u = r;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                I(r, c, 1) = R(u, v);
                I(r, c, 2) = G(u, v);
                I(r, c, 3) = B(u, v);
            end
        end
    end

    % Reverse mapping for right triangle
    i = 1;
    for c = 165:328
        for r = (164 - i):(164 + i)
            v = round((-0.7733 * r) + (1.7733 * c) + (0.0024 * r * r) + (-0.0024 * c * c));
            u = r;
            if u >= 1 && u <= 328 && v >= 1 && v <= 328
                I(r, c, 1) = R(u, v);
                I(r, c, 2) = G(u, v);
                I(r, c, 3) = B(u, v);
            end
        end
        i = i + 1;
    end
end
