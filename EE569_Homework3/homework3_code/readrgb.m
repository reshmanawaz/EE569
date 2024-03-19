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
