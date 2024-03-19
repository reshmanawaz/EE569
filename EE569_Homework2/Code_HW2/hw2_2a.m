

%row = 500;
%col = 750;

raw = readRawImage('LightHouse.raw',500,750);

figure(1)
imshow(raw);
title('Input Image LightHouse.raw');
Fixed_Thresholding = double(raw);
for row = 1:500
    for col = 1:750
        if raw(row,col)>=0 && raw(row,col)<128
            Fixed_Thresholding(row,col)=0;
        elseif raw(row,col)>=128 && raw(row,col)<256
            Fixed_Thresholding(row,col)=255;
        end
    end
end
figure(2)
imshow(Fixed_Thresholding);
title('Output Image Showing Fixed Thresholding Light House');
