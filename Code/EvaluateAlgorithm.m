clc; close all; clear variables;

img = imread('lena512.bmp');
watermark = imread('Copyright.png');

%% Run DWT SVT Tests
[wm_img_dwt_svd, rec_wm_dwt_svd, results_dwt_svd] = ...
     EvaluateWatermark('DWT SVD', @DWT_SVDWatermarkEmbedding, ...
     @DWT_SVDWatermarkExtraction, img, watermark, ones(1,8), 0.1);
 
showImages(img, watermark, wm_img_dwt_svd, rec_wm_dwt_svd, 'DWT SVD');

%% Run DWT DCT Tests
[wm_img_dwt_dct, rec_wm_dwt_dct, results_dwt_dct] = ...
    EvaluateWatermark('DWT DCT', @DWT_DCTWatermarkEmbedding, ...
    @DWT_DCTWatermarkExtraction, img, watermark, [0 1 1 1 1 1 1 1], 0.1);

showImages(img, watermark, wm_img_dwt_dct, rec_wm_dwt_dct, 'DWT DCT');

%% Run Joint DWT DCT Tests
[wm_img_jdwt_dct, rec_wm_jdwt_dct, results_jdwt_dct] = ...
    EvaluateWatermark('Joint DWT DCT', @jDWT_DCTWatermarkEmbedding, ...
    @jDWT_DCTWatermarkExtraction, img, watermark, [0 1 1 1 1 1 1 1], 0.1);

showImages(img, watermark, wm_img_jdwt_dct, rec_wm_jdwt_dct, 'Joint DWT DCT');

%% Run Robust DWT SVD Tests
[wm_img_rdwt_svd, rec_wm_rdwt_svd, results_rdwt_svd] = ...
    EvaluateWatermark('Robust DWT SVD', @RDWT_SVDWatermarkEmbedding, ...
    @RDWT_SVDWatermarkExtraction, img, watermark, [1 1 1 1 1 1 1 1], 0.1);

showImages(img, watermark, wm_img_rdwt_svd, rec_wm_rdwt_svd, 'Robust DWT SVD');

