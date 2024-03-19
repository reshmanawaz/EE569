
#include <iostream>
#include<string.h>
#include<vector>
#include<math.h>
#include<algorithm>

using namespace std;

const int original_height = 512;
const int original_width = 768;
const int rgb= 1;

void read_raw_file(char* image_name, vector<vector<vector<unsigned char> > > &original_image){
    FILE *file_name;
    file_name = fopen(image_name, "rb");
    if(file_name == NULL){
        exit(1);
    }
    for(int i = 0; i < original_height; i++){
        for(int j = 0; j < original_width; j++){
            fread(&original_image[i][j][0] , sizeof(unsigned char), 1, file_name);
            
        }
    }
    fclose(file_name);
}

void write_raw_file(char* image_name, vector<vector<vector<unsigned char> > > &output_data){
    FILE *file_name;
    file_name = fopen(image_name, "wb");
    if(file_name == NULL){
        exit(1);
    }
    for(int i = 0; i < original_height; i++){
        for(int j = 0; j < original_width; j++){
            fwrite(&output_data[i][j][0], sizeof(unsigned char), 1, file_name);
        }
    }
    fclose(file_name);
}

void mirror_original_image(vector<vector<vector<unsigned char> > > &image_mirror, int size, const vector<vector<vector<unsigned char> > > &original_image) {
    int num_channels = original_image[0][0].size();
    int extended_height = size + original_image.size() - 1;
    int extended_width = size + original_image[0].size() - 1;
    int extend_size = (size - 1) / 2;

    for (int i = 0; i < original_image.size(); i++) {
        for (int j = 0; j < original_image[0].size(); j++) {
            for (int k = 0; k < num_channels; k++) {
                image_mirror[i + extend_size][j + extend_size][k] = original_image[i][j][k];
            }
        }
    }

    for (int i = 0; i < extend_size; i++) {
        for (int j = 0; j < original_image[0].size(); j++) {
            for (int k = 0; k < num_channels; k++) {
                image_mirror[i][j + extend_size][k] = original_image[extend_size - i][j][k];
                image_mirror[extended_height - i - 1][j + extend_size][k] = original_image[original_image.size() - extend_size + i - 1][j][k];
            }
        }
    }

    for (int j = 0; j < extend_size; j++) {
        for (int i = 0; i < extended_height; i++) {
            for (int k = 0; k < num_channels; k++) {
                image_mirror[i][j][k] = image_mirror[i][2 * extend_size - j][k];
                image_mirror[i][extended_width - j - 1][k] = image_mirror[i][extended_width - 2 * extend_size + j - 1][k];
            }
        }
    }
}

unsigned char pixel_val_round(float x){
    int max = 255; 
    if (x < 0)
        return 0;
    else if (x > max)
        return max;
    else
        return static_cast<unsigned char>(x);
}

//generating the Gaussian filter
std::vector<std::vector<double> > generate_gaussian_filter(int size, double prod_factor) {
    std::vector<std::vector<double> > gaussian_filter(size, std::vector<double>(size));

    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            float exp_prod = pow(size / 2 - i, 2) + pow(size / 2 - j, 2);
            gaussian_filter[i][j] = exp(-exp_prod / (2 * 2 * 2)) / prod_factor;
        }
    }
    return gaussian_filter;
}

void apply_gaussian_filter(const std::vector<std::vector<std::vector<unsigned char> > > &mirror, std::vector<std::vector<std::vector<unsigned char> > > &output_data, int size) {
    int padding= size / 2;
    float output = 2 * M_PI * pow(2, 2);

    int num_channels = mirror[0][0].size();

    std::vector<std::vector<double> > gaussian_filter = generate_gaussian_filter(size, output);

    for (int row = padding; row < (original_height + padding); row++) {
        for (int coloumn = padding; coloumn < (original_width + padding); coloumn++) {
            for (int rgb= 0; rgb< num_channels; rgb++) {
                float result = 0;

                for (int i = -padding, rowi = row - padding; i <= padding; i++, rowi++) {
                    for (int j = -padding, coloumnj = coloumn - padding; j <= padding; j++, coloumnj++) {
                        result += mirror[rowi][coloumnj][rgb] * gaussian_filter[i + padding][j + padding];
                    }
                }
                output_data[row - padding][coloumn - padding][rgb] = pixel_val_round(result);
            }
        }
    }
}

void apply_median_filter(vector<vector<vector<unsigned char> > > &mirror, vector<vector<vector<unsigned char> > > &output_data, int size) {
    int padding= size / 2;
    int num_channels = mirror[0][0].size();

    for (int row = padding; row < (mirror.size() - padding); row++) {
        for (int coloumn = padding; coloumn < (mirror[0].size() - padding); coloumn++) {
            for (int rgb= 0; rgb< num_channels; rgb++) {
                vector<unsigned char> intensity;

                for (int i = row - padding; i <= row + padding; i++) {
                    for (int j = coloumn - padding; j <= coloumn + padding; j++) {
                        intensity.push_back(mirror[i][j][rgb]);
                    }
                }
                std::sort(intensity.begin(), intensity.end());
                output_data[row - padding][coloumn - padding][rgb] = intensity[intensity.size() / 2];
            }
        }
    }
}

int main(int argc, char* argv[])
{   
    if(argc < 5)
    {
        return 0;
    }
    int size = atoi(argv[1]);
    int k = atoi(argv[2]);
    int extended_height = size + original_height - 1;
    int extended_width = size + original_width - 1;

    vector<vector<vector<unsigned char> > > original_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (rgb)));
    vector<vector<vector<unsigned char> > > mirrored_image_output(extended_height, vector<vector<unsigned char> > (extended_width, vector<unsigned char> (rgb)));
    vector<vector<vector<unsigned char> > > gaussian_output(original_height+6, vector<vector<unsigned char> > (original_width+6, vector<unsigned char> (rgb)));
    vector<vector<vector<unsigned char> > > output_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (rgb)));
    vector<vector<vector<unsigned char> > > final_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (rgb)));
    
    mirror_original_image(mirrored_image_output, size, original_data);
    apply_median_filter(mirrored_image_output, output_data, size);
    mirror_original_image(gaussian_output, 7, original_data);
    apply_gaussian_filter(gaussian_output, final_data, 7);

    for(int rgb=0; rgb<3; rgb++)
    {
        for(int row=0; row<original_height; row++)
        {
            for(int coloumn=0; coloumn<original_width; coloumn++)
            {
                original_data[row][coloumn][rgb] = 1.4*output_data[row][coloumn][rgb] - 0.4*final_data[row][coloumn][rgb];
            }
        }
    }
    read_raw_file(argv[3], original_data);
    write_raw_file(argv[4], original_data);

    return 0;
}


