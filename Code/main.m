%% Main
clc; close all; clear variable;

%% Read in lena and watermark
img = imread('lena512.bmp');
watermark = imread('Copyright.png');
figure;
subplot(121);
imshow(img);
title('Host Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(122);
imshow(watermark);
title('Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');

% %% Method1: DWT-SVD
% [wm_img, rec_wm, test_results] = ...
%     EvaluateWatermark(@DWT_SVDWatermarkEmbedding, ...
%     @DWT_SVDWatermarkExtraction, img, watermark, 0.1);
% 
% showImages(wm_img, rec_wm);

%% Method2: DWT-DCT


% change variable to double
image = double(img);
watermark = double(watermark);
% 1st level Haar DWT
[LL1, HL1, LH1, HH1] = haart2(image, 1);
% 2nd level Haar DWT
[LL2, HL2, LH2, HH2] = haart2(HL1, 1);

