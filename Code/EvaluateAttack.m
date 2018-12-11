function [attack_result] = EvaluateAttack(results, extraction_func, watermark, attacked_img, img_data, idx)
    [wm_large] = extraction_func(attacked_img, img_data);
    wm_tmp = wm_large(1:size(watermark,1),1:size(watermark,2));

    results.wm{idx} = wm_tmp;
    results.psnr(idx) = psnr(wm_tmp, double(watermark));
    results.corr(idx) = corr2(wm_tmp, watermark);
    
    attack_result = results;
end