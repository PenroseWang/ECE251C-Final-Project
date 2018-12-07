function [watermarked_img, extracted_watermark, test_results] = EvaluateWatermark(embedding_func, extraction_func, img, watermark, varargin)
    
    %% Evaluate Embedding and Extraction Quality
    [watermarked_img, img_data] = embedding_func(img, watermark, varargin);
    
    test_results.psnr_img = psnr(watermarked_img, double(img));
    test_results.corr_img = corr2(watermarked_img, img);
    
    [wm_large] = extraction_func(watermarked_img, img_data);
    extracted_watermark = wm_large(1:size(watermark,1),1:size(watermark,2));
    
    test_results.psnr_watermark = psnr(extracted_watermark, double(watermark));
    test_results.corr_watermark = corr2(extracted_watermark, watermark);
    
    %% Evaluate Gaussian Blur Attack
    sigma = 0.1:.1:1;
    test_results.gaussfilt.gaussfilt_psnr_wm = zeros(1,length(sigma));
    test_results.gaussfilt.gaussfilt_corr_wm = zeros(1,length(sigma));
    test_results.gaussfilt.gaussfilt_wm = cell(1,length(sigma));
    j = 1;
    for i = sigma
        gauss_blur_img = imgaussfilt(watermarked_img, i);
        [wm_large] = extraction_func(gauss_blur_img, img_data);
        gaussfilt_wm{j} = wm_large(1:size(watermark,1),1:size(watermark,2));
        gaussfilt_psnr_wm(j) = psnr(gaussfilt_wm{j}, double(watermark));
        gaussfilt_corr_wm(j) = corr2(gaussfilt_wm{j}, watermark);
        j = j + 1;
    end
    test_results.gaussfilt_var = sigma;
    test_results.gaussfilt_wm = gaussfilt_wm;
    test_results.gaussfilt_psnr_wm = gaussfilt_psnr_wm;
    test_results.gaussfilt_corr_wm = gaussfilt_corr_wm;
end