function [watermarked_img, extracted_watermark, test_results] = ...
    EvaluateWatermark(algorithm_name, embedding_func, extraction_func, ...
    img, watermark, test_disable, varargin)

%% Evaluate Embedding and Extraction Quality
test_results.algorith_name = algorithm_name;

start_time = cputime;
[watermarked_img, img_data] = embedding_func(img, watermark, varargin);
test_results.embedding_time = cputime-start_time;

test_results.psnr_img = psnr(double(watermarked_img), double(img));
test_results.corr_img = corr2(double(watermarked_img), double(img));

start_time = cputime;
[wm_large] = extraction_func(watermarked_img, img_data);
test_results.extraction_time = cputime-start_time;

extracted_watermark = wm_large(1:size(watermark,1),1:size(watermark,2));
test_results.psnr_watermark = psnr(double(extracted_watermark), ...
    double(watermark));
test_results.corr_watermark = corr2(double(extracted_watermark), ...
    watermark);

test_idx = 1;

%% Evaluate Cropping Attack
crop_percentages = 0:10:90;
test_results.cropping = InitializeAttackResult(crop_percentages, ...
    'Cropping Attack', ...
    'Cropping Percentage');

function attacked_img = crop_image(watermarked_img, crop_percent)
    start_crop = floor((crop_percent/200)*size(watermarked_img));
    if (start_crop == [0,0])
        start_crop = [1,1];
    end
    end_crop = size(watermarked_img) - start_crop;
    crop_size = end_crop - start_crop;
    end_crop(1) = end_crop(1) - (1-mod(crop_size(1),2));
    end_crop(2) = end_crop(2) - (1-mod(crop_size(2),2));
    
    attacked_img = watermarked_img(start_crop(1):end_crop(2), ...
        start_crop(2):end_crop(2));
end

if (test_disable(test_idx))
test_results.cropping = EvaluateAttack(test_results.cropping, ...
    watermarked_img, extraction_func, @crop_image, watermark, ...
    img_data, crop_percentages);
end
test_idx = test_idx + 1;

%% Evaluate Rotation Attack
angles = 0:45:360;
test_results.rotation = InitializeAttackResult(angles, ...
    'Rotation Angle Attack',...
    'Rotation Angle');

function attacked_img = rotate_img(watermarked_img, ang)
    attacked_img = imrotate(watermarked_img, ang, 'crop');
end

if (test_disable(test_idx))
test_results.rotation = EvaluateAttack(test_results.rotation, ...
    watermarked_img, extraction_func, @rotate_img, watermark, ...
    img_data, angles);
end
test_idx = test_idx + 1;

%% Evaluate Gaussian Noise Attack
noise_var = 0.001:.001:.01;
test_results.gaussian_noise = InitializeAttackResult(noise_var, ...
    'Gaussian Noise Attack', ...
    'Noise Variance');

function attacked_img = gaussian_noise_func(watermarked_img, var)
    attacked_img = uint8(imnoise(watermarked_img, 'gaussian', 0, var));
end

if (test_disable(test_idx))
test_results.gaussian_noise = EvaluateAttack(test_results.gaussian_noise, ...
    watermarked_img, extraction_func, @gaussian_noise_func, watermark, ...
    img_data, noise_var);
end
test_idx = test_idx + 1;

%% Evaluate Gaussian Blur Attack
sigma = 0.1:.1:1;
test_results.gaussian_blur = InitializeAttackResult(sigma, ...
    'Gaussian Blur Attack', ...
    'Sigma');

function attacked_img = gaussian_blur(watermarked_img, variance)
    attacked_img = uint8(imgaussfilt(double(watermarked_img), variance));
end

if (test_disable(test_idx))
test_results.gaussian_blur = EvaluateAttack(test_results.gaussian_blur, ...
    watermarked_img, extraction_func, @gaussian_blur, watermark, ...
    img_data, sigma);
end
test_idx = test_idx + 1;

%% Evaluate JPEG Compression Attack
quality = 100:-10:10;
test_results.jpeg_compression = InitializeAttackResult(quality, ...
    'JPEG Compression Attack', ...
    'JPEG Compression Quality');

function attacked_img = jpeg_compression(watermarked_img, qual)
    imwrite(watermarked_img, 'wm_img_jpeg_test.jpg', 'jpg', ...
        'Quality', qual);
    attacked_img = uint8(imread('wm_img_jpeg_test.jpg'));
    delete wm_img_jpeg_test.jpg
end

if (test_disable(test_idx))
test_results.jpeg_compression = EvaluateAttack(...
    test_results.jpeg_compression, watermarked_img, extraction_func, ...
    @jpeg_compression, watermark, img_data, quality);
end
test_idx = test_idx + 1;

%% Evaluate Median Filtering
med_neighborhood = 1:1:10;
test_results.median_filt = InitializeAttackResult(med_neighborhood, ...
    'Median Filtering Attack', ...
    'Median Neighborhood Size');

function attacked_img = median_filtering(watermarked_img, nhood)
   attacked_img = medfilt2(watermarked_img, [nhood nhood]);
end

if (test_disable(test_idx))
test_results.median_filt = EvaluateAttack(...
    test_results.median_filt, watermarked_img, extraction_func, ...
    @median_filtering, watermark, img_data, med_neighborhood);
end
test_idx = test_idx + 1;


%% Evaluate Constrast Adjustment
contrast_limits = 0:0.05:.45;
test_results.contrast_adj = InitializeAttackResult(contrast_limits, ...
    'Contrast Adjustment Attack', ...
    'Contrast Limit Reduction');

function attacked_img = adjust_contrast(watermarked_img, limit)
    attacked_img = imadjust(watermarked_img, [0+limit 1-limit],[]);
end

if (test_disable(test_idx))
test_results.contrast_adj = EvaluateAttack(...
    test_results.contrast_adj, watermarked_img, extraction_func, ...
    @adjust_contrast, watermark, img_data, contrast_limits);
end
test_idx = test_idx + 1;

%% Evaluate Gamma Correction
gamma_values = 2:-.2:.1;
test_results.gamma_correction = InitializeAttackResult(gamma_values, ...
    'Gamma Correction Attack', ...
    'Gamma');

function attacked_img = gamma_correction(watermarked_img, gamma)
    attacked_img = imadjust(watermarked_img, [],[], gamma);
end

if (test_disable(test_idx))
test_results.gamma_correction = EvaluateAttack(...
    test_results.gamma_correction, watermarked_img, extraction_func, ...
    @gamma_correction, watermark, img_data, gamma_values);
end
test_idx = test_idx + 1;

end
