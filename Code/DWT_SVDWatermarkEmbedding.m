function [watermarked_img, img_data] = DWT_SVDWatermarkEmbedding(image, ...
    watermark, varargin)
%%DWT-SVDWatermarkEmbedding
%%Reference: "Digital Image Watermarking Using Discrete Wavelet ...
%%Transform and Singular Value Decomposition"

% change variable to double
image = double(image);
watermark = double(watermark);
% 1st level Haar DWT
[LL, HL, LH, HH] = haart2(image, 1);
% apply SVD to HL and LH
[U1, S1, V1] = svd(LH);
[U2, S2, V2] = svd(HL);
% divide watermark and padding
[h_watermark, w_watermark] = size(watermark);
[h_HL, w_HL] = size(HL);
W1 = watermark/2;
W2 = watermark - W1;
W1 = padarray(W1, [h_HL - h_watermark, w_HL - w_watermark], 'post');
W2 = padarray(W2, [h_HL - h_watermark, w_HL - w_watermark], 'post');   
% modify sigular values
alpha = cell2mat(varargin{1});
[U1_W, S1_W, V1_W] = svd(S1 + alpha*W1);
[U2_W, S2_W, V2_W] = svd(S2 + alpha*W2);
% obtain modified DWT coefficients
LH_star = U1*S1_W*V1.';
HL_star = U2*S2_W*V2.';
% obtain watermarked image
watermarked_img = uint8(ihaart2(LL, HL_star, LH_star, HH));

img_data.alpha = alpha;
img_data.U1_W = U1_W;
img_data.V1_W = V1_W;
img_data.U2_W = U2_W;
img_data.V2_W = V2_W;
img_data.S1 = S1;
img_data.S2 = S2;
end