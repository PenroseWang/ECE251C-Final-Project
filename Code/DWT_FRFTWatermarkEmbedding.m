function [watermarked_img, img_data] = DWT_FRFTWatermarkEmbedding(image, ...
    watermark, varargin)
    image = im2double(image);
    watermark = mat2gray(watermark);
    
    img_data.wm_size = size(watermark);
    % Haar DWT
    [LL1, HL1, LH1, HH1] = dwt2(image,'haar');
    
    %2nd-level Haar DWT
    [LL2, HL2, LH2, HH2] = dwt2(HL1,'haar');
    
    img_data.a1 = varargin{1};
    img_data.a2 = varargin{2};
    img_data.k = varargin{3};
    
    F_HL2 = frft2d(HL2, [img_data.a1, img_data.a2]);
    F_HL2_vec = F_HL2(:);
    F_LH2 = frft2d(LH2, [img_data.a1, img_data.a2]);
    F_LH2_vec = F_LH2(:);
    
    img_data.pn1_gen = commsrc.pn('NumBitsOut', numel(HL2));
    img_data.pn2_gen = commsrc.pn('NumBitsOut', numel(LH2));
    
    wm_vec = watermark(:);
    
    for i = 1:length(wm_vec)
       if (wm_vec(i) == 0)
           F_HL2_vec = F_HL2_vec + img_data.k*img_data.pn1_gen.generate();
           F_LH2_vec = F_LH2_vec + img_data.k*img_data.pn2_gen.generate();
       end
    end
    
    HL2_wm = frft2d(reshape(F_HL2_vec, size(F_HL2)), [-img_data.a1, -img_data.a2]);
    LH2_wm = frft2d(reshape(F_LH2_vec, size(F_LH2)), [-img_data.a1, -img_data.a2]);
    
    HL1_wm = idwt2(LL2, HL2_wm, LH2_wm, HH2,'haar');
    watermarked_img = real(uint8(255*mat2gray(idwt2(LL1, HL1_wm, LH1, HH1,'haar'), ...
    [0, 1])));
end