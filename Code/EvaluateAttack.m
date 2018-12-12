function [attack_result] = EvaluateAttack(results, watermarked_img, ...
    extraction_func, attack_func, watermark, img_data, attack_range)

    idx = 1;
    for i = attack_range
        attacked_img = attack_func(watermarked_img, i);
        [wm_large] = extraction_func(attacked_img, img_data);
        wm_tmp = wm_large(1:size(watermark,1),1:size(watermark,2));

        results.wm{idx} = wm_tmp;
        results.psnr(idx) = psnr(wm_tmp, watermark);
        results.corr(idx) = corr2(wm_tmp, watermark);

        idx = idx + 1;
    end
    results.best_corr = max(results.corr);
    results.avg_corr = mean(results.corr);
    results.best_psnr = max(results.psnr);
    results.avg_psnr = mean(results.psnr);
    attack_result = results;
   
end