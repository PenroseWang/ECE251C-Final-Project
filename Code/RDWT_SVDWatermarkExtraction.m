function [extracted_watermark] = ...
    RDWT_SVDWatermarkExtraction(watermarked_img, img_data)
%%RDWT-SVDWatermarkExtraction
%Reference: "Robust blind image watermarking scheme based on ...
%Redundant Discrete Wavelet Transform and Singular Value Decomposition"

% normalize variables to doulbe
watermarked_img = im2double(watermarked_img);
[LL_wm, HL_wm, LH_wm, HH_wm] = swt2(watermarked_img, 1, 'sym4');
[~, S1_wm, ~] = svd(LL_wm);
[~, S2_wm, ~] = svd(HL_wm);
[~, S3_wm, ~] = svd(LH_wm);
[~, S4_wm, ~] = svd(HH_wm);

D1 = img_data.U1_W(1:size(S1_wm,1))*S1_wm*(img_data.V1_W(1:size(S1_wm,1)))';
D2 = img_data.U2_W(1:size(S2_wm,1))*S2_wm*(img_data.V2_W(1:size(S2_wm,1)))';
D3 = img_data.U3_W(1:size(S3_wm,1))*S3_wm*(img_data.V3_W(1:size(S3_wm,1)))';
D4 = img_data.U4_W(1:size(S4_wm,1))*S4_wm*(img_data.V4_W(1:size(S4_wm,1)))';

W1_rec = (D1 - img_data.S1)/img_data.alpha;
W2_rec = (D2 - img_data.S2)/img_data.alpha;
W3_rec = (D3 - img_data.S3)/img_data.alpha;
W4_rec = (D4 - img_data.S4)/img_data.alpha;

W_rec = (W1_rec + W2_rec + W3_rec + W4_rec)/4;
wm_size = img_data.wm_size;
% extracted_watermark = uint8(255*mat2gray(W_rec(1:wm_size(1), 1:wm_size(2))));
extracted_watermark = uint8(255*floor(mat2gray(W_rec(1:wm_size(1), ...
    1:wm_size(2)), [0, 1])/.5));
end