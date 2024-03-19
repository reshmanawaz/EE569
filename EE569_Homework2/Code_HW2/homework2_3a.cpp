#include <iostream>
#include <vector>
#include <cstdlib>
#include <cstdio>

const int image_height = 375;
const int image_width = 500;
const int num_channels = 3;

const double matrix_fs[3][3] = {
    {0.0, 0.0, 0.0},
    {0.0, 0.0, 7.0/16},
    {3.0/16, 5.0/16, 1.0/16}
};

const double mirror_fs_matrix[3][3] = {
    {0.0, 0.0, 0.0},
    {7.0/16.0, 0.0, 0.0},
    {1.0/16.0, 5.0/16.0, 3.0/16.0}
};

unsigned char round_value(double val) {
    if (val > 255)
        return 255;
    else if (val < 0)
        return 0;
    else
        return static_cast<unsigned char>(val);
}

void read_raw_file(const char* file_name, std::vector<std::vector<std::vector<unsigned char> > >& image_data) {
    FILE* file;
    file = fopen(file_name, "rb");
    if (!file) {
        std::cout << "File does not exist" << std::endl;
        exit(1);
    }

    for (int row = 0; row < image_height; row++) {
        for (int col = 0; col < image_width; col++) {
            for (int channel = 0; channel < num_channels; ++channel) {
                fread(&image_data[row][col][channel], sizeof(unsigned char), 1, file);
            }
        }
    }

    fclose(file);
}


void mirror_function(std::vector<std::vector<std::vector<double> > >& mirror, const std::vector<std::vector<std::vector<double> > >& image) {
    int padded_height = image_height + 2;
    int padded_width = image_width + 2;

    for (int k = 0; k < num_channels; k++) {
        for (int row = 0; row < image_height; row++) {
            for (int col = 0; col < image_width; col++) {
                mirror[row + 1][col + 1][k] = image[row][col][k];
            }
        }

        for (int col = 0; col < image_width; col++) {
            mirror[0][col + 1][k] = image[1][col][k]; 
            mirror[padded_height - 1][col + 1][k] = image[image_height - 2][col][k]; 
        }

        for (int row = 0; row < padded_height; row++) {
            mirror[row][0][k] = mirror[row][2][k]; 
            mirror[row][padded_width - 1][k] = mirror[row][padded_width - 3][k]; 
        }
    }
}

void diffusion_process(std::vector<std::vector<std::vector<double> > >& padded_img, std::vector<std::vector<std::vector<unsigned char> > >& image_data, 
                        const double diff_matrix[3][3], const double diff_mirror_matrix[3][3], int padding_size) {
    double error;

    for (int k = 0; k < num_channels; k++) {
        for (int row = 0; row < image_height; row++) {
            if (row % 2 == 0) {
                for (int col = 0; col < image_width; col++) {
                    if (padded_img[row + padding_size][col + padding_size][k] > 0.5) {
                        error = padded_img[row + padding_size][col + padding_size][k] - 1.0;
                        padded_img[row + padding_size][col + padding_size][k] = 1.0;
                    } else {
                        error = padded_img[row + padding_size][col + padding_size][k] - 0.0;
                        padded_img[row + padding_size][col + padding_size][k] = 0.0;
                    }

                    int idx_r = 0;
                    int idx_c = 0;
                    for (int i = row; i <= row + (2*padding_size); i++) {
                        for (int j = col; j <= col + (2*padding_size); j++) {
                            padded_img[i][j][k] += (diff_matrix[idx_r][idx_c] * error);
                            idx_c++;
                        }
                        idx_r++;
                        idx_c = 0;
                    }
                }
            } else {
                for (int col = image_width + (2*padding_size) - 1; col >= (2*padding_size); col--) {
                    if (padded_img[row + padding_size][col - padding_size][k] > 0.5) {
                        error = padded_img[row + padding_size][col - padding_size][k] - 1.0;
                        padded_img[row + padding_size][col - padding_size][k] = 1.0;
                    } else {
                        error = padded_img[row + padding_size][col - padding_size][k] - 0.0;
                        padded_img[row  + padding_size][col - padding_size][k] = 0.0;
                    }

                    int idx_r = 0;
                    int idx_c = 2*padding_size;
                    for (int i = row; i <= row + (2*padding_size); i++) {
                        for (int j = col; j > col - (2*padding_size + 1); j--) {
                            padded_img[i][j][k] += (diff_mirror_matrix[idx_r][idx_c] * error);
                            idx_c--;
                        }
                        idx_r++;
                        idx_c = 2*padding_size;
                    }
                }
            }
        }
    }

    for (int k = 0; k < num_channels; k++) {
        for (int row = 0; row < image_height; row++) {
            for (int col = 0; col < image_width; col++) {
                double temp = 1 - padded_img[row + padding_size][col + padding_size][k];
                image_data[row][col][k] = round_value(255 * temp);
            }
        }
    }
}

void rgb_to_cmy(const std::vector<std::vector<std::vector<unsigned char> > >& image_data, std::vector<std::vector<std::vector<double> > >& cmy_data) {
    for (int row = 0; row < image_height; row++) {
        for (int col = 0; col < image_width; col++) {
            for (int channel = 0; channel < num_channels; ++channel) {
                cmy_data[row][col][channel] = 1 - (image_data[row][col][channel] / 255.0);
            }
        }
    }
}

void write_raw_file(const char* file_name, const std::vector<std::vector<std::vector<unsigned char> > >& output_data) {
    FILE* file;
    file = fopen(file_name, "wb");
    if (!file) {
        std::cout << "Cannot open the file" << std::endl;
        exit(1);
    }

    for (int row = 0; row < image_height; row++) {
        for (int col = 0; col < image_width; col++) {
            for (int channel = 0; channel < num_channels; ++channel) {
                fwrite(&output_data[row][col][channel], sizeof(unsigned char), 1, file);
            }
        }
    }
    fclose(file);
}

int main(int argc, char* argv[]) {
    int filter_size = 3;
    int padded_height = filter_size + image_height - 1;
    int padded_width = filter_size + image_width - 1;

    if (argc < 3) {
        std::cout << "Invalid Command" << std::endl;
        return 1;
    }

    std::vector<std::vector<std::vector<unsigned char> > > image_data(image_height, std::vector<std::vector<unsigned char> >(image_width, std::vector<unsigned char>(num_channels)));
    std::vector<std::vector<std::vector<double> > > padded_image_data(padded_height, std::vector<std::vector<double> >(padded_width, std::vector<double>(num_channels)));
    std::vector<std::vector<std::vector<double> > > cmy_image_data(image_height, std::vector<std::vector<double> >( image_width, std::vector<double>(num_channels)));
    std::vector<std::vector<std::vector<double> > > mirrored_cmy_image_data(padded_height, std::vector<std::vector<double> >(padded_width, std::vector<double>(num_channels)));
    read_raw_file(argv[1], image_data);
    rgb_to_cmy(image_data, cmy_image_data);
    mirror_function(mirrored_cmy_image_data, cmy_image_data);
    diffusion_process(mirrored_cmy_image_data, image_data, matrix_fs, mirror_fs_matrix, 1);
    write_raw_file(argv[2], image_data);

    return 0;
}