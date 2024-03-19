#include <iostream>
#include <fstream>
#include <vector>
#include <opencv2/opencv.hpp>


cv::Mat denoiseImage(const cv::Mat& inputImage, float filteringParameter, int templateSize, int searchSize) {
    cv::Mat output;
    cv::fastNlMeansDenoising(inputImage, output, filteringParameter, templateSize, searchSize);
    return output;
}
void saveImageToRaw(const cv::Mat& image, const char* filePath) {
    std::ofstream outFile(filePath, std::ios::binary);
    if (!outFile) {
        exit(-1);
    }
    outFile.write(reinterpret_cast<const char*>(image.data), image.total() * image.elemSize());
    outFile.close();
}
cv::Mat readRawImage(const char* filePath, int width, int height) {
    std::ifstream file(filePath, std::ios::binary);
    if (!file) {
        exit(-1);
    }
    std::vector<unsigned char> buffer(std::istreambuf_iterator<char>(file), {});
    cv::Mat image(height, width, CV_8UC1, buffer.data());
    return image;
}

int main(int argc, char* argv[]) {
    const char* original_image =  argv[1];
    int original_width = 768;
    int original_height = 512;
    cv::Mat output_image = readRawImage(original_image, original_width, original_height);
    float filteringParameter = atof(argv[2]);  
    int templateSize = atoi(argv[3]);
    int searchSize = atoi(argv[4]);
    cv::Mat output = denoiseImage(output_image, filteringParameter, templateSize, searchSize);
    const char* outputFilePath = "output_image2.3.raw";
    saveImageToRaw(output, outputFilePath);
    return 0;
}

