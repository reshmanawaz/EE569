% Jarvis, Judice, and Ninke (JJN) 

raw=readRawImage('LightHouse.raw',500,750);
figure(1)
imshow(raw);

title('Input Image LightHouse.raw ');
output=raw;
threshold=192;



%row = 500;
%col = 750;

figure(2);


mul = JJN_Error_Diffusion(output, threshold);
imshow(uint8(mul));
title('Ouput LightHouse Jarvis, Judice and Ninke(JJN) error diffusion');

function output_image = JJN_Error_Diffusion(output, threshold)
mul = zeros(size(output)); 
row = 500;
col = 750;

for i=1:row    
    if mod(i,2)~=0
      if i~=(row-1)
       for j=1:col
           if output(i,j)>threshold
               mul(i,j)=255;
           else
               mul(i,j)=0;
           end
           error = output(i,j)-mul(i,j);
           if j==1
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i,j+2)=output(i,j+2)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);
               output(i+2,j)=output(i+2,j)+((5/48)*error);
               output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);
               output(i+2,j+2)=output(i+2,j+2)+((1/48)*error);
           elseif j==2
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i,j+2)=output(i,j+2)+((5/48)*error);
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+1,j+2)=output(i+1,j+2)+((3/48)*error); 
               output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
               output(i+2,j)=output(i+2,j)+((5/48)*error);
               output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);
               output(i+2,j+2)=output(i+2,j+2)+((1/48)*error);
           elseif j==col
               output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+2,j-2)=output(i+2,j-2)+((1/48)*error);
               output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
               output(i+2,j)=output(i+2,j)+((5/48)*error);
           elseif j==col-1
               output(i,j+1)=output(i,j+1)+((7/48)*error); 
               output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+2,j-2)=output(i+2,j-2)+((1/48)*error);
               output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
               output(i+2,j)=output(i+2,j)+((5/48)*error);
               output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);             
           else 
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i,j+2)=output(i,j+2)+((5/48)*error);              
               output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);               
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);               
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);               
               output(i+2,j-2)=output(i+2,j-2)+((1/48)*error);              
               output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
               output(i+2,j)=output(i+2,j)+((5/48)*error);
               output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);
               output(i+2,j+2)=output(i+2,j+2)+((1/48)*error);
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
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i,j+2)=output(i,j+2)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);              
            elseif j==2
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i,j+2)=output(i,j+2)+((5/48)*error);             
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+1,j+2)=output(i+1,j+2)+((3/48)*error); 
           elseif j==col              
               output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
           elseif j==col-1               
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);           
           else 
               output(i,j+1)=output(i,j+1)+((7/48)*error);
               output(i,j+2)=output(i,j+2)+((5/48)*error);               
               output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);               
               output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
               output(i+1,j)=output(i+1,j)+((7/48)*error);
               output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
               output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);
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
                error=output(i,j)-mul(i,j);
               if j==col                 
                   output(i,j-2)=output(i,j-2)+((5/48)*error);
                   output(i,j-1)=output(i,j-1)+((7/48)*error);                  
                   output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);                 
                   output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
                   output(i+1,j)=output(i+1,j)+((7/48)*error);                   
                   output(i+2,j-2)=output(i+2,j-2)+((1/48)*error);                  
                   output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
                   output(i+2,j)=output(i+2,j)+((5/48)*error);
               elseif j==col-1   
                   output(i,j-2)=output(i,j-2)+((5/48)*error);                   
                   output(i,j-1)=output(i,j-1)+((7/48)*error);
                   output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);                   
                   output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);
                   output(i+1,j)=output(i+1,j)+((7/48)*error);                   
                   output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);                   
                   output(i+2,j-2)=output(i+2,j-2)+((1/48)*error);                   
                   output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
                   output(i+2,j)=output(i+2,j)+((5/48)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);      
               elseif j==1
                   output(i+1,j)=output(i+1,j)+((7/48)*error);
                   output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
                   output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);
                   output(i+2,j)=output(i+2,j)+((5/48)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);
                   output(i+2,j+2)=output(i+2,j+2)+((1/48)*error);
               elseif j==2
                   output(i,j-1)=output(i,j-1)+((7/48)*error);
                   output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);                  
                   output(i+1,j)=output(i+1,j)+((7/48)*error);
                   output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
                   output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);                  
                   output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);
                   output(i+2,j)=output(i+2,j)+((5/48)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);
                   output(i+2,j+2)=output(i+2,j+2)+((1/48)*error);                   
               else                   
                   output(i,j-2)=output(i,j-2)+((5/48)*error);
                   output(i,j-1)=output(i,j-1)+((7/48)*error);                  
                   output(i+1,j-2)=output(i+1,j-2)+((3/48)*error);
                   output(i+1,j-1)=output(i+1,j-1)+((5/48)*error);                   
                   output(i+1,j)=output(i+1,j)+((7/48)*error);                   
                   output(i+1,j+1)=output(i+1,j+1)+((5/48)*error);
                   output(i+1,j+2)=output(i+1,j+2)+((3/48)*error);                   
                   output(i+2,j-2)=output(i+2,j-2)+((1/48)*error);                   
                   output(i+2,j-1)=output(i+2,j-1)+((3/48)*error);                   
                   output(i+2,j)=output(i+2,j)+((5/48)*error);
                   output(i+2,j+1)=output(i+2,j+1)+((3/48)*error);
                   output(i+2,j+2)=output(i+2,j+2)+((1/48)*error);     
               end 
            end
        else
            for j=col:-1:1
               if output(i,j)>threshold
                    mul(i,j)=255;
               else
                    mul(i,j)=0;
               end
               e = output(i,j)-mul(i,j);
               if j==2
                   output(i,j-1)=output(i,j-1)+((7/48)*error);
               elseif (j==1)
               else                   
                   output(i,j-2)=output(i,j-2)+((5/48)*error);
                   output(i,j-1)=output(i,j-1)+((7/48)*error);
               end
            end
        end
    end
end

figure(3);
imshow(uint8(mul));
title('Output lighthouse image of JJN Error Diffusion');
output_image =mul;
end