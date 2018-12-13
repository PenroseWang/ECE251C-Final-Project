%% Main
clc; close all; clear variable;

%% Read in lena and watermark
image = imread('lena512.bmp');
watermark = imread('Copyright.png');


% %% Method1: DWT-SVD
% [wm_img, rec_wm, test_results_DWTSVD] = ...
%     EvaluateWatermark('DWT SVD', @DWT_SVDWatermarkEmbedding, ...
%     @DWT_SVDWatermarkExtraction, image, watermark, ones(1, 8), 0.1);
% 
% figure;
% showImages(image, watermark, wm_img, rec_wm);
% 
% 
% %% Method2: RDWT-SVD
% [wm_img, rec_wm, test_results_RDWTSVD] = ...
%     EvaluateWatermark('RDWT SVD', @DWT_SVDWatermarkEmbedding, ...
%     @DWT_SVDWatermarkExtraction, image, watermark, ones(1, 8), 0.1);
% 
% figure;
% showImages(image, watermark, wm_img, rec_wm);
% 
% 
% Method3: DWT-DCT
% [wm_img, rec_wm, test_results_DWTDCT] = ...
%     EvaluateWatermark('DWT DCT', @DWT_DCTWatermarkEmbedding, ...
%     @DWT_DCTWatermarkExtraction, image, watermark, [0 1 1 1 1 1 1 1], 0.1);
% 
% figure;
% showImages(image, watermark, wm_img, rec_wm);
% 
% 
% %% Method4: joint DWT-DCT
% [wm_img, rec_wm, test_results_jDWTDCT] = ...
%     EvaluateWatermark('joint DWT DCT', @jDWT_DCTWatermarkEmbedding, ...
%     @jDWT_DCTWatermarkExtraction, image, watermark, [0 1 1 1 1 1 1 1], 0.1);
% 
% figure;
% showImages(image, watermark, wm_img, rec_wm);


[wm_img, img_data] = jDWT_DCTWatermarkEmbedding(image, ...
    watermark, {.4});
[extracted_watermark] = ...
    jDWT_DCTWatermarkExtraction(wm_img, img_data);


showImages(image, watermark, wm_img, extracted_watermark);















