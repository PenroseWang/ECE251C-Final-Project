function [extracted_watermark] = ...
    jDWT_DCTWatermarkExtraction(watermarked_img, img_data)
%%jDWT-DCTWatermarkExtraction
%Reference: "Robust Digital Image Watermarking Based on Joint DWT-DCT"


% 0. normalize variables to double
image = im2double(watermarked_img);
% 1. filter attack (discarded)
% 2. 1st level Haar DWT
[~, HL1, LH1, ~] = haart2(image, 1);
% 3. 2nd level Haar DWT on HL1 and LH1
[~, HL12, LH12, ~] = haart2(HL1, 1);
[~, HL22, LH22, ~] = haart2(LH1, 1);
% 4. 3rd level Haar DWT on HL12, LH12, HL22, & HL22
[~, HL_HL12, ~, ~] = haart2(HL12, 1);
[~, HL_LH12, ~, ~] = haart2(LH12, 1);
[~, HL_HL22, ~, ~] = haart2(HL22, 1);
[~, HL_LH22, ~, ~] = haart2(LH22, 1);
% 5. divide into 4 by 4 blocks
b_HL13 = mat2tiles(HL_HL12, [4, 4]);
b_LH13 = mat2tiles(HL_LH12, [4, 4]);
b_HL23 = mat2tiles(HL_HL22, [4, 4]);
b_LH23 = mat2tiles(HL_LH22, [4, 4]);
% 6. apply DCT to each block
% suppose each Block has same dimension
[n_row, n_col] = size(b_HL13);
b_HL13_dct = cell(n_row, n_col);
b_LH13_dct = cell(n_row, n_col);
b_HL23_dct = cell(n_row, n_col);
b_LH23_dct = cell(n_row, n_col);
for row = 1:n_row
    for col = 1:n_col
        b_HL13_dct{row, col} = dct2(b_HL13{row, col});
        b_LH13_dct{row, col} = dct2(b_LH13{row, col});
        b_HL23_dct{row, col} = dct2(b_HL23{row, col});
        b_LH23_dct{row, col} = dct2(b_LH23{row, col});
    end
end
Blocks = {b_HL13_dct, b_LH13_dct, b_HL23_dct, b_LH23_dct};
% 7. obtain PN sequences used in embedding process
PN0 = img_data.PN0;
PN1 = img_data.PN1;
% 8. & 9.
wm_size = img_data.wm_size;
rec_wm = zeros(wm_size);
num_b = numel(b_HL13_dct);
for idx = 1:prod(wm_size)
    % 8. apply DCT to each block
    idx_B = floor((idx - 1)/num_b) + 1;
    idx_b = idx - (idx_B - 1)*num_b;
    block_dct = dct2(Blocks{idx_B}{idx_b});

    % 9. decide watermark bit
    % obtain mid-band coefficients
    tmp_dct = zigzag(block_dct);
    mdc = tmp_dct(4:10);
    corr0 = max(cxcorr(mdc, double(PN0)));
    corr1 = max(cxcorr(mdc, double(PN1)));
    if abs(corr0) < abs(corr1)
        rec_wm(idx) = 1;
    end
end
extracted_watermark = uint8(255*mat2gray(rec_wm, [0, 1]));
end