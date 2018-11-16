%% Main
clc; close all; clear all;

%% Read in lena and watermark
cover = imread('lena512.bmp');
watermark = imread('Copyright.png');
figure;
subplot(121);
imshow(cover);
title('Cover Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(122);
imshow(watermark);
title('Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');

%% Watermark embedding
% 1 level Haar DWT
[LL, HL, LH, HH] = haart2(double(cover), 1);
figure;
imshow([mat2gray(LL), mat2gray(HL); mat2gray(LH), mat2gray(HH)]);
title('1-level 2-D Haar DWT');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
close;
% apply SVD to HL and LH
[U1, S1, V1] = svd(LH);
[U2, S2, V2] = svd(HL);
% divide watermark and padding
[h_watermark, w_watermark] = size(watermark);
[h_HL, w_HL] = size(HL);
W1 = double(watermark)/2;
W2 = double(watermark) - W1;
W1 = padarray(W1, [h_HL - h_watermark, w_HL - w_watermark], ...
    'post');
W2 = padarray(W2, [h_HL - h_watermark, w_HL - w_watermark], ...
    'post');   
% modify sigular values
alpha = 0.1;
[U1_W, S1_W, V1_W] = svd(S1 + alpha*W1);
[U2_W, S2_W, V2_W] = svd(S2 + alpha*W2);
% obtain modified DWT coefficients
LH_star = U1*S1_W*V1.';
HL_star = U2*S2_W*V2.';
% obtain watermarked image
cover_wm = ihaart2(LL, HL_star, LH_star, HH);
figure;
subplot(121);
imshow(mat2gray(cover_wm));
title('Watermarked Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');

%% Watermark extraction
[LL_wm, HL_wm, LH_wm, HH_wm] = haart2(cover_wm, 1);
[~, S1_wm, ~] = svd(HL_wm);
[~, S2_wm, ~] = svd(LH_wm);

D1 = U1_W*S1_wm*V1_W.';
D2 = U2_W*S2_wm*V2_W.';

W1_rec = (D1 - S1)/alpha;
W2_rec = (D2 - S2)/alpha;

W_rec = W1_rec + W2_rec;
watermark = mat2gray(W_rec(1:h_watermark, 1:w_watermark));
watermark(watermark > .5) = 1;
watermark(watermark <= .5) = 0;
subplot(122);
imshow(watermark);
title('Extracted Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');