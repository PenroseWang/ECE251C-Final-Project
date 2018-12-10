function [watermarked_img, img_data] = RDWT_SVDWatermarkEmbedding(image, ...
    watermark, varargin)
%%RDWT-SVDWatermarkEmbedding
%Reference: "Robust blind image watermarking scheme based on ...
%Redundant Discrete Wavelet Transform and Singular Value Decomposition"

% normalize variables to double
image = im2double(image);
watermark = im2double(watermark);
% 1st level SWT
[LL, HL, LH, HH] = swt2(image, 1, 'sym4');
% apply SVD to all sub-bands
[U1, S1, V1] = svd(LL);
[U2, S2, V2] = svd(HL);
[U3, S3, V3] = svd(LH);
[U4, S4, V4] = svd(HH);
% divide watermark and padding
[h_wm, w_wm] = size(watermark);
[h_HL, w_HL] = size(HL);
W = padarray(watermark, [h_HL - h_wm, w_HL - w_wm], 'post');
% modify sigular values
alpha = cell2mat(varargin{1});
[U1_W, S1_W, V1_W] = svd(S1 + alpha*W);
[U2_W, S2_W, V2_W] = svd(S2 + alpha*W);
[U3_W, S3_W, V3_W] = svd(S3 + alpha*W);
[U4_W, S4_W, V4_W] = svd(S4 + alpha*W);
% obtain modified DWT coefficients
LL_star = U1*S1_W*V1.';
HL_star = U2*S2_W*V2.';
LH_star = U3*S3_W*V3.';
HH_star = U4*S4_W*V4.';
% obtain watermarked image
watermarked_img = uint8(255*mat2gray(iswt2(LL_star, HL_star, LH_star, ...
    HH_star, 'sym4')));

img_data.alpha = alpha;
img_data.U1_W = U1_W;
img_data.V1_W = V1_W;
img_data.U2_W = U2_W;
img_data.V2_W = V2_W;
img_data.U3_W = U3_W;
img_data.V3_W = V3_W;
img_data.U4_W = U4_W;
img_data.V4_W = V4_W;
img_data.S1 = S1;
img_data.S2 = S2;
img_data.S3 = S3;
img_data.S4 = S4;
img_data.wm_size = size(watermark);
end