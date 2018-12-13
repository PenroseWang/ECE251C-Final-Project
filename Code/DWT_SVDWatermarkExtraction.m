function [extracted_watermark] = ...
    DWT_SVDWatermarkExtraction(watermarked_img, img_data)
%%DWT-SVDWatermarkExtraction
%Reference: "Digital Image Watermarking Using Discrete Wavelet ...
%Transform and Singular Value Decomposition"

% normalize variables to doulbe
watermarked_img = im2double(watermarked_img);
[~, HL_wm, LH_wm, ~] = haart2(watermarked_img, 1);
[~, S1_wm, ~] = svd(HL_wm);
[~, S2_wm, ~] = svd(LH_wm);

D1 = img_data.U1_W(1:end,1:size(S1_wm,1))*S1_wm*(img_data.V1_W(1:end,1:size(S1_wm,2)))';
D2 = img_data.U2_W(1:end,1:size(S2_wm,1))*S2_wm*(img_data.V2_W(1:end,1:size(S2_wm,2)))';

W1_rec = (D1 - img_data.S1)/img_data.alpha;
W2_rec = (D2 - img_data.S2)/img_data.alpha;

W_rec = W1_rec + W2_rec;
wm_size = img_data.wm_size;
%extracted_watermark = W_rec(1:wm_size(1), 1:wm_size(2));
% extracted_watermark = uint8(255*mat2gray(W_rec(1:wm_size(1), 1:wm_size(2))));
extracted_watermark = uint8(255*floor(mat2gray(W_rec(1:wm_size(1), ...
    1:wm_size(2)), [0, 1])/.5));
end