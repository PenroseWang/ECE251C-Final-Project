function [extracted_watermark] = SVDWatermarkExtraction(watermarked_img, img_data)
%%SVDWAtermarkExtraction

    % change variables to doulbe
    watermarked_img = double(watermarked_img);
    [~, HL_wm, LH_wm, ~] = haart2(watermarked_img, 1);
    [~, S1_wm, ~] = svd(HL_wm);
    [~, S2_wm, ~] = svd(LH_wm);

    D1 = img_data.U1_W*S1_wm*(img_data.V1_W)';
    D2 = img_data.U2_W*S2_wm*(img_data.V2_W)';

    W1_rec = (D1 - img_data.S1)/img_data.alpha;
    W2_rec = (D2 - img_data.S2)/img_data.alpha;

    extracted_watermark = uint8(W1_rec + W2_rec);
end