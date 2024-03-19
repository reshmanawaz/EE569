%1 Floyd-Steingberg's error 
%Reading the raw file 
raw=readRawImage('LightHouse.raw',500,750);
figure(1)
imshow(raw);

title('Input Image LightHouse.raw ');
output=raw;
threshold=192;



row = 500;
col = 750;

figure(2);


mul = error_diffusion(output, threshold, row, col);
imshow(uint8(mul));
title('Ouput Image Floyd-Stringerg error diffusion');


function mul = error_diffusion(output, threshold, row, col)
    mul = zeros(size(output)); 
    
    for i = 1:row    
        if mod(i,2) ~= 0
            for j = 1:col
                if output(i,j) > threshold
                    mul(i,j) = 255;
                else
                    mul(i,j) = 0;
                end
                error = output(i,j) - mul(i,j);
                if j == 1 
                    output(i,j+1) = output(i,j+1) + ((7/16) * error);
                    output(i+1,j) = output(i+1,j) + ((5/16) * error);
                    output(i+1,j+1) = output(i+1,j+1) + ((1/16) * error);
                elseif j == col             
                    output(i+1,j-1) = output(i+1,j-1) + ((3/16) * error);
                    output(i+1,j) = output(i+1,j) + ((5/16) * error);
                else 
                    output(i,j+1) = output(i,j+1) + ((7/16) * error);
                    output(i+1,j-1) = output(i+1,j-1) + ((3/16) * error);
                    output(i+1,j) = output(i+1,j) + ((5/16) * error);
                    output(i+1,j+1) = output(i+1,j+1) + ((1/16) * error);
                end 
            end
        else
            if i ~= row
                for j = col:-1:1
                    if output(i,j) > threshold
                        mul(i,j) = 255;
                    else
                        mul(i,j) = 0;
                    end
                    error = output(i,j) - mul(i,j);
                    if j == col
                        output(i,j-1) = output(i,j-1) + ((7/16) * error);
                        output(i+1,j-1) = output(i+1,j-1) + ((1/16) * error);
                        output(i+1,j) = output(i+1,j) + ((5/16) * error);
                    elseif j == 1
                        output(i+1,j) = output(i+1,j) + ((5/16) * error);
                        output(i+1,j+1) = output(i+1,j+1) + ((3/16) * error);
                    else
                        output(i,j-1) = output(i,j-1) + ((7/16) * error);
                        output(i+1,j-1) = output(i+1,j-1) + ((1/16) * error);
                        output(i+1,j) = output(i+1,j) + ((5/16) * error);
                        output(i+1,j+1) = output(i+1,j+1) + ((3/16) * error);                
                    end  
                end
            else
                for j = col:-1:1
                    if output(i,j) > threshold
                        mul(i,j) = 255;
                    else
                        mul(i,j) = 0;
                    end
                    error = output(i,j) - mul(i,j);
                    if j ~= 1
                        output(i,j-1) = output(i,j-1) + ((7/16) * error);
                    end  
                end
            end
        end
    end
end


