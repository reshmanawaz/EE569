#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <algorithm>

const int original_height = 288;
const int original_width = 420;
const int extended_height = 290; //padding
const int extended_width = 422; //padding
const int rgb = 3;
const int grey = 1;
const int filter_width = 3;

void read_raw_file(char* input_name, unsigned char* original_data)
{
    FILE *filename;
    filename  = fopen(input_name, "rb");

    if(filename  == NULL){
        exit(1);
    }
    fread(original_data, sizeof(unsigned char), original_height * original_width * grey, filename);
    fclose(filename);
}

void write_raw_file(char* input_name, unsigned char* original_data)
{
    FILE *filename;
    filename = fopen(input_name, "wb");
    if(filename == NULL){
        exit(1);
    }
    fwrite(original_data, sizeof(unsigned char), original_height * original_width * rgb, filename);
    fclose(filename);
}

int main(int argc, char* argv[])
{
    // storing the data of the input file 
    unsigned char original_data[original_height][original_width][grey];
    read_raw_file(argv[1], (unsigned char*)original_data);
    // store info about the padded image
    unsigned char mirrored_data[extended_height][extended_width][grey];
    // apply 2d conv
    for (int i = 0; i < original_height; i++)
    {
        for (int j = 0; j < original_width; j++)
        {
            mirrored_data[i + 1][j + 1][0] = original_data[i][j][0];
        }
    }

    for (int j = 0; j < original_width; j++)
    {
        mirrored_data[0][j + 1][0] = original_data[1][j][0];
        mirrored_data[extended_height - 1][j + 1][0] = original_data[original_height - 2][j][0];
    }

    for (int i = 0; i < extended_height; i++)
    {
        mirrored_data[i][0][0] = mirrored_data[i][2][0];
        mirrored_data[i][extended_width - 1][0] = mirrored_data[i][extended_width - 3][0];
    }

    unsigned char demosaic_image_output[original_height][original_width][rgb];

    double conv1[3][3] = {
        {0 , 0.5, 0 },
        {0 , 0 , 0 },
        {0 , 0.5, 0 }
    };
    double conv2[3][3] = {
        {0.25, 0 , 0.25},
        {0 , 0 , 0 },
        {0.25, 0 , 0.25}
    };
    double conv3[3][3] = {
        {0 , 0 , 0 },
        {0.5, 0 , 0.5},
        {0 , 0 , 0 }
    };
    double conv4[3][3] = {
        {0 , 0.25, 0 },
        {0.25, 0 , 0.25},
        {0 , 0.25, 0 }
    };

    for (int i = 1; i < extended_height; i++)
    {
        for (int j = 1; j < extended_width; j++)
        {
            if (i % 2 == 1 && j % 2 == 1)
            {
                demosaic_image_output[i- 1][j- 1][0] = (unsigned char) (mirrored_data[i][j][0] * conv3[0][1] + mirrored_data[i][j][0] * conv3[1][0] + mirrored_data[i][j][0] * conv3[1][2] + mirrored_data[i][j][0] * conv3[2][1]);
                demosaic_image_output[i- 1][j- 1][1] = mirrored_data[i][j][1];
                demosaic_image_output[i- 1][j- 1][2] = (unsigned char) (mirrored_data[i][j][0] * conv1[0][1] + mirrored_data[i][j][0] * conv1[1][0] + mirrored_data[i][j][0] * conv1[1][2] + mirrored_data[i][j][0] * conv1[2][1]);
            }
            else if (i% 2 == 0 && j% 2 == 0)
            {
                demosaic_image_output[i- 1][j- 1][0] = (unsigned char) (mirrored_data[i][j][0] * conv1[0][1] + mirrored_data[i][j][0] * conv1[1][0] + mirrored_data[i][j][0] * conv1[1][2] + mirrored_data[i][j][0] * conv1[2][1]);
                demosaic_image_output[i- 1][j- 1][1] = mirrored_data[i][j][1];
                demosaic_image_output[i- 1][j- 1][2] = (unsigned char) (mirrored_data[i][j][0] * conv3[0][1] + mirrored_data[i][j][0] * conv3[1][0] + mirrored_data[i][j][0] * conv3[1][2] + mirrored_data[i][j][0] * conv3[2][1]);
            }
            else if (i% 2 == 1 && j% 2 == 0)
            {
                demosaic_image_output[i- 1][j- 1][0] = mirrored_data[i][j][0];
                demosaic_image_output[i- 1][j- 1][1] = (unsigned char) (mirrored_data[i][j][0] * conv4[0][1] + mirrored_data[i][j][0] * conv4[1][0] + mirrored_data[i][j][0] * conv4[1][2] + mirrored_data[i][j][0] * conv4[2][1]);
                demosaic_image_output[i- 1][j- 1][2] = (unsigned char) (mirrored_data[i][j][0] * conv2[0][1] + mirrored_data[i][j][0] * conv2[1][0] + mirrored_data[i][j][0] * conv2[1][2] + mirrored_data[i][j][0] * conv2[2][1]);
            }
            else if (i% 2 == 0 && j% 2 == 1)
            {
                demosaic_image_output[i- 1][j- 1][0] = (unsigned char) (mirrored_data[i][j][0] * conv2[0][1] + mirrored_data[i][j][0] * conv2[1][0] + mirrored_data[i][j][0] * conv2[1][2] + mirrored_data[i][j][0] * conv2[2][1]);
                demosaic_image_output[i- 1][j- 1][1] = (unsigned char) (mirrored_data[i][j][0] * conv4[0][1] + mirrored_data[i][j][0] * conv4[1][0] + mirrored_data[i][j][0] * conv4[1][2] +mirrored_data[i][j][0] * conv4[2][1]);
                demosaic_image_output[ - 1][j- 1][2] = mirrored_data[i][j][2];
            }
        }
    }

    // writing the demosaiced image to the output filename
    write_raw_file(argv[2], (unsigned char*)demosaic_image_output);
    return 0;
}

