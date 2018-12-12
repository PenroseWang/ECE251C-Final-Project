clc; close all; clear variables;

img = imread('lena512.bmp');
watermark = imread('Copyright.png');

[wm_img, rec_wm, test_results] = ...
     EvaluateWatermark('DWT SVD', @DWT_SVDWatermarkEmbedding, ...
     @DWT_SVDWatermarkExtraction, img, watermark, ones(1,8), 0.1);
 
[wm_img, rec_wm, test_results2] = ...
    EvaluateWatermark('DWT DCT', @DWT_DCTWatermarkEmbedding, ...
    @DWT_DCTWatermarkExtraction, img, watermark, [0 1 1 1 1 1 1 1], 0.1);

figure
imagesc(wm_img);
colormap gray

figure
imagesc(rec_wm);
colormap gray