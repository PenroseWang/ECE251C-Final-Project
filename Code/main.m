%% Main
clc; close all; clear variable;

%% Read in lena and watermark
img = imread('lena512.bmp');
watermark = imread('Copyright.png');


%% Method1: DWT-SVD
[wm_img, rec_wm, test_results_DWTSVD] = ...
    EvaluateWatermark(@DWT_SVDWatermarkEmbedding, ...
    @DWT_SVDWatermarkExtraction, img, watermark, 0.1);

showImages(img, watermark, wm_img, rec_wm);


%% Method2: DWT-DCT
[wm_img, rec_wm, test_results_DWTDCT] = ...
    EvaluateWatermark(@DWT_DCTWatermarkEmbedding, ...
    @DWT_DCTWatermarkExtraction, img, watermark, 0.1);

showImages(img, watermark, wm_img, rec_wm);
















