%row = 500;
%col = 750;
raw = readRawImage('LightHouse.raw',500,750);
Dithering = double(raw);
I2 = [1 2;3 0];
I4 = [((4*I2)+1) ((4*I2)+2);((4*I2)+3) ((4*I2))];
I8 = [((4*I4)+1) ((4*I4)+2);((4*I4)+3) ((4*I4))];
I16 = [((4*I8)+1) ((4*I8)+2);((4*I8)+3) ((4*I8))];
I32 = [((4*I16)+1) ((4*I16)+2);((4*I16)+3) ((4*I16))];

N = 2;
T = zeros(N,N);
for x = 1:N
    for y = 1:N
        T(x,y) = ((I2(x,y)+0.5)/(N^2))*255;
    end
end

Dithering_Matrix = double(raw);
for row = 1:500
    for col = 1:750
        if raw(row,col)<T(mod(row,N)+1,mod(col,N)+1)
            Dithering_Matrix(row,col)=0;
        else
            Dithering_Matrix(row,col)=255;
        end
    end
end
figure(4)
imshow(Dithering_Matrix);
title('Output Showing Light House Image with Dithering 4X4');