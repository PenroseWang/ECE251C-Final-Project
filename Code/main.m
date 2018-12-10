%% Main
clc; close all; clear variable;

%% Read in lena and watermark
img = imread('lena512.bmp');
watermark = imread('Copyright.png');
% figure;
% subplot(121);
% imshow(img);
% title('Host Image');
% set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
% subplot(122);
% imshow(watermark);
% title('Watermark');
% set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');

% %% Method1: DWT-SVD
% [wm_img, rec_wm, test_results] = ...
%     EvaluateWatermark(@DWT_SVDWatermarkEmbedding, ...
%     @DWT_SVDWatermarkExtraction, img, watermark, 0.1);
% 
% showImages(wm_img, rec_wm);

%% Method2: DWT-DCT
%DWT_DCTWatermarkEmbedding
alpha = .5;
% 0. change variable to double
image = im2double(img);
watermark = im2double(watermark);
% 1. 1st level Haar DWT
[LL1, HL1, LH1, HH1] = haart2(image, 1);
% 2. 2nd level Haar DWT
[LL2, HL2, LH2, HH2] = haart2(HL1, 1);
% 3. divide into 4 by 4 blocks
Blocks = mat2tiles(HL2, [4, 4]);
% 4. apply DCT to each block
[n_row, n_col] = size(Blocks);
Blocks_dct = cell(n_row, n_col);
for row = 1:n_row
    for col = 1:n_col
        Blocks_dct{row, col} = dct2(Blocks{row, col});
    end
end
% 5. vectorize watermark
wm_vec = watermark(:);
% 6. generate Gold code as PN sequence
PN0 = PNGenerator([3, 1], 0);
PN1 = PNGenerator([3, 2], 0);
% PN0 = xor(circshift(pn0, 1), circshift(pn1, 3));
% PN1 = xor(circshift(pn0, 2), circshift(pn1, 4));
% 7. embed PN sequences
idx = 1;
Blocks_pn = Blocks_dct;
for k = 1:length(wm_vec)
    bit = wm_vec(k);
    if bit == 0
        PN = PN0;
    else
        PN = PN1;
    end
    % skip blocks whose size not equal to [4, 4]
    while (sum(size(Blocks_dct{idx}) == [4, 4]) ~= 2)
        idx = idx + 1;
        if idx > numel(Blocks_dct)
            error('Watermark is too big to embed for host image.')
        end
    end
    % add PN to mid-band coefficients
    PN = double([zeros(1, 3), PN, zeros(1, 6)]); 
    PN = izigzag(PN, 4, 4);
    Blocks_pn{idx} = Blocks_dct{idx} + alpha*PN;
    
    idx  = idx + 1;
end

% 8. apply inverse DCT to each block
Blocks_star = cell(n_row, n_col);
for row = 1:n_row
    for col = 1:n_col
        Blocks_star{row, col} = idct2(Blocks_pn{row, col});
    end
end
% 9. watermarked host image
HL2_star = cell2mat(Blocks_star);
HL1_star = ihaart2(LL2, HL2_star, LH2, HH2);
watermarked_img = uint8(255*mat2gray(ihaart2(LL1, HL1_star, LH1, HH1), ...
    [0, 1]));



%DWT_DCTWatermarkExtraction
wm_size = size(watermark);
% 0. change variable to double
image = im2double(watermarked_img);
% 1. 1st level Haar DWT
[LL1, HL1, LH1, HH1] = haart2(image, 1);
% 2. 2nd level Haar DWT
[LL2, HL2, LH2, HH2] = haart2(HL1, 1);
% 3. divide into 4 by 4 blocks
Blocks = mat2tiles(HL2, [4, 4]);
% 5. obtain PN sequences used in embedding process
PN0;
PN1;
% 4. & 6.
[n_row, n_col] = size(Blocks);
Blocks_dct = cell(n_row, n_col);
idx = 1;
rec_wm = zeros(wm_size);
for k = 1:numel(watermark)
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
    if corr0 < corr1
        rec_wm(k) = 255;
    end
    idx = idx + 1;
end
rec = uint8(255*mat2gray(rec_wm, [0, 1]));


showImages(watermarked_img, mat2gray(rec_wm));
















