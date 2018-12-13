function GeneratePlots(results)
    dir = './plots';
    mkdir(dir);
    for algorithm = results
        dir_alg = [dir '/' algorithm.algorithm_name];
        mkdir(dir_alg);
        imwrite(algorithm.watermarked_img, ...
            [dir_alg '/watermarked_img.jpg'], 'Quality', 100);
        imwrite(algorithm.extracted_watermark, ...
            [dir_alg '/wm_rec.jpg'], 'Quality', 100);
        names = fieldnames(algorithm);
        for name = names(10:end)'
            attack = algorithm.(cell2mat(name));
            if (~isempty(attack))
                dir_attack = [dir_alg '/' attack.name];
                mkdir(dir_attack);
                %display(dir_attack);
                for attack_idx = 1:length(attack.attack_range)
                    imwrite(cell2mat(attack.wm(attack_idx)), ...
                    [dir_attack '/' attack.parameter_name '_' ...
                    num2str(attack.attack_range(attack_idx)) '.jpg'], ...
                    'Quality', 100);
                end
            end
        end
    end
end