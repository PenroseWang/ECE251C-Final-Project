function showImages(watermarked_img, extracted_watermark)
%%showImages
%%Display image results

figure;
subplot(121)
imshow(watermarked_img);
colormap gray;
title('Watermarked Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(122);
imshow(extracted_watermark);
colormap gray
title('Extracted Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');


end