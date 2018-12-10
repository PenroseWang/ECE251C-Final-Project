function [watermarked_img, img_data] = DWT_DCTWatermarkEmbedding(image, ...
    watermark, varargin)
%%DWT-DCTWatermarkEmbedding
%%Reference: "Combined DWT-DCT Digital Image Watermarking"


% 0. normalize variables to double
image = im2double(image);
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
alpha = cell2mat(varargin{1});
Blocks_pn = Blocks_dct;
idx = 1;
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

img_data.PN0 = PN0;
img_data.PN1 = PN1;
img_data.wm_size = size(watermark);
end