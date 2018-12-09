function [watermarked_img, img_data] = DWT_DCTWatermarkEmbedding(image, ...
    watermark, varargin)
%%DWT-DCTWatermarkEmbedding
%%Reference: "Combined DWT-DCT Digital Image Watermarking"

% change variable to double
image = double(image);
watermark = double(watermark);
% 1st level Haar DWT
[LL1, HL1, LH1, HH1] = haart2(image, 1);
% 2nd level Haar DWT
[LL2, HL2, LH2, HH2] = haart2(HL1, 1);

end