#include<iostream>
#include<string.h>
using namespace std;


const int original_height = 422;
const int original_width = 750;
const int rgb = 3;


void read_raw_file(unsigned char* input_file, char* original_image)
{
    FILE *raw_file;
    raw_file = fopen(original_image, "rb");

    if(raw_file == NULL){
        exit(1);
    }

    fread(input_file, sizeof(unsigned char), original_height*original_width*rgb, raw_file);
    fclose(raw_file);
}

void raw_write(unsigned char* data_defogged_image, char* original_image)
{
    FILE *raw_file;
    raw_file = fopen(original_image, "wb");

    if(raw_file == NULL){
        exit(1);
    }

    fwrite(data_defogged_image, sizeof(unsigned char), original_height*original_width*rgb, raw_file);
    fclose(raw_file);
}

unsigned char x_round_off(float round)

{
    int max = 255;
    if(round < 0)
        return 0;
    else if(round > max)
        return max;
    else return (unsigned char)round;
}


// function to convert RGB to YUV (Luminance, Chrominance):
void rgb_to_yuv(unsigned char (&input_file)[original_height][original_width][rgb])
{
    int y, u, v;
    for(int i = 0; i < original_height; i++)
    {
        for(int j = 0; j < original_width; j++)
        {
            y = x_round_off((0.257 * input_file[i][j][0]) + (0.504 * input_file[i][j][1]) + (0.098 * input_file[i][j][2]) + 16);
            u = x_round_off(-(0.148 * input_file[i][j][0]) - (0.291 * input_file[i][j][1]) + (0.439 * input_file[i][j][2]) + 128); 
            v = x_round_off((0.439 * input_file[i][j][0]) - (0.368 * input_file[i][j][1]) - (0.071 * input_file[i][j][2]) + 128);  
            input_file[i][j][0] = y;
            input_file[i][j][1] = u;
            input_file[i][j][2] = v;
        }
    }    
}

void defog(unsigned char (&input_file)[original_height][original_width][rgb], unsigned char (&data_defogged_image)[original_height][original_width][rgb])
{
    // finding frequencies of xs
    int freq[256] = {0};

    for(int r = 0; r < original_height; r++)
    {
        for(int c = 0; c < original_width; c++)
        {
            freq[input_file[r][c][0]]++; 
        }
    }
    int xs_per_binary = (int)(original_height * original_width) / 256;
    int current_binary = 0;
    int pix_in_binary = 0;

    for(int i = 0; i < 256; i++)
    {
        for(int r = 0; r < original_height; r++)
        {
            for(int c = 0; c < original_width; c++)
            {
                if(input_file[r][c][0] == (unsigned char)i)
                {
                    data_defogged_image[r][c][0] =  (unsigned char)current_binary;
                    pix_in_binary++;
                    if(pix_in_binary > xs_per_binary)
                    {
                        pix_in_binary = 0;
                        current_binary++;
                    }
                }
            }
        }
    }
    //copying the chrominance (color information) values from the original foggy image 
    for(int i = 0; i < original_height; i++)
    {
        for(int j = 0; j < original_width; j++)
        {
            //focus is on intensity values stored in red at index 0
            data_defogged_image[i][j][1] = input_file[i][j][1];
            data_defogged_image[i][j][2] = input_file[i][j][2];

        }
    }
}

void histogram_man(unsigned char (&input_file)[original_height][original_width][rgb])
{
    int x;
    int freq[256] = {0};
    float np[256] = {0.0};
    float cp[256] = {0.0};

    for(int row = 0; row < original_height; row++)
    {
        for(int col = 0; col < original_width; col++)
        {
            x = input_file[row][col][0];
            freq[x]++; 
        }
    }

    int max = 256; 
    for(int i = 0; i < max; i++)
    {
        np[i] = freq[i] / (750.0*422.0);
    }    

    cp[0] = np[0];
    for(int i = 1; i < max; i++)
    {
        cp[i] = cp[i-1] + np[i];
    }
    for(int i = 0; i < original_height; i++)
    {
        for(int j = 0; j < original_width; j++)
        {
            input_file[i][j][0] = (int)255*cp[input_file[i][j][0]];
        }
    }
}

void yuv_to_rgb(unsigned char (&input_file)[original_height][original_width][rgb], char* path) 
{
    int red, green, blue;
    for(int i = 0; i < original_height; i++)
    {
        for(int j = 0; j < original_width; j++)
        {
            red = x_round_off(1.164 * (input_file[i][j][0] - 16) + 1.596 * (input_file[i][j][2] - 128));
            green = x_round_off(1.164 * (input_file[i][j][0] - 16) - 0.813 * (input_file[i][j][2] - 128) - 0.319 * (input_file[i][j][1] - 128)); 
            blue = x_round_off(1.164 * (input_file[i][j][0] - 16) + 2.018 * (input_file[i][j][1] - 128));  
            input_file[i][j][0] = red;
            input_file[i][j][1] = green;
            input_file[i][j][2] = blue;
        }
    } 
    raw_write((unsigned char*)input_file,path);
}

int main(int argc, char* argv[])
{
    
    if (argc < 4) {
        cout << "Usage: " << argv[0] << " <input_file> <output_file> <method>" << endl;
        exit(1);
    }
    string method = argv[3];
    unsigned char input_file[original_height][original_width][rgb];
    read_raw_file((unsigned char*)input_file, argv[1]);

    //memory allocation
    cout << "Address of argv[0]: " << static_cast<void*>(argv[0]) << endl;
    cout << "Address of argv[1]: " << static_cast<void*>(argv[1]) << endl;
    cout << "Address of argv[2]: " << static_cast<void*>(argv[2]) << endl;
    cout << "Address of argv[3]: " << static_cast<void*>(argv[3]) << endl;

    rgb_to_yuv(input_file);

    if(method == "transfer_function_method"){
        histogram_man(input_file);
    }else if(method == "bucket_filling_method"){
        unsigned char  data_defogged_image[original_height][original_width][rgb];
        defog(input_file,  data_defogged_image);
    }else{
        exit(1);
    }
    yuv_to_rgb(input_file, argv[2]); //convert back
    return 0;
}
