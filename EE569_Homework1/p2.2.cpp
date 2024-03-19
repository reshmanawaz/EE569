#include<string.h>
#include<vector>
#include<math.h>
#include <iostream>

using namespace std;

//const int channels = 1;
const int grey = 1;
const int original_height = 512;
const int original_width = 768;

// function for reading raw file
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
    cout<<"a";
    fclose(file_name);
}

// function for writing raw file
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
//mirroring.
void mirror_original_image(vector<vector<vector<unsigned char> > > &image_mirror, int filter_size, const vector<vector<vector<unsigned char> > > &original_image) {
    int extended_height = filter_size + original_image.size() - 1;
    int extended_width = filter_size + original_image[0].size() - 1;
    int size = (filter_size - 1) / 2;

    for (int i = 0; i < original_image.size(); i++) {
        for (int j = 0; j < original_image[0].size(); j++) {
            image_mirror[i + size][j + size][0] = original_image[i][j][0];
            // cout<<"\n i+ size ="<<(i+ size)<<"\t j+size ="<<(j+size);
        }
    }

    for (int i = 0; i < size; i++) {
        for (int j = 0; j < original_image[0].size(); j++) {
            image_mirror[i][j + size][0] = original_image[size - i][j][0];
            // cout<<"\n i ="<<i<<"\t j+ size ="<<(j+ size);
            image_mirror[extended_height - i - 1][j + size][0] = original_image[original_image.size() - size + i - 1][j][0];
            // cout<<"\n extended_height - i - 1 ="<<(extended_height - i - 1)<<"\t j+ size ="<<(j+ size);
        }
    }

    for (int j = 0; j < size; j++) {
        for (int i = 0; i < extended_height; i++) {
            image_mirror[i][j][0] = image_mirror[i][2 * size - j][0];
            // cout<<"\n i ="<<i<<"\t j ="<<j;
            image_mirror[i][extended_width - j - 1][0] = image_mirror[i][extended_width - 2 * size + j - 1][0];
            // cout<<"\n i ="<<i<<"\t extended_width - j - 1 ="<<(extended_width - j - 1);
        }
    }
}
// pixel rounding off 
unsigned char pixel_val_round(float x){
    int max = 255; 
    if (x < 0)
        return 0;
    else if (x > max)
        return max;
    else
        return static_cast<unsigned char>(x);
}

void calc_psnr(vector<vector<vector<unsigned char> > > &original_image, const vector<vector<vector<unsigned char> > > &output_image){
    int image_height = original_image.size();
    int image_width = original_image[0].size();
    double mean_squared_error = 0.0;

    //base case check
    if (image_height != output_image.size() || image_width != output_image[0].size()){
        return;
    }

    // calc the mse 
    for (int row = 0; row < image_height; row++){
        for (int column = 0; column < image_width; column++){
            double pixel_difference = static_cast<double>(output_image[row][column][0]) - static_cast<double>(original_image[row][column][0]);
            mean_squared_error += pow(pixel_difference, 2);
        }
    }
    // average of the MSE 
    mean_squared_error = mean_squared_error / (image_height * image_width);

    //base case check of the mse  
    if (mean_squared_error < 1e-10){
        return;
    }

    double psnr_output = 10 * log10((255.0 * 255.0) / mean_squared_error);

    //output the calculated PSNR value
    std::cout << "PSNR Output: " << psnr_output << " dB" << std::endl;
}
//bilateral filtering 
void apply_bilateral_filter(vector<vector<vector<unsigned char> > > &mirror, vector<vector<vector<unsigned char> > > &output_data, double sigma_c_value, double sigma_s_value, int size) {
    const int extend_size = size / 2;
    const int num_channels = mirror[0][0].size();

    for (int row = extend_size; row < (mirror.size() - extend_size); row++) {
        for (int col = extend_size; col < (mirror[0].size() - extend_size); col++) {
            for (int channel = 0; channel < num_channels; channel++) {
                double numerator = 0.0;
                double denominator = 0.0;

                for (int i = row - extend_size; i <= row + extend_size; i++) {
                    for (int j = col - extend_size; j <= col + extend_size; j++) {
                        const double spatial_term = exp(-((row - i) * (row - i) + (col - j) * (col - j)) / (2 * sigma_c_value * sigma_c_value));
                        const double intensity_term = exp(-(mirror[row][col][channel] - mirror[i][j][channel]) * (mirror[row][col][channel] - mirror[i][j][channel]) / (2 * sigma_s_value * sigma_s_value));

                        const double weight = spatial_term * intensity_term;

                        numerator += weight * mirror[i][j][channel];
                        denominator += weight;
                    }
                }
                output_data[row - extend_size][col - extend_size][channel] = pixel_val_round(numerator / denominator);
            }
        }
    }
}
int main(int argc, char* argv[])
{    //initializing
    int size = atoi(argv[2]);
    int extended_height = size + original_height - 1;
    int extended_width = size + original_width - 1;
    double sigma_c_value = atof(argv[3]);
    double sigma_s_value = atof(argv[4]);
    vector<vector<vector<unsigned char> > > original_image(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (grey)));
    vector<vector<vector<unsigned char> > > image_mirror(extended_height, vector<vector<unsigned char> > (extended_width, vector<unsigned char> (grey)));
    vector<vector<vector<unsigned char> > > output_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (grey)));
    vector<vector<vector<unsigned char> > > original_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (grey)));
    cout<<"\n main ";
    read_raw_file(argv[1], original_image);//reading b 
    cout<<"\n reading done original_image";
    mirror_original_image(image_mirror, size, original_image);
    cout<<"\n Mirroring done";
    apply_bilateral_filter(image_mirror, output_data, sigma_c_value, sigma_s_value, size);
    cout<<"\n done bilateral filtering ";
    read_raw_file(argv[5], original_data);//reading a 
    cout<<"\n done reading another raw file ";
    calc_psnr(original_data, output_data);
    cout<<"\n done calculate print print psnr ";
    write_raw_file(argv[6], output_data);
    cout<<"\n done write output image";
    return 0;
}
