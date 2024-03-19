
%row = 500;
%col = 750;
raw = readRawImage('LightHouse.raw',500,750);
Random_Threshold = double(raw);

random = zeros(500,750);

for row = 1:500
    for col = 1:750
        random(row,col) = randi([0,255]);
        if raw(row,col)>=0 && raw(row,col)<random(row,col)
            Random_Threshold(row,col)=0;
        elseif raw(row,col)>=raw(row,col) && raw(row,col)<256
            Random_Threshold(row,col)=255;
        end
    end
end
figure(3)
imshow(Random_Threshold);
title('Output Image Showing Random Thresholding of Light House Image');