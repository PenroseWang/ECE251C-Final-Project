function seq = PNGenerator(fp, delay)
%%PNGenerator
%Note: We suppose the initial of LFSR is all 1s.
%Input: 
%    fp: 1D int vector - feedback polynomial, i.e. [3,2] for x^3 + x^2 + 1,
%        values in fp should be in decending order
% delay: int - delay of the output with initial status.

% sort fp in descending order
fp = sort(fp, 'descend');
n = fp(1);
% initial status = 1s
bits = ones(1, n);
% output
N = 2^fp(1) - 1;
seq = zeros(1, N);
% LFSR
seq(1) = bits(n);
for k = 1:N - 1
    bit = xor(bits(fp(1)), bits(fp(2)));
    for idx = 1:length(fp) - 2
        bit = xor(bits(fp(idx + 2)), bit);
    end
    bits(2:end) = bits(1:end - 1);
    bits(1) = bit;
    seq(k + 1) = bits(n);
end
seq = circshift(seq, delay);
seq(seq == 0) = -1;
end