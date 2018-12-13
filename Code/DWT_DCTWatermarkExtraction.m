function [extracted_watermark] = ...
    DWT_DCTWatermarkExtraction(watermarked_img, img_data)
%%DWT-SVDWatermarkExtraction
%%Reference: "Combined DWT-DCT Digital Image Watermarking"


% 0. normalize variables to double
image = im2double(watermarked_img);
% 1. 1st level Haar DWT
[~, HL1, ~, ~] = haart2(image, 1);
% 2. 2nd level Haar DWT
[~, HL2, ~, ~] = haart2(HL1, 1);
% 3. divide into 4 by 4 blocks
Blocks = mat2tiles(HL2, [4, 4]);
% 5. obtain PN sequences used in embedding process
PN0 = img_data.PN0;
PN1 = img_data.PN1;
% 4. & 6.
wm_size = img_data.wm_size;
rec_wm = zeros(wm_size);
idx = 1;
for k = 1:prod(wm_size)
    while (sum(size(Blocks{idx}) == [4, 4]) ~= 2)
        idx = idx + 1;
    end
    % 4. apply DCT to each block
    block_dct = dct2(Blocks{idx});
%     disp(block_dct);
    % 6. decide watermark bit
    % obtain mid-band coefficients
    tmp_dct = zigzag(block_dct);
    mdc = tmp_dct(4:10);
    corr0 = max(cxcorr(mdc, double(PN0)));
    corr1 = max(cxcorr(mdc, double(PN1)));
    if abs(corr0) < abs(corr1)
        rec_wm(k) = 1;
    end
    idx = idx + 1;
end
extracted_watermark = uint8(255*mat2gray(rec_wm, [0, 1]));
end