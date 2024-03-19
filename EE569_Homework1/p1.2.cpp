#include<iostream>

using namespace std;

const int original_height = 340;
const int original_width = 596;
const int rgb = 1;

void read_raw_file(unsigned char* original_image_data, char* original_image)
{
    FILE *raw_file;
    raw_file = fopen(original_image, "rb");
    int product = 340*596*1;

    if(raw_file == NULL){
        exit(1);
    }
    fread(original_image_data, sizeof(unsigned char), product, raw_file);
    fclose(raw_file);
}
void write_raw_file(unsigned char* original_image_data, char* original_image)
{
    FILE *raw_file;
    raw_file = fopen(original_image, "wb");
    if(raw_file == NULL){
        exit(1);
    }
    int product =  596*340; 
    fwrite(original_image_data, sizeof(unsigned char), product, raw_file);
    fclose(raw_file);
}

void transfer_function_method(unsigned char (&original_image_data)[original_height][original_width][rgb], unsigned char (&processed_image_data)[original_height][original_width][rgb])
{
    float np[256] = {0.0};
    float cp[256] = {0.0};
    int freq[256] = {0};
    int x;
    for(int r = 0; r < original_height; r++)
    {
        for(int c = 0; c < original_width; c++)
        {
            x = original_image_data[r][c][0];
            freq[x]++; 
        }
    }
    for(int i = 0; i < 256; i++)
    {
        int prod = 596.0*340.0;
        np[i] = freq[i] / prod;
    }    
    cp[0] = np[0];
    int max = 256; 
    for(int i = 1; i < max; i++)
    {
        cp[i] = cp[i-1] + np[i];
    }
    for(int i = 0; i < original_height; i++)
    {
        for(int j = 0; j < original_width; j++)
        {
            processed_image_data[i][j][0] = (int)255*cp[original_image_data[i][j][0]];
        }
    }
}
void bucket_filling_method(unsigned char (&original_image_data)[original_height][original_width][rgb], unsigned char (&processed_image_data)[original_height][original_width][rgb])
{
    int freq[256] = {0};
    for(int i = 0; i < original_height; i++)
    {
        for(int j = 0; j < original_width; j++)
        {
            freq[original_image_data[i][j][0]]++; 
        }
    }
    int max = 256; 
    int output_binary = (int)(original_height * original_width) / max;
    int current_binary = 0;
    int pix_in_binary = 0;

    for(int i = 0; i < max; i++)
    {
        for(int j = 0; j < original_height; j++)
        {
            for(int k = 0; k < original_width; k++)
            {
                if(original_image_data[j][k][0] == (unsigned char)i)
                {
                    processed_image_data[j][k][0] = (unsigned char)current_binary;
                    pix_in_binary++;
                    if(pix_in_binary > output_binary)
                    {
                        pix_in_binary = 0;
                        current_binary++;
                    }
                }
            }
        }
    }
}

int main(int argc, char* argv[])
{
    // storing the data of the image
    unsigned char original_image_data[original_height][original_width][rgb];
    string method = argv[3];
    // reading the image file
    read_raw_file((unsigned char*)original_image_data, argv[1]);

    // storing the data of the bright image
    unsigned char processed_image_data[original_height][original_width][1];
    if(method == "transfer_function_method"){
        transfer_function_method(original_image_data, processed_image_data);
        write_raw_file((unsigned char*)processed_image_data, argv[2]);
    }else if(method == "bucket_filling_method"){
        bucket_filling_method(original_image_data, processed_image_data);
        write_raw_file((unsigned char*)processed_image_data, argv[3]);
    }else{
        exit(1);
    }
    return 0;
}
