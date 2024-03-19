% Stucki %


raw=readRawImage('LightHouse.raw',500,750);
figure(1)
imshow(raw);

title('Input Image LightHouse.raw ');
output=raw;
threshold=192;





figure(2);


mul = Stucki_Error_Diffusion(output, threshold);
imshow(uint8(mul));
title('Ouput Image Floyd-Stringerg error diffusion');

function output_image = Stucki_Error_Diffusion(output, threshold)
row = 500;
col = 750;

mul = zeros(size(output)); 

for i=1:row    
    if mod(i,2)~=0
      if i~=row-1
       for j=1:col
           if output(i,j)>threshold 
               mul(i,j)=255;
           else
               mul(i,j)=0;
           end
           error = output(i,j)-mul(i,j);
           if j==1 
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i,j+2)=output(i,j+2)+((4/42)*error);               
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);               
               output(i+2,j)=output(i+2,j)+((4/42)*error);
               output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);
               output(i+2,j+2)=output(i+2,j+2)+((1/42)*error);
           elseif j==2
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i,j+2)=output(i,j+2)+((4/42)*error);
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+1,j+2)=output(i+1,j+2)+((2/42)*error); 
               output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
               output(i+2,j)=output(i+2,j)+((4/42)*error);
               output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);
               output(i+2,j+2)=output(i+2,j+2)+((1/42)*error);
           elseif j==col
               output(i+1,j)=output(i+1,j)+((8/42)*error);              
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
               output(i+2,j)=output(i+2,j)+((4/42)*error);
               output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
               output(i+2,j-2)=output(i+2,j-2)+((1/42)*error);
           elseif j==col-1
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
               output(i+2,j-2)=output(i+2,j-2)+((1/42)*error);
               output(i+2,j)=output(i+2,j)+((4/42)*error);
               output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);             
           else 
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i,j+2)=output(i,j+2)+((4/42)*error);
               output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);               
               output(i+2,j-2)=output(i+2,j-2)+((1/42)*error);               
               output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
               output(i+2,j)=output(i+2,j)+((4/42)*error);
               output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);
               output(i+2,j+2)=output(i+2,j+2)+((1/42)*error);
           end 
       end
      else
          for j=col:-1:1
               if output(i,j)>threshold
                    mul(i,j)=255;
               else
                    mul(i,j)=0;
               end
               error = output(i,j)-mul(i,j);
            if j==1 
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i,j+2)=output(i,j+2)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);              
            elseif j==2
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i,j+2)=output(i,j+2)+((4/42)*error);
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+1,j+2)=output(i+1,j+2)+((2/42)*error); 
           elseif j==col
               output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);              
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
           elseif j==col-1               
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);           
           else 
               output(i,j+1)=output(i,j+1)+((8/42)*error);
               output(i,j+2)=output(i,j+2)+((4/42)*error);
               output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
               output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
               output(i+1,j)=output(i+1,j)+((8/42)*error);
               output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
               output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);
            end 
          end
      end
    else
        if i~=row
            for j=col:-1:1
                if output(i,j)>threshold
                    mul(i,j)=255;
                else
                    mul(i,j)=0;
                end
                error = output(i,j)-mul(i,j);
               if j==col
                   output(i,j-2)=output(i,j-2)+((4/42)*error);
                   output(i,j-1)=output(i,j-1)+((8/42)*error);
                   output(i+2,j-2)=output(i+2,j-2)+((1/42)*error);
                   output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
                   output(i+2,j)=output(i+2,j)+((4/42)*error);
                   output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
                   output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
                   output(i+1,j)=output(i+1,j)+((8/42)*error);
               elseif j==col-1
                   output(i,j-2)=output(i,j-2)+((4/42)*error);
                   output(i,j-1)=output(i,j-1)+((8/42)*error);
                   output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
                   output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
                   output(i+1,j)=output(i+1,j)+((8/42)*error);
                   output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
                   output(i+2,j-2)=output(i+2,j-2)+((1/42)*error);
                   output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
                   output(i+2,j)=output(i+2,j)+((4/42)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);      
               elseif j==1
                   output(i+1,j)=output(i+1,j)+((8/42)*error);
                   output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
                   output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);
                   output(i+2,j)=output(i+2,j)+((4/42)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);
                   output(i+2,j+2)=output(i+2,j+2)+((1/42)*error);
               elseif j==2
                   output(i,j-1)=output(i,j-1)+((8/42)*error);
                   output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
                   output(i+1,j)=output(i+1,j)+((8/42)*error);
                   output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
                   output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);
                   output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
                   output(i+2,j)=output(i+2,j)+((4/42)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);
                   output(i+2,j+2)=output(i+2,j+2)+((1/42)*error);                   
               else
                   output(i,j-2)=output(i,j-2)+((4/42)*error);
                   output(i,j-1)=output(i,j-1)+((8/42)*error);
                   output(i+1,j-2)=output(i+1,j-2)+((2/42)*error);
                   output(i+1,j-1)=output(i+1,j-1)+((4/42)*error);
                   output(i+1,j)=output(i+1,j)+((8/42)*error);
                   output(i+1,j+1)=output(i+1,j+1)+((4/42)*error);
                   output(i+1,j+2)=output(i+1,j+2)+((2/42)*error);
                   output(i+2,j-2)=output(i+2,j-2)+((1/42)*error);
                   output(i+2,j-1)=output(i+2,j-1)+((2/42)*error);
                   output(i+2,j)=output(i+2,j)+((4/42)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((2/42)*error);
                   output(i+2,j+2)=output(i+2,j+2)+((1/42)*error);     
               end   
            end
        else
            for j=col:-1:1
               if output(i,j)>threshold
                    mul(i,j)=255;
               else
                    mul(i,j)=0;
               end
               error = output(i,j)-mul(i,j);
               if j==2
                   output(i,j-1)=output(i,j-1)+((8/42)*error);
               elseif (j==1)
               else
                   output(i,j-2)=output(i,j-2)+((4/42)*error);
                   output(i,j-1)=output(i,j-1)+((8/42)*error);
               end
            end
        end
    end
end
figure(4);
imshow(uint8(mul));
title('output of lighthouse using Stucki Error Diffusion method');
output_image = mul;
end