#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

#include <QObject>
#include <opencv2/core.hpp>
#include <QSize>

class ImageProcessor : public QObject
{
    Q_OBJECT

public:
    explicit ImageProcessor(QObject *parent = nullptr);

    Q_INVOKABLE QSize getImageSize(const QString &imageUrl);

private:
    cv::Mat loadImage(const QString &imageUrl);
};

#endif // IMAGEPROCESSOR_H
