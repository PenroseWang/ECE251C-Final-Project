function [wm_rec] = DWT_FRFTWatermarkExtraction(...
    watermarked_img, img_data)
    
image = im2double(watermarked_img);

[~, HL1, ~, ~] = dwt2(image,'haar');
[~, HL2, LH2, ~] = dwt2(HL1,'haar');

F_HL2 = frft2d(HL2, [img_data.a1, img_data.a2]);
F_HL2_vec = F_HL2(:);
F_LH2 = frft2d(LH2, [img_data.a1, img_data.a2]);
F_LH2_vec = F_LH2(:);

wm_rec = ones(img_data.wm_size);

PN0 = img_data.PN0;
PN1 = img_data.PN1;
len_pn = length(PN0);
for i = 1:prod(img_data.wm_size)
   corr0 = circshift(PN0, i)*abs(F_HL2_vec)/len_pn;
   corr1 = circshift(PN1, i)*abs(F_LH2_vec)/len_pn;
   wm_rec(i) = ~ (mean([corr0, corr1]) > .0001);
end
wm_rec = uint8(255*mat2gray(wm_rec, [0,1]));
end