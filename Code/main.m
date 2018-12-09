%% Main
clc; close all; clear variable;

%% Read in lena and watermark
img = imread('lena512.bmp');
watermark = imread('Copyright.png');
figure;
subplot(121);
imshow(img);
title('Cover Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(122);
imshow(watermark);
title('Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');

%% method1: SVDWatermark
[wm_img, rec_wm, test_results] = EvaluateWatermark(@SVDWatermarkEmbedding, ...
                                                   @SVDWatermarkExtraction, ...
                                                   img, watermark, 0.1);

figure;
subplot(121)
imshow(wm_img);
colormap gray;
title('Watermarked Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(122);
imshow(rec_wm);
colormap gray
title('Extracted Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');