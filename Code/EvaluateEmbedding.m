clc; close all; clear variables;

img = imread('lena512.bmp');
watermark = imread('Copyright.png');

[wm_img, rec_wm, test_results] = ...
    EvaluateWatermark(@DWT_SVDWatermarkEmbedding, ...
    @DWT_SVDWatermarkExtraction, img, watermark, 0.1);

figure
imagesc(wm_img);
colormap gray

figure
imagesc(rec_wm);
colormap gray