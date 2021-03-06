function showImages(img, watermark, watermarked_img, extracted_watermark)
%%showImages
%Display image results


subplot(131);
imshow(img);
title('Host Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(132);
imshow(watermarked_img);
title('Watermarked Image');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(233);
imshow(watermark);
title('Original Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
subplot(236);
imshow(extracted_watermark);
title('Extracted Watermark');
set(gca, 'FontSize', 22, 'FontName', 'Times New Roman');
set(gcf, 'Position', [300 300 900 400]);

end