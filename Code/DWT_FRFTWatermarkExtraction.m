function [wm_rec] = DWT_FRFTWatermarkExtraction(...
    watermarked_img, img_data)
    
    image = im2double(watermarked_img);
    
    [~, HL1, ~, ~] = dwt2(image,'haar');
    [~, HL2, LH2, ~] = dwt2(HL1,'haar');
    
    F_HL2 = frft2d(HL2, [img_data.a1, img_data.a2]);
    F_HL2_vec = F_HL2(:);
    F_LH2 = frft2d(LH2, [img_data.a1, img_data.a2]);
    F_LH2_vec = F_LH2(:);
    
    wm_rec = ones(img_data.wm_size)';
    
    img_data.pn1_gen.reset();
    img_data.pn2_gen.reset();
    
    for i = 1:prod(img_data.wm_size)
       corr0 = corr(F_HL2_vec, img_data.pn1_gen.generate());
       corr1 = corr(F_LH2_vec, img_data.pn2_gen.generate());
       wm_rec(i) = mean([corr0, corr1]);
    end
    wm_rec = real(uint8(255*mat2gray(wm_rec, [0,1])));
end