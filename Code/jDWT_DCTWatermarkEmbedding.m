function [watermarked_img, img_data] = jDWT_DCTWatermarkEmbedding(image, ...
    watermark, varargin)
%%jDWT-DCTWatermarkEmbedding
%Reference: "Robust Digital Image Watermarking Based on Joint DWT-DCT"


% 0. normalize variables to double
image = im2double(image);
watermark = im2double(watermark);
% 1. 1st level Haar DWT
[LL1, HL1, LH1, HH1] = haart2(image, 1);
% 2. 2nd level Haar DWT on HL1 and LH1
[LL12, HL12, LH12, HH12] = haart2(HL1, 1);
[LL22, HL22, LH22, HH22] = haart2(LH1, 1);
% 3. 3rd level Haar DWT on HL12, LH12, HL22, & HL22
[LL_HL12, HL_HL12, LH_HL12, HH_HL12] = haart2(HL12, 1);
[LL_LH12, HL_LH12, LH_LH12, HH_LH12] = haart2(LH12, 1);
[LL_HL22, HL_HL22, LH_HL22, HH_HL22] = haart2(HL22, 1);
[LL_LH22, HL_LH22, LH_LH22, HH_LH22] = haart2(LH22, 1);
% 4. divide into 4 by 4 blocks
b_HL13 = mat2tiles(HL_HL12, [4, 4]);
b_LH13 = mat2tiles(HL_LH12, [4, 4]);
b_HL23 = mat2tiles(HL_HL22, [4, 4]);
b_LH23 = mat2tiles(HL_LH22, [4, 4]);
% 5. apply DCT to each block
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
% 6. scramble watermark (discarded)
% 7. vectorize watermark
wm_vec = watermark(:);
% 8. generate PN sequence
pn0 = PNGenerator([3, 1], 0);
pn1 = PNGenerator([3, 2], 0);
PN0 = circshift(pn0, 0).*circshift(pn1, 5);
PN1 = circshift(pn0, 0).*circshift(pn1, 6);
% 9. embed PN sequences
alpha = cell2mat(varargin{1});
num_b = numel(b_HL13_dct);
Blocks_pn = Blocks;
for idx = 1:length(wm_vec)
    bit = wm_vec(idx);
    if bit == 0
        PN = PN0;
    else
        PN = PN1;
    end
    % add PN to mid-band coefficients
    PN = double([zeros(1, 3), PN, zeros(1, 6)]); 
    PN = izigzag(PN, 4, 4);
    idx_B = floor((idx - 1)/num_b) + 1;
    idx_b = idx - (idx_B - 1)*num_b;
    
    Blocks_pn{idx_B}{idx_b} = Blocks{idx_B}{idx_b} + alpha*PN;
end

% 8. apply inverse DCT to each block
Blocks_star = cell(4, n_row, n_col);
for page = 1:4
    for row = 1:n_row
        for col = 1:n_col
            Blocks_star{page}{row, col} = idct2(Blocks_pn{page}{row, col});
        end
    end
end
% 9. watermarked host image
HL_HL12_star = cell2mat(Blocks_star{1});
HL_LH12_star = cell2mat(Blocks_star{2});
HL_HL22_star = cell2mat(Blocks_star{3});
HL_LH22_star = cell2mat(Blocks_star{4});
HL12_star = ihaart2(LL_HL12, HL_HL12_star, LH_HL12, HH_HL12);
LH12_star = ihaart2(LL_LH12, HL_LH12_star, LH_LH12, HH_LH12);
HL22_star = ihaart2(LL_HL22, HL_HL22_star, LH_HL22, HH_HL22);
LH22_star = ihaart2(LL_LH22, HL_LH22_star, LH_LH22, HH_LH22);
HL1_star = ihaart2(LL12, HL12_star, LH12_star, HH12);
LH1_star = ihaart2(LL22, HL22_star, LH22_star, HH22);
watermarked_img = uint8(255*mat2gray(ihaart2(LL1, HL1_star, LH1_star, HH1), ...
    [0, 1]));

img_data.PN0 = PN0;
img_data.PN1 = PN1;
img_data.wm_size = size(watermark);
end