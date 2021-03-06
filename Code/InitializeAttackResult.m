function [attack_result] = InitializeAttackResult(attack_range, ...
    attack_name, ...
    parameter_name)
    attack_result.name = attack_name;
    attack_result.psnr = zeros(1,length(attack_range));
    attack_result.corr = zeros(1,length(attack_range));
    attack_result.wm = cell(1,length(attack_range));
    attack_result.attack_range = attack_range;
    attack_result.parameter_name = parameter_name;
end