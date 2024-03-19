function Z = readRawImage(filename, row, col)
    % Open the raw file
    fin = fopen(filename, 'r');
    if fin == -1
        error('Unable to open the raw file.');
    end

    % Read the pixel values
    I = fread(fin, row * col, 'uint8=>uint8');
    fclose(fin);

    % Reshape the pixel values into the image matrix
    Z = reshape(I, col, row)'; % Transpose to match MATLAB's convention

    % Display the image
    imshow(Z);
    title('Raw Image');
end