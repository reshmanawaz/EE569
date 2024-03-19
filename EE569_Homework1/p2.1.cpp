
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

void mirror_original_image(vector<vector<vector<unsigned char> > > &image_mirror, int size, const vector<vector<vector<unsigned char> > > &original_image) {
    int extended_height = size + original_image.size() - 1;
    int extended_width = size + original_image[0].size() - 1;
    int padding_size = (size - 1) / 2;

    for (int i = 0; i < original_image.size(); i++) {
        for (int j = 0; j < original_image[0].size(); j++) {
            image_mirror[i + padding_size][j + padding_size][0] = original_image[i][j][0];
        }
    }

    for (int i = 0; i < padding_size; i++) {
        for (int j = 0; j < original_image[0].size(); j++) {
            image_mirror[i][j + padding_size][0] = original_image[padding_size - i][j][0];
            image_mirror[extended_height - i - 1][j + padding_size][0] = original_image[original_image.size() - padding_size + i - 1][j][0];
        }
    }

    for (int j = 0; j < padding_size; j++) {
        for (int i = 0; i < extended_height; i++) {
            image_mirror[i][j][0] = image_mirror[i][2 * padding_size - j][0];
            image_mirror[i][extended_width - j - 1][0] = image_mirror[i][extended_width - 2 * padding_size + j - 1][0];
        }
    }
}

//generating the mean filter
std::vector<std::vector<double> > generate_mean_filter(int size){
    std::vector<std::vector<double> > mean_filter(size, std::vector<double>(size, 1.0 / (size * size)));
    return mean_filter;
}

//generating the Gaussian filter
std::vector<std::vector<double> > generate_gaussian_filter(int size, double sigma)
{
    std::vector<std::vector<double> > gaussian_filter(size, std::vector<double>(size));
    double prod = 2 * M_PI * pow(sigma, 2);

    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            double exp_prod = pow(size / 2.0 - i, 2) + pow(size / 2.0 - j, 2);
            gaussian_filter[i][j] = exp(-(exp_prod) / (2 * pow(sigma, 2))) / prod;
        }
    }
    return gaussian_filter;
}

//identifying which filter needs to be called 
std::vector<std::vector<double> > call_filter(int size, const std::string &filter_type, double sigma){
    if (filter_type == "mean"){
        return generate_mean_filter(size);
    }else if (filter_type == "gaussian"){
        return generate_gaussian_filter(size, sigma);
    }else{
        return std::vector<std::vector<double> >();
    }
}

// rounding off the pixel value 
unsigned char pixel_val_round(float x){
    int max = 255; 
    if (x < 0)
        return 0;
    else if (x > max)
        return max;
    else
        return static_cast<unsigned char>(x);
}

// convolution function:
void perform_convolution(vector<vector<vector<unsigned char> > > &original_image, 
vector<vector<vector<unsigned char> > > &output_data, 
int filter_size, vector<vector<double> > convolution_filter){
    float result = 0.0;
    int filter_row = 0;
    int filter_col = 0;
    int input_height = original_height;
    int input_width = original_width;
    int padding = filter_size / 2;

    //iterate over each pixel in the input image 
    for (int row = padding; row < (input_height + padding); row++){
        for (int column = padding; column < (input_width + padding); column++){
            //inilize the convolution of the for the current pixel 
            result = 0;
            filter_row = 0;
            //cout<<"\n result="<< result;
            //cout<<"\t row="<<row;
            //cout<<"\t column"<<column;
            //cout<<"\t filter_row ="<<filter_row;
            //cout<<"\t filter_column="<<filter_col;
            

            //filter matrix 
            for (int i = row - padding; i <= row + padding; i++){
                filter_col = 0;
                for (int j = column - padding; j <= column + padding; j++){
                    //input pixel*filter element 
                    //cout<<"\n i="<<i;
                    //cout<<"\t j="<<j;
                    //cout<<"\t filter_row ="<<filter_row;
                    //cout<<"\t filter_column="<<filter_col;
                    float product = original_image[i][j][0] * convolution_filter[filter_row][filter_col];

                    result += product;
                    //cout<<"\n Result"<<result;
                    filter_col++;
                }
                filter_row++;
            }
            //the output from the calc is stored in the output_data 
            output_data[row - padding][column - padding][0] = pixel_val_round(result);
        }
    }
}

// calc Peak Signal-to-Noise Ratio (PSNR) between images 
void calculate_and_print_psnr(const vector<vector<vector<unsigned char> > > &original_image, const vector<vector<vector<unsigned char> > > &output_image){
    int image_height = original_image.size();
    int image_width = original_image[0].size();
    double mean_squared_error = 0.0;

    //base case check
    if (image_height != output_image.size() || image_width != output_image[0].size()){
        cout << "error: image dimensions are not a match." << endl;
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
        cout<< "error found: the mse is close to 0" << std::endl;
        return;
    }

    double psnr_output = 10 * log10((255.0 * 255.0) / mean_squared_error);

    //output the calculated PSNR value
    std::cout << "PSNR Output: " << psnr_output << " dB" << std::endl;
}

int main(int argc, char* argv[])
{    //initializing
    int size = atoi(argv[2]);
    int extended_height = size + original_height - 1;
    int extended_width = size + original_width - 1;
    string filter_type = argv[4];
    double sigma = atof(argv[3]);
    //creating and initializing a 3D vector 
    vector<vector<vector<unsigned char> > > original_image(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (grey)));
    vector<vector<vector<unsigned char> > > image_mirror(extended_height, vector<vector<unsigned char> > (extended_width, vector<unsigned char> (grey)));
    vector<vector<vector<unsigned char> > > output_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (grey)));
    vector<vector<vector<unsigned char> > > original_data(original_height, vector<vector<unsigned char> > (original_width, vector<unsigned char> (grey)));
    vector<vector<double> > filter = call_filter(size, filter_type, sigma);
    read_raw_file(argv[1], original_image);//reading b 
    mirror_original_image(image_mirror, size, original_image);
    perform_convolution(image_mirror, output_data, size, filter);
    read_raw_file(argv[5], original_data);//reading a 
    calculate_and_print_psnr(original_data, output_data);
    write_raw_file(argv[6], output_data);
    return 0;
}
