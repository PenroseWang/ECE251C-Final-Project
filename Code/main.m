%% Main
clc; close all; clear variable;

%% Read in lena and watermark
img = imread('lena512.bmp');
watermark = imread('Copyright.png');


%% Method1: DWT-SVD
[wm_img, rec_wm, test_results_DWTSVD] = ...
    EvaluateWatermark('DWT SVD', @DWT_SVDWatermarkEmbedding, ...
    @DWT_SVDWatermarkExtraction, img, watermark, ones(1, 8), 0.1);

showImages(img, watermark, wm_img, rec_wm);


%% Method2: RDWT-SVD
[wm_img, rec_wm, test_results_RDWTSVD] = ...
    EvaluateWatermark('RDWT SVD', @DWT_SVDWatermarkEmbedding, ...
    @DWT_SVDWatermarkExtraction, img, watermark, ones(1, 8), 0.1);

showImages(img, watermark, wm_img, rec_wm);


%% Method3: DWT-DCT
[wm_img, rec_wm, test_results_DWTDCT] = ...
    EvaluateWatermark('DWT DCT', @DWT_DCTWatermarkEmbedding, ...
    @DWT_DCTWatermarkExtraction, img, watermark, [0 1 1 1 1 1 1 1], 0.1);

showImages(img, watermark, wm_img, rec_wm);


%% Method4: joint DWT-DCT
[wm_img, rec_wm, test_results_jDWTDCT] = ...
    EvaluateWatermark('joint DWT DCT', @DWT_DCTWatermarkEmbedding, ...
    @DWT_DCTWatermarkExtraction, img, watermark, [0 1 1 1 1 1 1 1], 0.1);

showImages(img, watermark, wm_img, rec_wm);













