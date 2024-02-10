// ImageProcessor.cpp
#include "ImageProcessor.h"
#include <opencv2/imgcodecs.hpp>


ImageProcessor::ImageProcessor(QObject *parent) : QObject(parent) {}

QSize ImageProcessor::getImageSize(const QString &imageUrl) {
    cv::Mat image = loadImage(imageUrl);
    return QSize(image.cols, image.rows);
}

cv::Mat ImageProcessor::loadImage(const QString &imageUrl) {
    cv::Mat image = cv::imread(imageUrl.toStdString());
    return image;
}

